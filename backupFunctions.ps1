# backupFunctions.ps1

# Логування
function Log-Message {
    param (
        [string]$Message,
        [ValidateSet("INFO", "WARNING", "ERROR")] [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$Level] $Message"
    Write-Output $logEntry
    Add-Content -Path "$LogRoot\log.txt" -Value $logEntry
}

# Отримання останньої ітерації
function Get-LastIteration {
    param (
        [string]$BackupRoot,
        [int]$MaxBackups
    )
    
    $backupDirs = Get-ChildItem -Path $BackupRoot -Directory | Sort-Object CreationTime
    if ($backupDirs.Count -gt 0) {
        $oldestBackup = $backupDirs[0]
        $iteration = [int]($oldestBackup.Name -replace '\D', '')
        return $iteration + 1
    }
    return 1
}

# Створення бекапу
function Create-Backup {
    param (
        [int]$Iteration,
        [int]$MaxBackups,
        [string]$Source,
        [string]$BackupRoot,
        [string[]]$ExcludedFolders
    )
    
    $BackupNumber = ($Iteration - 1) % $MaxBackups + 1
    $NewBackup = "$BackupRoot\backup$BackupNumber"
    Log-Message "Creating backup$BackupNumber at $(Get-Date)"

    if (Test-Path $NewBackup) {
        Remove-Item -Recurse -Force $NewBackup
    }

    New-Item -ItemType Directory -Path $NewBackup -Force | Out-Null
    Get-ChildItem -Path $Source | Where-Object { $_.PSIsContainer -and $ExcludedFolders -notcontains $_.Name } | ForEach-Object {
        $SourceFolder = $_.FullName
        $DestFolder = Join-Path -Path $NewBackup -ChildPath $_.Name
        robocopy $SourceFolder $DestFolder /MIR /XD $ExcludedFolders
    }

    Log-Message "Backup$BackupNumber completed at $(Get-Date)"
}
