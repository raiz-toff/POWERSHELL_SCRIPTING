$extractFolder = "F:\Extracted"   # Folder where files are being extracted
$checkInterval = 10                      # Seconds between checks
$totalTarget = 630GB                       # Expected total extracted size (your estimate)

Write-Host "═══════════════════════════════════════════════════════"
Write-Host " 📂 Monitoring extraction progress"
Write-Host "    Folder : $extractFolder"
Write-Host "    Target : $([math]::Round($totalTarget/1GB,2)) GB"
Write-Host "    Interval: $checkInterval sec"
Write-Host "═══════════════════════════════════════════════════════`n"

$previousSize = 0
$startTime = Get-Date

while ($true) {
    if (!(Test-Path $extractFolder)) {
        Write-Host "`n❌ Folder not found: $extractFolder" -ForegroundColor Red
        Start-Sleep $checkInterval
        continue
    }

    # Current stats
    $files = Get-ChildItem -Path $extractFolder -Recurse -File -ErrorAction SilentlyContinue
    $totalSize = ($files | Measure-Object Length -Sum).Sum
    $sizeGB = [math]::Round($totalSize / 1GB, 2)

    # Speed calculation
    $deltaSize = $totalSize - $previousSize
    $speedMBps = [math]::Round(($deltaSize / 1MB) / $checkInterval, 2)
    $previousSize = $totalSize

    # Progress %
    $progress = [math]::Min(($totalSize / $totalTarget) * 100, 100)
    $progressRounded = [math]::Round($progress, 2)

    # ETA calculation
    if ($speedMBps -gt 0) {
        $remaining = $totalTarget - $totalSize
        $secondsLeft = $remaining / ( $speedMBps * 1MB )
        $eta = (Get-Date).AddSeconds($secondsLeft)
        $timeLeft = [TimeSpan]::FromSeconds($secondsLeft)
        $etaText = "$([math]::Round($timeLeft.TotalHours,2)) hrs left (ETA $($eta.ToString('HH:mm:ss')))"
    } else {
        $etaText = "Calculating / Waiting..."
    }

    # Progress bar
    $barLength = 40
    $filled = [math]::Round(($progress / 100) * $barLength)
    $empty = $barLength - $filled
    $bar = ("█" * $filled) + ("░" * $empty)

    # Output
    Clear-Host
    Write-Host "═══════════════════════════════════════════════════════"
    Write-Host " ⏱️  Started: $startTime"
    Write-Host " 📂 Folder : $extractFolder"
    Write-Host "═══════════════════════════════════════════════════════`n"

    Write-Host (" [{0}] {1,6:N2}%  " -f $bar, $progressRounded) -ForegroundColor Cyan
    Write-Host (" ✅ Size    : {0} GB / {1} GB" -f $sizeGB, [math]::Round($totalTarget/1GB,2))
    Write-Host (" 🚀 Speed   : {0} MB/s" -f $speedMBps)
    Write-Host (" ⏳ ETA     : {0}" -f $etaText)

    Start-Sleep $checkInterval
}
