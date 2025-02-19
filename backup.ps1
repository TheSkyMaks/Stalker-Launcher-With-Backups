# backup.ps1

# Load scripts
. .\configuration.ps1
. .\logger.ps1
. .\fileManager.ps1  # Load file manager functions

function New-Backup {
    $sourceItems = Get-ChildItem -Path $Source -File
    if ($sourceItems.Count -gt 0) {
        Write-LogMessage "No need for backup. 0 Files in $Source."
        return
    }

    Write-LogMessage "Creating backup for iteration $Iteration"

    $BackupNumber = ($Iteration - 1) % $MaxBackups + 1
    $NewBackup = "$BackupRoot\backup$BackupNumber"

    # Remove old backup if it exists
    if (Test-Path $NewBackup) {
        Write-LogMessage "Old backup found, removing it."
        Remove-Item -Recurse -Force $NewBackup
    }

    Write-LogMessage "Creating new backup directory: $NewBackup"
    New-Item -ItemType Directory -Path $NewBackup -Force | Out-Null

    Copy-Files -SourceFolder $Source -DestinationFolder $NewBackup

    Write-LogMessage "Backup №$BackupNumber completed successfully."
}
