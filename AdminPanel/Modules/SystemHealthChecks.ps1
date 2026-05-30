# Ensure shared helpers and styling are loaded if run standalone
if ($null -eq $Theme) {
    $helperPath = Join-Path $PSScriptRoot "SharedHelpers.ps1"
    if (-not (Test-Path $helperPath)) { $helperPath = Join-Path $PSScriptRoot "..\SharedHelpers.ps1" }
    if (Test-Path $helperPath) { . $helperPath }
}
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

# Run the function if executed directly (standalone)
if ($MyInvocation.InvocationName -ne '.') {
    SystemHealthChecks
}
