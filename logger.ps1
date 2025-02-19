# logger.ps1

# Load scripts
. .\configuration.ps1

# Path to the logs file
$logsFilePath = ".\logs.txt"

# Logging function
function Write-LogMessage {
    param (
        [string]$Message,  # The message to log
        [ValidateSet("INFO", "WARNING", "ERROR")] [string]$Level = "INFO"  # The log level
    )
    
    # Get current timestamp for log entry
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$Level] $Message"
    
    # Output log entry to the console
    Write-Output $logEntry

    # Append the log entry to the file
    Add-Content -Path $logsFilePath -Value $logEntry
}
