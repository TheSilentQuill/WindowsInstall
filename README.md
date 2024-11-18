# WindowsInstall

## Prerequisites
- Windows PowerShell (or Windows Terminal) should be available on your system.

## Instructions

### Step 1: Open PowerShell
1. Right-click on the Windows start menu
2. Select PowerShell or Windows Terminal (if Terminal ensure you are on Powershell, not Command Prompt).

### Step 2: Run the Script
1. Copy and paste the following command into the PowerShell/Windows Terminal window:
- If you want to install everything:
```pwsh
iwr https://raw.githubusercontent.com/TheSilentQuill/WindowsInstall/refs/heads/main/winget-packages.ps1 | iex
```
- If you want to select what to install:
```pwsh
iwr https://raw.githubusercontent.com/TheSilentQuill/WindowsInstall/refs/heads/main/winget-select-packages.ps1 | iex
```
2. Press **Enter** to execute the command.

### Step 2.5: Execution Policy
- If you get an error `Script blocked by Execution Policy`, do the following:
1. Ensure you are running PowerShell as admin: Press `Windows Key+X` and select PowerShell (Admin) or Windows Terminal (Admin).
2. In the PowerShell window, type this to allow unsigned code to execute and run the installation script:
- If you a temporary solution (Only affects the current PowerShell session):
```pwsh
Set-ExecutionPolicy Unrestricted -Scope Process -Force
```
- If you a permanent solution (Affects the system or user-wide execution policy):
```pwsh
Set-ExecutionPolicy Unrestricted -Force
```

### Step 3: Complete Activation
- After you make your selection, the script will automatically proceed with the installation / ask for your input in interactive mode.
- Once complete, all the programs will be installed on your computer.

That's all! You've successfully installed the programs on your system.
