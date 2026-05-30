# Ensure shared helpers and styling are loaded if run standalone
if ($null -eq $Theme) {
    $helperPath = Join-Path $PSScriptRoot "SharedHelpers.ps1"
    if (-not (Test-Path $helperPath)) { $helperPath = Join-Path $PSScriptRoot "..\SharedHelpers.ps1" }
    if (Test-Path $helperPath) { . $helperPath }
}
    Function BackupAutomation {
        # Load required assemblies
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
    
        # Create the form
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Backup Automation"
        $form.Size = New-Object System.Drawing.Size(500, 500)
        $form.StartPosition = "CenterScreen"
        $form.BackColor = "LightGray"
    
        # Add Title Label
        $lblTitle = New-Object System.Windows.Forms.Label
        $lblTitle.Text = "Backup Automation"
        $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
        $lblTitle.ForeColor = "DarkOrange"
        $lblTitle.AutoSize = $true
        $lblTitle.Location = New-Object System.Drawing.Point(([int]$form.Width - 300) / 2, 20)
        $form.Controls.Add($lblTitle)
    
        # Add Button: Run Backup
        $btnRunBackup = New-Object System.Windows.Forms.Button
        $btnRunBackup.Text = "Run Backup"
        $btnRunBackup.Location = New-Object System.Drawing.Point(50, 80)
        $btnRunBackup.Size = New-Object System.Drawing.Size(400, 40)
        $btnRunBackup.BackColor = "SteelBlue"
        $btnRunBackup.ForeColor = "White"
        $btnRunBackup.Add_Click({ Run-Backup })
        $form.Controls.Add($btnRunBackup)
    
        # Add Button: Restore from Backup
        $btnRestoreBackup = New-Object System.Windows.Forms.Button
        $btnRestoreBackup.Text = "Restore from Backup"
        $btnRestoreBackup.Location = New-Object System.Drawing.Point(50, 140)
        $btnRestoreBackup.Size = New-Object System.Drawing.Size(400, 40)
        $btnRestoreBackup.BackColor = "SteelBlue"
        $btnRestoreBackup.ForeColor = "White"
        $btnRestoreBackup.Add_Click({ Restore-Backup })
        $form.Controls.Add($btnRestoreBackup)
    
        # Add Button: Manage Backups
        $btnManageBackups = New-Object System.Windows.Forms.Button
        $btnManageBackups.Text = "Backup Management"
        $btnManageBackups.Location = New-Object System.Drawing.Point(50, 200)
        $btnManageBackups.Size = New-Object System.Drawing.Size(400, 40)
        $btnManageBackups.BackColor = "SteelBlue"
        $btnManageBackups.ForeColor = "White"
        $btnManageBackups.Add_Click({ Manage-Backups })
        $form.Controls.Add($btnManageBackups)
    
        # Show the form
        $form.ShowDialog()
    }
    
    # Function for Run Backup
    Function Run-Backup {
        [System.Windows.Forms.MessageBox]::Show("Running backup tasks...", "Run Backup")
        Start-FullBackup
    }
    
    Function Start-FullBackup {
        $backupLocation = "E:\Backups\FullBackup" # Update this path
        if (-not (Test-Path $backupLocation)) {
            New-Item -ItemType Directory -Path $backupLocation
        }
    
        Write-Host "Starting Full Backup to $backupLocation..."
        wbadmin start backup -backupTarget:$backupLocation -include:C: -quiet
        Write-Host "Full Backup Completed."
        [System.Windows.Forms.MessageBox]::Show("Full Backup completed successfully.", "Backup Automation")
    }
    
    # Function for Restore Backup
    Function Restore-Backup {
        $backupLocation = "E:\Backups\FullBackup" # Update this path
        if (-not (Test-Path $backupLocation)) {
            [System.Windows.Forms.MessageBox]::Show("Backup location not found.", "Restore Backup")
            return
        }
    
        $backupVersions = wbadmin get versions -backupTarget:$backupLocation
        if ($backupVersions -match "Version Identifier: ([^\r\n]+)") {
            $versionIdentifier = $matches[1]
        } else {
            [System.Windows.Forms.MessageBox]::Show("No backup versions found in $backupLocation.", "Restore Backup")
            return
        }
    
        $confirmRestore = [System.Windows.Forms.MessageBox]::Show(
            "Restore from version $versionIdentifier?",
            "Restore Confirmation",
            [System.Windows.Forms.MessageBoxButtons]::YesNo
        )
    
        if ($confirmRestore -eq [System.Windows.Forms.DialogResult]::Yes) {
            wbadmin start recovery -version:$versionIdentifier -itemType:SystemState -recoveryTarget:C: -quiet
            Write-Host "Restore Completed."
            [System.Windows.Forms.MessageBox]::Show("Restore completed successfully.", "Restore Backup")
        } else {
            [System.Windows.Forms.MessageBox]::Show("Restore cancelled.", "Restore Backup")
        }
    }
    
    # Function for Manage Backups
    Function Manage-Backups {
        $subOptions = @("Schedule Backups", "Manage Backup Locations", "Export Logs", "Check Backup Status")
        $selectedTask = [System.Windows.Forms.MessageBox]::Show(
            "1. Schedule Backups`n2. Manage Backup Locations`n3. Export Logs`n4. Check Backup Status",
            "Backup Management",
            [System.Windows.Forms.MessageBoxButtons]::OKCancel
        )
    
        if ($selectedTask -eq [System.Windows.Forms.DialogResult]::OK) {
            Schedule-Backups
        } else {
            [System.Windows.Forms.MessageBox]::Show("Task selection canceled.", "Backup Management")
        }
    }
    
    Function Schedule-Backups {
        [System.Windows.Forms.MessageBox]::Show("Scheduling backups...", "Backup Management")
        schtasks /create /tn "DailyBackup" /tr "wbadmin start backup -backupTarget:E:\Backups -include:C:" /sc daily /st 02:00 /f
        [System.Windows.Forms.MessageBox]::Show("Backup scheduled for 2:00 AM daily.", "Backup Management")
    }
    
    Function Manage-BackupLocations {
        $backupLocation = "E:\Backups"
        if (-not (Test-Path $backupLocation)) {
            New-Item -ItemType Directory -Path $backupLocation
            [System.Windows.Forms.MessageBox]::Show("Backup location created.", "Backup Management")
        } else {
            [System.Windows.Forms.MessageBox]::Show("Backup location already exists.", "Backup Management")
        }
    }
    
    Function Export-BackupLogs {
        $logFile = "E:\Backups\BackupLogs.txt"
        wbadmin get versions > $logFile
        [System.Windows.Forms.MessageBox]::Show("Logs exported to $logFile.", "Backup Management")
    }
    
    Function Check-BackupStatus {
        $status = wbadmin get status
        [System.Windows.Forms.MessageBox]::Show("Backup Status:`n$status", "Backup Management")
    }
    

# Run the function if executed directly (standalone)
if ($MyInvocation.InvocationName -ne '.') {
    BackupAutomation
}
