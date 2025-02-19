# S.T.A.L.K.E.R. Launcher with Backup

This PowerShell-based project provides a user-friendly GUI interface for managing backups and launching the GAMMA game. 
It supports automatic backups, restoring from the last backup, and running the game launcher.

## Features

- **Backup Creation**: Automatically creates backups of your specified game data.
- **Restore from Backup**: Restores your game data from the latest backup if necessary.
- **Game Launcher**: Launches the GAMMA game directly from the interface.
- **Logging**: Detailed logs for backup and restore operations.
- **Configuration**: Easily editable configuration file for all paths and settings.

## Requirements

- PowerShell (Recommended version: 7.x or higher)
- .NET Framework (for Windows Forms)
- GAMMA game launcher installed

## File Structure

### 1. **config.txt**

A configuration file for specifying parameters:
- `Source`: Path to the game data folder.
- `Launcher`: Path to the game launcher executable.
- `MaxBackups`: Maximum number of backups to keep.
- `autoRestore`: Enable/disable automatic restore when there are not enough files in the source.
- `BackupDelayBetweenIterations`: Delay (in seconds) between backup iterations.

### 2. **launch.ps1**

This is the main script for running the program. It:
- Loads the configuration.
- Creates a Windows Forms graphical interface.
- Manages backup operations, restores, and game launching.

### 3. **launchWithoutGUI.ps1**

This file allows you to run backups and restores without using the Windows Forms graphical interface. The script simply runs backups or restores in the background, useful for automation.

## Setup

1. **Clone the repository** or download the files to your local machine.

   ```bash
   git clone https://github.com/your-repository.git
