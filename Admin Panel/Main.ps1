
# Function containing the logic of main.ps1
Function Main-Function {
    # Place the content of main.ps1 here
    Write-Host "Executing main script..." -ForegroundColor Cyan
    
    
    Write-Host "Welcome to the main script!" -ForegroundColor Green
    #main logic will be added here
# functions part 

# Centralized Styling for Forms and Controls

# Colors
$Theme = @{
    BackgroundColor   = [System.Drawing.Color]::LightSlateGray    # Background
    ButtonColor       = [System.Drawing.Color]::SteelBlue         # Buttons
    ButtonTextColor   = [System.Drawing.Color]::White             # Button Text
    LabelFontColor    = [System.Drawing.Color]::Lavender          # Label Text
    HeaderFontColor   = [System.Drawing.Color]::DarkOrange        # Header Text
}

# Fonts
$Fonts = @{
    HeaderFont = New-Object System.Drawing.Font("Verdana", 18, [System.Drawing.FontStyle]::Bold)
    LabelFont  = New-Object System.Drawing.Font("Verdana", 12, [System.Drawing.FontStyle]::Regular)
    ButtonFont = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
}

# Universal Function to Apply Form Styling
Function Apply-FormStyle {
    param (
        [System.Windows.Forms.Form]$Form
    )
    $Form.BackColor = $Theme.BackgroundColor
    $Form.StartPosition = "CenterScreen"
    $Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
}

# Create Styled Label
Function Create-StyledLabel {
    param (
        [string]$Text,
        [int]$X,
        [int]$Y
    )
    $Label = New-Object System.Windows.Forms.Label
    $Label.Text = $Text
    $Label.AutoSize = $true
    $Label.ForeColor = $Theme.LabelFontColor
    $Label.Font = $Fonts.LabelFont
    $Label.BackColor = [System.Drawing.Color]::Transparent
    $Label.Location = New-Object System.Drawing.Point($X, $Y)
    return $Label
}

# Create Styled Button
Function Create-StyledButton {
    param (
        [string]$Text,
        [int]$X,
        [int]$Y,
        [int]$Width = 200,
        [int]$Height = 50
    )
    $Button = New-Object System.Windows.Forms.Button
    $Button.Text = $Text
    $Button.Size = New-Object System.Drawing.Size($Width, $Height)
    $Button.Font = $Fonts.ButtonFont
    $Button.BackColor = $Theme.ButtonColor
    $Button.ForeColor = $Theme.ButtonTextColor
    $Button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $Button.FlatAppearance.BorderSize = 0
    $Button.FlatAppearance.BorderColor = [System.Drawing.Color]::Black
    $Button.Location = New-Object System.Drawing.Point($X, $Y)
    return $Button
}

# Create Rounded Button
Function Create-RoundedButton {
    param (
        [string]$Text,
        [int]$X,
        [int]$Y,
        [int]$Width = 250,
        [int]$Height = 80,
        [int]$Radius = 30
    )
    $Button = Create-StyledButton -Text $Text -X $X -Y $Y -Width $Width -Height $Height
    $GraphicsPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $GraphicsPath.AddArc(0, 0, $Radius * 2, $Radius * 2, 180, 90)
    $GraphicsPath.AddArc($Width - $Radius * 2, 0, $Radius * 2, $Radius * 2, 270, 90)
    $GraphicsPath.AddArc($Width - $Radius * 2, $Height - $Radius * 2, $Radius * 2, $Radius * 2, 0, 90)
    $GraphicsPath.AddArc(0, $Height - $Radius * 2, $Radius * 2, $Radius * 2, 90, 90)
    $GraphicsPath.CloseAllFigures()
    $Button.Region = New-Object System.Drawing.Region($GraphicsPath)
    return $Button
}

# Create Styled Textbox
Function Create-StyledTextbox {
    param (
        [int]$X,
        [int]$Y,
        [int]$Width = 200
    )
    $Textbox = New-Object System.Windows.Forms.TextBox
    $Textbox.Font = $Fonts.LabelFont
    $Textbox.BackColor = [System.Drawing.Color]::White
    $Textbox.ForeColor = [System.Drawing.Color]::Black
    $Textbox.Location = New-Object System.Drawing.Point($X, $Y)
    $Textbox.Width = $Width
    return $Textbox
}
##Centralized styling ends here 

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

# Time Tracking Reminders Function
function TimeTrackingReminders {
   
        # Load required assemblies
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
    
        # Create the form
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Time Tracking & Reminders"
        $form.Size = New-Object System.Drawing.Size(800, 600)
        $form.StartPosition = "CenterScreen"
        $form.BackColor = "LightGray"
    
        # Title Label
        $lblTitle = New-Object System.Windows.Forms.Label
        $lblTitle.Text = "Time Tracking & Reminders"
        $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
        $lblTitle.ForeColor = "DarkOrange"
        $lblTitle.AutoSize = $true
        $lblTitle.Location = New-Object System.Drawing.Point(($form.Width - 400) / 2, 20)
        $form.Controls.Add($lblTitle)
    
        # Reminder Details Section
        $lblReminderDetails = New-Object System.Windows.Forms.Label
        $lblReminderDetails.Text = "Set Reminder Details:"
        $lblReminderDetails.Location = New-Object System.Drawing.Point(30, 80)
        $lblReminderDetails.Size = New-Object System.Drawing.Size(200, 20)
        $form.Controls.Add($lblReminderDetails)
    
        $lblReminderTask = New-Object System.Windows.Forms.Label
        $lblReminderTask.Text = "Task Description:"
        $lblReminderTask.Location = New-Object System.Drawing.Point(30, 110)
        $lblReminderTask.Size = New-Object System.Drawing.Size(150, 20)
        $form.Controls.Add($lblReminderTask)
    
        $txtReminderTask = New-Object System.Windows.Forms.TextBox
        $txtReminderTask.Location = New-Object System.Drawing.Point(200, 110)
        $txtReminderTask.Size = New-Object System.Drawing.Size(500, 20)
        $form.Controls.Add($txtReminderTask)
    
        $lblReminderTime = New-Object System.Windows.Forms.Label
        $lblReminderTime.Text = "Reminder Time (HH:mm):"
        $lblReminderTime.Location = New-Object System.Drawing.Point(30, 150)
        $lblReminderTime.Size = New-Object System.Drawing.Size(150, 20)
        $form.Controls.Add($lblReminderTime)
    
        $txtReminderTime = New-Object System.Windows.Forms.TextBox
        $txtReminderTime.Location = New-Object System.Drawing.Point(200, 150)
        $txtReminderTime.Size = New-Object System.Drawing.Size(150, 20)
        $txtReminderTime.Text = (Get-Date).ToString("HH:mm")
        $form.Controls.Add($txtReminderTime)
    
        $btnAddReminder = New-Object System.Windows.Forms.Button
        $btnAddReminder.Text = "Add Reminder"
        $btnAddReminder.Location = New-Object System.Drawing.Point(400, 145)
        $btnAddReminder.Size = New-Object System.Drawing.Size(150, 30)
        $btnAddReminder.BackColor = "SteelBlue"
        $btnAddReminder.ForeColor = "White"
        $form.Controls.Add($btnAddReminder)
    
        # Reminder List Section
        $lblScheduledReminders = New-Object System.Windows.Forms.Label
        $lblScheduledReminders.Text = "Scheduled Reminders:"
        $lblScheduledReminders.Location = New-Object System.Drawing.Point(30, 200)
        $lblScheduledReminders.Size = New-Object System.Drawing.Size(200, 20)
        $form.Controls.Add($lblScheduledReminders)
    
        $lstReminders = New-Object System.Windows.Forms.ListView
        $lstReminders.Location = New-Object System.Drawing.Point(30, 230)
        $lstReminders.Size = New-Object System.Drawing.Size(720, 250)
        $lstReminders.View = [System.Windows.Forms.View]::Details
        $lstReminders.FullRowSelect = $true
        $lstReminders.Columns.Add("Task", 400)
        $lstReminders.Columns.Add("Reminder Time", 100)
        $lstReminders.Columns.Add("Status", 100)
        $form.Controls.Add($lstReminders)
    
        # Clear Expired & Send Manual Reminder Buttons
        $btnClearExpired = New-Object System.Windows.Forms.Button
        $btnClearExpired.Text = "Clear Expired Reminders"
        $btnClearExpired.Location = New-Object System.Drawing.Point(30, 500)
        $btnClearExpired.Size = New-Object System.Drawing.Size(200, 30)
        $btnClearExpired.BackColor = "SteelBlue"
        $btnClearExpired.ForeColor = "White"
        $form.Controls.Add($btnClearExpired)
    
        $btnSendManualReminder = New-Object System.Windows.Forms.Button
        $btnSendManualReminder.Text = "Send Manual Reminder"
        $btnSendManualReminder.Location = New-Object System.Drawing.Point(250, 500)
        $btnSendManualReminder.Size = New-Object System.Drawing.Size(200, 30)
        $btnSendManualReminder.BackColor = "SteelBlue"
        $btnSendManualReminder.ForeColor = "White"
        $form.Controls.Add($btnSendManualReminder)
    
        # Global Reminder List
        $global:Reminders = @()
    
        
        function Add-Reminder {
        param(
            [string]$Task,
            [string]$ReminderTime
        )
    
        # Regular expression for time validation (HH:mm format)
        $timeRegex = '^(2[0-3]|[01]?[0-9]):([0-5]?[0-9])$'
    
        # Validate inputs
        if (-not [string]::IsNullOrWhiteSpace($Task) -and $ReminderTime -match $timeRegex) {
            # Add the reminder
            $status = "Pending"
            $reminder = [PSCustomObject]@{
                Task         = $Task
                ReminderTime = $ReminderTime
                Status       = $status
            }
            $global:Reminders += $reminder
            Update-ReminderList
            [System.Windows.Forms.MessageBox]::Show("Reminder added successfully.", "Success")
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please enter valid task details and time in HH:mm format.", "Invalid Input")
        }
    }
    
    
        function Update-ReminderList {
            $lstReminders.Items.Clear()
            foreach ($reminder in $global:Reminders) {
                $item = New-Object System.Windows.Forms.ListViewItem $reminder.Task
                $item.SubItems.Add($reminder.ReminderTime)
                $item.SubItems.Add($reminder.Status)
                $lstReminders.Items.Add($item)
            }
        }
    
        function Clear-ExpiredReminders {
            $currentTime = (Get-Date).ToString("HH:mm")
            $global:Reminders = $global:Reminders | Where-Object { $_.ReminderTime -gt $currentTime }
            Update-ReminderList
            [System.Windows.Forms.MessageBox]::Show("Expired reminders cleared.", "Success")
        }
    
        function Send-ManualReminder {
            foreach ($selectedItem in $lstReminders.SelectedItems) {
                $selectedReminder = $global:Reminders | Where-Object { $_.Task -eq $selectedItem.Text }
                if ($selectedReminder) {
                    [System.Windows.Forms.MessageBox]::Show("Reminder sent for task: $($selectedReminder.Task)", "Manual Reminder Sent")
                }
            }
        }
    
        # Button Event Handlers
        $btnAddReminder.Add_Click({
            Add-Reminder -Task $txtReminderTask.Text -ReminderTime $txtReminderTime.Text
        })
    
        $btnClearExpired.Add_Click({
            Clear-ExpiredReminders
        })
    
        $btnSendManualReminder.Add_Click({
            Send-ManualReminder
        })
    
        # Show the Form
        $form.ShowDialog()
}
    
# Patch Management Function
function PatchManagement {
    Function PatchManagement {
        # Load required assemblies
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
    
        # Create the form
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Patch Management"
        $form.Size = New-Object System.Drawing.Size(900, 600)
        $form.StartPosition = "CenterScreen"
        $form.BackColor = "LightGray"
    
        # Title Label
        $lblTitle = New-Object System.Windows.Forms.Label
        $lblTitle.Text = "Patch Management"
        $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
        $lblTitle.ForeColor = "DarkOrange"
        $lblTitle.AutoSize = $true
        $lblTitle.Location = New-Object System.Drawing.Point(($form.Width - 300) / 2, 20)
        $form.Controls.Add($lblTitle)
    
        # Available Patches Section
        $lblAvailablePatches = New-Object System.Windows.Forms.Label
        $lblAvailablePatches.Text = "Available Patches:"
        $lblAvailablePatches.Location = New-Object System.Drawing.Point(30, 80)
        $lblAvailablePatches.Size = New-Object System.Drawing.Size(200, 20)
        $form.Controls.Add($lblAvailablePatches)
    
        $lstAvailablePatches = New-Object System.Windows.Forms.ListView
        $lstAvailablePatches.Location = New-Object System.Drawing.Point(30, 110)
        $lstAvailablePatches.Size = New-Object System.Drawing.Size(720, 200)
        $lstAvailablePatches.View = [System.Windows.Forms.View]::Details
        $lstAvailablePatches.FullRowSelect = $true
        $lstAvailablePatches.Columns.Add("Patch ID", 150)
        $lstAvailablePatches.Columns.Add("Description", 400)
        $lstAvailablePatches.Columns.Add("Severity", 100)
        $form.Controls.Add($lstAvailablePatches)
    
        $btnDeployPatches = New-Object System.Windows.Forms.Button
        $btnDeployPatches.Text = "Deploy Selected Patches"
        $btnDeployPatches.Location = New-Object System.Drawing.Point(30, 330)
        $btnDeployPatches.Size = New-Object System.Drawing.Size(200, 30)
        $btnDeployPatches.BackColor = "SteelBlue"
        $btnDeployPatches.ForeColor = "White"
        $form.Controls.Add($btnDeployPatches)
    
        # Deployment History Section
        $lblDeploymentHistory = New-Object System.Windows.Forms.Label
        $lblDeploymentHistory.Text = "Deployment History:"
        $lblDeploymentHistory.Location = New-Object System.Drawing.Point(30, 380)
        $lblDeploymentHistory.Size = New-Object System.Drawing.Size(200, 20)
        $form.Controls.Add($lblDeploymentHistory)
    
        $lstDeploymentHistory = New-Object System.Windows.Forms.ListView
        $lstDeploymentHistory.Location = New-Object System.Drawing.Point(30, 410)
        $lstDeploymentHistory.Size = New-Object System.Drawing.Size(720, 130)
        $lstDeploymentHistory.View = [System.Windows.Forms.View]::Details
        $lstDeploymentHistory.FullRowSelect = $true
        $lstDeploymentHistory.Columns.Add("Patch ID", 150)
        $lstDeploymentHistory.Columns.Add("Deployment Date", 200)
        $lstDeploymentHistory.Columns.Add("Status", 100)
        $form.Controls.Add($lstDeploymentHistory)
    
        $btnRefreshHistory = New-Object System.Windows.Forms.Button
        $btnRefreshHistory.Text = "Refresh History"
        $btnRefreshHistory.Location = New-Object System.Drawing.Point(30, 550)
        $btnRefreshHistory.Size = New-Object System.Drawing.Size(200, 30)
        $btnRefreshHistory.BackColor = "SteelBlue"
        $btnRefreshHistory.ForeColor = "White"
        $form.Controls.Add($btnRefreshHistory)
    
        # Global Patch Lists
        $global:AvailablePatches = @(
            [PSCustomObject]@{ PatchID = "KB123456"; Description = "Critical security update"; Severity = "Critical" },
            [PSCustomObject]@{ PatchID = "KB654321"; Description = "Performance improvement"; Severity = "Moderate" }
        )
        $global:DeploymentHistory = @()
    
        # Functions
        function Load-AvailablePatches {
            $lstAvailablePatches.Items.Clear()
            foreach ($patch in $global:AvailablePatches) {
                $item = New-Object System.Windows.Forms.ListViewItem $patch.PatchID
                $item.SubItems.Add($patch.Description)
                $item.SubItems.Add($patch.Severity)
                $lstAvailablePatches.Items.Add($item)
            }
        }
    
        function Deploy-Patches {
            foreach ($selectedItem in $lstAvailablePatches.SelectedItems) {
                $patchID = $selectedItem.Text
                $patch = $global:AvailablePatches | Where-Object { $_.PatchID -eq $patchID }
                if ($patch) {
                    # Example: Mark as deployed (extend to implement real deployment logic)
                    $global:DeploymentHistory += [PSCustomObject]@{
                        PatchID         = $patch.PatchID
                        DeploymentDate  = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                        Status          = "Deployed"
                    }
                    [System.Windows.Forms.MessageBox]::Show("Patch $($patch.PatchID) deployed successfully.", "Deployment Successful")
                }
            }
            Load-DeploymentHistory
        }
    
        function Load-DeploymentHistory {
            $lstDeploymentHistory.Items.Clear()
            foreach ($deployment in $global:DeploymentHistory) {
                $item = New-Object System.Windows.Forms.ListViewItem $deployment.PatchID
                $item.SubItems.Add($deployment.DeploymentDate)
                $item.SubItems.Add($deployment.Status)
                $lstDeploymentHistory.Items.Add($item)
            }
        }
    
        # Button Event Handlers
        $btnDeployPatches.Add_Click({
            if ($lstAvailablePatches.SelectedItems.Count -eq 0) {
                [System.Windows.Forms.MessageBox]::Show("Please select patches to deploy.", "No Selection")
                return
            }
            Deploy-Patches
        })
    
        $btnRefreshHistory.Add_Click({
            Load-DeploymentHistory
        })
    
        # Load initial data
        Load-AvailablePatches
        Load-DeploymentHistory
    
        # Show the Form
        $form.ShowDialog()
    }
    patchmanagement
    
    
}

# Password Reset Automation Function
function PasswordResetAutomation {

   
        # Load required assemblies
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
    
        # Create the form
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Password Reset Automation"
        $form.Size = New-Object System.Drawing.Size(900, 600)
        $form.StartPosition = "CenterScreen"
        $form.BackColor = "LightGray"
    
        # Title Label
        $lblTitle = New-Object System.Windows.Forms.Label
        $lblTitle.Text = "Password Reset Automation"
        $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
        $lblTitle.ForeColor = "DarkOrange"
        $lblTitle.AutoSize = $true
        $lblTitle.Location = New-Object System.Drawing.Point(($form.Width - 400) / 2, 20)
        $form.Controls.Add($lblTitle)
    
        #password generator
        $btnLaunchGenerator = New-Object System.Windows.Forms.Button
        $btnLaunchGenerator.Text = "Launch Password Generator"
        $btnLaunchGenerator.Location = New-Object System.Drawing.Point(30,590)
        $btnLaunchGenerator.Size = New-Object System.Drawing.Size(200, 40)
        $btnLaunchGenerator.BackColor = "SteelBlue"
        $btnLaunchGenerator.ForeColor = "White"
        $form.Controls.Add($btnLaunchGenerator)
    
        # Search Section
        $lblSearch = New-Object System.Windows.Forms.Label
        $lblSearch.Text = "Search User:"
        $lblSearch.Location = New-Object System.Drawing.Point(30, 80)
        $lblSearch.Size = New-Object System.Drawing.Size(100, 20)
        $form.Controls.Add($lblSearch)
    
        $txtSearch = New-Object System.Windows.Forms.TextBox
        $txtSearch.Location = New-Object System.Drawing.Point(140, 80)
        $txtSearch.Size = New-Object System.Drawing.Size(300, 20)
        $form.Controls.Add($txtSearch)
    
        $btnSearch = New-Object System.Windows.Forms.Button
        $btnSearch.Text = "Search"
        $btnSearch.Location = New-Object System.Drawing.Point(460, 75)
        $btnSearch.Size = New-Object System.Drawing.Size(100, 30)
        $btnSearch.BackColor = "SteelBlue"
        $btnSearch.ForeColor = "White"
        $form.Controls.Add($btnSearch)
    
        # User List Section
        $lblUsers = New-Object System.Windows.Forms.Label
        $lblUsers.Text = "Select Users:"
        $lblUsers.Location = New-Object System.Drawing.Point(30, 130)
        $lblUsers.Size = New-Object System.Drawing.Size(200, 20)
        $form.Controls.Add($lblUsers)
    
        $lstUsers = New-Object System.Windows.Forms.ListView
        $lstUsers.Location = New-Object System.Drawing.Point(30, 160)
        $lstUsers.Size = New-Object System.Drawing.Size(720, 200)
        $lstUsers.View = [System.Windows.Forms.View]::Details
        $lstUsers.FullRowSelect = $true
        $lstUsers.Columns.Add("SamAccountName", 150)
        $lstUsers.Columns.Add("DisplayName", 200)
        $lstUsers.Columns.Add("Enabled", 100)
        $form.Controls.Add($lstUsers)
    
        # Password Reset Section
        $lblNewPassword = New-Object System.Windows.Forms.Label
        $lblNewPassword.Text = "New Password:"
        $lblNewPassword.Location = New-Object System.Drawing.Point(30, 380)
        $lblNewPassword.Size = New-Object System.Drawing.Size(200, 20)
        $form.Controls.Add($lblNewPassword)
    
        $txtNewPassword = New-Object System.Windows.Forms.TextBox
        $txtNewPassword.Location = New-Object System.Drawing.Point(140, 380)
        $txtNewPassword.Size = New-Object System.Drawing.Size(300, 20)
        $form.Controls.Add($txtNewPassword)
    
        $btnResetPassword = New-Object System.Windows.Forms.Button
        $btnResetPassword.Text = "Reset Password"
        $btnResetPassword.Location = New-Object System.Drawing.Point(460, 375)
        $btnResetPassword.Size = New-Object System.Drawing.Size(150, 30)
        $btnResetPassword.BackColor = "SteelBlue"
        $btnResetPassword.ForeColor = "White"
        $btnResetPassword.Enabled = $false
        $form.Controls.Add($btnResetPassword)
    
        # Status Log Section
        $lblStatus = New-Object System.Windows.Forms.Label
        $lblStatus.Text = "Status Log:"
        $lblStatus.Location = New-Object System.Drawing.Point(30, 430)
        $lblStatus.Size = New-Object System.Drawing.Size(200, 20)
        $form.Controls.Add($lblStatus)
    
        $txtStatusLog = New-Object System.Windows.Forms.TextBox
        $txtStatusLog.Location = New-Object System.Drawing.Point(30, 460)
        $txtStatusLog.Size = New-Object System.Drawing.Size(720, 100)
        $txtStatusLog.Multiline = $true
        $txtStatusLog.ScrollBars = "Vertical"
        $txtStatusLog.ReadOnly = $true
        $form.Controls.Add($txtStatusLog)
    
        # Global User List
        $global:UserList = @()
    
        # Functions
       Function passwordGenerator{
    
    # Load required assemblies
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    
    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Password Generator"
    $form.Size = New-Object System.Drawing.Size(400, 400)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = "LightGray"
    
    # Title Label
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = "Random Password Generator"
    $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
    $lblTitle.ForeColor = "DarkBlue"
    $lblTitle.AutoSize = $true
    $lblTitle.Location = New-Object System.Drawing.Point(80, 20)
    $form.Controls.Add($lblTitle)
    
    # Password Length Label and NumericUpDown
    $lblLength = New-Object System.Windows.Forms.Label
    $lblLength.Text = "Password Length:"
    $lblLength.Location = New-Object System.Drawing.Point(30, 70)
    $lblLength.Size = New-Object System.Drawing.Size(120, 20)
    $form.Controls.Add($lblLength)
    
    $numLength = New-Object System.Windows.Forms.NumericUpDown
    $numLength.Location = New-Object System.Drawing.Point(150, 70)
    $numLength.Size = New-Object System.Drawing.Size(60, 20)
    $numLength.Minimum = 4
    $numLength.Maximum = 32
    $numLength.Value = 12
    $form.Controls.Add($numLength)
    
    # Character Set Checkboxes
    $chkUppercase = New-Object System.Windows.Forms.CheckBox
    $chkUppercase.Text = "Include Uppercase Letters"
    $chkUppercase.Location = New-Object System.Drawing.Point(30, 110)
    $chkUppercase.Size = New-Object System.Drawing.Size(200, 20)
    $chkUppercase.Checked = $true
    $form.Controls.Add($chkUppercase)
    
    $chkLowercase = New-Object System.Windows.Forms.CheckBox
    $chkLowercase.Text = "Include Lowercase Letters"
    $chkLowercase.Location = New-Object System.Drawing.Point(30, 140)
    $chkLowercase.Size = New-Object System.Drawing.Size(200, 20)
    $chkLowercase.Checked = $true
    $form.Controls.Add($chkLowercase)
    
    $chkNumbers = New-Object System.Windows.Forms.CheckBox
    $chkNumbers.Text = "Include Numbers"
    $chkNumbers.Location = New-Object System.Drawing.Point(30, 170)
    $chkNumbers.Size = New-Object System.Drawing.Size(200, 20)
    $chkNumbers.Checked = $true
    $form.Controls.Add($chkNumbers)
    
    $chkSpecial = New-Object System.Windows.Forms.CheckBox
    $chkSpecial.Text = "Include Special Characters"
    $chkSpecial.Location = New-Object System.Drawing.Point(30, 200)
    $chkSpecial.Size = New-Object System.Drawing.Size(200, 20)
    $chkSpecial.Checked = $true
    $form.Controls.Add($chkSpecial)
    
    # Generate Password Button
    $btnGenerate = New-Object System.Windows.Forms.Button
    $btnGenerate.Text = "Generate Password"
    $btnGenerate.Location = New-Object System.Drawing.Point(30, 240)
    $btnGenerate.Size = New-Object System.Drawing.Size(150, 30)
    $btnGenerate.BackColor = "SteelBlue"
    $btnGenerate.ForeColor = "White"
    $form.Controls.Add($btnGenerate)
    
    # Password Output TextBox
    $txtPassword = New-Object System.Windows.Forms.TextBox
    $txtPassword.Location = New-Object System.Drawing.Point(30, 290)
    $txtPassword.Size = New-Object System.Drawing.Size(320, 20)
    $txtPassword.ReadOnly = $true
    $form.Controls.Add($txtPassword)
    
    # Copy to Clipboard Button
    $btnCopy = New-Object System.Windows.Forms.Button
    $btnCopy.Text = "Copy to Clipboard"
    $btnCopy.Location = New-Object System.Drawing.Point(200, 240)
    $btnCopy.Size = New-Object System.Drawing.Size(150, 30)
    $btnCopy.BackColor = "Green"
    $btnCopy.ForeColor = "White"
    $btnCopy.Enabled = $false
    $form.Controls.Add($btnCopy)
    
    # Function to Generate Password
    function Generate-Password {
        param (
            [int]$Length,
            [bool]$IncludeUppercase,
            [bool]$IncludeLowercase,
            [bool]$IncludeNumbers,
            [bool]$IncludeSpecial
        )
    
        $upperChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        $lowerChars = "abcdefghijklmnopqrstuvwxyz"
        $numberChars = "0123456789"
        $specialChars = "!@#$%^&*()-_=+[]{}|;:'"",.<>/?`~"
    
        $charSet = ""
    
        if ($IncludeUppercase) { $charSet += $upperChars }
        if ($IncludeLowercase) { $charSet += $lowerChars }
        if ($IncludeNumbers) { $charSet += $numberChars }
        if ($IncludeSpecial) { $charSet += $specialChars }
    
        if ([string]::IsNullOrEmpty($charSet)) {
            [System.Windows.Forms.MessageBox]::Show("Please select at least one character set.", "Error")
            return ""
        }
    
        $passwordChars = @()
        $random = New-Object System.Random
    
        for ($i = 0; $i -lt $Length; $i++) {
            $index = $random.Next(0, $charSet.Length)
            $passwordChars += $charSet[$index]
        }
    
        return ($passwordChars -join "")
    }
    
    # Generate Button Event Handler
    $btnGenerate.Add_Click({
        $password = Generate-Password -Length $numLength.Value `
            -IncludeUppercase $chkUppercase.Checked `
            -IncludeLowercase $chkLowercase.Checked `
            -IncludeNumbers $chkNumbers.Checked `
            -IncludeSpecial $chkSpecial.Checked
    
        if (-not [string]::IsNullOrEmpty($password)) {
            $txtPassword.Text = $password
            $btnCopy.Enabled = $true
        } else {
            $txtPassword.Text = ""
            $btnCopy.Enabled = $false
        }
    })
    
    # Copy to Clipboard Event Handler
    $btnCopy.Add_Click({
        [System.Windows.Forms.Clipboard]::SetText($txtPassword.Text)
        [System.Windows.Forms.MessageBox]::Show("Password copied to clipboard.", "Success")
    })
    
    # Run the Form
    $form.Topmost = $true
    $form.Add_Shown({ $form.Activate() })
    [void]$form.ShowDialog()
    
     }
    
        function Search-Users {
            param(
                [string]$SearchQuery
            )
    
            try {
                Import-Module ActiveDirectory
                $users = Get-ADUser -Filter {Name -like "*$SearchQuery*"} -Properties SamAccountName, DisplayName, Enabled
    
                if (!$users) {
                    return @()
                }
    
                $userList = $users | ForEach-Object {
                    [PSCustomObject]@{
                        SamAccountName = $_.SamAccountName
                        DisplayName    = $_.DisplayName
                        Enabled        = $_.Enabled
                    }
                }
    
                return $userList
            } catch {
                return @()
            }
        }
    
        function Reset-Passwords {
            param(
                [array]$SelectedUsers,
                [string]$NewPassword
            )
    
            foreach ($user in $SelectedUsers) {
                try {
                    Set-ADAccountPassword -Identity $user.SamAccountName -Reset -NewPassword (ConvertTo-SecureString $NewPassword -AsPlainText -Force)
                    $txtStatusLog.AppendText("Password reset for $($user.DisplayName) ($($user.SamAccountName)).`r`n")
                } catch {
                    $txtStatusLog.AppendText("Failed to reset password for $($user.DisplayName).`r`n")
                }
            }
        }
    
        # Button Event Handlers
        $btnSearch.Add_Click({
            $searchQuery = $txtSearch.Text
            if (-not [string]::IsNullOrWhiteSpace($searchQuery)) {
                $lstUsers.Items.Clear()
                $userList = Search-Users -SearchQuery $searchQuery
                if ($userList) {
                    $global:UserList = $userList
                    foreach ($user in $userList) {
                        $item = New-Object System.Windows.Forms.ListViewItem $user.SamAccountName
                        $item.SubItems.Add($user.DisplayName)
                        $item.SubItems.Add($user.Enabled)
                        $lstUsers.Items.Add($item)
                    }
                    $btnResetPassword.Enabled = $true
                } else {
                    [System.Windows.Forms.MessageBox]::Show("No users found matching '$searchQuery'.", "Search Results")
                    $btnResetPassword.Enabled = $false
                }
            } else {
                [System.Windows.Forms.MessageBox]::Show("Please enter a valid search query.", "Invalid Input")
            }
        })
    
        $btnResetPassword.Add_Click({
            $selectedUsers = @()
            foreach ($item in $lstUsers.SelectedItems) {
                $selectedUsers += $global:UserList | Where-Object { $_.SamAccountName -eq $item.Text }
            }
            if ($selectedUsers) {
                $newPassword = $txtNewPassword.Text
                if (-not [string]::IsNullOrWhiteSpace($newPassword)) {
                    Reset-Passwords -SelectedUsers $selectedUsers -NewPassword $newPassword
                } else {
                    [System.Windows.Forms.MessageBox]::Show("Please enter a valid password.", "Invalid Input")
                }
            } else {
                [System.Windows.Forms.MessageBox]::Show("Please select users to reset passwords.", "No Selection")
            }
        })
    
        $btnLaunchGenerator.Add_Click({
            passwordGenerator
        })
    
        # Show the Form
        $form.ShowDialog()
    
     
    }
    

# System Health Checks Function#this code is not complete yet

Function SystemHealthChecks {
    # Load required assemblies
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "System Health Checks"
    $form.Size = New-Object System.Drawing.Size(600, 500)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = "LightGray"

    # Title Label
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = "System Health Checks"
    $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $lblTitle.ForeColor = "DarkOrange"
    $lblTitle.AutoSize = $true
    $form.Controls.Add($lblTitle)

    # Output Box
    $txtOutput = New-Object System.Windows.Forms.TextBox
    $txtOutput.Location = New-Object System.Drawing.Point(270, 80)
    $txtOutput.Size = New-Object System.Drawing.Size(300, 300)
    $txtOutput.Multiline = $true
    $txtOutput.ScrollBars = "Vertical"
    $txtOutput.ReadOnly = $true
    $form.Controls.Add($txtOutput)

    # Add Buttons Individually

    # Button: Check CPU Usage
    $btnCPU = New-Object System.Windows.Forms.Button
    $btnCPU.Text = "Check CPU Usage"
    $btnCPU.Location = New-Object System.Drawing.Point(50, 80)
    $btnCPU.Size = New-Object System.Drawing.Size(200, 40)
    $btnCPU.BackColor = "SteelBlue"
    $btnCPU.ForeColor = "White"
    $btnCPU.Add_Click({
        $cpuUsage = Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples 1
        $txtOutput.AppendText("CPU Usage: {0:N2}%`r`n" -f $cpuUsage.CounterSamples.CookedValue)
    })
    $form.Controls.Add($btnCPU)

    # Button: Check Memory Usage
    $btnMemory = New-Object System.Windows.Forms.Button
    $btnMemory.Text = "Check Memory Usage"
    $btnMemory.Location = New-Object System.Drawing.Point(50, 140)
    $btnMemory.Size = New-Object System.Drawing.Size(200, 40)
    $btnMemory.BackColor = "SteelBlue"
    $btnMemory.ForeColor = "White"
    $btnMemory.Add_Click({
        $memory = Get-CimInstance -ClassName Win32_OperatingSystem
        $totalMemory = [math]::Round($memory.TotalVisibleMemorySize / 1MB, 2)
        $freeMemory = [math]::Round($memory.FreePhysicalMemory / 1MB, 2)
        $usedMemory = $totalMemory - $freeMemory
        $txtOutput.AppendText("Memory Usage: $usedMemory MB / $totalMemory MB`r`n")
    })
    $form.Controls.Add($btnMemory)

    # Button: Check Disk Space
    $btnDisk = New-Object System.Windows.Forms.Button
    $btnDisk.Text = "Check Disk Space"
    $btnDisk.Location = New-Object System.Drawing.Point(50, 200)
    $btnDisk.Size = New-Object System.Drawing.Size(200, 40)
    $btnDisk.BackColor = "SteelBlue"
    $btnDisk.ForeColor = "White"
    $btnDisk.Add_Click({
        $drives = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType = 3"
        foreach ($drive in $drives) {
            $freeSpace = [math]::Round($drive.FreeSpace / 1GB, 2)
            $totalSpace = [math]::Round($drive.Size / 1GB, 2)
            $txtOutput.AppendText("Drive $($drive.DeviceID): $freeSpace GB free / $totalSpace GB total`r`n")
        }
    })
    $form.Controls.Add($btnDisk)

    # Button: Check Network Connectivity
    $btnNetwork = New-Object System.Windows.Forms.Button
    $btnNetwork.Text = "Check Network Connectivity"
    $btnNetwork.Location = New-Object System.Drawing.Point(50, 260)
    $btnNetwork.Size = New-Object System.Drawing.Size(200, 40)
    $btnNetwork.BackColor = "SteelBlue"
    $btnNetwork.ForeColor = "White"
    $btnNetwork.Add_Click({
        $ping = Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet
        if ($ping) {
            $txtOutput.AppendText("Network Connectivity: Online`r`n")
        } else {
            $txtOutput.AppendText("Network Connectivity: Offline`r`n")
        }
    })
    $form.Controls.Add($btnNetwork)

    # Button: View Event Logs
    $btnLogs = New-Object System.Windows.Forms.Button
    $btnLogs.Text = "View Event Logs"
    $btnLogs.Location = New-Object System.Drawing.Point(50, 320)
    $btnLogs.Size = New-Object System.Drawing.Size(200, 40)
    $btnLogs.BackColor = "SteelBlue"
    $btnLogs.ForeColor = "White"
    $btnLogs.Add_Click({
        $logs = Get-EventLog -LogName System -Newest 5
        foreach ($log in $logs) {
            $txtOutput.AppendText("Event: $($log.EntryType) - $($log.Message)`r`n")
        }
    })
    $form.Controls.Add($btnLogs)

    # Button: Check System Uptime
    $btnUptime = New-Object System.Windows.Forms.Button
    $btnUptime.Text = "Check System Uptime"
    $btnUptime.Location = New-Object System.Drawing.Point(50, 380)
    $btnUptime.Size = New-Object System.Drawing.Size(200, 40)
    $btnUptime.BackColor = "SteelBlue"
    $btnUptime.ForeColor = "White"
    $btnUptime.Add_Click({
        $uptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
        $uptimeFormatted = (Get-Date) - $uptime
        $txtOutput.AppendText("System Uptime: $($uptimeFormatted.Days) days, $($uptimeFormatted.Hours) hours, $($uptimeFormatted.Minutes) minutes`r`n")
    })
    $form.Controls.Add($btnUptime)

    # Show the form
    $form.ShowDialog()
}
# Backup Automation Function
function BackupAutomation {
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
    
    
    
    
}

# Reporting and Logging Function
function ReportingAndLogging {

    
    # Load required assemblies
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Reporting and Logging"
    $form.Size = New-Object System.Drawing.Size(500, 400)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = "LightGray"

    # Add Title Label
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = "Reporting and Logging"
    $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $lblTitle.ForeColor = "DarkOrange"
    $lblTitle.AutoSize = $true
    $lblTitle.Location = New-Object System.Drawing.Point(([int]$form.Width - 300) / 2, 20)
    $form.Controls.Add($lblTitle)

    # Add Button: Generate Report
    $btnGenerateReport = New-Object System.Windows.Forms.Button
    $btnGenerateReport.Text = "Generate Report"
    $btnGenerateReport.Location = New-Object System.Drawing.Point(50, 80)
    $btnGenerateReport.Size = New-Object System.Drawing.Size(400, 40)
    $btnGenerateReport.BackColor = "SteelBlue"
    $btnGenerateReport.ForeColor = "White"
    $btnGenerateReport.Add_Click({ Generate-Report })
    $form.Controls.Add($btnGenerateReport)

    # Add Button: Export Logs
    $btnExportLogs = New-Object System.Windows.Forms.Button
    $btnExportLogs.Text = "Export Logs"
    $btnExportLogs.Location = New-Object System.Drawing.Point(50, 140)
    $btnExportLogs.Size = New-Object System.Drawing.Size(400, 40)
    $btnExportLogs.BackColor = "SteelBlue"
    $btnExportLogs.ForeColor = "White"
    $btnExportLogs.Add_Click({ Export-Logs })
    $form.Controls.Add($btnExportLogs)

    # Show the form
    $form.ShowDialog()
    # Logic for Generating Reports
Function Generate-Report {
    $reportFile = "C:\Reports\SystemReport.txt"
    if (-not (Test-Path "C:\Reports")) {
        New-Item -ItemType Directory -Path "C:\Reports"
    }

    # Create a sample system report
    $reportContent = @"
System Report:
--------------
Date: $(Get-Date)
CPU Usage: $(Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples 1 | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue)%
Memory Usage: $(Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory) KB Free
Uptime: $(((Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime).ToString())
"@

    $reportContent | Set-Content -Path $reportFile
    [System.Windows.Forms.MessageBox]::Show("System report generated successfully at $reportFile", "Report Generated")
}

# Logic for Exporting Logs
Function Export-Logs {
    $logFile = "C:\Reports\SystemLogs.txt"
    if (-not (Test-Path "C:\Reports")) {
        New-Item -ItemType Directory -Path "C:\Reports"
    }

    # Export logs (e.g., latest system logs)
    Get-EventLog -LogName System -Newest 100 | Out-File -FilePath $logFile
    [System.Windows.Forms.MessageBox]::Show("System logs exported successfully to $logFile", "Logs Exported")
}


}

# Phonetic Spelling Automation Function
function PhoneticSpellingAutomation {


    # Load required assemblies
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Phonetic Spelling Automation"
    $form.Size = New-Object System.Drawing.Size(500, 400)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = "LightGray"

    # Add Title Label
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = "Phonetic Spelling Automation"
    $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
    $lblTitle.ForeColor = "DarkOrange"
    $lblTitle.AutoSize = $true
    $lblTitle.Location = New-Object System.Drawing.Point(([int]$form.Width - 300) / 2, 20)
    $form.Controls.Add($lblTitle)

    # Button: Convert Text to Phonetics
    $btnConvert = New-Object System.Windows.Forms.Button
    $btnConvert.Text = "Convert Text to Phonetics"
    $btnConvert.Location = New-Object System.Drawing.Point(50, 80)
    $btnConvert.Size = New-Object System.Drawing.Size(400, 40)
    $btnConvert.BackColor = "SteelBlue"
    $btnConvert.ForeColor = "White"
    $btnConvert.Add_Click({ Convert-TextToPhonetics })
    $form.Controls.Add($btnConvert)

    # Button: Export Phonetics to File
    $btnExport = New-Object System.Windows.Forms.Button
    $btnExport.Text = "Export Phonetics to File"
    $btnExport.Location = New-Object System.Drawing.Point(50, 140)
    $btnExport.Size = New-Object System.Drawing.Size(400, 40)
    $btnExport.BackColor = "SteelBlue"
    $btnExport.ForeColor = "White"
    $btnExport.Add_Click({ Export-PhoneticsToFile })
    $form.Controls.Add($btnExport)

    # Button: Generate IPA Transcriptions
    $btnIPA = New-Object System.Windows.Forms.Button
    $btnIPA.Text = "Generate IPA Transcriptions"
    $btnIPA.Location = New-Object System.Drawing.Point(50, 200)
    $btnIPA.Size = New-Object System.Drawing.Size(400, 40)
    $btnIPA.BackColor = "SteelBlue"
    $btnIPA.ForeColor = "White"
    $btnIPA.Add_Click({ Generate-IPATranscriptions })
    $form.Controls.Add($btnIPA)

    # Show the form
    $form.ShowDialog()
   
    
}

# Scheduled Tasks Management Function
function ScheduledTasksManagement {
   
        # Load required assemblies
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
    
        # Create the form
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Scheduled Tasks Management"
        $form.Size = New-Object System.Drawing.Size(500, 400)
        $form.StartPosition = "CenterScreen"
        $form.BackColor = "LightGray"
    
        # Add Title Label
        $lblTitle = New-Object System.Windows.Forms.Label
        $lblTitle.Text = "Scheduled Tasks Management"
        $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
        $lblTitle.ForeColor = "DarkOrange"
        $lblTitle.AutoSize = $true
        $lblTitle.Location = New-Object System.Drawing.Point(([int]$form.Width - 300) / 2, 20)
        $form.Controls.Add($lblTitle)
    
        # Add Button: View Scheduled Tasks
        $btnViewTasks = New-Object System.Windows.Forms.Button
        $btnViewTasks.Text = "View Scheduled Tasks"
        $btnViewTasks.Location = New-Object System.Drawing.Point(50, 80)
        $btnViewTasks.Size = New-Object System.Drawing.Size(400, 40)
        $btnViewTasks.BackColor = "SteelBlue"
        $btnViewTasks.ForeColor = "White"
        $btnViewTasks.Add_Click({ View-ScheduledTasks })
        $form.Controls.Add($btnViewTasks)
    
        # Add Button: Create Scheduled Task
        $btnCreateTask = New-Object System.Windows.Forms.Button
        $btnCreateTask.Text = "Create Scheduled Task"
        $btnCreateTask.Location = New-Object System.Drawing.Point(50, 140)
        $btnCreateTask.Size = New-Object System.Drawing.Size(400, 40)
        $btnCreateTask.BackColor = "SteelBlue"
        $btnCreateTask.ForeColor = "White"
        $btnCreateTask.Add_Click({ Create-ScheduledTask })
        $form.Controls.Add($btnCreateTask)
    
        # Add Button: Delete Scheduled Task
        $btnDeleteTask = New-Object System.Windows.Forms.Button
        $btnDeleteTask.Text = "Delete Scheduled Task"
        $btnDeleteTask.Location = New-Object System.Drawing.Point(50, 200)
        $btnDeleteTask.Size = New-Object System.Drawing.Size(400, 40)
        $btnDeleteTask.BackColor = "SteelBlue"
        $btnDeleteTask.ForeColor = "White"
        $btnDeleteTask.Add_Click({ Delete-ScheduledTask })
        $form.Controls.Add($btnDeleteTask)
    
        # Add Button: Edit Scheduled Task
        $btnEditTask = New-Object System.Windows.Forms.Button
        $btnEditTask.Text = "Edit Scheduled Task"
        $btnEditTask.Location = New-Object System.Drawing.Point(50, 260)
        $btnEditTask.Size = New-Object System.Drawing.Size(400, 40)
        $btnEditTask.BackColor = "SteelBlue"
        $btnEditTask.ForeColor = "White"
        $btnEditTask.Add_Click({ Edit-ScheduledTask })
        $form.Controls.Add($btnEditTask)
    
        # Show the form
        $form.ShowDialog()
    
    
    # Function: View Scheduled Tasks
    Function View-ScheduledTasks {
        $tasks = schtasks /query /fo LIST | Out-String
        [System.Windows.Forms.MessageBox]::Show("Scheduled Tasks:`n$tasks", "View Scheduled Tasks")
    }
    
    # Function: Create Scheduled Task
    Function Create-ScheduledTask {
        $taskName = Show-InputDialog "Enter task name:" "Create Scheduled Task"
        if ($taskName) {
            schtasks /create /tn $taskName /tr "powershell.exe -NoProfile -Command `"Write-Output 'Scheduled task executed'`"" /sc once /st 12:00 /f
            [System.Windows.Forms.MessageBox]::Show("Task '$taskName' created successfully.", "Task Created")
        } else {
            [System.Windows.Forms.MessageBox]::Show("No task name provided.", "Error")
        }
    }
    
    # Function: Delete Scheduled Task
    Function Delete-ScheduledTask {
        $taskName = Show-InputDialog "Enter task name to delete:" "Delete Scheduled Task"
        if ($taskName) {
            schtasks /delete /tn $taskName /f
            [System.Windows.Forms.MessageBox]::Show("Task '$taskName' deleted successfully.", "Task Deleted")
        } else {
            [System.Windows.Forms.MessageBox]::Show("No task name provided.", "Error")
        }
    }
    
    # Function: Edit Scheduled Task
    Function Edit-ScheduledTask {
        $taskName = Show-InputDialog "Enter task name to edit:" "Edit Scheduled Task"
        if ($taskName) {
            $newTime = Show-InputDialog "Enter new start time (HH:mm):" "Edit Scheduled Task"
            if ($newTime) {
                schtasks /change /tn $taskName /st $newTime
                [System.Windows.Forms.MessageBox]::Show("Task '$taskName' updated successfully to start at $newTime.", "Task Updated")
            } else {
                [System.Windows.Forms.MessageBox]::Show("No new time provided.", "Error")
            }
        } else {
            [System.Windows.Forms.MessageBox]::Show("No task name provided.", "Error")
        }
    }
    
    # Function: Show Input Dialog (Custom InputBox)
    Function Show-InputDialog {
        param(
            [string]$Prompt,
            [string]$Title
        )
    
        # Create Input Dialog Form
        $form = New-Object System.Windows.Forms.Form
        $form.Text = $Title
        $form.Size = New-Object System.Drawing.Size(400, 200)
        $form.StartPosition = "CenterScreen"
    
        # Add Label
        $label = New-Object System.Windows.Forms.Label
        $label.Text = $Prompt
        $label.Location = New-Object System.Drawing.Point(10, 20)
        $label.Size = New-Object System.Drawing.Size(370, 40)
        $form.Controls.Add($label)
    
        # Add TextBox
        $textBox = New-Object System.Windows.Forms.TextBox
        $textBox.Location = New-Object System.Drawing.Point(10, 70)
        $textBox.Size = New-Object System.Drawing.Size(370, 20)
        $form.Controls.Add($textBox)
    
        # Add Buttons
        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Text = "OK"
        $okButton.Location = New-Object System.Drawing.Point(100, 120)
        $okButton.Size = New-Object System.Drawing.Size(80, 30)
        $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Controls.Add($okButton)
    
        $cancelButton = New-Object System.Windows.Forms.Button
        $cancelButton.Text = "Cancel"
        $cancelButton.Location = New-Object System.Drawing.Point(200, 120)
        $cancelButton.Size = New-Object System.Drawing.Size(80, 30)
        $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.Controls.Add($cancelButton)
    
        $form.AcceptButton = $okButton
        $form.CancelButton = $cancelButton
    
        # Show Dialog
        if ($form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            return $textBox.Text
        } else {
            return $null
        }
    }
    
    
    
    
   
}


# Create the main form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "IT Management Dashboard"
$Form.Width = 700
$Form.Height = 800
Apply-FormStyle -Form $Form

# Add a title label
$titleLabel = Create-StyledLabel -Text "IT Management Dashboard" -X 0 -Y 20
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = $Theme.HeaderFontColor
$titleLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$titleLabel.Size = New-Object System.Drawing.Size($Form.Width, 50)
$Form.Controls.Add($titleLabel)

# Adjust button layout
$buttonDetails = @(
    @{ Text = "User Account Management"; Action = { UserAccountManagement } },
    @{ Text = "Password Expiration Alerts"; Action = { PasswordExpirationAlerts } },
    @{ Text = "Time Tracking Reminders"; Action = { TimeTrackingReminders } },
    @{ Text = "Patch Management"; Action = { PatchManagement } },
    @{ Text = "Password Reset Automation"; Action = { PasswordResetAutomation } },
    @{ Text = "System Health Checks"; Action = { SystemHealthChecks } },
    @{ Text = "Backup Automation"; Action = { BackupAutomation } },
    @{ Text = "Reporting and Logging"; Action = { ReportingAndLogging } },
    @{ Text = "Phonetic Spelling Automation"; Action = { PhoneticSpellingAutomation } },
    @{ Text = "Scheduled Tasks Management"; Action = { ScheduledTasksManagement } }
)

# Button settings
$startY = 100
$buttonSpacing = 70
$buttonWidth = 400
$buttonHeight = 60
$buttonX = ($Form.Width - $buttonWidth) / 2

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

# Show the form
$Form.ShowDialog()





    
}

Main-Function
