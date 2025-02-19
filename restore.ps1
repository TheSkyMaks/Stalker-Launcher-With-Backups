# restore.ps1

# Load scripts
. .\configuration.ps1
. .\logger.ps1

# Function to perform the restore from backup
function Restore-Backup {
    param (
        [int]$Iteration = [int]$config["Iteration"], # Default to current iteration from config
        [string]$Source = $config["Source"], # Default to source path from config
        [string]$BackupRoot = $config["BackupRoot"], # Default to backup root from config
        [string]$RestoreRoot = $config["RestoreRoot"], # Default to restore root from config
        [array]$ExcludedFolders = @("backups", "logs", "restored") # Folders to exclude from restore
    )
    # Calculate the backup number for restoration
    $BackupNumber = $Iteration % $MaxBackups
    $BackupFolder = "$BackupRoot\backup$BackupNumber"

    # Create a restore path with timestamp
    $timestampRestore = Get-Date -Format "yyyyMMdd_HHmmss"
    $RestorePath = "$RestoreRoot\restore_$timestampRestore"
    New-Item -ItemType Directory -Path $RestorePath -Force | Out-Null

    # Create old and new folders during the restoration process
    $OldFolder = "$RestorePath\old"
    $NewFolder = "$RestorePath\new"
    New-Item -ItemType Directory -Path $OldFolder -Force | Out-Null
    New-Item -ItemType Directory -Path $NewFolder -Force | Out-Null

    # Move current files to the old folder, excluding certain folders
    Get-ChildItem -Path $Source -File | Where-Object { 
        $excluded = $ExcludedFolders | Where-Object { $_ -eq $_.Name }
        return !$excluded
    } | Move-Item -Destination $OldFolder -Force -ErrorAction SilentlyContinue

    # Copy files from the backup to the new folder, excluding certain folders
    Get-ChildItem -Path $BackupFolder -Recurse | Where-Object {
        $excluded = $ExcludedFolders | Where-Object { $_.Name -eq $_.Name }
        return !$excluded
    } | Copy-Item -Destination $NewFolder -Recurse -Force -ErrorAction SilentlyContinue

    # Log message indicating the completion of the restore process
    Write-LogMessage "Restore completed from backup$BackupNumber."

    # Return true indicating success
    return $true
}

# Function for Auto-Restore
function Restore-Auto {
    # Check if the number of files in source is below the minimum threshold
    $FilesInSource = Get-ChildItem -Path $Source -File
    if ($FilesInSource.Count -lt $minFilesForRestore) {
        Write-LogMessage "Not enough files in $Source. Performing restore from the last backup."

        # Perform the restore (using Restore-Backup function)
        $restoreResult = Restore-Backup

        if ($restoreResult) {
            Write-LogMessage "Auto-restore completed successfully."
            return $true
        }
        else {
            Write-LogMessage "Auto-restore failed." -Level "ERROR"
            return $false
        }
    }

    Write-LogMessage "No need for auto-restore. Files are sufficient in $Source."
    return $false
}
