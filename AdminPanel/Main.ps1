# main.ps1 - Streamlined IT Management Dashboard entry point
# Dynamically loads UI configuration and modules

# Ensure we run in a single-threaded apartment mode (required for Forms)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 1. Load Shared UI Helpers and Themes
$helperPath = Join-Path $PSScriptRoot "SharedHelpers.ps1"
if (Test-Path $helperPath) {
    . $helperPath
} else {
    Write-Error "SharedHelpers.ps1 not found in $PSScriptRoot"
    exit 1
}

# 2. Dynamically Load All Module Scripts from the Modules directory
$modulesDir = Join-Path $PSScriptRoot "Modules"
if (Test-Path $modulesDir) {
    $moduleFiles = Get-ChildItem -Path $modulesDir -Filter "*.ps1"
    foreach ($file in $moduleFiles) {
        try {
            . $file.FullName
        } catch {
            Write-Warning "Failed to load module script: $($file.Name). Error: $($_.Exception.Message)"
        }
    }
} else {
    Write-Warning "Modules directory not found at $modulesDir"
}

# 3. Create the Main Form
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

# Button Layout configuration matching original styling and actions
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

$startY = 100
$buttonSpacing = 70
$buttonWidth = 400
$buttonHeight = 60
$buttonX = ($Form.Width - $buttonWidth) / 2

foreach ($index in 0..($buttonDetails.Count - 1)) {
    $btnDetail = $buttonDetails[$index]
    $buttonY = $startY + ($index * $buttonSpacing)

    # Create rounded button using shared helpers
    $button = Create-RoundedButton -Text $btnDetail.Text -X $buttonX -Y $buttonY -Width $buttonWidth -Height $buttonHeight
    
    # Hover Effects
    $button.MouseEnter.Add({
        $button.BackColor = [System.Drawing.Color]::DodgerBlue
    })
    $button.MouseLeave.Add({
        $button.BackColor = $Theme.ButtonColor
    })
    
    $button.Add_Click($btnDetail.Action)
    $Form.Controls.Add($button)
}

# Show the Main Form
[void]$Form.ShowDialog()
