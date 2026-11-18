$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Install-ChocolateyZipPackage -PackageName 'kodinncli' `
  -Url64bit 'https://www.digitalsolutions.it/downloads/kodinncli/0.9.5/KodinnCli-0.9.5-win-x64.zip' `
  -Checksum64 '4405b9b4b1288181e429dc47b2d00ad617ae45b167e85f75037fb7470221d265' -ChecksumType64 'sha256' `
  -UnzipLocation $toolsDir
# Chocolatey shims every .exe under tools (KodinnCli); `kodinn` is the short command.
Install-BinFile -Name 'kodinn' -Path (Join-Path $toolsDir 'KodinnCli-0.9.5-win-x64\KodinnCli.exe')
