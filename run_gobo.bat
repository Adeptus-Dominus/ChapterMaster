@echo off
setlocal enabledelayedexpansion

REM --- CONFIGURATION ---
set "FORMATTER_NAME=Gobo"
set "FORMATTER_FILE=gobo.exe"
set "EXT=*.gml"
set "EXCLUDE_LIST=extensions .git .svn prefabs"
set "ZIP_NAME=gobo-windows.zip"
set "DOWNLOAD_URL=https://github.com/EttyKitty/Gobo/releases/download/v1.0.0/%ZIP_NAME%"

REM --- CONFIRMATION ---
echo [INFO] This script will run %FORMATTER_NAME% on all %EXT% files in the project
echo [INFO] The following folders will be excluded: %EXCLUDE_LIST%.

pause

echo ---------------------------------------

REM --- AUTO-UPDATE / DOWNLOAD ---
echo [INFO] Downloading %FORMATTER_NAME%...

curl -s -LO %DOWNLOAD_URL%

if %errorlevel% equ 0 (
    echo [INFO] Extracting %FORMATTER_NAME%...
    tar -xf %ZIP_NAME%
    del %ZIP_NAME%
    echo [INFO] Update successful
) else (
    echo [WARNING] Could not download %FORMATTER_NAME%. Attempting to use existing %FORMATTER_FILE%
)
echo ---------------------------------------

REM --- VALIDATION ---
where %FORMATTER_FILE% >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] %FORMATTER_NAME% not found in PATH or current directory
    pause
    exit /b
)

REM --- PROCESSING ---
echo [INFO] Processing...

set "START_TIME=%TIME%"
set /a "FILE_COUNT=0"

for /r %%f in (%EXT%) do (
    set "SKIP="

    for %%e in (%EXCLUDE_LIST%) do (
        echo "%%f" | findstr /i "%%e" >nul && set "SKIP=1"
    )

    if not defined SKIP (
        set /a "FILE_COUNT+=1"
        title Formatting: %%~nxf [Total: !FILE_COUNT!]

        %FORMATTER_FILE% "%%f" >nul
        if !errorlevel! neq 0 (
            echo [!] ERROR: Failed to format %%f
        )
    )
)

REM --- CALCULATE DURATION ---
set "END_TIME=%TIME%"

for /f "tokens=1-4 delims=:.," %%a in ("%START_TIME%") do (
    set /a "start_h=%%a", "start_m=1%%b-100", "start_s=1%%c-100", "start_ms=1%%d-100"
)
for /f "tokens=1-4 delims=:.," %%a in ("%END_TIME%") do (
    set /a "end_h=%%a", "end_m=1%%b-100", "end_s=1%%c-100", "end_ms=1%%d-100"
)

set /a "start_total=(start_h*360000)+(start_m*6000)+(start_s*100)+start_ms"
set /a "end_total=(end_h*360000)+(end_m*6000)+(end_s*100)+end_ms"

set /a "diff=end_total-start_total"

if %diff% lss 0 set /a "diff+=8640000"

set /a "dur_h=diff/360000", "diff%%=360000"
set /a "dur_m=diff/6000", "diff%%=6000"
set /a "dur_s=diff/100", "dur_ms=diff%%100"

if %dur_m% lss 10 set dur_m=0%dur_m%
if %dur_s% lss 10 set dur_s=0%dur_s%
if %dur_ms% lss 10 set dur_ms=0%dur_ms%

REM --- SUMMARY ---
echo ---------------------------------------
echo [SUCCESS] Formatting complete
echo [STATS]   Total Processed: %FILE_COUNT%
echo [STATS]   Time Elapsed:    %dur_h%:%dur_m%:%dur_s%.%dur_ms%
echo ---------------------------------------
title Command Prompt

pause
