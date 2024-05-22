#param (
#    [string]$folderPath
#)

# Prepare the output CSV file
$folderPath = "C:\Users\barri\file-scrub-test\sample"

# Define the file extensions to look for
$fileExtensions = @('*.txt', '*.csv', '*.zip')

# Prepare the output CSV file
$outputFile = "file_inspection_report.csv"

# Initialize a list to hold the file details
$fileDetails = New-Object System.Collections.Generic.List[PSObject]

# Function to get file details
function Get-FileDetails {
    param (
        [string]$file
    )
    $fileInfo = Get-Item $file
    $details = [PSCustomObject]@{
        'File Name'     = $fileInfo.Name
        'File Type'     = $fileInfo.Extension
        'Location'      = $fileInfo.DirectoryName
        'Created Date'  = $fileInfo.CreationTime.ToString("yyyy-MM-dd HH:mm:ss")
        'Modified Date' = $fileInfo.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
    }
    Write-Output "Adding file details: $($details | Format-Table | Out-String)"
    $fileDetails.Add($details)
}

# Recursively search for files
foreach ($extension in $fileExtensions) {
    $files = Get-ChildItem -Path $folderPath -Recurse -Filter $extension -File
    foreach ($file in $files) {
        Write-Output "Processing file: $($file.FullName)"
        Get-FileDetails -file $file.FullName
    }
}

# Check if any file details were collected
if ($fileDetails.Count -gt 0) {
    # Export the file details to a CSV
    $fileDetails | Export-Csv -Path $outputFile -NoTypeInformation
    Write-Output "File inspection completed. Report saved as $outputFile"
} else {
    Write-Output "No files found matching the specified extensions."
}

# Example usage
# .\inspect_files.ps1 -folderPath "C:\path\to\your\folder"
