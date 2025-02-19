# launchWithoutGUI.ps1

# Load scripts
. .\configuration.ps1
. .\backup.ps1
. .\restore.ps1
. .\logger.ps1

# Launch the game launcher
# Start-Process -FilePath $Launcher -Verb RunAs

# Main backup cycle
while ($true) {
    try {
        # Get the current iteration from the configuration
        $Iteration = [int]$config["Iteration"]

        # If auto-restore is enabled and there are fewer than $minFilesForRestore files in the save folder, perform restore
        if ($autoRestore) {
            # Perform the restore (using Restore-Auto function)
            Restore-Auto
        }

        # Call the function to create a backup
        Write-LogMessage "Starting backup creation for iteration $Iteration..."
        New-Backup -Iteration $Iteration -MaxBackups $MaxBackups -Source $Source -BackupRoot $BackupRoot -ExcludedFolders $ExcludedFolders

        # Update the iteration in the configuration after backup
        $Iteration++
        $config["Iteration"] = $Iteration.ToString()
        Save-Config $config

        Write-LogMessage "Backup completed. Updated iteration: $Iteration"
    }
    catch {
        # Log any error that occurs during backup
        Write-LogMessage "Error during backup iteration $Iteration : $_" -Level "ERROR"
    }

    # Wait before the next iteration
    Write-LogMessage "Waiting for $BackupDelayBetweenIterations seconds before next backup cycle."    
    break
    Start-Sleep -Seconds $BackupDelayBetweenIterations
}

