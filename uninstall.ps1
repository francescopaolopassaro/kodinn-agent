# Kodinn Agent (KodinnCli) uninstaller for Windows: removes what install.ps1 put in place.
#
#   irm https://raw.githubusercontent.com/francescopaolopassaro/kodinn-agent/main/uninstall.ps1 | iex
#
# Removes %LOCALAPPDATA%\Programs\KodinnCli and its entry in the user PATH. Your configuration and sessions
# (%APPDATA%\KodinnCli) are left alone.
$ErrorActionPreference = 'Stop'
$appDir = Join-Path $env:LOCALAPPDATA 'Programs\KodinnCli'

if (Get-Process -Name KodinnCli -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "$appDir*" }) {
    throw 'Kodinn Agent is running — close it and run the uninstaller again.'
}
if (Test-Path $appDir) { Remove-Item $appDir -Recurse -Force; Write-Host "removed $appDir" } else { Write-Host "nothing at $appDir" }

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($userPath) {
    $kept = ($userPath -split ';' | Where-Object { $_ -and $_.TrimEnd('\') -ine $appDir }) -join ';'
    if ($kept -ne $userPath) { [Environment]::SetEnvironmentVariable('Path', $kept, 'User'); Write-Host 'removed it from your PATH' }
}
Write-Host 'Kodinn Agent removed. Configuration kept: %APPDATA%\KodinnCli (delete it by hand to remove it too).'
