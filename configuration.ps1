# configuration.ps1

# Шлях до файлу конфігурації
$configFilePath = ".\config.txt"

# Функція для завантаження конфігурації з файлу
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
        Write-Host "Файл конфігурації не знайдено. Створюємо новий із стандартними параметрами."
        # Створюємо дефолтні значення
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

# Функція для збереження конфігурації у файл
function Save-Config {
    param ($config)
    $configContent = $config.Keys | ForEach-Object { "$_=$($config[$_])" }
    Set-Content -Path $configFilePath -Value $configContent
}

# Функція для зчитування ітерації
function Load-Iteration {
    param ($config)
    return if ($config.ContainsKey("Iteration")) { [int]$config["Iteration"] } else { 1 }
}

# Функція для оновлення ітерації в конфігу
function Save-Iteration {
    param ([int]$iteration, [hashtable]$config)
    $config["Iteration"] = $iteration.ToString()
    Save-Config $config
}

# Завантаження конфігурації
$config = Load-Config
$Iteration = Load-Iteration -config $config

# Змінні конфігурації
$Source = $config["Source"]
$Launcher = $config["Launcher"]
$MaxBackups = [int]$config["MaxBackups"]
$autoRestore = [bool]($config["autoRestore"] -eq "True")
$minFilesForRestore = [int]$config["minFilesForRestore"]
$BackupDelayBetweenIterations = [int]$config["BackupDelayBetweenIterations"]

# Шляхи для бекапів, логів та відновлень
$BackupRoot = Join-Path -Path $Source -ChildPath "backups"
$RestoreRoot = Join-Path -Path $Source -ChildPath "restored"
$LogRoot = Join-Path -Path $Source -ChildPath "logs"

# Папки для виключення під час бекапу
$ExcludedFolders = @("backups", "logs", "restored")
