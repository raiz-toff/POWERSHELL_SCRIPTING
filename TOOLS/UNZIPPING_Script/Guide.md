# PowerShell Script to Unzip All Zip Files in the Current Directory

This PowerShell script extracts all `.zip` files in the current directory. It creates a separate folder for each zip file, using the zip file's name as the folder name. The script uses the `Expand-Archive` cmdlet to perform the extraction.

## Prerequisites

Ensure you are running the script in the directory containing the `.zip` files.

## Script

```powershell
# This script unzips all zip files in the current directory
# and creates a folder for each zip file with the same name as the zip file.
# It uses the Expand-Archive cmdlet to extract the contents of the zip files.
# Ensure the script is run in the directory containing the zip files

Get-ChildItem *.zip | ForEach-Object {
    $destination = "$($_.BaseName)"
    Expand-Archive -Path $_.FullName -DestinationPath $destination
}

