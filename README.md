```markdown
# IT Management Dashboard

## Overview

The **IT Management Dashboard** is a Windows-based GUI application designed for efficient Active Directory (AD) user and system management. Built using PowerShell and Windows Forms, it provides tools for managing users, tracking login attempts, sending notifications, monitoring system health, and automating routine administrative tasks.

---

## Features

- **User Account Management**: 
  - Add, enable, disable, or delete Active Directory users.
  - Manage roles and permissions.
  - Reset user passwords.

- **Login Attempts Tracking**:
  - Track user login events from Active Directory logs.
  - Export login data to CSV.

- **Password Expiration Alerts**:
  - Monitor and notify users about upcoming password expiration.

- **Patch Management**:
  - Centralized interface for tracking and managing patches.

- **System Health Checks**:
  - Monitor essential system metrics and log health status.

- **Backup Automation**:
  - Configure and manage backup tasks with reporting.

- **Notifications**:
  - Send email or desktop notifications to users.
  - Log notification events to the system.

- **Dynamic UI Elements**:
  - Styled forms, labels, buttons, and textboxes.
  - Hover effects on buttons for enhanced user experience.

---

## Prerequisites

1. **PowerShell**: Ensure you have at least PowerShell 5.1 or higher installed.
2. **Windows OS**: Application is designed to run on Windows systems.
3. **Active Directory Module**:
   - Install the Active Directory PowerShell module:
     ```powershell
     Install-WindowsFeature RSAT-AD-PowerShell
     ```
   - Required for fetching user details and performing AD operations.

4. **SMTP Server**:
   - Required for sending email notifications.
   - Configure the `$SMTPServer` variable with your SMTP server address in the code.

---

## How to Run

1. Save the script as `ITManagementDashboard.ps1`.
2. Run the script with PowerShell:
   ```powershell
   powershell -ExecutionPolicy Bypass -File ITManagementDashboard.ps1
```

3. The main dashboard will open, providing access to all features.

---

## Configuration

- **Theme Settings**:

  - Modify the `$Theme` variable to adjust the application colors:
    ```powershell
    $Theme = @{
        BackgroundColor   = [System.Drawing.Color]::LightSlateGray    # Background
        ButtonColor       = [System.Drawing.Color]::SteelBlue         # Buttons
        ButtonTextColor   = [System.Drawing.Color]::White             # Button Text
        LabelFontColor    = [System.Drawing.Color]::Lavender          # Label Text
        HeaderFontColor   = [System.Drawing.Color]::DarkOrange        # Header Text
    }
    ```
- **Font Settings**:

  - Adjust the `$Fonts` variable for headers, labels, and buttons:
    ```powershell
    $Fonts = @{
        HeaderFont = New-Object System.Drawing.Font("Verdana", 18, [System.Drawing.FontStyle]::Bold)
        LabelFont  = New-Object System.Drawing.Font("Verdana", 12, [System.Drawing.FontStyle]::Regular)
        ButtonFont = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    }
    ```

---

## Available Modules and Forms

| Feature                    | Function                     |
| -------------------------- | ---------------------------- |
| User Account Management    | `UserAccountManagement`    |
| Login Attempts Tracking    | `Show-LoginAttempts`       |
| Roles Management           | `Show-RolesForm`           |
| Notifications              | `Show-NotificationsForm`   |
| Password Expiration Alerts | `PasswordExpirationAlerts` |
| Patch Management           | `PatchManagement`          |
| System Health Checks       | `SystemHealthChecks`       |
| Backup Automation          | `BackupAutomation`         |
| Reporting and Logging      | `ReportingAndLogging`      |

---

## Usage Instructions

### User Account Management

1. Click the "User Account Management" button on the main dashboard.
2. Perform operations like adding, enabling, or deleting users.
3. Use the search functionality to find specific users.

### Login Tracking

1. Click the "Track Login Attempts" button.
2. Enter a username or filter criteria to fetch logs.
3. Export logs to a CSV file for further analysis.

### Notifications

1. Click "Send Notifications".
2. Enter the username and message.
3. Choose to send as a desktop notification, email, or log the message.

### Additional Tools

- Use buttons on the main dashboard for other features like health checks, patch management, and backups.

---

## Known Issues and Limitations

1. **Active Directory Connectivity**:
   - Ensure the machine running this script is connected to an Active Directory domain.
2. **SMTP Server Configuration**:
   - Email notifications require a configured SMTP server.
3. **Windows Version**:
   - This application is built for Windows systems only.

---

## Contributing

Feel free to contribute by:

- Reporting bugs.
- Suggesting new features.
- Submitting pull requests.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.