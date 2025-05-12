Get-ChildItem -File | ForEach-Object {
    $newName = $_.Name -replace ' ', ''
    Rename-Item $_.FullName -NewName $newName
}
# This script renames all files in the current directory by removing spaces from their names.
# It uses Get-ChildItem to list all files and ForEach-Object to iterate over each file.