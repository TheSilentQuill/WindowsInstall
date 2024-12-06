$scriptLogic = @'
$availableApps = @(
    "TheBrowserCompany.Arc",
    "Brave.Brave",
    "Google.Chrome",
    "Mozilla.Firefox",
    "Mozilla.Firefox.DeveloperEdition",
    "LibreWolf.LibreWolf",
    "MullvadVPN.MullvadBrowser",
    "TorProject.TorBrowser",
    "Betterbird.Betterbird",
    "OpenWhisperSystems.Signal",
    "Vencord.Vesktop",
    "Google.AndroidStudio",
    "Kitware.CMake",
    "Git.Git",
    "HTTPToolKit.HTTPToolKit",
    "WerWolv.ImHex",
    "JanDeDobbeleer.OhMyPosh",
    "Postman.Postman",
    "Python.Python.3.12",
    "Microsoft.VisualStudioCode",
    "VSCodium.VSCodium",
    "Valve.Steam",
    "Microsoft.PowerShell",
    "Microsoft.PowerToys",
    "ImageMagick.ImageMagick",
    "IrfanSkiljan.IrfanView",
    "IrfanSkiljan.IrfanView.PlugIns",
    "MediaArea.MediaInfo",
    "MediaArea.MediaInfo.GUI",
    "MoritzBunkus.MKVToolNix",
    "FlorianHeidenreich.Mp3tag",
    "OBSProject.OBSStudio",
    "Spotify.Spotify",
    "yt-dlp.yt-dlp",
    "IVPN.IVPN",
    "MullvadVPN.MullvadVPN",
    "NordSecurity.NordVPN",
    "RustDesk.RustDesk",
    "AgileBits.1Password",
    "7zip.7zip",
    "aria2.aria2",
    "AutoHotkey.AutoHotkey",
    "Bitwarden.Bitwarden",
    "CrystalDewWorld.CrystalDiskInfo",
    "File-New-Project.EarTrumpet",
    "voidtools.Everything.Alpha",
    "Levitsky.FontBase",
    "junegunn.fzf",
    "Logitech.GHUB",
    "jqlang.jq",
    "LocalSend.LocalSend",
    "Rclone.Rclone",
    "ShareX.ShareX",
    "SpecialK.SpecialK",
    "Ookla.Speedtest.CLI",
    "CodeSector.TeraCopy",
    "WinMerge.WinMerge",
    "ajeetdsouza.zoxide"
)

function Show-CheckboxMenu {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$Arguments,

        [Parameter(Position = 1)]
        [string]$Title = "Select options",

        [Parameter(Position = 2)]
        [int]$PageSize = 15
    )

    $selectedApps = @{}
    $currentIndex = 0
    $startIndex = 0

    function Show-DrawMenu {
        Clear-Host
        Write-Host $Title -ForegroundColor Cyan
        Write-Host

        $endIndex = [math]::Min($startIndex + $PageSize, $Arguments.Count)

        for ($i = $startIndex; $i -lt $endIndex; $i++) {
            if ($selectedApps.ContainsKey($i)) {
                $prefix = "[X]"
            } else {
                $prefix = "[ ]"
            }

            if ($i -eq $currentIndex) {
                Write-Host "$prefix $($Arguments[$i])" -BackgroundColor DarkBlue -ForegroundColor White
            } else {
                Write-Host "$prefix $($Arguments[$i])"
            }
        }

        Write-Host
        Write-Host "Navigate with ↑ and ↓, select/unselect with Space, confirm with Enter." -ForegroundColor Yellow
        Write-Host "Showing $($startIndex + 1)-$endIndex of $($Arguments.Count)" -ForegroundColor Gray
    }

    Show-DrawMenu

    while ($true) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode

        switch ($key) {
            38 {
                if ($currentIndex -gt 0) {
                    $currentIndex--
                    if ($currentIndex -lt $startIndex) {
                        $startIndex = [math]::Max($startIndex - 1, 0)
                    }
                    Show-DrawMenu
                }
            }

            40 {
                if ($currentIndex -lt ($Arguments.Count - 1)) {
                    $currentIndex++
                    if ($currentIndex -ge ($startIndex + $PageSize)) {
                        $startIndex = [math]::Min($startIndex + 1, $Arguments.Count - $PageSize)
                    }
                    Show-DrawMenu
                }
            }

            32 {
                if ($selectedApps.ContainsKey($currentIndex)) {
                    $selectedApps.Remove($currentIndex)
                } else {
                    $selectedApps[$currentIndex] = $true
                }
                Show-DrawMenu
            }

            13 {
                $sortedApps = $selectedApps.Keys | Sort-Object
                return $sortedApps | ForEach-Object { $Arguments[$_] }
            }
        }
    }
}

$selectedApps = Show-CheckboxMenu -Arguments $availableApps -Title "Select Your Options" -PageSize 15

Clear-Host
Write-Host "Installing selected applications..."
Write-Host

foreach ($selectedApp in $selectedApps) {
    $installCommand = "winget install -e --id $selectedApp"

    if ($selectedApp -eq "yt-dlp.yt-dlp") {
        $installCommand = "winget install -e --skip-dependencies --id $selectedApp"
    }
    elseif ($selectedApp -eq "MediaArea.MediaInfo.GUI" -or $selectedApp -eq "Python.Python.3.13") {
        $installCommand = "winget install -e -i --id $selectedApp"
    }
    elseif ($selectedApp -eq "Microsoft.VisualStudioCode") {
        $installCommand = "winget install -e --id $selectedApp --override '/SILENT /mergetasks=`"!runcode,addcontextmenufiles,addcontextmenufolders`"'"
    }

    Write-Host "`nInstalling $selectedApp..."
    Invoke-Expression $installCommand
}

Write-Host "`nInstallation of $($selectedApps.Count) $(if ($selectedApps.Count -eq 1) { 'app' } else { 'apps' }) complete."
Write-Host "Press any key to exit or wait 10 seconds..."

$startTime = Get-Date

while ((Get-Date) -lt $startTime.AddSeconds(10)) {
    if ([console]::KeyAvailable) {
        # Key was pressed
        [void][console]::ReadKey($true)
        Write-Host "Key pressed. Exiting..."
        break
    }
    Start-Sleep -Milliseconds 100
}

if ((Get-Date) -ge $startTime.AddSeconds(10)) {
    Write-Host "Timeout reached. Exiting..."
}
# Start-Sleep -Seconds 0.75
'@

$scriptLogic = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptLogic))
Start-Process WT.exe -ArgumentList "powershell.exe -NoLogo -NoProfile -EncodedCommand $scriptLogic"
