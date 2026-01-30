@echo off
setlocal enabledelayedexpansion

:: --- CONFIGURATION ---
set "FORMATTER=gobo.exe"
set "EXT=*.gml"
set "EXCLUDE_DIR=extensions"

:: --- VALIDATION ---
where %FORMATTER% >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] %FORMATTER% not found in PATH or current directory.
    pause
    exit /b
)

echo [SYSTEM] Starting GML Formatter...
echo [SYSTEM] Excluding: %EXCLUDE_DIR%
echo ---------------------------------------

set /a "FILE_COUNT=0"

:: --- PROCESSING ---

for /r %%f in (%EXT%) do (
    echo %%f | findstr /i "EXCLUDE_DIR" >nul || (
        echo Formatting: %%f
        gobo.exe "%%f"
        set /a "FILE_COUNT+=1"
        title Formatting: !FILE_COUNT! files...
        %FORMATTER% "%%f" >nul
    )
)

:: --- SUMMARY ---
echo ---------------------------------------
echo [SUCCESS] Formatting complete.
echo [STATS]   Total GML files processed: %FILE_COUNT%
echo ---------------------------------------
title Command Prompt
pause