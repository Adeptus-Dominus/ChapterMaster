# --- CONFIGURATION ---
$Repo = "EttyKitty/GoboCat"
$FormatterName = "Gobo"
$Extension = "*.gml"

# Polyfill for Windows PowerShell 5.1 (which lacks built-in $IsWindows, $IsLinux, $IsMacOS)
if ($null -eq $IsWindows -and $null -eq $IsLinux -and $null -eq $IsMacOS) {
    $IsWindows = $true
    $IsLinux = $false
    $IsMacOS = $false
}

# Detect operating system and set platform-specific variables
if ($IsWindows) {
    $Formatter = "gobo.exe"
    $PlatformKeyword = "windows"
} elseif ($IsLinux) {
    $Formatter = "gobo"
    $PlatformKeyword = "linux"
} elseif ($IsMacOS) {
    $Formatter = "gobo"
    $PlatformKeyword = "mac"
} else {
    Write-Error "Unsupported operating system."
    exit 1
}

# Detect system architecture (defaulting to x64)
$ArchKeyword = "x64"
if ($IsWindows) {
    if ($env:PROCESSOR_ARCHITECTURE -like "*ARM*") {
        $ArchKeyword = "arm64"
    }
} else {
    try {
        $OSArch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString().ToLower()
        if ($OSArch -eq "arm64") {
            $ArchKeyword = "arm64"
        }
    } catch {
        if ((uname -m) -match "arm64|aarch64") {
            $ArchKeyword = "arm64"
        }
    }
}

Clear-Host
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "         GoboCat: GML Formatter             " -ForegroundColor White
Write-Host "=========================================" -ForegroundColor Cyan

# --- AUTO-UPDATE ---
if (!(Test-Path $Formatter)) {
    Write-Host ""
    Write-Host "[INFO] Downloading latest release..." -ForegroundColor Yellow
    $ApiUrl = "https://api.github.com/repos/$Repo/releases/latest"
    $Assets = (Invoke-RestMethod -Uri $ApiUrl -ErrorAction Stop).assets
    
    # 1. Attempt to match both platform and architecture keywords
    $Asset = $Assets | Where-Object { $_.name -like "*$PlatformKeyword*" -and $_.name -like "*$ArchKeyword*" } | Select-Object -First 1
    
    # Fallback for macOS if asset name uses "osx" instead of "mac"
    if (!$Asset -and $IsMacOS) {
        $Asset = $Assets | Where-Object { $_.name -like "*osx*" -and $_.name -like "*$ArchKeyword*" } | Select-Object -First 1
    }
    
    # 2. General fallback if no architecture-specific match is found
    if (!$Asset) {
        $Asset = $Assets | Where-Object { $_.name -like "*$PlatformKeyword*" } | Select-Object -First 1
    }
    if (!$Asset -and $IsMacOS) {
        $Asset = $Assets | Where-Object { $_.name -like "*osx*" } | Select-Object -First 1
    }
    
    if (!$Asset) {
        Write-Error "Could not find a valid release asset for this platform."
        exit 1
    }
    
    $FileName = $Asset.name
    Write-Host "[INFO] Downloading: $FileName" -ForegroundColor Gray
    Invoke-WebRequest -Uri $Asset.browser_download_url -OutFile $FileName -ErrorAction Stop
    
    # Handle extraction based on file extension
    if ($FileName -like "*.zip") {
        Expand-Archive -Path $FileName -DestinationPath "." -Force
    } elseif ($FileName -like "*.tar.gz" -or $FileName -like "*.tgz") {
        tar -xzf $FileName
    }
    
    Remove-Item $FileName
    
    # Set execution permissions on Linux and macOS
    if (!$IsWindows) {
        chmod +x "./$Formatter"
    }
    
    Write-Host "[SUCCESS] Formatter ready.`n" -ForegroundColor Green
}

Write-Host ""
Write-Host "[INFO] This script will run $FormatterName on all $Extension files in the project" -ForegroundColor Cyan
Write-Host ""

[void](Read-Host "Press Enter to continue")

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
    [void](Read-Host "Press Enter to exit")
    exit 1
} else {
    Write-Host "[SUCCESS] Press Enter to close..." -ForegroundColor Green
    [void](Read-Host "Press Enter to exit")
    exit 0
}
