# launch.ps1

# Load scripts
. .\configuration.ps1  # Load configuration settings
. .\logger.ps1        # Load logging functions
. .\backup.ps1        # Load backup functions
. .\restore.ps1       # Load restore functions

# Ensure the necessary folders exist
$folders = @($BackupRoot, $RestoreRoot, $LogRoot)

foreach ($folder in $folders) {
    if (-not (Test-Path -Path $folder)) {
        Write-LogMessage "Folder '$folder' does not exist. Creating it now."
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
    else {
        Write-LogMessage "Folder '$folder' already exists."
    }
}
    
# Check if the log file exists, if not, create it
$logFilePath = Join-Path $LogRoot "log.txt"
if (-not (Test-Path $logFilePath)) {
    Write-Host "Log file not found. Creating 'log.txt'..."
    New-Item -Path $logFilePath -ItemType File
}

# Function to check if a library exists at a specified path
function Test-IfLibraryExists {
    param (
        [string]$assemblyPath  # The path where the library should be located
    )
    
    # Returns true if the library exists at the given path
    return Test-Path $assemblyPath
}

# Function to install a library if it is not found
function Install-LibraryIfNeeded {
    param (
        [string]$libraryName, # The name of the library to check/install
        [string]$libraryPath   # The path where the library should be located
    )

    # If the library doesn't exist, attempt to install it
    if (-not (Test-IfLibraryExists $libraryPath)) {
        Write-Host "Library '$libraryName' not found. Installing..."

        # Example of how you might install the library (adjust as needed)
        Install-Package -Name $libraryName -Source 'nuget.org' -Force

        # Verify if the library was successfully installed
        if (-not (Test-IfLibraryExists $libraryPath)) {
            Write-Host "Failed to install library '$libraryName'. Please check your settings."
            exit
        }
    }
    else {
        Write-Host "Library '$libraryName' is already installed."
    }
}

# Install or verify the required System.Windows.Forms library
$windowsFormsPath = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\System.Windows.Forms.dll"
Install-LibraryIfNeeded -libraryName "System.Windows.Forms" -libraryPath $windowsFormsPath

# Add types for C# code defining the GUI components
Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;

public class MyForm : Form
{
    public Button backupButton;
    public Button restoreButton;
    public Button playGameButton;
    public Label statusLabel;
    public TextBox consoleBox;

    public MyForm()
    {
        backupButton = new Button();
        restoreButton = new Button();
        playGameButton = new Button();
        statusLabel = new Label();
        consoleBox = new TextBox();

        // Add logic for GUI components (buttons, labels, etc.)
    }
}
"@ -Language CSharp -ReferenceAssemblies $windowsFormsPath

# Create the form instance
$form = New-Object MyForm

# Function to update the status on the form and log to console
function Update-Status {
    param (
        [string]$message  # Message to display and log
    )
    
    # Update status label on the form
    $form.statusLabel.Text = $message
    $form.Refresh()
    
    # Log message to console (optional)
    $form.LogToConsole($message)
}

# Define button click event for backup
$form.backupButton.Add_Click({
        Update-Status "Starting Backup..."
        try {
            # Call the New-Backup function from backup.ps1
            New-Backup
            Update-Status "Backup Complete"
        }
        catch {
            # If backup fails, update status with error message
            Update-Status "Backup failed: $_" -Level "ERROR"
        }
    })

# Define button click event for restore
$form.restoreButton.Add_Click({
        Update-Status "Restoring..."
        try {
            # Call the Restore-Backup function from restore.ps1
            Restore-Backup
            Update-Status "Restore Complete"
        }
        catch {
            # If restore fails, update status with error message
            Update-Status "Restore failed: $_" -Level "ERROR"
        }
    })

# Define button click event for launching the game
$form.playGameButton.Add_Click({
        Update-Status "Launching game without GUI..."
        try {
            # Call launchWithoutGUI.ps1 to run the game without GUI
            .\launchWithoutGUI.ps1
            Update-Status "Game Launched"
        }
        catch {
            # If game launch fails, update status with error message
            Update-Status "Error launching game: $_" -Level "ERROR"
        }
    })
