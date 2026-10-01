# Applies the VLC dark theme + 4K scaling fix. Close VLC before running.
# Usage: powershell -ExecutionPolicy Bypass -File apply.ps1 [-Scale 1.5]   (-Scale 1 = no extra scaling)
param([double]$Scale = 1.25)

$vlc = "$env:APPDATA\vlc"
if (Get-Process vlc -ErrorAction SilentlyContinue) { Write-Warning "VLC is running - close it first or it may overwrite these settings."; exit 1 }
if (-not (Test-Path "$vlc\vlcrc")) { Write-Warning "No vlcrc found. Open and close VLC once, then rerun."; exit 1 }

$ts = Get-Date -Format yyyyMMdd-HHmmss
$bak = Join-Path $PSScriptRoot "backups"
New-Item -ItemType Directory -Force $bak | Out-Null
Copy-Item "$vlc\vlcrc" "$bak\vlcrc.bak-$ts"
if (Test-Path "$vlc\vlc-qt-interface.ini") { Copy-Item "$vlc\vlc-qt-interface.ini" "$bak\vlc-qt-interface.ini.bak-$ts" }

$utf8 = New-Object Text.UTF8Encoding $false

# 1. Built-in dark palette
$rc = [IO.File]::ReadAllText("$vlc\vlcrc")
if ($rc -match '(?m)^#?qt-dark-palette=\d') { $rc = $rc -replace '(?m)^#?qt-dark-palette=\d', 'qt-dark-palette=1' }
else { $rc = $rc -replace '(?m)^\[qt\].*\r?\n', "`$0qt-dark-palette=1`r`n" }
[IO.File]::WriteAllText("$vlc\vlcrc", $rc, $utf8)

# 2. Fusion style (makes the dark palette apply everywhere)
$iniPath = "$vlc\vlc-qt-interface.ini"
$ini = if (Test-Path $iniPath) { [IO.File]::ReadAllText($iniPath) } else { "" }
if ($ini -match '(?m)^QtStyle=') { $ini = $ini -replace '(?m)^QtStyle=.*', 'QtStyle=Fusion' }
elseif ($ini -match '(?m)^\[MainWindow\]') { $ini = $ini -replace '(?m)^\[MainWindow\]\r?\n', "[MainWindow]`r`nQtStyle=Fusion`r`n" }
else { $ini += "`r`n[MainWindow]`r`nQtStyle=Fusion`r`n" }
[IO.File]::WriteAllText($iniPath, $ini, $utf8)

# 3. HiDPI scaling (user env var, read by Qt at startup)
[Environment]::SetEnvironmentVariable('QT_AUTO_SCREEN_SCALE_FACTOR', '1', 'User')
# VLC 3 ignores the auto factor for toolbar icons; QT_SCALE_FACTOR is what actually enlarges them
if ($Scale -gt 0 -and $Scale -ne 1) { [Environment]::SetEnvironmentVariable('QT_SCALE_FACTOR', "$Scale", 'User') }
else { [Environment]::SetEnvironmentVariable('QT_SCALE_FACTOR', $null, 'User') }

Write-Host "Done. Backups saved to $bak (suffix $ts). Sign out/in or restart Explorer if VLC still looks small."
