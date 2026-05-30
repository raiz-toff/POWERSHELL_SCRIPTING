# Ensure shared helpers and styling are loaded if run standalone
if ($null -eq $Theme) {
    $helperPath = Join-Path $PSScriptRoot "SharedHelpers.ps1"
    if (-not (Test-Path $helperPath)) { $helperPath = Join-Path $PSScriptRoot "..\SharedHelpers.ps1" }
    if (Test-Path $helperPath) { . $helperPath }
}
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
    $dirPath = Join-Path $PSScriptRoot "Output"
    if (-not (Test-Path $dirPath)) {
        New-Item -ItemType Directory -Path $dirPath -ErrorAction SilentlyContinue | Out-Null
    }
    $reportFile = Join-Path $dirPath "SystemReport.txt"

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
    $dirPath = Join-Path $PSScriptRoot "Output"
    if (-not (Test-Path $dirPath)) {
        New-Item -ItemType Directory -Path $dirPath -ErrorAction SilentlyContinue | Out-Null
    }
    $logFile = Join-Path $dirPath "SystemLogs.txt"

    # Export logs (e.g., latest system logs)
    Get-EventLog -LogName System -Newest 100 | Out-File -FilePath $logFile
    [System.Windows.Forms.MessageBox]::Show("System logs exported successfully to $logFile", "Logs Exported")
}


}

# Run the function if executed directly (standalone)
if ($MyInvocation.InvocationName -ne '.') {
    ReportingAndLogging
}




