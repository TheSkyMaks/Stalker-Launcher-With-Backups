# configuration.ps1

# Path to the configuration file
$configFilePath = ".\config.txt"

# Function to load the configuration from the file
function Load-Config {
    $config = @{}
    if (Test-Path $configFilePath) {
        $lines = Get-Content $configFilePath
        foreach ($line in $lines) {
            $parts = $line -split "="
            if ($parts.Length -eq 2) {
                $config[$parts[0].Trim()] = $parts[1].Trim()
            }
        }
    } else {
        # Create default values
        $config = @{
            "Source"                     = "D:\Anomaly\appdata\savedgames"
            "Launcher"                   = "D:\GAMMA\.Grok's Modpack Installer\G.A.M.M.A. Launcher.exe"
            "MaxBackups"                 = "5"
            "autoRestore"                = "True"
            "minFilesForRestore"         = "5"
            "BackupDelayBetweenIterations" = "300"
            "Iteration"                  = "1"
        }
        Save-Config $config
    }
    return $config
}

# Function to save the configuration to the file
function Save-Config {
    param ($config)
    $configContent = $config.Keys | ForEach-Object { "$_=$($config[$_])" }
    Set-Content -Path $configFilePath -Value $configContent
}

# Function to load the iteration
function Load-Iteration {
    param ($config)
    if ($config.ContainsKey("Iteration")) { 
        return [int]$config["Iteration"]
    }    
}

# Function to update the iteration in the config
function Save-Iteration {
    param ([int]$iteration, [hashtable]$config)
    $config["Iteration"] = $iteration.ToString()
    Save-Config $config
}

# Load configuration
$config = Load-Config
$Iteration = Load-Iteration -config $config

# Configuration variables
$Source = $config["Source"]
$Launcher = $config["Launcher"]
$MaxBackups = [int]$config["MaxBackups"]
$autoRestore = [bool]($config["autoRestore"] -eq "True")
$minFilesForRestore = [int]$config["minFilesForRestore"]
$BackupDelayBetweenIterations = [int]$config["BackupDelayBetweenIterations"]

# Paths for backups, logs, and restores
$BackupRoot = Join-Path -Path $Source -ChildPath "backups"
$RestoreRoot = Join-Path -Path $Source -ChildPath "restored"

# Folders to exclude during operations
$ExcludedFolders = @("backups", "restored")

# Ensure the necessary folders exist
$folders = @($BackupRoot, $RestoreRoot)