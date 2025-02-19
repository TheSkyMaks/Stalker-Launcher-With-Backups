# S.T.A.L.K.E.R. Launcher with Save Backuping

## English Version

### Overview

This PowerShell project provides an automated system for managing game save backups and restores.  
It ensures that your progress is safely stored and can be recovered in case of accidental loss.  
The script can also launch the game directly, making the entire process seamless.

### 📌 Features

- **Automated Backups** – Regularly saves game progress at set intervals.
- **Auto-Restore** – Detects missing save files and restores them from the last backup.
- **Custom Configuration** – Easily configurable paths for game, saves, and backups.
- **Logging** – All operations are logged for troubleshooting.

### 🛠 Requirements

- PowerShell (Recommended version: 7.x or higher)
- Windows OS
- Any **S.T.A.L.K.E.R.** version, including **Anomaly/GAMMA**

### 🚀 How to Use

1. **Download or copy the project files** to your PC.
2. **Edit `config.txt`** to match your S.T.A.L.K.E.R. installation.
3. **Run `launch.ps1`** to activate automatic backups and restores.

If you encounter any issues, check the log file located in the root folder of the project.

### 📁 Configuration (`config.txt`)

This file contains key parameters for backup and restore functionality.

#### Example:

```ini
Source=G:\Steam\steamapps\common\Stalker Call of Pripyat\_appdata_\savedgames
autoRestore=True
Iteration=1
MaxBackups=5
Launcher=G:\Steam\steamapps\common\Stalker Call of Pripyat\Stalker-COP.exe
BackupDelayBetweenIterations=300
```

- `Source` – Path to the save game folder.
- `Launcher` – Path to the game's `.exe` file.
- `MaxBackups` – Number of backups to retain.
- `autoRestore` – Enables/disables automatic restoration of missing save files.
- `BackupDelayBetweenIterations` – Time interval (in seconds) between backups.

### Compatible with Modded Versions

This system is designed for **both original and modified S.T.A.L.K.E.R. versions**, such as **Anomaly/GAMMA**.

#### Example for GAMMA:

```ini
Source=G:\Anomaly\appdata\savedgames
Launcher=G:\GAMMA\.Groks Modpack Installer\G.A.M.M.A. Launcher.exe
```


---

## Українська версія

### Огляд

Цей PowerShell-проєкт автоматизує резервне копіювання та відновлення збережень гри.  
Він гарантує, що ваш прогрес надійно збережено і його можна відновити у разі втрати.  
Скрипт також дозволяє запускати гру безпосередньо, роблячи процес максимально зручним.

### 📌 Можливості

- **Автоматичні бекапи** – Регулярне збереження ігрового прогресу з заданими інтервалами.
- **Автоматичне відновлення** – Визначає відсутні файли сейвів і відновлює їх з останнього бекапу.
- **Гнучке налаштування** – Легко редаговані шляхи для гри, сейвів та резервних копій.
- **Логування** – Всі операції записуються у файл для усунення можливих проблем.

### 🛠 Вимоги

- PowerShell (рекомендована версія: 7.x або вище)
- Windows OS
- Будь-яка версія **S.T.A.L.K.E.R.**, включаючи **Anomaly/GAMMA**

### 🚀 Як використовувати

1. **Завантажте або скопіюйте файли проєкту** на свій ПК.
2. **Відредагуйте `config.txt`** відповідно до вашої версії S.T.A.L.K.E.R.
3. **Запустіть `launch.ps1`**, щоб активувати автоматичне резервне копіювання та відновлення.

У разі проблем перевірте лог-файл, який знаходиться у кореневій папці проєкту.

### 📁 Налаштування (`config.txt`)

Файл містить основні параметри для резервного копіювання та відновлення.

#### Приклад:

```ini
Source=G:\Steam\steamapps\common\Stalker Call of Pripyat\_appdata_\savedgames
autoRestore=True
Iteration=1
MaxBackups=5
Launcher=G:\Steam\steamapps\common\Stalker Call of Pripyat\Stalker-COP.exe
BackupDelayBetweenIterations=300
```


- **Source** – Шлях до папки збережень гри.
- **Launcher** – Шлях до `.exe` файлу гри.
- **MaxBackups** – Кількість резервних копій, що зберігаються.
- **autoRestore** – Вмикає/вимикає автоматичне відновлення при відсутності сейвів.
- **BackupDelayBetweenIterations** – Часовий інтервал (у секундах) між резервними копіями.

### Сумісність із модифікованими версіями

Система підтримує **як оригінальні версії S.T.A.L.K.E.R., так і модифіковані (Anomaly/GAMMA)**.

#### Приклад для GAMMA:

```ini
Source=G:\Anomaly\appdata\savedgames
Launcher=G:\GAMMA\.Groks Modpack Installer\G.A.M.M.A. Launcher.exe
```