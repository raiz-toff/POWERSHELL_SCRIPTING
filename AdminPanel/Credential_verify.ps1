# main.ps1 - Main script that will be called after successful authentication

# Function to verify administrator credentials
Function Verify-AdminCredentials {
    # Prompt for credentials
    $credentials = Get-Credential -Message "Enter administrator credentials to access the script."

    # Check if credentials are null
    if (-not $credentials) {
        Write-Host "No credentials entered. Exiting script." -ForegroundColor Red
        return
    }

    # Define a test command to validate credentials
    $testCommand = {
        Test-Path "C:\Windows\System32"
    }

    try {
        # Run a test command using the entered credentials
        $result = Start-Process -FilePath "powershell.exe" -ArgumentList "-Command", $testCommand -Credential $credentials -NoNewWindow -Wait -PassThru

        # Ensure result is not null
        if (-not $result) {
            Write-Host "Start-Process failed to return a result." -ForegroundColor Red
            return
        }

        # Check ExitCode
        if ($result.ExitCode -eq 0) {
            Write-Host "Authentication successful. Access granted. Launching Dashboard..." -ForegroundColor Green
            $mainPath = Join-Path $PSScriptRoot "Main.ps1"
            # Start the main dashboard in a new window under the elevated credentials
            Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$mainPath`"" -Credential $credentials
        } else {
            Write-Host "Authentication failed. Access denied." -ForegroundColor Red
        }
    } catch {
        Write-Host "An error occurred during authentication:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        Write-Host $_.Exception.StackTrace -ForegroundColor Gray
    }
}

# Call the Verify-AdminCredentials function at the start of the script
Verify-AdminCredentials



