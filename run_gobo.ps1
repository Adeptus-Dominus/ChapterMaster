# --- CONFIGURATION ---
$Repo = "EttyKitty/Gobo"
$FormatterName = "Gobo"
$Formatter = "gobo.exe"
$ZipFile = "gobo-windows.zip"
$Extension = "*.gml"

Clear-Host
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "         Gobo: GML Formatter             " -ForegroundColor White
Write-Host "=========================================" -ForegroundColor Cyan

# --- AUTO-UPDATE ---
if (!(Test-Path $Formatter)) {
	Write-Host ""
    Write-Host "[INFO] Downloading latest release..." -ForegroundColor Yellow
    $ApiUrl = "https://api.github.com/repos/$Repo/releases/latest"
    $Asset = (Invoke-RestMethod -Uri $ApiUrl).assets | Where-Object { $_.name -like "*windows*.zip" } | Select-Object -First 1
    Invoke-WebRequest -Uri $Asset.browser_download_url -OutFile "temp.zip"
    Expand-Archive -Path "temp.zip" -DestinationPath "." -Force
    Remove-Item "temp.zip"
    Write-Host "[SUCCESS] Formatter ready.`n" -ForegroundColor Green
}

Write-Host ""
Write-Host "[INFO] This script will run $FormatterName on all $Extension files in the project" -ForegroundColor Cyan
Write-Host ""

pause

Write-Host ""

Write-Host "[INFO] Formatting project..." -ForegroundColor Cyan

$Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Run Gobo and capture ALL output (Stdout and Stderr) into an array of strings
$Output = & "./$Formatter" . 2>&1

$Stopwatch.Stop()

# --- PARSE RESULTS ---
$Errors = 0
$Warnings = 0
$FilesProcessed = "Unknown"

foreach ($Line in $Output) {
    if ($Line -match "\[Error\]") {
        Write-Host $Line -ForegroundColor Red
        $Errors++
    }
    elseif ($Line -match "\[Warn\]") {
        Write-Host $Line -ForegroundColor Yellow
        $Warnings++
    }
    else {
        Write-Host $Line -ForegroundColor Gray
        if ($Line -match "Formatted (\d+) files") {
            $FilesProcessed = $Matches[1]
        }
    }
}

# --- SUMMARY BLOCK ---
$Time = $Stopwatch.Elapsed.ToString("hh\:mm\:ss\.ff")
Write-Host ""
Write-Host "-----------------------------------------" -ForegroundColor Cyan
Write-Host "[SUMMARY] Formatting Complete" -ForegroundColor Green
Write-Host "-----------------------------------------" -ForegroundColor Cyan
Write-Host "Files Processed: $FilesProcessed" -ForegroundColor White
Write-Host "Time Elapsed:    $Time" -ForegroundColor White

if ($Errors -gt 0) {
    Write-Host "Errors:          $Errors" -ForegroundColor Red
} else {
    Write-Host "Errors:          0" -ForegroundColor Green
}

if ($Warnings -gt 0) {
    Write-Host "Warnings:        $Warnings" -ForegroundColor Yellow
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

if ($LASTEXITCODE -ne 0 -or $Errors -gt 0) {
    Write-Host "[TERMINATED] Finished with errors." -ForegroundColor Red
    pause
    exit 1
} else {
    Write-Host "[SUCCESS] Press any key to close..." -ForegroundColor Green
    pause
    exit 0
}
