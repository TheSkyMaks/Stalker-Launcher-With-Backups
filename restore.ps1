# restore.ps1

# Завантажуємо конфігурацію
. .\configuration.ps1
. .\backupFunctions.ps1
. .\restoreFunctions.ps1

# Виконання відновлення
$Iteration = 1  # Можна додати перевірку ітерації, якщо це необхідно
Restore-Backup -Iteration $Iteration -Source $Source -BackupRoot $BackupRoot -RestoreRoot $RestoreRoot
