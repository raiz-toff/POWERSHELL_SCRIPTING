# Ensure shared helpers and styling are loaded if run standalone
if ($null -eq $Theme) {
    $helperPath = Join-Path $PSScriptRoot "SharedHelpers.ps1"
    if (-not (Test-Path $helperPath)) { $helperPath = Join-Path $PSScriptRoot "..\SharedHelpers.ps1" }
    if (Test-Path $helperPath) { . $helperPath }
}
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

# Run the function if executed directly (standalone)
if ($MyInvocation.InvocationName -ne '.') {
    PasswordResetAutomation
}
