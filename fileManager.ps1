# fileManager.ps1

# Load scripts
. .\configuration.ps1
. .\logger.ps1

# Function to copy files from source to destination
function Copy-Files {
    param (
        [string]$SourceFolder,
        [string]$DestinationFolder
    )

    $sourceItems = Get-ChildItem -Path $SourceFolder -File
    Write-LogMessage "Found $($sourceItems.Count) files in folder $SourceFolder. Moving current files to the folder $DestinationFolder"

    # Move current files to the old folder, excluding certain folders
    $sourceItems | ForEach-Object {
        $SourceFolder = $_.FullName

        # Copy files from source to destination using file manager function
        Get-ChildItem -Path $SourceFolder -File | ForEach-Object {
            $SourceFile = $_.FullName
            $DestinationFile = Join-Path -Path $DestinationFolder -ChildPath $_.Name
            Write-LogMessage "Copying file: $SourceFile to $DestinationFile"
            Copy-Item -Path $SourceFile -Destination $DestinationFile -Force
        }
    } 
}
