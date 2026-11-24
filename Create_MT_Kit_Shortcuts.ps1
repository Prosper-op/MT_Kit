$ErrorActionPreference = 'Stop'

$applicationPath = Join-Path $PSScriptRoot 'MT_Kit.exe'
if (-not (Test-Path -LiteralPath $applicationPath -PathType Leaf)) {
    throw "MT_Kit.exe was not found beside this shortcut installer: $applicationPath"
}

$shell = New-Object -ComObject WScript.Shell
$desktopPath = [Environment]::GetFolderPath('Desktop')
$startMenuPath = Join-Path ([Environment]::GetFolderPath('ApplicationData')) `
    'Microsoft\Windows\Start Menu\Programs'
New-Item -ItemType Directory -Path $startMenuPath -Force | Out-Null

foreach ($shortcutPath in @(
    (Join-Path $desktopPath 'MT_Kit.lnk'),
    (Join-Path $startMenuPath 'MT_Kit.lnk')
)) {
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $applicationPath
    $shortcut.WorkingDirectory = $PSScriptRoot
    $shortcut.Description = 'Launch MT_Kit MT data application'
    $shortcut.Save()
}
