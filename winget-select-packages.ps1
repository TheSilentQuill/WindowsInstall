$availableApps = @(
    "7zip.7zip",
    "Bitwarden.Bitwarden",
    "CodeSector.TeraCopy",
    "CrystalDewWorld.CrystalDiskInfo.ShizukuEdition",
    "Git.Git",
    "Google.AndroidStudio",
    "HTTPToolKit.HTTPToolKit",
    "IrfanSkiljan.IrfanView",
    "IrfanSkiljan.IrfanView.PlugIns",
    "IVPN.IVPN",
    "Levitsky.FontBase",
    "MediaArea.MediaInfo",
    "MediaArea.MediaInfo.GUI",
    "Microsoft.PowerToys",
    "Microsoft.VisualStudioCode",
    "MoritzBunkus.MKVToolNix",
    "Mozilla.Firefox",
    "Mozilla.Thunderbird",
    "MullvadVPN.MullvadVPN",
    "NordSecurity.NordVPN",
    "Postman.Postman",
    "PeterPawlowski.foobar2000",
    "Python.Python.3.13",
    "Rclone.Rclone",
    "RustDesk.RustDesk",
    "ShareX.ShareX",
    "SpecialK.SpecialK",
    "Spotify.Spotify",
    "Valve.Steam",
    "Vencord.Vesktop",
    "WinMerge.WinMerge",
    "WerWolv.ImHex",
    "aria2.aria2",
    "jqlang.jq",
    "voidtools.Everything.Alpha",
    "yt-dlp.yt-dlp"
)

$cursorPosition = 0
$selectedApps = New-Object System.Collections.Generic.List[System.String]

function Show-Menu {
    Clear-Host
    Write-Host "Use the Up/Down arrows to select, Space to toggle, and Enter to confirm your choices"
    Write-Host ""

    for ($i = 0; $i -lt $availableApps.Length; $i++) {
        $checkboxSelection = if ($selectedApps.Contains($availableApps[$i])) { "[X]" } else { "[ ]" }
        if ($i -eq $cursorPosition) {
            Write-Host "$checkboxSelection`t> $($availableApps[$i])" -ForegroundColor Cyan
        }
        else {
            Write-Host "$checkboxSelection`t  $($availableApps[$i])"
        }
    }
}

Show-Menu

while ($pressedKey -ne 'Enter') {
    $pressedKey = [System.Console]::ReadKey($true).Key

    switch ($pressedKey) {
        "UpArrow" {
            $cursorPosition = if ($cursorPosition -gt 0) { $cursorPosition - 1 } else { $availableApps.Length - 1 }
        }
        "DownArrow" {
            $cursorPosition = if ($cursorPosition -lt $availableApps.Length - 1) { $cursorPosition + 1 } else { 0 }
        }
        "Spacebar" {
            $currentApp = $availableApps[$cursorPosition]
            if ($selectedApps.Contains($currentApp)) {
                $selectedApps.Remove($currentApp)
            }
            else {
                $selectedApps.Add($currentApp)
            }
        }
        "Enter" {
            if ($selectedApps.Count -gt 0) {
                break
            }
        }
    }

    Show-Menu
}

Clear-Host

Write-Host "Installing selected applications..."
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