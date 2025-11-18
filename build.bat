@echo off
REM Build script for Infinite Stairs PC (Windows)
REM Builds game for Windows, Linux, and macOS

setlocal enabledelayedexpansion

set VERSION=1.0.0
set GODOT_BIN=godot

REM Check if Godot is available
where %GODOT_BIN% >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Error: Godot not found in PATH
    echo Please install Godot 4.3+ or add it to your PATH
    echo Download from: https://godotengine.org/download
    exit /b 1
)

REM Create builds directory
if not exist builds\windows mkdir builds\windows
if not exist builds\linux mkdir builds\linux
if not exist builds\macos mkdir builds\macos

REM Parse command line arguments
set PLATFORM=%1
if "%PLATFORM%"=="" set PLATFORM=all

if /i "%PLATFORM%"=="windows" goto build_windows
if /i "%PLATFORM%"=="win" goto build_windows
if /i "%PLATFORM%"=="linux" goto build_linux
if /i "%PLATFORM%"=="macos" goto build_macos
if /i "%PLATFORM%"=="mac" goto build_macos
if /i "%PLATFORM%"=="all" goto build_all

echo Unknown platform: %PLATFORM%
echo Usage: build.bat [windows^|linux^|macos^|all]
exit /b 1

:build_windows
echo Building for Windows...
%GODOT_BIN% --headless --export-release "Windows Desktop" builds\windows\InfiniteStairs.exe
if exist builds\windows\InfiniteStairs.exe (
    echo [OK] Windows build complete: builds\windows\InfiniteStairs.exe
) else (
    echo [FAIL] Windows build failed
    exit /b 1
)
if "%PLATFORM%"=="all" goto build_linux
goto end

:build_linux
echo.
echo Building for Linux...
%GODOT_BIN% --headless --export-release "Linux/X11" builds\linux\InfiniteStairs.x86_64
if exist builds\linux\InfiniteStairs.x86_64 (
    echo [OK] Linux build complete: builds\linux\InfiniteStairs.x86_64
) else (
    echo [FAIL] Linux build failed
    exit /b 1
)
if "%PLATFORM%"=="all" goto build_macos
goto end

:build_macos
echo.
echo Building for macOS...
%GODOT_BIN% --headless --export-release "macOS" builds\macos\InfiniteStairs.zip
if exist builds\macos\InfiniteStairs.zip (
    echo [OK] macOS build complete: builds\macos\InfiniteStairs.zip
) else (
    echo [FAIL] macOS build failed
    exit /b 1
)
goto end

:build_all
echo Building all platforms...
echo.
call :build_windows
call :build_linux
call :build_macos
echo.
echo All builds complete!
goto end

:end
echo.
echo Build process finished!
echo Builds are located in the 'builds\' directory
endlocal
