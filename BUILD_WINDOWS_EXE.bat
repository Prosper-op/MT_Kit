@echo off
setlocal

set "APP_DIR=%~dp0"
set "MATLAB_EXE="

if defined MATLAB_ROOT if exist "%MATLAB_ROOT%\bin\matlab.exe" (
    set "MATLAB_EXE=%MATLAB_ROOT%\bin\matlab.exe"
)

if not defined MATLAB_EXE (
    for /f "delims=" %%M in ('where matlab 2^>nul') do (
        if not defined MATLAB_EXE set "MATLAB_EXE=%%M"
    )
)

if not defined MATLAB_EXE if exist "%ProgramFiles%\MATLAB\R2022b\bin\matlab.exe" (
    set "MATLAB_EXE=%ProgramFiles%\MATLAB\R2022b\bin\matlab.exe"
)

if not defined MATLAB_EXE (
    echo MATLAB was not found.
    echo Install MATLAB R2022b or newer, add matlab.exe to PATH, or set MATLAB_ROOT.
    pause
    exit /b 1
)

if not exist "%APP_DIR%dist" mkdir "%APP_DIR%dist"

echo Building the self-contained MT_Kit application with:
echo "%MATLAB_EXE%"
"%MATLAB_EXE%" -sd "%APP_DIR%" -batch "mcc('-m','MT_Kit.m','-d','dist','-o','MT_Kit')"
if errorlevel 1 (
    echo Build failed for MT_Kit. Confirm MATLAB Compiler is licensed and available.
    pause
    exit /b 1
)

if not exist "%APP_DIR%dist\MT_Kit.exe" (
    echo MATLAB reported success, but the expected executable was not found:
    echo "%APP_DIR%dist\MT_Kit.exe"
    pause
    exit /b 1
)

copy /Y "%APP_DIR%INSTALL_MT_Kit_Shortcuts.bat" "%APP_DIR%dist\INSTALL_MT_Kit_Shortcuts.bat" >nul
if errorlevel 1 (
    echo Could not copy the MT_Kit shortcut installer into the distribution folder.
    pause
    exit /b 1
)

copy /Y "%APP_DIR%Create_MT_Kit_Shortcuts.ps1" "%APP_DIR%dist\Create_MT_Kit_Shortcuts.ps1" >nul
if errorlevel 1 (
    echo Could not copy the MT_Kit shortcut setup into the distribution folder.
    pause
    exit /b 1
)

echo.
echo Build complete:
echo "%APP_DIR%dist\MT_Kit.exe"
echo.
echo Run "%APP_DIR%dist\INSTALL_MT_Kit_Shortcuts.bat" on each target PC
echo to add MT_Kit to that user's Desktop and Start menu.
echo.
echo Install the MATLAB Runtime matching the MATLAB Compiler release on
echo every target Windows PC before running the executable. MATLAB itself
echo is not required on the target PC.
pause
endlocal
