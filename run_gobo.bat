@echo off

:: Run the script
powershell -ExecutionPolicy Bypass -File "run_gobo.ps1"

:: If the exit code is not 0, something went wrong. Pause the window.
if %errorlevel% neq 0 (
    echo.
    echo [TERMINATED] The script encountered a fatal error.
    pause
    exit /b 1
) else (
    echo.
    echo [FINISHED] Press any key to close...
    pause >nul
    exit /b 0
)