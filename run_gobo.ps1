# --- CONFIGURATION ---
$FormatterName = "Gobo"
$Formatter = "gobo.exe"
$ZipFile = "gobo-windows.zip"
$DownloadUrl = "https://github.com/EttyKitty/Gobo/releases/download/latest/$ZipFile"
$Exclusions = "extensions|.git|.svn|prefabs"
$Extension = "*.gml"

Write-Host "--- Gobo: GML Formatter ---" -ForegroundColor Cyan
Write-Host ""

Write-Host "[INFO] This script will run $FormatterName on all $Extension files in the project" -ForegroundColor Cyan
Write-Host "[INFO] The following patterns will be excluded: $Exclusions" -ForegroundColor Cyan
Write-Host ""

pause

Write-Host ""

# --- AUTO-UPDATE ---
if (!(Test-Path $Formatter)) {
    Write-Host "[INFO] $Formatter not found. Downloading..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipFile
    Expand-Archive -Path $ZipFile -DestinationPath "." -Force
    Remove-Item $ZipFile
    Write-Host "[INFO] Downloaded $Formatter" -ForegroundColor Green
}

# --- FILE GATHERING ---
Write-Host "[INFO] Gathering files..." -ForegroundColor Cyan

$Files = Get-ChildItem -Recurse -Filter $Extension | Where-Object { $_.FullName -notmatch $Exclusions }
$Total = $Files.Count
$Count = 0

if ($Total -eq 0) {
    Write-Host "[WARN] No $Extension files found!" -ForegroundColor Yellow
    pause; exit
}

Write-Host "[INFO] Found $Total files" -ForegroundColor Cyan

# --- PROCESSING ---
Write-Host "[INFO] Formatting..." -ForegroundColor Cyan

$Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

foreach ($File in $Files) {
    $Count++
    $Host.UI.RawUI.WindowTitle = "$($File.Name) [$Count / $Total]"
    
    # Run the formatter
    & "./$Formatter" $File.FullName | Out-Null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed on $($File.FullName)" -ForegroundColor Red
    }
}

$Stopwatch.Stop()

# --- SUMMARY ---
$Time = $Stopwatch.Elapsed.ToString("hh\:mm\:ss\.ff")
Write-Host ""
Write-Host "[INFO] Formatting Complete!" -ForegroundColor Green
Write-Host "[INFO] Total Processed: $Total" -ForegroundColor Cyan
Write-Host "[INFO] Time Elapsed:    $Time" -ForegroundColor Cyan
Write-Host ""

pause