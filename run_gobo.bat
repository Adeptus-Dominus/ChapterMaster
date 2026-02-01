@echo off
setlocal enabledelayedexpansion

:: --- CONFIGURATION ---
set "FORMATTER=gobo.exe"
set "EXT=*.gml"
set "EXCLUDE_LIST=extensions .git .svn"
set "ZIP_NAME=gobo-windows.zip"
set "DOWNLOAD_URL=https://github.com/EttyKitty/Gobo/releases/download/v1.0.0/%ZIP_NAME%"

:: --- AUTO-UPDATE / DOWNLOAD ---
echo [SYSTEM] Checking for latest version of %FORMATTER%...

curl -LO %DOWNLOAD_URL%

if %errorlevel% equ 0 (
    echo [SYSTEM] Extracting %FORMATTER%...
    tar -xf %ZIP_NAME%
    del %ZIP_NAME%
    echo [SYSTEM] Update successful.
) else (
    echo [WARNING] Could not download latest version. Attempting to use existing %FORMATTER%.
)

:: --- VALIDATION ---
where %FORMATTER% >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] %FORMATTER% not found in PATH or current directory.
    pause
    exit /b
)

echo [SYSTEM] Starting GML Formatter...
echo [SYSTEM] Excluding: %EXCLUDE_LIST%
echo ---------------------------------------

set /a "FILE_COUNT=0"

:: --- PROCESSING ---

for /r %%f in (%EXT%) do (
    set "SKIP="

    for %%e in (%EXCLUDE_LIST%) do (
        echo %%f | findstr /i "%%e" >nul && set "SKIP=1"
    )

    if not defined SKIP (
        set /a "FILE_COUNT+=1"
        title Formatting: !FILE_COUNT! files...

        %FORMATTER% "%%f" >nul
        if !errorlevel! neq 0 (
            echo [!] ERROR: Failed to format %%f
        )
    )
)

:: --- SUMMARY ---
echo ---------------------------------------
echo [SUCCESS] Formatting complete.
echo [STATS]   Total Processed: %FILE_COUNT%
echo [SYSTEM]  End Time:   %TIME%
echo ---------------------------------------
title Command Prompt

pause
