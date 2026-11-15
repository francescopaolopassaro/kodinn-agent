$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Install-ChocolateyZipPackage -PackageName 'kodinncli' `
  -Url64bit 'https://www.digitalsolutions.it/downloads/kodinncli/0.9.4/KodinnCli-0.9.4-win-x64.zip' `
  -Checksum64 'eee9e0c9a3ae5566125700f4122cacdd1b04bfbad39705e265e1a65ba7577149' -ChecksumType64 'sha256' `
  -UnzipLocation $toolsDir
# Chocolatey shims every .exe under tools (KodinnCli); `kodinn` is the short command.
Install-BinFile -Name 'kodinn' -Path (Join-Path $toolsDir 'KodinnCli-0.9.4-win-x64\KodinnCli.exe')
