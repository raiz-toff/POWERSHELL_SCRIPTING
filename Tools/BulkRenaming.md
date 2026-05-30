# PowerShell Script to Remove Spaces from File Names

This PowerShell script removes spaces from file names in the current directory.

## Script

```powershell
Get-ChildItem -File | ForEach-Object {
    $newName = $_.Name -replace ' ', ''
    Rename-Item $_.FullName -NewName $newName
}
