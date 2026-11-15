# Kodinn Agent (KodinnCli) installer for Windows.
#
#   irm https://raw.githubusercontent.com/francescopaolopassaro/kodinn-agent/main/install.ps1 | iex
#
# Reads latest.json from www.digitalsolutions.it (GitHub as fallback), downloads the Windows package, checks its
# SHA-256, unpacks it into %LOCALAPPDATA%\Programs\KodinnCli and adds that folder to the user PATH, with a `kodinn`
# command beside KodinnCli.exe. $env:KODINNCLI_VERSION installs a given version.
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$latestUrls = @($env:KODINNCLI_LATEST_URL) + @(
    'https://www.digitalsolutions.it/downloads/kodinncli/latest.json',
    'https://raw.githubusercontent.com/francescopaolopassaro/kodinn-agent/main/latest.json'
)
$appDir = Join-Path $env:LOCALAPPDATA 'Programs\KodinnCli'

function Say($t) { Write-Host $t -ForegroundColor Cyan }

if ([Environment]::Is64BitOperatingSystem -eq $false) { throw 'Kodinn Agent needs 64-bit Windows.' }
if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { Say 'Windows on ARM: the x64 build runs under emulation.' }

$latest = $null
foreach ($u in ($latestUrls | Where-Object { $_ })) {
    try { $latest = Invoke-RestMethod -Uri $u -UseBasicParsing; break } catch { }
}
if (-not $latest) { throw 'Could not read latest.json.' }

$version = $latest.version
$pkg = $latest.files.'win-x64'
$url = $pkg.url; $sha = $pkg.sha256; $folder = $pkg.folder
if ($env:KODINNCLI_VERSION -and $env:KODINNCLI_VERSION -ne $version) {
    $url = $url.Replace($version, $env:KODINNCLI_VERSION); $folder = $folder.Replace($version, $env:KODINNCLI_VERSION)
    $sha = $null; $version = $env:KODINNCLI_VERSION
}
Say "Kodinn Agent $version for Windows x64"

$tmp = Join-Path $env:TEMP ("kodinncli-install-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Force $tmp | Out-Null
try {
    $zip = Join-Path $tmp 'kodinncli.zip'
    Say "Downloading $url"
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
    if ($sha) {
        $got = (Get-FileHash $zip -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($got -ne $sha.ToLowerInvariant()) { throw "Checksum mismatch (expected $sha, got $got)." }
        Say 'Checksum ok'
    }
    Expand-Archive -Path $zip -DestinationPath $tmp -Force

    # A running copy holds its files: ask to close it rather than half-replace them.
    if (Get-Process -Name KodinnCli -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "$appDir*" }) {
        throw 'Kodinn Agent is running — close it and run the installer again.'
    }
    if (Test-Path $appDir) { Remove-Item $appDir -Recurse -Force }
    New-Item -ItemType Directory -Force $appDir | Out-Null
    Copy-Item -Path (Join-Path $tmp "$folder\*") -Destination $appDir -Recurse -Force
    Set-Content -Path (Join-Path $appDir 'kodinn.cmd') -Value "@`"%~dp0KodinnCli.exe`" %*" -Encoding ascii
} finally {
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($env:KODINNCLI_NO_PATH) { Say "Installed into $appDir (PATH left as it is)."; return }
if (-not ($userPath -split ';' | Where-Object { $_.TrimEnd('\') -ieq $appDir })) {
    [Environment]::SetEnvironmentVariable('Path', ($userPath.TrimEnd(';') + ";$appDir").TrimStart(';'), 'User')
    $env:Path += ";$appDir"
    Say "Added $appDir to your PATH (new terminals pick it up)."
}
Say "Installed into $appDir"
Say 'Run: kodinn'
