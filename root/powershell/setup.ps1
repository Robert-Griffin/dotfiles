# Install Powershell Modules
Install-Module PSReadLine -Repository PSGallery -Scope CurrentUser -Force
Install-Module -Name Terminal-Icons -Repository PSGallery

# Install scoop and scoop packages
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "`nInstalling Scoop..." -ForegroundColor Cyan
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    
    # Add common buckets
    scoop bucket add extras
    scoop bucket add versions
} else {
    Write-Host "`nScoop already installed" -ForegroundColor Green
}

# Install Scoop packages from list
if (Test-Path "$PSScriptRoot\scoop-packages.txt") {
    Write-Host "Installing Scoop packages..." -ForegroundColor Cyan
    Get-Content "$PSScriptRoot\scoop-packages.txt" | ForEach-Object {
        if ($_ -match '^\s*(\S+)') {
            scoop install $matches[1]
        }
    }
}
