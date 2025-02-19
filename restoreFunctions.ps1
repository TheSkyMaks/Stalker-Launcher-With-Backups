# restoreFunctions.ps1

# Логування
function Log-Message {
    param (
        [string]$Message,
        [ValidateSet("INFO", "WARNING", "ERROR")] [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$Level] $Message"
    Write-Output $logEntry
    Add-Content -Path "$RestoreRoot\restore_log.txt" -Value $logEntry
}

# Відновлення з бекапу
function Restore-Backup {
    param (
        [int]$Iteration,
        [string]$Source,
        [string]$BackupRoot,
        [string]$RestoreRoot
    )

    Log-Message "Not enough files in $Source. Restoring from last backup."
    
    $BackupNumber = ($Iteration - 1) % $MaxBackups + 1
    $BackupFolder = "$BackupRoot\backup$BackupNumber"
    $timestampRestore = Get-Date -Format "yyyyMMdd_HHmmss"
    $RestorePath = "$RestoreRoot\restore_$timestampRestore"
    New-Item -ItemType Directory -Path $RestorePath -Force | Out-Null

    $OldFolder = "$RestorePath\old"
    $NewFolder = "$RestorePath\new"
    New-Item -ItemType Directory -Path $OldFolder -Force | Out-Null
    New-Item -ItemType Directory -Path $NewFolder -Force | Out-Null

    Move-Item -Path $Source\* -Destination $OldFolder -Force
    Copy-Item -Path "$BackupFolder\*" -Destination $NewFolder -Recurse -Force

    Log-Message "Restore completed from backup$BackupNumber."
}
