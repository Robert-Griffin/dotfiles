# Install Powershell Modules
Install-Module PSReadLine -Repository PSGallery -Scope CurrentUser -Force
Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force

# Install scoop and scoop packages
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "`nInstalling Scoop..." -ForegroundColor Cyan
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    
    # Add common buckets
    scoop bucket add extras
    scoop bucket add nerd-fonts
    scoop bucket add versions
} else {
    Write-Host "`nScoop already installed" -ForegroundColor Green
}

# Install Scoop packages from list
if (Test-Path "$PSScriptRoot\scoop-packages.json") {
    Write-Host "Installing Scoop packages..." -ForegroundColor Cyan
    $scoopPackages = Get-Content "$PSScriptRoot\scoop-packages.json" | ConvertFrom-Json
    foreach ($app in $scoopPackages.apps) {
        scoop install $app.Name
    }
}

# Link terminal settings
$wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

Copy-Item $wtSettingsPath "$wtSettingsPath.backup"
Remove-Item $wtSettingsPath
New-Item -ItemType SymbolicLink -Path $wtSettingsPath -Target "$PSScriptRoot\terminalSettings.json" -Force

# Link Profile
New-Item -ItemType SymbolicLink -Path $PROFILE -Target "$PSScriptRoot\profile.ps1" -Force
