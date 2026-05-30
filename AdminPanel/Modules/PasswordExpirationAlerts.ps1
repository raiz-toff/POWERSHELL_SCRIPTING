# Ensure shared helpers and styling are loaded if run standalone
if ($null -eq $Theme) {
    $helperPath = Join-Path $PSScriptRoot "SharedHelpers.ps1"
    if (-not (Test-Path $helperPath)) { $helperPath = Join-Path $PSScriptRoot "..\SharedHelpers.ps1" }
    if (Test-Path $helperPath) { . $helperPath }
}
function PasswordExpirationAlerts {
    

# Load required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the Main Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Active Directory Management Tool"
$form.Size = New-Object System.Drawing.Size(500, 400)
$form.StartPosition = "CenterScreen"
$form.BackColor = "LightGray"


# Group 1: Manage Password Expirations
Function Manage-PasswordExpirations {
    # Load required assemblies
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Manage Password Expirations"
    $form.Size = New-Object System.Drawing.Size(800, 600)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = "LightGray"

    # Title Label
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = "Password Expiration Management"
    $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $lblTitle.ForeColor = "DarkOrange"
    $lblTitle.AutoSize = $true
    $lblTitle.Location = New-Object System.Drawing.Point(($form.Width - 300) / 2, 20)
    $form.Controls.Add($lblTitle)

    # Days to Check Label and TextBox
    $lblDays = New-Object System.Windows.Forms.Label
    $lblDays.Text = "Days to Check:"
    $lblDays.Location = New-Object System.Drawing.Point(30, 80)
    $lblDays.Size = New-Object System.Drawing.Size(100, 20)
    $form.Controls.Add($lblDays)

    $txtDays = New-Object System.Windows.Forms.TextBox
    $txtDays.Location = New-Object System.Drawing.Point(140, 80)
    $txtDays.Size = New-Object System.Drawing.Size(100, 20)
    $txtDays.Text = "30"
    $form.Controls.Add($txtDays)

    # Buttons
    $btnView = New-Object System.Windows.Forms.Button
    $btnView.Text = "View Expiration List"
    $btnView.Location = New-Object System.Drawing.Point(30, 120)
    $btnView.Size = New-Object System.Drawing.Size(200, 40)
    $btnView.BackColor = "SteelBlue"
    $btnView.ForeColor = "White"
    $form.Controls.Add($btnView)

    $btnExport = New-Object System.Windows.Forms.Button
    $btnExport.Text = "Export to CSV"
    $btnExport.Location = New-Object System.Drawing.Point(30, 180)
    $btnExport.Size = New-Object System.Drawing.Size(200, 40)
    $btnExport.BackColor = "SteelBlue"
    $btnExport.ForeColor = "White"
    $btnExport.Enabled = $false
    $form.Controls.Add($btnExport)

    $btnNotify = New-Object System.Windows.Forms.Button
    $btnNotify.Text = "Send Notifications"
    $btnNotify.Location = New-Object System.Drawing.Point(30, 240)
    $btnNotify.Size = New-Object System.Drawing.Size(200, 40)
    $btnNotify.BackColor = "SteelBlue"
    $btnNotify.ForeColor = "White"
    $btnNotify.Enabled = $false
    $form.Controls.Add($btnNotify)

    # Results Box
    $resultsBox = New-Object System.Windows.Forms.TextBox
    $resultsBox.Location = New-Object System.Drawing.Point(260, 80)
    $resultsBox.Size = New-Object System.Drawing.Size(500, 400)
    $resultsBox.Multiline = $true
    $resultsBox.ScrollBars = "Vertical"
    $resultsBox.ReadOnly = $true
    $form.Controls.Add($resultsBox)

    # Global Expiration List
    $global:ExpirationList = @()

    # Functions
    function Get-PasswordExpirationList {
        param(
            [int]$DaysToCheck = 30
        )

        try {
            Import-Module ActiveDirectory
            $users = Get-ADUser -Filter {PasswordNeverExpires -eq $false -and Enabled -eq $true} -Properties SamAccountName, DisplayName, PasswordLastSet, EmailAddress

            if (!$users) {
                return @()
            }

            $maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days

            $expirationList = $users | ForEach-Object {
                $passwordLastSet = $_.PasswordLastSet
                if ($passwordLastSet) {
                    $passwordExpirationDate = $passwordLastSet.AddDays($maxPasswordAge)
                    $daysToExpire = ($passwordExpirationDate - (Get-Date)).Days
                    if ($daysToExpire -ge 0 -and $daysToExpire -le $DaysToCheck) {
                        [PSCustomObject]@{
                            SamAccountName   = $_.SamAccountName
                            DisplayName      = $_.DisplayName
                            EmailAddress     = $_.EmailAddress
                            PasswordExpires  = $passwordExpirationDate
                            DaysToExpiration = $daysToExpire
                        }
                    }
                }
            }

            return $expirationList
        } catch {
            return @()
        }
    }

    function Send-Notifications {
        param(
            [array]$ExpirationList
        )

        foreach ($user in $ExpirationList) {
            $message = "Hello $($user.DisplayName), your password will expire in $($user.DaysToExpiration) days. Please update it."

            # Send Desktop Notification
            try {
                Start-Process -FilePath "msg.exe" -ArgumentList "$($user.SamAccountName) $message" -NoNewWindow
            } catch {
                Write-Host "Failed to send desktop notification to $($user.SamAccountName)."
            }

            # Send Email Notification
            if ($user.EmailAddress) {
                try {
                    Send-MailMessage -From "admin@yourdomain.com" -To $user.EmailAddress -Subject "Password Expiration Notice" -Body $message -SmtpServer "smtp.yourdomain.com"
                } catch {
                    Write-Host "Failed to send email to $($user.EmailAddress)."
                }
            }
        }
    }

    function Export-ExpirationList {
        param(
            [array]$ExpirationList,
            [string]$FilePath
        )

        if ($ExpirationList) {
            $ExpirationList | Export-Csv -Path $FilePath -NoTypeInformation
            [System.Windows.Forms.MessageBox]::Show("Exported to $FilePath.", "Export Successful")
        }
    }

    # Button Event Handlers
    $btnView.Add_Click({
        $daysToCheck = [int]$txtDays.Text
        if ($daysToCheck -gt 0) {
            $resultsBox.Text = "Fetching expiration list..."
            $expirationList = Get-PasswordExpirationList -DaysToCheck $daysToCheck
            if ($expirationList) {
                $global:ExpirationList = $expirationList
                $resultsBox.Text = ($expirationList | Format-Table -AutoSize | Out-String)
                $btnExport.Enabled = $true
                $btnNotify.Enabled = $true
            } else {
                $resultsBox.Text = "No users found with expiring passwords."
                $btnExport.Enabled = $false
                $btnNotify.Enabled = $false
            }
        } else {
            $resultsBox.Text = "Please enter a valid number of days."
        }
    })

    $btnExport.Add_Click({
        $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
        $saveFileDialog.Filter = "CSV files (*.csv)|*.csv"
        $saveFileDialog.Title = "Save Expiration List as CSV"
        $saveFileDialog.ShowDialog()

        if ($saveFileDialog.FileName -ne "") {
            Export-ExpirationList -ExpirationList $global:ExpirationList -FilePath $saveFileDialog.FileName
        }
    })

    $btnNotify.Add_Click({
        Send-Notifications -ExpirationList $global:ExpirationList
        $resultsBox.Text += "`nNotifications sent successfully."
    })

    # Show the Form
    $form.ShowDialog()
}

# Group 2: Manage Users
Function Manage-Users {
    # Load required assemblies
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Manage Users"
    $form.Size = New-Object System.Drawing.Size(900, 600)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = "LightGray"

    # Title Label
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = "User Management"
    $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $lblTitle.ForeColor = "DarkOrange"
    $lblTitle.AutoSize = $true
    $lblTitle.Location = New-Object System.Drawing.Point(($form.Width - 300) / 2, 20)
    $form.Controls.Add($lblTitle)

    # Search Label and TextBox
    $lblSearch = New-Object System.Windows.Forms.Label
    $lblSearch.Text = "Search Users:"
    $lblSearch.Location = New-Object System.Drawing.Point(30, 80)
    $lblSearch.Size = New-Object System.Drawing.Size(100, 20)
    $form.Controls.Add($lblSearch)

    $txtSearch = New-Object System.Windows.Forms.TextBox
    $txtSearch.Location = New-Object System.Drawing.Point(140, 80)
    $txtSearch.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($txtSearch)

    # Buttons
    $btnSearch = New-Object System.Windows.Forms.Button
    $btnSearch.Text = "Search"
    $btnSearch.Location = New-Object System.Drawing.Point(360, 75)
    $btnSearch.Size = New-Object System.Drawing.Size(100, 30)
    $btnSearch.BackColor = "SteelBlue"
    $btnSearch.ForeColor = "White"
    $form.Controls.Add($btnSearch)

    $btnResetPassword = New-Object System.Windows.Forms.Button
    $btnResetPassword.Text = "Reset Passwords"
    $btnResetPassword.Location = New-Object System.Drawing.Point(30, 130)
    $btnResetPassword.Size = New-Object System.Drawing.Size(200, 40)
    $btnResetPassword.BackColor = "SteelBlue"
    $btnResetPassword.ForeColor = "White"
    $btnResetPassword.Enabled = $false
    $form.Controls.Add($btnResetPassword)

    $btnUnlockAccount = New-Object System.Windows.Forms.Button
    $btnUnlockAccount.Text = "Unlock Accounts"
    $btnUnlockAccount.Location = New-Object System.Drawing.Point(30, 190)
    $btnUnlockAccount.Size = New-Object System.Drawing.Size(200, 40)
    $btnUnlockAccount.BackColor = "SteelBlue"
    $btnUnlockAccount.ForeColor = "White"
    $btnUnlockAccount.Enabled = $false
    $form.Controls.Add($btnUnlockAccount)

    # Results Box
    $resultsBox = New-Object System.Windows.Forms.ListView
    $resultsBox.Location = New-Object System.Drawing.Point(260, 130)
    $resultsBox.Size = New-Object System.Drawing.Size(600, 400)
    $resultsBox.View = [System.Windows.Forms.View]::Details
    $resultsBox.FullRowSelect = $true
    $resultsBox.Columns.Add("SamAccountName", 150)
    $resultsBox.Columns.Add("DisplayName", 200)
    $resultsBox.Columns.Add("Enabled", 80)
    $resultsBox.Columns.Add("LockedOut", 80)
    $form.Controls.Add($resultsBox)

    # Global User List
    $global:UserList = @()

    # Functions
    function Search-Users {
        param(
            [string]$SearchQuery
        )

        try {
            Import-Module ActiveDirectory
            $users = Get-ADUser -Filter {Name -like "*$SearchQuery*"} -Properties SamAccountName, DisplayName, Enabled, LockedOut

            if (!$users) {
                return @()
            }

            $userList = $users | ForEach-Object {
                [PSCustomObject]@{
                    SamAccountName = $_.SamAccountName
                    DisplayName    = $_.DisplayName
                    Enabled        = $_.Enabled
                    LockedOut      = $_.LockedOut
                }
            }

            return $userList
        } catch {
            return @()
        }
    }

    function Reset-Passwords {
        param(
            [array]$SelectedUsers
        )

        foreach ($user in $SelectedUsers) {
            $newPassword = [System.Windows.Forms.MessageBox]::Show(
                "Set a new password for $($user.DisplayName) ($($user.SamAccountName))",
                "Set Password",
                [System.Windows.Forms.MessageBoxButtons]::OKCancel
            )
            if ($newPassword -eq [System.Windows.Forms.DialogResult]::OK) {
                try {
                    Set-ADAccountPassword -Identity $user.SamAccountName -Reset -NewPassword (ConvertTo-SecureString "Default@123" -AsPlainText -Force)
                    Write-Host "Password reset for $($user.DisplayName)"
                } catch {
                    Write-Host "Failed to reset password for $($user.DisplayName)."
                }
            }
        }
    }

    function Unlock-Accounts {
        param(
            [array]$SelectedUsers
        )

        foreach ($user in $SelectedUsers) {
            try {
                Unlock-ADAccount -Identity $user.SamAccountName
                Write-Host "Account unlocked for $($user.DisplayName)"
            } catch {
                Write-Host "Failed to unlock account for $($user.DisplayName)."
            }
        }
    }

    # Button Event Handlers
    $btnSearch.Add_Click({
        $searchQuery = $txtSearch.Text
        if (-not [string]::IsNullOrWhiteSpace($searchQuery)) {
            $resultsBox.Items.Clear()
            $userList = Search-Users -SearchQuery $searchQuery
            if ($userList) {
                $global:UserList = $userList
                foreach ($user in $userList) {
                    $item = New-Object System.Windows.Forms.ListViewItem $user.SamAccountName
                    $item.SubItems.Add($user.DisplayName)
                    $item.SubItems.Add($user.Enabled)
                    $item.SubItems.Add($user.LockedOut)
                    $resultsBox.Items.Add($item)
                }
                $btnResetPassword.Enabled = $true
                $btnUnlockAccount.Enabled = $true
            } else {
                [System.Windows.Forms.MessageBox]::Show("No users found matching '$searchQuery'.", "Search Results")
                $btnResetPassword.Enabled = $false
                $btnUnlockAccount.Enabled = $false
            }
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please enter a valid search query.", "Invalid Input")
        }
    })

    $btnResetPassword.Add_Click({
        $selectedUsers = @()
        foreach ($item in $resultsBox.SelectedItems) {
            $selectedUsers += $global:UserList | Where-Object { $_.SamAccountName -eq $item.Text }
        }
        if ($selectedUsers) {
            Reset-Passwords -SelectedUsers $selectedUsers
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please select users to reset passwords.", "No Selection")
        }
    })

    $btnUnlockAccount.Add_Click({
        $selectedUsers = @()
        foreach ($item in $resultsBox.SelectedItems) {
            $selectedUsers += $global:UserList | Where-Object { $_.SamAccountName -eq $item.Text }
        }
        if ($selectedUsers) {
            Unlock-Accounts -SelectedUsers $selectedUsers
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please select users to unlock accounts.", "No Selection")
        }
    })

    # Show the Form
    $form.ShowDialog()
}



# Group 3: Manage Policies and Notifications
Function Manage-PoliciesAndNotifications {
    # Load required assemblies
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Manage Policies & Notifications"
    $form.Size = New-Object System.Drawing.Size(800, 600)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = "LightGray"

    # Title Label
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = "Policies & Notifications Management"
    $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $lblTitle.ForeColor = "DarkOrange"
    $lblTitle.AutoSize = $true
    $lblTitle.Location = New-Object System.Drawing.Point(($form.Width - 400) / 2, 20)
    $form.Controls.Add($lblTitle)

    # Reminder Schedule Section
    $lblReminder = New-Object System.Windows.Forms.Label
    $lblReminder.Text = "Set Reminder Schedule (Days):"
    $lblReminder.Location = New-Object System.Drawing.Point(30, 80)
    $lblReminder.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($lblReminder)

    $txtReminderDays = New-Object System.Windows.Forms.TextBox
    $txtReminderDays.Location = New-Object System.Drawing.Point(250, 80)
    $txtReminderDays.Size = New-Object System.Drawing.Size(100, 20)
    $txtReminderDays.Text = "7"
    $form.Controls.Add($txtReminderDays)

    $btnSetReminder = New-Object System.Windows.Forms.Button
    $btnSetReminder.Text = "Set Reminder Schedule"
    $btnSetReminder.Location = New-Object System.Drawing.Point(400, 75)
    $btnSetReminder.Size = New-Object System.Drawing.Size(200, 30)
    $btnSetReminder.BackColor = "SteelBlue"
    $btnSetReminder.ForeColor = "White"
    $form.Controls.Add($btnSetReminder)

    # Customize Notifications Section
    $lblCustomize = New-Object System.Windows.Forms.Label
    $lblCustomize.Text = "Customize Notifications:"
    $lblCustomize.Location = New-Object System.Drawing.Point(30, 130)
    $lblCustomize.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($lblCustomize)

    $txtNotificationTemplate = New-Object System.Windows.Forms.TextBox
    $txtNotificationTemplate.Location = New-Object System.Drawing.Point(30, 160)
    $txtNotificationTemplate.Size = New-Object System.Drawing.Size(720, 80)
    $txtNotificationTemplate.Multiline = $true
    $txtNotificationTemplate.ScrollBars = "Vertical"
    $txtNotificationTemplate.Text = "Hello {UserName}, your password will expire in {DaysRemaining} days. Please update it."
    $form.Controls.Add($txtNotificationTemplate)

    $btnSaveTemplate = New-Object System.Windows.Forms.Button
    $btnSaveTemplate.Text = "Save Notification Template"
    $btnSaveTemplate.Location = New-Object System.Drawing.Point(30, 260)
    $btnSaveTemplate.Size = New-Object System.Drawing.Size(200, 30)
    $btnSaveTemplate.BackColor = "SteelBlue"
    $btnSaveTemplate.ForeColor = "White"
    $form.Controls.Add($btnSaveTemplate)

    # Policy Enforcement Section
    $lblPolicy = New-Object System.Windows.Forms.Label
    $lblPolicy.Text = "Active Directory Password Policy:"
    $lblPolicy.Location = New-Object System.Drawing.Point(30, 320)
    $lblPolicy.Size = New-Object System.Drawing.Size(300, 20)
    $form.Controls.Add($lblPolicy)

    $txtPolicyDetails = New-Object System.Windows.Forms.TextBox
    $txtPolicyDetails.Location = New-Object System.Drawing.Point(30, 350)
    $txtPolicyDetails.Size = New-Object System.Drawing.Size(720, 150)
    $txtPolicyDetails.Multiline = $true
    $txtPolicyDetails.ScrollBars = "Vertical"
    $txtPolicyDetails.ReadOnly = $true
    $form.Controls.Add($txtPolicyDetails)

    $btnRefreshPolicy = New-Object System.Windows.Forms.Button
    $btnRefreshPolicy.Text = "Refresh Policy"
    $btnRefreshPolicy.Location = New-Object System.Drawing.Point(30, 520)
    $btnRefreshPolicy.Size = New-Object System.Drawing.Size(200, 30)
    $btnRefreshPolicy.BackColor = "SteelBlue"
    $btnRefreshPolicy.ForeColor = "White"
    $form.Controls.Add($btnRefreshPolicy)

    # Functions
    function Set-ReminderSchedule {
        param(
            [int]$Days
        )

        # Example: Save the reminder schedule (implementation can be extended as needed)
        [System.Windows.Forms.MessageBox]::Show("Reminder schedule set to $Days days.", "Success")
    }

    function Save-NotificationTemplate {
        param(
            [string]$Template
        )

        # Example: Save the notification template (implementation can be extended as needed)
        [System.Windows.Forms.MessageBox]::Show("Notification template saved.", "Success")
    }

    function Refresh-PolicyDetails {
        try {
            Import-Module ActiveDirectory
            $policy = Get-ADDefaultDomainPasswordPolicy

            $policyDetails = @"
Minimum Password Length: $($policy.MinPasswordLength)
Maximum Password Age: $($policy.MaxPasswordAge.Days) days
Password Complexity Enabled: $($policy.ComplexityEnabled)
Password History Count: $($policy.PasswordHistoryCount)
Lockout Threshold: $($policy.LockoutThreshold)
"@
            $txtPolicyDetails.Text = $policyDetails
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Failed to retrieve policy details: $_", "Error")
        }
    }

    # Button Event Handlers
    $btnSetReminder.Add_Click({
        $reminderDays = [int]$txtReminderDays.Text
        if ($reminderDays -gt 0) {
            Set-ReminderSchedule -Days $reminderDays
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please enter a valid number of days.", "Invalid Input")
        }
    })

    $btnSaveTemplate.Add_Click({
        $template = $txtNotificationTemplate.Text
        if (-not [string]::IsNullOrWhiteSpace($template)) {
            Save-NotificationTemplate -Template $template
        } else {
            [System.Windows.Forms.MessageBox]::Show("Notification template cannot be empty.", "Invalid Input")
        }
    })

    $btnRefreshPolicy.Add_Click({
        Refresh-PolicyDetails
    })

    # Load initial policy details
    Refresh-PolicyDetails

    # Show the Form
    $form.ShowDialog()
}




# Group 4: View Reports and Audits
Function View-ReportsAndAudits {
    # Load required assemblies
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Manage Reports & Audits"
    $form.Size = New-Object System.Drawing.Size(900, 600)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = "LightGray"

    # Title Label
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = "Reports & Audits"
    $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $lblTitle.ForeColor = "DarkOrange"
    $lblTitle.AutoSize = $true
    $lblTitle.Location = New-Object System.Drawing.Point(($form.Width - 300) / 2, 20)
    $form.Controls.Add($lblTitle)

    # Reports Section
    $lblReports = New-Object System.Windows.Forms.Label
    $lblReports.Text = "Generate Reports:"
    $lblReports.Location = New-Object System.Drawing.Point(30, 80)
    $lblReports.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($lblReports)

    $cmbReportType = New-Object System.Windows.Forms.ComboBox
    $cmbReportType.Location = New-Object System.Drawing.Point(250, 80)
    $cmbReportType.Size = New-Object System.Drawing.Size(300, 20)
    $cmbReportType.Items.AddRange(@("Password Expiration Report", "User Account Report", "Group Membership Report"))
    $cmbReportType.SelectedIndex = 0
    $form.Controls.Add($cmbReportType)

    $btnGenerateReport = New-Object System.Windows.Forms.Button
    $btnGenerateReport.Text = "Generate Report"
    $btnGenerateReport.Location = New-Object System.Drawing.Point(600, 75)
    $btnGenerateReport.Size = New-Object System.Drawing.Size(200, 30)
    $btnGenerateReport.BackColor = "SteelBlue"
    $btnGenerateReport.ForeColor = "White"
    $form.Controls.Add($btnGenerateReport)

    # Audit Logs Section
    $lblAuditLogs = New-Object System.Windows.Forms.Label
    $lblAuditLogs.Text = "View Audit Logs:"
    $lblAuditLogs.Location = New-Object System.Drawing.Point(30, 140)
    $lblAuditLogs.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($lblAuditLogs)

    $btnViewAuditLogs = New-Object System.Windows.Forms.Button
    $btnViewAuditLogs.Text = "View Audit Logs"
    $btnViewAuditLogs.Location = New-Object System.Drawing.Point(250, 135)
    $btnViewAuditLogs.Size = New-Object System.Drawing.Size(200, 30)
    $btnViewAuditLogs.BackColor = "SteelBlue"
    $btnViewAuditLogs.ForeColor = "White"
    $form.Controls.Add($btnViewAuditLogs)

    # Historical Trends Section
    $lblTrends = New-Object System.Windows.Forms.Label
    $lblTrends.Text = "View Historical Trends:"
    $lblTrends.Location = New-Object System.Drawing.Point(30, 200)
    $lblTrends.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($lblTrends)

    $btnViewTrends = New-Object System.Windows.Forms.Button
    $btnViewTrends.Text = "View Trends"
    $btnViewTrends.Location = New-Object System.Drawing.Point(250, 195)
    $btnViewTrends.Size = New-Object System.Drawing.Size(200, 30)
    $btnViewTrends.BackColor = "SteelBlue"
    $btnViewTrends.ForeColor = "White"
    $form.Controls.Add($btnViewTrends)

    # Results Box
    $resultsBox = New-Object System.Windows.Forms.TextBox
    $resultsBox.Location = New-Object System.Drawing.Point(30, 260)
    $resultsBox.Size = New-Object System.Drawing.Size(820, 300)
    $resultsBox.Multiline = $true
    $resultsBox.ScrollBars = "Vertical"
    $resultsBox.ReadOnly = $true
    $form.Controls.Add($resultsBox)

    # Functions
    function Generate-Report {
        param(
            [string]$ReportType
        )

        # Example: Generate a mock report (can be extended to fetch real data)
        switch ($ReportType) {
            "Password Expiration Report" {
                $resultsBox.Text = "Generating Password Expiration Report..."
                Start-Sleep -Seconds 1
                $resultsBox.Text = "Password Expiration Report: Example content here..."
            }
            "User Account Report" {
                $resultsBox.Text = "Generating User Account Report..."
                Start-Sleep -Seconds 1
                $resultsBox.Text = "User Account Report: Example content here..."
            }
            "Group Membership Report" {
                $resultsBox.Text = "Generating Group Membership Report..."
                Start-Sleep -Seconds 1
                $resultsBox.Text = "Group Membership Report: Example content here..."
            }
        }
    }

    function View-AuditLogs {
        # Example: Display mock audit logs (can be extended to fetch real logs)
        $resultsBox.Text = "Fetching Audit Logs..."
        Start-Sleep -Seconds 1
        $resultsBox.Text = "Audit Logs: Example content here..."
    }

    function View-HistoricalTrends {
        # Example: Display mock historical trends (can be extended to fetch real trends)
        $resultsBox.Text = "Fetching Historical Trends..."
        Start-Sleep -Seconds 1
        $resultsBox.Text = "Historical Trends: Example content here..."
    }

    # Button Event Handlers
    $btnGenerateReport.Add_Click({
        $reportType = $cmbReportType.SelectedItem
        if ($reportType) {
            Generate-Report -ReportType $reportType
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please select a report type.", "Invalid Input")
        }
    })

    $btnViewAuditLogs.Add_Click({
        View-AuditLogs
    })

    $btnViewTrends.Add_Click({
        View-HistoricalTrends
    })

    # Show the Form
    $form.ShowDialog()
}


    

# Add Title Label
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "AD Management Tool"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = "DarkOrange"
$lblTitle.AutoSize = $true
$lblTitle.Location = New-Object System.Drawing.Point(($form.Width - 300) / 2, 20)
$form.Controls.Add($lblTitle)

# Group Buttons
$groups = @(
    @{ Name = "Manage Password Expirations"; Action = { Manage-PasswordExpirations } }
    @{ Name = "Manage Users"; Action = { Manage-Users } }
    @{ Name = "Manage Policies & Notifications"; Action = { Manage-PoliciesAndNotifications } }
    @{ Name = "View Reports & Audits"; Action = { View-ReportsAndAudits } }
)

$yPos = 80
foreach ($group in $groups) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $group.Name
    $button.Location = New-Object System.Drawing.Point(50, $yPos)
    $button.Size = New-Object System.Drawing.Size(400, 40)
    $button.BackColor = "SteelBlue"
    $button.ForeColor = "White"
    $button.Tag = $group.Action
    $form.Controls.Add($button)

    # Button Event Handler
    $button.Add_Click({
        $action = $button.Tag
        & $action
    })

    $yPos += 60
}

# Show the Main Form
$form.ShowDialog()

}

# Run the function if executed directly (standalone)
if ($MyInvocation.InvocationName -ne '.') {
    PasswordExpirationAlerts
}
