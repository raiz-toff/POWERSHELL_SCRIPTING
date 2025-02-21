Function ReportingAndLogging {
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
}

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


