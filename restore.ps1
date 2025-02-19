# restore.ps1

# Load scripts
. .\configuration.ps1
. .\logger.ps1

# Function to perform the restore from backup
function Restore-Backup {
    # Calculate the backup number for restoration
    $BackupNumber = ($Iteration + 3) % $MaxBackups + 1
    $BackupFolder = "$BackupRoot\backup$BackupNumber"

    # Create a restore path with timestamp
    $timestampRestore = Get-Date -Format "yyyyMMdd_HHmmss"
    $RestorePath = "$RestoreRoot\restore_$timestampRestore"
    Write-LogMessage "Creating restore folder at: $RestorePath"
    New-Item -ItemType Directory -Path $RestorePath -Force | Out-Null

    # Create old and new folders during the restoration process
    $OldFolder = "$RestorePath\old"
    $NewFolder = "$RestorePath\new"
    Write-LogMessage "Creating old and new folders for restore."
    New-Item -ItemType Directory -Path $OldFolder -Force | Out-Null
    New-Item -ItemType Directory -Path $NewFolder -Force | Out-Null
    
    # Move current files to the old folder
    Copy-Files -SourceFolder $Source -DestinationFolder $OldFolder

    # Move backup files to the new folder
    Copy-Files -SourceFolder $BackupFolder -DestinationFolder $NewFolder
    
    # Move new files to the source folder
    Copy-Files -SourceFolder $NewFolder -DestinationFolder $Source

    # Log message indicating the completion of the restore process
    Write-LogMessage "Restore completed from backup$BackupNumber."
}

# Function for Auto-Restore
function Restore-Auto {
    # Check if the number of files in source is below the minimum threshold
    $FilesInSource = Get-ChildItem -Path $Source -File
    
    Write-LogMessage "Found $($FilesInSource.Count) in $Source."
    if ($FilesInSource.Count -ge $minFilesForRestore) {
        Write-LogMessage "No need for auto-restore. Files are sufficient in $Source."
        return
    }

    Write-LogMessage "Not enough files in $Source. Performing restore from the last backup."

    # Perform the restore (using Restore-Backup function)
    Restore-Backup
}
