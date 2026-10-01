# Reverts VLC to the light theme and removes the scaling variables. Close VLC before running.
$vlc = "$env:APPDATA\vlc"
if (Get-Process vlc -ErrorAction SilentlyContinue) { Write-Warning "Close VLC first."; exit 1 }
$utf8 = New-Object Text.UTF8Encoding $false

$rc = [IO.File]::ReadAllText("$vlc\vlcrc") -replace '(?m)^qt-dark-palette=1', '#qt-dark-palette=0'
[IO.File]::WriteAllText("$vlc\vlcrc", $rc, $utf8)

$iniPath = "$vlc\vlc-qt-interface.ini"
if (Test-Path $iniPath) {
    $ini = [IO.File]::ReadAllText($iniPath) -replace '(?m)^QtStyle=Fusion\r?\n', ''
    [IO.File]::WriteAllText($iniPath, $ini, $utf8)
}

[Environment]::SetEnvironmentVariable('QT_AUTO_SCREEN_SCALE_FACTOR', $null, 'User')
[Environment]::SetEnvironmentVariable('QT_SCALE_FACTOR', $null, 'User')
Write-Host "Reverted. Original files are also in the backups folder if you want a full restore."
