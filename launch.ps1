# Завантажуємо конфігурацію
. .\configuration.ps1
. .\backupFunctions.ps1
. .\restoreFunctions.ps1

# Створюємо Windows Form
Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;

public class MyForm : Form
{
    public Button backupButton;
    public Button restoreButton;
    public Button playGameButton;
    public Label statusLabel;

    public MyForm()
    {
        this.Text = 'GAMMA Launcher with Backup';
        this.Size = new System.Drawing.Size(400, 300);

        // Створюємо кнопки
        backupButton = new Button();
        backupButton.Text = 'Backup';
        backupButton.Location = new System.Drawing.Point(30, 50);
        backupButton.Size = new System.Drawing.Size(120, 30);
        backupButton.Click += new EventHandler(BackupButton_Click);
        
        restoreButton = new Button();
        restoreButton.Text = 'Restore';
        restoreButton.Location = new System.Drawing.Point(30, 100);
        restoreButton.Size = new System.Drawing.Size(120, 30);
        restoreButton.Click += new EventHandler(RestoreButton_Click);
        
        playGameButton = new Button();
        playGameButton.Text = 'Play GAMMA';
        playGameButton.Location = new System.Drawing.Point(30, 150);
        playGameButton.Size = new System.Drawing.Size(120, 30);
        playGameButton.Click += new EventHandler(PlayGameButton_Click);
        
        statusLabel = new Label();
        statusLabel.Text = 'Ready';
        statusLabel.Location = new System.Drawing.Point(30, 200);
        statusLabel.Size = new System.Drawing.Size(300, 30);

        // Додаємо елементи на форму
        this.Controls.Add(backupButton);
        this.Controls.Add(restoreButton);
        this.Controls.Add(playGameButton);
        this.Controls.Add(statusLabel);
    }

    private void BackupButton_Click(object sender, EventArgs e)
    {
        statusLabel.Text = 'Starting Backup...';
        Create-Backup -Iteration $Iteration -MaxBackups $MaxBackups -Source $Source -BackupRoot $BackupRoot -ExcludedFolders $ExcludedFolders
        statusLabel.Text = 'Backup Completed';
    }

    private void RestoreButton_Click(object sender, EventArgs e)
    {
        statusLabel.Text = 'Starting Restore...';
        Restore-Backup -Iteration $Iteration -Source $Source -BackupRoot $BackupRoot -RestoreRoot $RestoreRoot
        statusLabel.Text = 'Restore Completed';
    }

    private void PlayGameButton_Click(object sender, EventArgs e)
    {
        statusLabel.Text = 'Launching GAMMA...';
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File .\main.ps1"
        statusLabel.Text = 'Game Started';
    }
}
"@

# Створюємо інтерфейс
$form = New-Object MyForm
$form.ShowDialog()
