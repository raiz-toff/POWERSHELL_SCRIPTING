# Ensure shared helpers and styling are loaded if run standalone
if ($null -eq $Theme) {
    $helperPath = Join-Path $PSScriptRoot "SharedHelpers.ps1"
    if (-not (Test-Path $helperPath)) { $helperPath = Join-Path $PSScriptRoot "..\SharedHelpers.ps1" }
    if (Test-Path $helperPath) { . $helperPath }
}
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

# Run the function if executed directly (standalone)
if ($MyInvocation.InvocationName -ne '.') {
    TimeTrackingReminders
}