@echo off
setlocal

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Create_MT_Kit_Shortcuts.ps1"
if errorlevel 1 (
    echo Could not create MT_Kit shortcuts.
    pause
    exit /b 1
)

echo MT_Kit shortcuts are available on the Desktop and in the Start menu.
pause
endlocal
