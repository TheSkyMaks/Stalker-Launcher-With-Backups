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
        Write-Host "Configuration file not found. Creating a new one with default values."
        # Створюємо дефолтні значення, якщо конфігураційний файл відсутній
        $config["Source"] = "G:\Anomaly\appdata\savedgames"
        $config["Launcher"] = "G:\GAMMA\.Grok's Modpack Installer\G.A.M.M.A. Launcher.exe"
        $config["MaxBackups"] = "5"
        $config["autoRestore"] = "True"
        $config["BackupDelayBetweenIterations"] = "300"
        $config["Iteration"] = "1"
        Save-Config $config
    }
    return $config
}

# Функція для збереження конфігурації у файл
function Save-Config {
    param ($config)
    $config | ForEach-Object { "$($_.Key)=$($_.Value)" } | Set-Content -Path $configFilePath
}

# Завантажуємо конфігурацію
$config = Load-Config

# Зчитуємо параметри з конфігурації
$Source = $config["Source"]
$Launcher = $config["Launcher"]
$MaxBackups = [int]$config["MaxBackups"]
$autoRestore = [bool]$config["autoRestore"]
$BackupDelayBetweenIterations = [int]$config["BackupDelayBetweenIterations"]
$Iteration = [int]$config["Iteration"]

# Шлях до файлу, де зберігається ітерація
$iterationFilePath = ".\iteration.txt"

# Перевіряємо, чи існує файл ітерації
if (Test-Path $iterationFilePath) {
    # Якщо файл існує, зчитуємо номер ітерації
    $Iteration = [int](Get-Content -Path $iterationFilePath)
} else {
    # Якщо файл не існує, починаємо з ітерації 1
    $Iteration = 1
}

# Запускаємо лаунчер гри
Start-Process -FilePath $Launcher -Verb RunAs

# Логіка бекапів (якщо потрібно)
while ($true) {
    try {
        # Якщо авто-відновлення увімкнено і в папці збережень менше ніж $minFilesForRestore файлів, відновлюємо з останнього бекапу
        if ($autoRestore) {
            $FilesInSource = Get-ChildItem -Path $Source -File
            if ($FilesInSource.Count -lt $minFilesForRestore) {
                # Якщо відновлення було успішно, пропускаємо бекап
                $restoreSuccess = Restore-Backup -Iteration $Iteration -Source $Source -BackupRoot $BackupRoot -RestoreRoot $RestoreRoot
                if ($restoreSuccess) {
                    continue
                }
            }
        }

        # Викликаємо функцію для створення бекапу
        Create-Backup -Iteration $Iteration -MaxBackups $MaxBackups -Source $Source -BackupRoot $BackupRoot -ExcludedFolders $ExcludedFolders

        # Оновлюємо ітерацію в файлі та конфігурації
        $Iteration++
        Set-Content -Path $iterationFilePath -Value $Iteration

        # Оновлюємо конфігурацію
        $config["Iteration"] = $Iteration.ToString()
        Save-Config $config

    }
    catch {
        Write-Error "Error during backup iteration $Iteration."
    }

    # Чекаємо задану кількість секунд (за замовчуванням 5 хвилин)
    Start-Sleep -Seconds $BackupDelayBetweenIterations
}
