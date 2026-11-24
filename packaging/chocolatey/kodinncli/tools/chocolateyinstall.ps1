$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Install-ChocolateyZipPackage -PackageName 'kodinncli' `
  -Url64bit 'https://www.digitalsolutions.it/downloads/kodinncli/0.9.6/KodinnCli-0.9.6-win-x64.zip' `
  -Checksum64 '92db84ab03ca647288567ef669cbc263673c081e0e0b4d047be9467af7eec71c' -ChecksumType64 'sha256' `
  -UnzipLocation $toolsDir
# Chocolatey shims every .exe under tools (KodinnCli); `kodinn` is the short command.
Install-BinFile -Name 'kodinn' -Path (Join-Path $toolsDir 'KodinnCli-0.9.6-win-x64\KodinnCli.exe')
