# logger.ps1

# Load scripts
. .\configuration.ps1  # Load configuration settings

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
    
    # Check if the log file exists, if not, create it
    $logFilePath = Join-Path $LogRoot "log.txt"
    if (-not (Test-Path $logFilePath)) {
        Write-Host "Log file not found. Creating 'log.txt'..."
        New-Item -Path $logFilePath -ItemType File
    }

    # Append the log entry to the file
    Add-Content -Path $logFilePath -Value $logEntry
}
