$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Install-ChocolateyZipPackage -PackageName 'kodinncli' `
  -Url64bit 'https://www.digitalsolutions.it/downloads/kodinncli/0.9.7/KodinnCli-0.9.7-win-x64.zip' `
  -Checksum64 '293701dd1abab8c82d2b4e6135a7aa58d08e17cb052d2034d5c757bb31b69179' -ChecksumType64 'sha256' `
  -UnzipLocation $toolsDir
# Chocolatey shims every .exe under tools (KodinnCli); `kodinn` is the short command.
Install-BinFile -Name 'kodinn' -Path (Join-Path $toolsDir 'KodinnCli-0.9.7-win-x64\KodinnCli.exe')
