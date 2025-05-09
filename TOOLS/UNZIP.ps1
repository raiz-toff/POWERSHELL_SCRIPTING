# This script unzips all zip files in the current directory
# and creates a folder for each zip file with the same name as the zip file.
# It uses the Expand-Archive cmdlet to extract the contents of the zip files.
# Ensure the script is run in the directory containing the zip files


Get-ChildItem *.zip | ForEach-Object {
    $destination = "$($_.BaseName)"
    Expand-Archive -Path $_.FullName -DestinationPath $destination
}



