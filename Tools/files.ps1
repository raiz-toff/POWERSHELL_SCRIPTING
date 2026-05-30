# Folder path
$folderPath = "D:\DataGoogle\fOLDER\AllPhotos"

# Get all files in the folder
$files = Get-ChildItem -Path $folderPath -File

# Group files by base name without the (number) suffix
$groups = $files | Group-Object {
    $_.BaseName -replace '\(\d+\)$', ''
}

foreach ($group in $groups) {
    # Sort so that the original (without suffix) comes first
    $sortedFiles = $group.Group | Sort-Object {
        if ($_.BaseName -match '\(\d+\)$') { 1 } else { 0 }
    }

    # Keep the first (original) and delete the rest
    $filesToDelete = $sortedFiles | Select-Object -Skip 1
    foreach ($file in $filesToDelete) {
        Write-Host "Deleting duplicate: $($file.FullName)"
        Remove-Item $file.FullName -Force
    }
}

Write-Host "All numbered duplicates removed successfully."
