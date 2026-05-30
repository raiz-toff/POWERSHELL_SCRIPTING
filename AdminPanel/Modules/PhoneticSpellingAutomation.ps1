# Ensure shared helpers and styling are loaded if run standalone
if ($null -eq $Theme) {
    $helperPath = Join-Path $PSScriptRoot "SharedHelpers.ps1"
    if (-not (Test-Path $helperPath)) { $helperPath = Join-Path $PSScriptRoot "..\SharedHelpers.ps1" }
    if (Test-Path $helperPath) { . $helperPath }
}

Function PhoneticSpellingAutomation {
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
    $btnIPA.Add_Click({ Invoke-IPATranscriptions })
    $form.Controls.Add($btnIPA)

    # Show the form
    $form.ShowDialog()
}

# Function to Convert Text to Phonetics
Function Convert-TextToPhonetics {
    $inputText = Show-InputDialog "Enter text to convert to phonetics:" "Phonetic Converter"
    if (-not [string]::IsNullOrWhiteSpace($inputText)) {
        $phoneticMapping = @{
            "a" = "Alpha"; "b" = "Bravo"; "c" = "Charlie"; "d" = "Delta";
            "e" = "Echo"; "f" = "Foxtrot"; "g" = "Golf"; "h" = "Hotel";
            "i" = "India"; "j" = "Juliett"; "k" = "Kilo"; "l" = "Lima";
            "m" = "Mike"; "n" = "November"; "o" = "Oscar"; "p" = "Papa";
            "q" = "Quebec"; "r" = "Romeo"; "s" = "Sierra"; "t" = "Tango";
            "u" = "Uniform"; "v" = "Victor"; "w" = "Whiskey"; "x" = "X-ray";
            "y" = "Yankee"; "z" = "Zulu"
        }

        $phonetics = ($inputText.ToLower() -split '' | ForEach-Object { $phoneticMapping[$_] })
        [System.Windows.Forms.MessageBox]::Show("Phonetic Representation:`n$($phonetics -join ' ')", "Conversion Complete")
    } else {
        [System.Windows.Forms.MessageBox]::Show("No input provided.", "Error")
    }
}

# Function to Export Phonetics to File
Function Export-PhoneticsToFile {
    $dirPath = Join-Path $PSScriptRoot "Output"
    if (-not (Test-Path $dirPath)) {
        New-Item -ItemType Directory -Path $dirPath -ErrorAction SilentlyContinue | Out-Null
    }
    $filePath = Join-Path $dirPath "Phonetics.txt"
    $content = "Sample phonetic data exported to this file."
    $content | Set-Content -Path $filePath
    [System.Windows.Forms.MessageBox]::Show("Phonetics exported to $filePath", "Export Complete")
}

Function Show-InputDialog {
    param(
        [string]$Prompt,
        [string]$Title
    )
    
    # Create a new form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object System.Drawing.Size(400, 200)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false

    # Add Label for Prompt
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Prompt
    $label.Size = New-Object System.Drawing.Size(350, 40)
    $label.Location = New-Object System.Drawing.Point(20, 20)
    $form.Controls.Add($label)

    # Add TextBox for Input
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Size = New-Object System.Drawing.Size(350, 25)
    $textBox.Location = New-Object System.Drawing.Point(20, 70)
    $form.Controls.Add($textBox)

    # Add OK Button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Location = New-Object System.Drawing.Point(80, 120)
    $okButton.Size = New-Object System.Drawing.Size(100, 30)
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Controls.Add($okButton)

    # Add Cancel Button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "Cancel"
    $cancelButton.Location = New-Object System.Drawing.Point(200, 120)
    $cancelButton.Size = New-Object System.Drawing.Size(100, 30)
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.Controls.Add($cancelButton)

    # Show dialog and return result
    $form.AcceptButton = $okButton
    $form.CancelButton = $cancelButton
    $dialogResult = $form.ShowDialog()

    if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
        return $textBox.Text
    } else {
        return $null
    }
}

# Function to Generate IPA Transcriptions
Function Invoke-IPATranscriptions {
    $inputText = Show-InputDialog "Enter text to generate IPA transcriptions:" "IPA Transcription"
    if (-not [string]::IsNullOrWhiteSpace($inputText)) {
        # Example IPA transcription logic (simple simulation)
        $ipaMapping = @{
            "a" = "æ"; "b" = "b"; "c" = "k"; "d" = "d"; "e" = "ɛ";
            "f" = "f"; "g" = "ɡ"; "h" = "h"; "i" = "ɪ"; "j" = "ʤ";
            "k" = "k"; "l" = "l"; "m" = "m"; "n" = "n"; "o" = "ɒ";
            "p" = "p"; "q" = "kw"; "r" = "r"; "s" = "s"; "t" = "t";
            "u" = "ʌ"; "v" = "v"; "w" = "w"; "x" = "ks"; "y" = "j";
            "z" = "z"
        }

        $ipaTranscription = ($inputText.ToLower() -split '' | ForEach-Object { $ipaMapping[$_] })
        [System.Windows.Forms.MessageBox]::Show("IPA Transcription:`n$($ipaTranscription -join '')", "IPA Complete")
    } else {
        [System.Windows.Forms.MessageBox]::Show("No input provided.", "Error")
    }
}

# Run the function if executed directly (standalone)
if ($MyInvocation.InvocationName -ne '.') {
    PhoneticSpellingAutomation
}
