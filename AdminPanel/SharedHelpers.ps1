# SharedHelpers.ps1 - Shared UI Styling and Theme Configuration for IT Management Dashboard

# Load Windows Forms and Drawing assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Centralized Theme Settings (Harmonious Dark/Steel palette)
$Theme = @{
    BackgroundColor   = [System.Drawing.Color]::LightSlateGray    # Main Form Background
    ButtonColor       = [System.Drawing.Color]::SteelBlue         # Regular Button Background
    ButtonTextColor   = [System.Drawing.Color]::White             # Button Text Color
    LabelFontColor    = [System.Drawing.Color]::Lavender          # Label Text Color
    HeaderFontColor   = [System.Drawing.Color]::DarkOrange        # Header Text Color
}

# Centralized Font Configurations
$Fonts = @{
    HeaderFont = New-Object System.Drawing.Font("Verdana", 18, [System.Drawing.FontStyle]::Bold)
    LabelFont  = New-Object System.Drawing.Font("Verdana", 12, [System.Drawing.FontStyle]::Regular)
    ButtonFont = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
}

# Applies standard background, position, and border style to forms
Function Apply-FormStyle {
    param (
        [System.Windows.Forms.Form]$Form
    )
    $Form.BackColor = $Theme.BackgroundColor
    $Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
}

# Creates a label styled according to the active theme
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

# Creates a button styled according to the active theme
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

# Creates a rounded button using the active theme
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

# Creates a styled textbox using the active theme
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

# Helper to load a modular script if it is not already loaded
Function Import-HelperModule {
    param (
        [string]$ModuleName
    )
    $moduleFile = Join-Path $PSScriptRoot "$ModuleName.ps1"
    if (Test-Path $moduleFile) {
        . $moduleFile
    } else {
        $moduleFile = Join-Path $PSScriptRoot "Modules\$ModuleName.ps1"
        if (Test-Path $moduleFile) {
            . $moduleFile
        }
    }
}
