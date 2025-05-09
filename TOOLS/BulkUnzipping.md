
# 📦 Bulk Unzip Guide Using PowerShell

This guide helps you extract multiple `.zip` files at once using a simple PowerShell script.

---

## ✅ Step-by-Step Instructions

### 1. Save the Script
Save the following script as `unzip-all.ps1`:

```powershell
Get-ChildItem *.zip | ForEach-Object {
    $destination = "$($_.BaseName)"
    Expand-Archive -Path $_.FullName -DestinationPath $destination
}

```

> This script creates a folder named `Extracted` in your current directory and unzips each `.zip` into its own subfolder.

---

### 2. Prepare ZIP Files
Place all your `.zip` files in a single folder (e.g.,  
`C:\Users\YourName\Downloads\Zips`).

---

### 3. Open PowerShell
- Press `Win + S`, search for **PowerShell**, and open it.

---

### 4. Navigate to ZIP Folder

```powershell
cd "C:\Users\YourName\Downloads\Zips"
```

---

### 5. Run the Script

- If the script is in the same folder:

```powershell
.\unzip-all.ps1
```

- If the script is in another folder:

```powershell
& "C:\Path\To\unzip-all.ps1"
```

---

## ⚙️ Custom Output Folder

To extract all `.zip` files into a custom folder (e.g., `D:\UnzippedFiles`), change the script like this:

```powershell
$destinationRoot = "D:\UnzippedFiles"

Get-ChildItem -Filter *.zip | ForEach-Object {
    $destination = Join-Path $destinationRoot $_.BaseName
    Expand-Archive -Path $_.FullName -DestinationPath $destination -Force
}
```

---

## 🛠 If You Get a Permission Error

Run this command in PowerShell to allow script execution:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

> This enables local scripts to run without compromising system security.

---

## 📁 Example Output

For a file named `project-files.zip`, the output will be:

```
Extracted/
└── project-files/
    └── [unzipped contents here]
```

---

## ❓ Need Help?

If you run into issues, contact the script author or open an issue where this guide was provided.
