```markdown
# ✅ How to Use

1. **Save the Script**  
   Save the script in a file named `unzip-all.ps1`.

2. **Place Your ZIP Files**  
   Put all your `.zip` files in a folder (e.g., `C:\Users\YourName\Downloads\Zips`).

3. **Open PowerShell**  
   Press `Win + S`, type **PowerShell**, and open it.

4. **Navigate to the ZIP Folder**

```powershell
cd "C:\Users\YourName\Downloads\Zips"
```

5. **Run the Script**  
   If the script is in the same folder:

```powershell
.\unzip-all.ps1
```

If the script is elsewhere, provide the full path:

```powershell
& "C:\Path\To\unzip-all.ps1"
```

# 🛠 Customizing Destination Path

To extract all files into a specific folder (e.g., `D:\ExtractedZips`), modify the script:

```powershell
$destinationRoot = "D:\ExtractedZips"

Get-ChildItem *.zip | ForEach-Object {
    $destination = Join-Path $destinationRoot $_.BaseName
    Expand-Archive -Path $_.FullName -DestinationPath $destination
}
```

# ⚠️ Troubleshooting

If you get a permission error when running the script:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

This allows local scripts to run.

# 📂 Output Example

For a file named `project-files.zip`, the script will create:

```bash
./project-files/
    └── [unzipped contents here]
```

# 💬 Questions?

Open an issue or contact the author if you need help.
```
