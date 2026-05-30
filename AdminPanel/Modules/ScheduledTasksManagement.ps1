# Ensure shared helpers and styling are loaded if run standalone
if ($null -eq $Theme) {
    $helperPath = Join-Path $PSScriptRoot "SharedHelpers.ps1"
    if (-not (Test-Path $helperPath)) { $helperPath = Join-Path $PSScriptRoot "..\SharedHelpers.ps1" }
    if (Test-Path $helperPath) { . $helperPath }
}
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

# Run the function if executed directly (standalone)
if ($MyInvocation.InvocationName -ne '.') {
    ScheduledTasksManagement
}
