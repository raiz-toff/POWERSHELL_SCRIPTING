param(
    [string]$inputRoot = "D:\DataGoogle\fOLDER\Takeout\Google Photos",
    [string]$outputRoot = "D:\DataGoogle\fOLDER\PatchedPhotos"
)

# Create output folder if it doesn't exist
if (!(Test-Path $outputRoot)) {
    New-Item -ItemType Directory -Path $outputRoot | Out-Null
}

# Loop through all subfolders
Get-ChildItem -Path $inputRoot -Directory -Recurse | ForEach-Object {
    $relativePath = $_.FullName.Substring($inputRoot.Length).TrimStart('\')
    $outPath = Join-Path $outputRoot $relativePath

    if (!(Test-Path $outPath)) {
        New-Item -ItemType Directory -Path $outPath | Out-Null
    }

    Write-Host "Processing $($_.FullName) -> $outPath" -ForegroundColor Cyan
    python -m google_photos_takeout_helper -i "$($_.FullName)" -o "$outPath"
}
