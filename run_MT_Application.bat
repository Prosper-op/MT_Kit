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

"%MATLAB_EXE%" -sd "%APP_DIR%" -r "MT_Kit"
if errorlevel 1 (
    echo MATLAB could not start MT_Kit.
    pause
    exit /b 1
)

endlocal
