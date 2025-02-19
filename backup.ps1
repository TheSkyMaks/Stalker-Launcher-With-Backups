# backup.ps1

# Load scripts
. .\configuration.ps1
. .\logger.ps1

# New backup function
function New-Backup {
    # Log message for starting the backup creation
    Write-LogMessage "Creating backup for iteration $Iteration"

    # Calculate the backup number and path
    $BackupNumber = $Iteration % $MaxBackups
    $NewBackup = "$BackupRoot\backup$BackupNumber"

    # Remove old backup if it exists
    if (Test-Path $NewBackup) {
        Remove-Item -Recurse -Force $NewBackup
    }

    # Create new backup directory
    New-Item -ItemType Directory -Path $NewBackup -Force | Out-Null

    # Copy the source folders excluding the specified ones to the new backup
    Get-ChildItem -Path $Source | Where-Object { $_.PSIsContainer -and $ExcludedFolders -notcontains $_.Name } | ForEach-Object {
        $SourceFolder = $_.FullName
        $DestFolder = Join-Path -Path $NewBackup -ChildPath $_.Name
        
        # Copy items using Copy-Item
        Write-LogMessage "Copying $SourceFolder to $DestFolder"
        Copy-Item -Path $SourceFolder -Destination $DestFolder -Recurse -Force
    }

    # Log message indicating the backup is complete
    Write-LogMessage "Backup №$BackupNumber completed successfully."

    # Update iteration in the configuration
    $Iteration++
    $config["Iteration"] = $Iteration.ToString()
    Save-Config $config
}