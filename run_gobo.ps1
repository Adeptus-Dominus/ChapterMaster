# --- CONFIGURATION ---
$Repo = "EttyKitty/Gobo"
$FormatterName = "Gobo"
$Formatter = "gobo.exe"
$ZipFile = "gobo-windows.zip"
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
    Write-Host "[INFO] $Formatter not found. Fetching latest release info..." -ForegroundColor Yellow
    
    try {
        $ApiUrl = "https://api.github.com/repos/$Repo/releases/latest"
        $ReleaseInfo = Invoke-RestMethod -Uri $ApiUrl -ErrorAction Stop
        
        $Asset = $ReleaseInfo.assets | Where-Object { $_.name -like "*windows*.zip" } | Select-Object -First 1
        
        if ($null -eq $Asset) { throw "Could not find a Windows zip in the latest release." }
        
        $DownloadUrl = $Asset.browser_download_url
        Write-Host "[INFO] Found version $($ReleaseInfo.tag_name). Downloading..." -ForegroundColor Gray

        Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipFile -ErrorAction Stop
        
        Write-Host "[INFO] Extracting..." -ForegroundColor Gray
        Expand-Archive -Path $ZipFile -DestinationPath "." -Force
        Remove-Item $ZipFile
        
        Write-Host "[SUCCESS] Installed $Formatter (Version: $($ReleaseInfo.tag_name))`n" -ForegroundColor Green
    } catch {
        Write-Host "`n[FATAL ERROR] Could not setup formatter!" -ForegroundColor Red
        Write-Host "Reason: $($_.Exception.Message)" -ForegroundColor White
        exit 1
    }
}

# --- FILE GATHERING ---
Write-Host "[INFO] Gathering files..." -ForegroundColor Cyan

$Files = Get-ChildItem -Recurse -Filter $Extension | Where-Object { $_.FullName -notmatch $Exclusions }
$Total = $Files.Count
$Count = 0
$Errors = 0

if ($Total -eq 0) {
    Write-Host "[WARN] No $Extension files found!" -ForegroundColor Yellow
    pause; exit 0
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
        $Errors++
    }
}

$Stopwatch.Stop()

# --- SUMMARY ---
$Time = $Stopwatch.Elapsed.ToString("hh\:mm\:ss\.ff")
Write-Host ""
Write-Host "[INFO] Formatting Complete!" -ForegroundColor Green
Write-Host "[INFO] Total Processed: $Total" -ForegroundColor Cyan
Write-Host "[INFO] Time Elapsed:    $Time" -ForegroundColor Cyan
Write-Host "[INFO] Errors:          $Errors" -ForegroundColor $(if ($Errors -gt 0) { "Red" } else { "Cyan" })
Write-Host ""

pause