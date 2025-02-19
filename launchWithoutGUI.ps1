# launchWithoutGUI.ps1

# Load scripts
. .\configuration.ps1
. .\backup.ps1
. .\restore.ps1
. .\logger.ps1

# Launch the game launcher
Start-Process -FilePath $Launcher -Verb RunAs

# Ensure the necessary folders exist
$folders = @($BackupRoot, $RestoreRoot, $LogRoot)

foreach ($folder in $folders) {
    if (-not (Test-Path -Path $folder)) {
        Write-LogMessage "Folder '$folder' does not exist. Creating it now."
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    } else {
        Write-LogMessage "Folder '$folder' already exists."
    }
}

# Main backup cycle
while ($true) {
    try {
        # Get the current iteration from the configuration
        $Iteration = [int]$config["Iteration"]

        # If auto-restore is enabled and there are fewer than $minFilesForRestore files in the save folder, perform restore
        if ($autoRestore) {
            Write-LogMessage "Checking if auto-restore is needed for iteration $Iteration..."

            # Perform the restore (using Restore-Auto function)
            $autoRestoreResult = Restore-Auto
            if ($autoRestoreResult) {
                Write-LogMessage "Auto-restore completed successfully."
                    
                # Update the iteration in the configuration after the restore
                $Iteration++
                $config["Iteration"] = $Iteration.ToString()
                Save-Config $config

                # Continue to the next cycle after restore
                Write-LogMessage "Skipping backup after successful restore. Continuing to next cycle."
                continue
            }
            else {
                Write-LogMessage "Auto-restore failed." -Level "ERROR"
            }
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
    Start-Sleep -Seconds $BackupDelayBetweenIterations
}

