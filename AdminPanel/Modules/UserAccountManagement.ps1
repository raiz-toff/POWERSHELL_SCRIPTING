# Ensure shared helpers and styling are loaded if run standalone
if ($null -eq $Theme) {
    $helperPath = Join-Path $PSScriptRoot "SharedHelpers.ps1"
    if (-not (Test-Path $helperPath)) { $helperPath = Join-Path $PSScriptRoot "..\SharedHelpers.ps1" }
    if (Test-Path $helperPath) { . $helperPath }
}
function UserAccountManagement {
   
    Function Create-AdminForm {
        # Create the Form
        $Form = New-Object System.Windows.Forms.Form
        $Form.Text = "Admin User Management App"
        $Form.Width = 800
        $Form.Height = 600
        Apply-FormStyle -Form $Form  # Apply background and styling
    
        # Add a centralized title label
        $titleLabel = Create-StyledLabel -Text "Admin Dashboard" -X 0 -Y 20
        $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
        $titleLabel.ForeColor = $Theme.HeaderFontColor
        $titleLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        $titleLabel.Size = New-Object System.Drawing.Size($Form.Width, 50)
        $Form.Controls.Add($titleLabel)
    
        # Define button details
        $buttonDetails = @(
            @{ Text = "View User Statistics"; Action = { Show-UserStatistics } },
            @{ Text = "Manage Users"; Action = { Show-ManageUsersForm } },
            @{ Text = "Manage Roles"; Action = { Show-RolesForm } },
            @{ Text = "Track Login Attempts"; Action = { Show-LoginAttempts } },
            @{ Text = "Account Control"; Action = { Show-AccountControlForm } },
            @{ Text = "Send Notifications"; Action = { Show-NotificationsForm } },
            @{ Text = "Exit"; Action = { $Form.Close() } }
        )
    
        # Button layout settings
        $startY = 100
        $buttonSpacing = 70
        $buttonWidth = 400
        $buttonHeight = 60
        $buttonX = ($Form.Width - $buttonWidth) / 2
    
        # Create and add buttons
        foreach ($index in 0..($buttonDetails.Count - 1)) {
            $btnDetail = $buttonDetails[$index]
            $buttonY = $startY + ($index * $buttonSpacing)
    
            # Create rounded buttons with hover effect
            $button = Create-RoundedButton -Text $btnDetail.Text -X $buttonX -Y $buttonY -Width $buttonWidth -Height $buttonHeight
            $button.MouseEnter.Add({
                $button.BackColor = [System.Drawing.Color]::DodgerBlue
            })
            $button.MouseLeave.Add({
                $button.BackColor = $Theme.ButtonColor
            })
            $button.Add_Click($btnDetail.Action)
            $Form.Controls.Add($button)
        }
    
        # Show the Form
        $Form.ShowDialog()
    }
    
Function Show-UserStatistics {
    # Gather User Data from Active Directory
    Try {
        # Import the Active Directory module
        Import-Module ActiveDirectory -ErrorAction Stop

        # Fetch real-time statistics
        $TotalUsers = (Get-ADUser -Filter *).Count
        $ActiveUsers = (Get-ADUser -Filter {Enabled -eq $true}).Count
        $DisabledUsers = (Get-ADUser -Filter {Enabled -eq $false}).Count
        $NewUsers = (Get-ADUser -Filter * -Properties WhenCreated |
            Where-Object {($_.WhenCreated -ge (Get-Date).AddDays(-30))}).Count

        # Generate terminal-style output
        $TerminalOutput = @(
            "===================================",
            "Active Directory User Statistics",
            "===================================",
            "Total Users: $TotalUsers",
            "Active Users: $ActiveUsers",
            "Disabled Users: $DisabledUsers",
            "New Users (Last 30 Days): $NewUsers",
            "==================================="
        ) -join "`r`n"
    }
    Catch {
        # Display error details in the GUI
        $TerminalOutput = "Error retrieving data: $($_.Exception.Message)"
    }

    # Create a new Form
    $StatsForm = New-Object System.Windows.Forms.Form
    $StatsForm.Text = "User Statistics"
    $StatsForm.Size = New-Object System.Drawing.Size(500, 400)
    Apply-FormStyle $StatsForm  # Apply centralized theme to form

    # Create a Header Label
    $Header = Create-StyledLabel "User Statistics" 150 10
    $Header.Font = $HeaderFont
    $Header.ForeColor = [System.Drawing.Color]::Gold
    $StatsForm.Controls.Add($Header)

    # Create a TextBox to Display Output (Terminal-Like)
    $OutputBox = New-Object System.Windows.Forms.TextBox
    $OutputBox.Size = New-Object System.Drawing.Size(460, 250)
    $OutputBox.Location = New-Object System.Drawing.Point(20, 50)
    $OutputBox.Multiline = $true
    $OutputBox.ScrollBars = "Vertical"
    $OutputBox.ReadOnly = $true
    $OutputBox.Font = New-Object System.Drawing.Font("Consolas", 10)
    $OutputBox.BackColor = [System.Drawing.Color]::White
    $OutputBox.ForeColor = [System.Drawing.Color]::Black
    $OutputBox.Text = $TerminalOutput

    # Add Close Button
    $CloseButton = Create-StyledButton "Close" 200 320

    # Event Handler to Close the Form
    $CloseButton.Add_Click({
        $StatsForm.Close()
    })

    # Add Controls to the Form
    $StatsForm.Controls.Add($OutputBox)
    $StatsForm.Controls.Add($CloseButton)

    # Show the Form
    $StatsForm.ShowDialog()
}

Function Show-ManageUsersForm {

   # Ensure Active Directory Module is available
Try {
    Import-Module ActiveDirectory -ErrorAction Stop
} Catch {
    [System.Windows.Forms.MessageBox]::Show("Active Directory module not found or cannot be loaded. Exiting.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    Exit
}

# Load Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


# Main GUI Form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "AD User Management"
$Form.Size = New-Object System.Drawing.Size(500, 600)
Apply-FormStyle $Form  # Apply centralized style to form

# Add Header
$HeaderLabel = Create-StyledLabel "Active Directory User Management" 50 10
$HeaderLabel.Font = $HeaderFont
$HeaderLabel.ForeColor = $HeaderFontColor
$Form.Controls.Add($HeaderLabel)

# Add User Section
$Form.Controls.Add((Create-StyledLabel "Add New User" 10 50))

$Form.Controls.Add((Create-StyledLabel "Username:" 20 80))
$UsernameBox = Create-StyledTextbox 150 80
$Form.Controls.Add($UsernameBox)

$Form.Controls.Add((Create-StyledLabel "Display Name:" 20 120))
$DisplayNameBox = Create-StyledTextbox 150 120
$Form.Controls.Add($DisplayNameBox)

$Form.Controls.Add((Create-StyledLabel "Email Address:" 20 160))
$EmailBox = Create-StyledTextbox 150 160
$Form.Controls.Add($EmailBox)

$Form.Controls.Add((Create-StyledLabel "Password:" 20 200))
$PasswordBox = Create-StyledTextbox 150 200
$PasswordBox.UseSystemPasswordChar = $true
$Form.Controls.Add($PasswordBox)

$AddUserButton = Create-StyledButton "Add User" 150 240
$Form.Controls.Add($AddUserButton)

# Divider
$Divider = New-Object System.Windows.Forms.Label
$Divider.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Divider.Size = New-Object System.Drawing.Size(440, 2)
$Divider.Location = New-Object System.Drawing.Point(20, 290)
$Form.Controls.Add($Divider)

# Selected User Section
$Form.Controls.Add((Create-StyledLabel "Manage Existing User" 10 310))

$Form.Controls.Add((Create-StyledLabel "Selected User:" 20 340))
$SelectedUserBox = Create-StyledTextbox 150 340
$SelectedUserBox.ReadOnly = $true
$Form.Controls.Add($SelectedUserBox)

$Form.Controls.Add((Create-StyledLabel "Enter Username:" 20 380))
$ManageUserInput = Create-StyledTextbox 150 380
$Form.Controls.Add($ManageUserInput)

# Set User Button
$SetUserButton = Create-StyledButton "Set User" 340 380
$Form.Controls.Add($SetUserButton)

# User Management Buttons
$EnableButton = Create-StyledButton "Enable User" 50 440
$Form.Controls.Add($EnableButton)

$DisableButton = Create-StyledButton "Disable User" 200 440
$Form.Controls.Add($DisableButton)

$DeleteButton = Create-StyledButton "Delete User" 350 440
$Form.Controls.Add($DeleteButton)

# Search Section
$SearchButton = Create-StyledButton "Search Users" 50 500
$Form.Controls.Add($SearchButton)

$SearchResultBox = New-Object System.Windows.Forms.TextBox
$SearchResultBox.Multiline = $true
$SearchResultBox.ScrollBars = "Vertical"
$SearchResultBox.Location = New-Object System.Drawing.Point(50, 550)
$SearchResultBox.Size = New-Object System.Drawing.Size(400, 100)
$SearchResultBox.Font = $LabelFont
$SearchResultBox.BackColor = [System.Drawing.Color]::White
$Form.Controls.Add($SearchResultBox)

# Event Handlers

# Add User Button
$AddUserButton.Add_Click({
    Try {
        New-ADUser -SamAccountName $UsernameBox.Text `
                   -Name $DisplayNameBox.Text `
                   -UserPrincipalName "$($UsernameBox.Text)" `
                   -EmailAddress $EmailBox.Text `
                   -AccountPassword (ConvertTo-SecureString $PasswordBox.Text -AsPlainText -Force) `
                   -Enabled $true `
                   -Path "OU=Users,DC=rajkumar,DC=.com"
        [System.Windows.Forms.MessageBox]::Show("User added successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } Catch {
        [System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Set User Button
$SetUserButton.Add_Click({
    $SelectedUserBox.Text = $ManageUserInput.Text
    [System.Windows.Forms.MessageBox]::Show("Now managing user: $($SelectedUserBox.Text)", "User Set", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})

# Enable User Button
$EnableButton.Add_Click({
    If (-not [string]::IsNullOrWhiteSpace($SelectedUserBox.Text)) {
        Try {
            Enable-ADAccount -Identity $SelectedUserBox.Text
            [System.Windows.Forms.MessageBox]::Show("User '$($SelectedUserBox.Text)' enabled successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } Catch {
            [System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    } Else {
        [System.Windows.Forms.MessageBox]::Show("Please set a user to manage first!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    }
})

# Disable User Button
$DisableButton.Add_Click({
    If (-not [string]::IsNullOrWhiteSpace($SelectedUserBox.Text)) {
        Try {
            Disable-ADAccount -Identity $SelectedUserBox.Text
            [System.Windows.Forms.MessageBox]::Show("User '$($SelectedUserBox.Text)' disabled successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } Catch {
            [System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    } Else {
        [System.Windows.Forms.MessageBox]::Show("Please set a user to manage first!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    }
})

# Delete User Button
$DeleteButton.Add_Click({
    If (-not [string]::IsNullOrWhiteSpace($SelectedUserBox.Text)) {
        Try {
            Remove-ADUser -Identity $SelectedUserBox.Text -Confirm:$false
            [System.Windows.Forms.MessageBox]::Show("User '$($SelectedUserBox.Text)' deleted successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } Catch {
            [System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    } Else {
        [System.Windows.Forms.MessageBox]::Show("Please set a user to manage first!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    }
})

# Search Button
$SearchButton.Add_Click({
    Try {
        $Results = Get-ADUser -Filter * -Properties DisplayName, EmailAddress | Where-Object {
            $_.SamAccountName -like "*$($ManageUserInput.Text)*" -or $_.EmailAddress -like "*$($ManageUserInput.Text)*"
        }
        $SearchResultBox.Clear()
        If ($Results.Count -gt 0) {
            $Results | ForEach-Object {
                $SearchResultBox.AppendText("Name: $($_.Name) | Email: $($_.EmailAddress)`r`n")
            }
        } Else {
            $SearchResultBox.Text = "No results found."
        }
    } Catch {
        [System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Run the form
[void]$Form.ShowDialog()

}


Function Show-RolesForm {
    # Load Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Role-Based Functionality"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"

# Create a label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Select Your Role:"
$label.Location = New-Object System.Drawing.Point(140, 20)
$label.Size = New-Object System.Drawing.Size(200, 30)
$label.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($label)

# Create dropdown (ComboBox) for roles
$roleComboBox = New-Object System.Windows.Forms.ComboBox
$roleComboBox.Location = New-Object System.Drawing.Point(100, 70)
$roleComboBox.Size = New-Object System.Drawing.Size(200, 30)
$roleComboBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$roleComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$roleComboBox.Items.AddRange(@("Admin", "User", "Guest"))
$form.Controls.Add($roleComboBox)

# Create a button
$submitButton = New-Object System.Windows.Forms.Button
$submitButton.Text = "Submit"
$submitButton.Location = New-Object System.Drawing.Point(150, 120)
$submitButton.Size = New-Object System.Drawing.Size(100, 30)
$submitButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$submitButton.BackColor = [System.Drawing.Color]::SteelBlue
$submitButton.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($submitButton)

# Create an output label
$outputLabel = New-Object System.Windows.Forms.Label
$outputLabel.Text = ""
$outputLabel.Location = New-Object System.Drawing.Point(100, 180)
$outputLabel.Size = New-Object System.Drawing.Size(250, 50)
$outputLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.Controls.Add($outputLabel)

# Event Handler for Submit Button
$submitButton.Add_Click({
    $selectedRole = $roleComboBox.Text
    if ([string]::IsNullOrWhiteSpace($selectedRole)) {
        $outputLabel.Text = "Please select a role!"
        $outputLabel.ForeColor = [System.Drawing.Color]::Red
    } else {
        switch ($selectedRole.ToLower()) {
            "admin" {
                $outputLabel.Text = "Performing Admin tasks..."
                $outputLabel.ForeColor = [System.Drawing.Color]::Green
                # Add Admin-specific functionality here
            }
            "user" {
                $outputLabel.Text = "Performing User tasks..."
                $outputLabel.ForeColor = [System.Drawing.Color]::Blue
                # Add User-specific functionality here
            }
            "guest" {
                $outputLabel.Text = "Performing Guest tasks..."
                $outputLabel.ForeColor = [System.Drawing.Color]::DarkOrange
                # Add Guest-specific functionality here
            }
        }
    }
})

# Show the form
[void]$form.ShowDialog()

    
}



Function Show-LoginAttempts {
    # Load Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Define global variables
$DomainController = "Your-DC-Name"  # Replace with your Domain Controller name
$EventLog = "Security"
$EventIDs = @(4624, 4625)  # Event IDs for login attempts (success/failure)

# Function: Fetch Login Attempts
function Fetch-LoginAttempts {
    param(
        [string]$UserFilter = "",
        [datetime]$StartTime = (Get-Date).AddDays(-1)
    )

    Write-Host "Fetching login attempts from $DomainController..." -ForegroundColor Yellow

    $logs = Get-WinEvent -ComputerName $DomainController -LogName $EventLog -FilterHashtable @{
        LogName   = $EventLog
        Id        = $EventIDs
        StartTime = $StartTime
    }

    if ($UserFilter -ne "") {
        $logs = $logs | Where-Object { $_.Message -match $UserFilter }
    }

    return $logs | Select-Object TimeCreated, Id, Message
}

# GUI Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Role-Based Functionality with AD Integration"
$form.Size = New-Object System.Drawing.Size(500, 400)
$form.StartPosition = "CenterScreen"

# GUI Components
# Title Label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Role-Based Functionality"
$titleLabel.Location = New-Object System.Drawing.Point(120, 10)
$titleLabel.Size = New-Object System.Drawing.Size(250, 30)
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($titleLabel)

# Role Dropdown
$roleComboBox = New-Object System.Windows.Forms.ComboBox
$roleComboBox.Location = New-Object System.Drawing.Point(150, 60)
$roleComboBox.Size = New-Object System.Drawing.Size(200, 30)
$roleComboBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$roleComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$roleComboBox.Items.AddRange(@("Admin", "User", "Guest"))
$form.Controls.Add($roleComboBox)

# User Filter TextBox
$userTextBox = New-Object System.Windows.Forms.TextBox
$userTextBox.Location = New-Object System.Drawing.Point(150, 110)
$userTextBox.Size = New-Object System.Drawing.Size(200, 30)
$userTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$userTextBox.PlaceholderText = "Filter by Username (optional)"
$form.Controls.Add($userTextBox)

# Submit Button
$submitButton = New-Object System.Windows.Forms.Button
$submitButton.Text = "Fetch Logs"
$submitButton.Location = New-Object System.Drawing.Point(200, 160)
$submitButton.Size = New-Object System.Drawing.Size(100, 30)
$submitButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$submitButton.BackColor = [System.Drawing.Color]::SteelBlue
$submitButton.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($submitButton)

# Output Label
$outputLabel = New-Object System.Windows.Forms.Label
$outputLabel.Text = "Output will appear here."
$outputLabel.Location = New-Object System.Drawing.Point(50, 200)
$outputLabel.Size = New-Object System.Drawing.Size(400, 150)
$outputLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$outputLabel.ForeColor = [System.Drawing.Color]::Gray
$form.Controls.Add($outputLabel)

# Export Button
$exportButton = New-Object System.Windows.Forms.Button
$exportButton.Text = "Export to CSV"
$exportButton.Location = New-Object System.Drawing.Point(200, 330)
$exportButton.Size = New-Object System.Drawing.Size(100, 30)
$exportButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$exportButton.BackColor = [System.Drawing.Color]::SteelBlue
$exportButton.ForeColor = [System.Drawing.Color]::White
$exportButton.Enabled = $false
$form.Controls.Add($exportButton)

# Event Handlers
# Fetch Logs
$submitButton.Add_Click({
    $role = $roleComboBox.Text
    $usernameFilter = $userTextBox.Text
    $outputLabel.Text = "Fetching logs, please wait..."
    $outputLabel.ForeColor = [System.Drawing.Color]::Blue

    if ([string]::IsNullOrWhiteSpace($role)) {
        $outputLabel.Text = "Please select a role!"
        $outputLabel.ForeColor = [System.Drawing.Color]::Red
    } else {
        $logs = Fetch-LoginAttempts -UserFilter $usernameFilter
        if ($logs) {
            $outputLabel.Text = "Logs fetched successfully!"
            $outputLabel.ForeColor = [System.Drawing.Color]::Green
            $global:LogsData = $logs  # Store logs globally for export
            $exportButton.Enabled = $true
        } else {
            $outputLabel.Text = "No logs found for the specified filter."
            $outputLabel.ForeColor = [System.Drawing.Color]::Orange
        }
    }
})

# Export Logs to CSV
$exportButton.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "CSV files (*.csv)|*.csv"
    $saveFileDialog.Title = "Save Logs as CSV"
    $saveFileDialog.ShowDialog()

    if ($saveFileDialog.FileName -ne "") {
        $global:LogsData | Export-Csv -Path $saveFileDialog.FileName -NoTypeInformation
        [System.Windows.Forms.MessageBox]::Show("Logs exported to $($saveFileDialog.FileName)", "Export Successful", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
})

# Show the Form
[void]$form.ShowDialog()
}

Function Show-AccountControlForm {

    # Load Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Import Active Directory Module
Import-Module ActiveDirectory

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "AD Account Control"
$form.Size = New-Object System.Drawing.Size(500, 400)
$form.StartPosition = "CenterScreen"

# Create Components
# Search Box
$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Location = New-Object System.Drawing.Point(50, 30)
$searchBox.Size = New-Object System.Drawing.Size(300, 30)
$searchBox.PlaceholderText = "Enter username or email..."
$form.Controls.Add($searchBox)

# Search Button
$searchButton = New-Object System.Windows.Forms.Button
$searchButton.Text = "Search"
$searchButton.Location = New-Object System.Drawing.Point(360, 30)
$searchButton.Size = New-Object System.Drawing.Size(75, 30)
$form.Controls.Add($searchButton)

# Results Box
$resultsLabel = New-Object System.Windows.Forms.Label
$resultsLabel.Text = "Results will appear here."
$resultsLabel.Location = New-Object System.Drawing.Point(50, 80)
$resultsLabel.Size = New-Object System.Drawing.Size(400, 100)
$form.Controls.Add($resultsLabel)

# Action Buttons
$enableButton = New-Object System.Windows.Forms.Button
$enableButton.Text = "Enable Account"
$enableButton.Location = New-Object System.Drawing.Point(50, 200)
$enableButton.Size = New-Object System.Drawing.Size(150, 30)
$enableButton.Enabled = $false
$form.Controls.Add($enableButton)

$disableButton = New-Object System.Windows.Forms.Button
$disableButton.Text = "Disable Account"
$disableButton.Location = New-Object System.Drawing.Point(220, 200)
$disableButton.Size = New-Object System.Drawing.Size(150, 30)
$disableButton.Enabled = $false
$form.Controls.Add($disableButton)

$resetPasswordButton = New-Object System.Windows.Forms.Button
$resetPasswordButton.Text = "Reset Password"
$resetPasswordButton.Location = New-Object System.Drawing.Point(50, 250)
$resetPasswordButton.Size = New-Object System.Drawing.Size(150, 30)
$resetPasswordButton.Enabled = $false
$form.Controls.Add($resetPasswordButton)

$unlockButton = New-Object System.Windows.Forms.Button
$unlockButton.Text = "Unlock Account"
$unlockButton.Location = New-Object System.Drawing.Point(220, 250)
$unlockButton.Size = New-Object System.Drawing.Size(150, 30)
$unlockButton.Enabled = $false
$form.Controls.Add($unlockButton)

# Event Handlers
# Search for User
$searchButton.Add_Click({
    $username = $searchBox.Text
    if (-not [string]::IsNullOrWhiteSpace($username)) {
        try {
            $user = Get-ADUser -Filter "SamAccountName -eq '$username' -or EmailAddress -eq '$username'" -Properties LockedOut, Enabled, PasswordExpired
            if ($user) {
                $resultsLabel.Text = "User found: $($user.SamAccountName)`nStatus: $($user.Enabled)`nLocked: $($user.LockedOut)"
                $resultsLabel.ForeColor = [System.Drawing.Color]::Green
                $enableButton.Enabled = -not $user.Enabled
                $disableButton.Enabled = $user.Enabled
                $resetPasswordButton.Enabled = $true
                $unlockButton.Enabled = $user.LockedOut
            } else {
                $resultsLabel.Text = "User not found."
                $resultsLabel.ForeColor = [System.Drawing.Color]::Red
            }
        } catch {
            $resultsLabel.Text = "Error: $_"
            $resultsLabel.ForeColor = [System.Drawing.Color]::Red
        }
    } else {
        $resultsLabel.Text = "Please enter a username or email."
        $resultsLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

# Enable Account
$enableButton.Add_Click({
    Set-ADUser -Identity $user.SamAccountName -Enabled $true
    [System.Windows.Forms.MessageBox]::Show("Account enabled successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    $enableButton.Enabled = $false
    $disableButton.Enabled = $true
})

# Disable Account
$disableButton.Add_Click({
    Set-ADUser -Identity $user.SamAccountName -Enabled $false
    [System.Windows.Forms.MessageBox]::Show("Account disabled successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    $disableButton.Enabled = $false
    $enableButton.Enabled = $true
})

# Reset Password
$resetPasswordButton.Add_Click({
    $newPassword = [System.Windows.Forms.MessageBox]::Show("Set the new password in AD!", "Password Reset", [System.Windows.Forms.MessageBoxButtons]::OKCancel)
    # Implement password reset logic here
})

# Unlock Account
$unlockButton.Add_Click({
    Unlock-ADAccount -Identity $user.SamAccountName
    [System.Windows.Forms.MessageBox]::Show("Account unlocked successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    $unlockButton.Enabled = $false
})

# Show Form
[void]$form.ShowDialog()

}


Function Show-NotificationsForm {
    # Load Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Import Active Directory Module
Import-Module ActiveDirectory

# Function: Send Desktop Notification
function Send-DesktopNotification {
    param (
        [string]$Username,
        [string]$Message
    )
    try {
        $ComputerName = (Get-ADUser -Identity $Username -Properties LastLogonComputer | 
            Select-Object -ExpandProperty LastLogonComputer)
        
        if ($ComputerName) {
            Start-Process -FilePath "msg.exe" -ArgumentList "$Username $Message" -NoNewWindow
            return "Desktop message sent to $Username on $ComputerName."
        } else {
            return "No active session found for $Username."
        }
    } catch {
        return "Error sending desktop notification: $_"
    }
}

# Function: Send Email Notification
function Send-EmailNotification {
    param (
        [string]$Email,
        [string]$Subject,
        [string]$Message
    )
    $SMTPServer = "smtp.rajkumar.com"  # Replace with your SMTP server
    $FromEmail = "rajkumar@rajkumar.com"  # Replace with a valid sender email
    try {
        Send-MailMessage -From $FromEmail -To $Email -Subject $Subject -Body $Message -SmtpServer $SMTPServer
        return "Email sent to $Email."
    } catch {
        return "Error sending email: $_"
    }
}

# Function: Log Notification
function Log-Notification {
    param (
        [string]$Message,
        [string]$EventSource = "ADNotification",
        [int]$EventID = 1001
    )
    try {
        if (-not (Get-EventLog -LogName Application -Source $EventSource -ErrorAction SilentlyContinue)) {
            New-EventLog -LogName Application -Source $EventSource
        }

        Write-EventLog -LogName Application -Source $EventSource -EventID $EventID -EntryType Information -Message $Message
        return "Event log created: $Message"
    } catch {
        return "Error logging event: $_"
    }
}

# GUI Setup
$form = New-Object System.Windows.Forms.Form
$form.Text = "AD Notification Tool"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"

# Username Label and TextBox
$usernameLabel = New-Object System.Windows.Forms.Label
$usernameLabel.Text = "Username:"
$usernameLabel.Location = New-Object System.Drawing.Point(30, 30)
$usernameLabel.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($usernameLabel)

$usernameTextBox = New-Object System.Windows.Forms.TextBox
$usernameTextBox.Location = New-Object System.Drawing.Point(150, 30)
$usernameTextBox.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($usernameTextBox)

# Notification Message Label and TextBox
$messageLabel = New-Object System.Windows.Forms.Label
$messageLabel.Text = "Notification Message:"
$messageLabel.Location = New-Object System.Drawing.Point(30, 70)
$messageLabel.Size = New-Object System.Drawing.Size(150, 20)
$form.Controls.Add($messageLabel)

$messageTextBox = New-Object System.Windows.Forms.TextBox
$messageTextBox.Location = New-Object System.Drawing.Point(150, 70)
$messageTextBox.Size = New-Object System.Drawing.Size(400, 20)
$form.Controls.Add($messageTextBox)

# Email Subject Label and TextBox
$emailLabel = New-Object System.Windows.Forms.Label
$emailLabel.Text = "Email Subject (Optional):"
$emailLabel.Location = New-Object System.Drawing.Point(30, 110)
$emailLabel.Size = New-Object System.Drawing.Size(150, 20)
$form.Controls.Add($emailLabel)

$emailTextBox = New-Object System.Windows.Forms.TextBox
$emailTextBox.Location = New-Object System.Drawing.Point(150, 110)
$emailTextBox.Size = New-Object System.Drawing.Size(400, 20)
$form.Controls.Add($emailTextBox)

# Buttons
$sendDesktopButton = New-Object System.Windows.Forms.Button
$sendDesktopButton.Text = "Send Desktop Notification"
$sendDesktopButton.Location = New-Object System.Drawing.Point(30, 150)
$sendDesktopButton.Size = New-Object System.Drawing.Size(200, 30)
$form.Controls.Add($sendDesktopButton)

$sendEmailButton = New-Object System.Windows.Forms.Button
$sendEmailButton.Text = "Send Email Notification"
$sendEmailButton.Location = New-Object System.Drawing.Point(250, 150)
$sendEmailButton.Size = New-Object System.Drawing.Size(200, 30)
$form.Controls.Add($sendEmailButton)

$logEventButton = New-Object System.Windows.Forms.Button
$logEventButton.Text = "Log Event"
$logEventButton.Location = New-Object System.Drawing.Point(470, 150)
$logEventButton.Size = New-Object System.Drawing.Size(100, 30)
$form.Controls.Add($logEventButton)

# Output Label
$outputLabel = New-Object System.Windows.Forms.Label
$outputLabel.Text = "Output will appear here."
$outputLabel.Location = New-Object System.Drawing.Point(30, 200)
$outputLabel.Size = New-Object System.Drawing.Size(540, 100)
$outputLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$form.Controls.Add($outputLabel)

# Button Event Handlers
$sendDesktopButton.Add_Click({
    $username = $usernameTextBox.Text
    $message = $messageTextBox.Text
    if (-not [string]::IsNullOrWhiteSpace($username) -and -not [string]::IsNullOrWhiteSpace($message)) {
        $result = Send-DesktopNotification -Username $username -Message $message
        $outputLabel.Text = $result
    } else {
        $outputLabel.Text = "Please enter a valid username and message."
    }
})

$sendEmailButton.Add_Click({
    $username = $usernameTextBox.Text
    $message = $messageTextBox.Text
    $subject = $emailTextBox.Text
    try {
        $email = (Get-ADUser -Identity $username -Properties EmailAddress).EmailAddress
        if ($email -and -not [string]::IsNullOrWhiteSpace($message)) {
            $result = Send-EmailNotification -Email $email -Subject $subject -Message $message
            $outputLabel.Text = $result
        } else {
            $outputLabel.Text = "User does not have a valid email address or message is empty."
        }
    } catch {
        $outputLabel.Text = "Error fetching email address or sending email: $_"
    }
})

$logEventButton.Add_Click({
    $message = $messageTextBox.Text
    if (-not [string]::IsNullOrWhiteSpace($message)) {
        $result = Log-Notification -Message $message
        $outputLabel.Text = $result
    } else {
        $outputLabel.Text = "Please enter a valid message to log."
    }
})

# Run the Form
[void]$form.ShowDialog()




    
}

# Start the GUI Application
Create-AdminForm

}

# Run the function if executed directly (standalone)
if ($MyInvocation.InvocationName -ne '.') {
    UserAccountManagement
}
