# Ensure shared helpers and styling are loaded if run standalone
if ($null -eq $Theme) {
    $helperPath = Join-Path $PSScriptRoot "SharedHelpers.ps1"
    if (-not (Test-Path $helperPath)) { $helperPath = Join-Path $PSScriptRoot "..\SharedHelpers.ps1" }
    if (Test-Path $helperPath) { . $helperPath }
}
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

# Run the function if executed directly (standalone)
if ($MyInvocation.InvocationName -ne '.') {
    PatchManagement
}
