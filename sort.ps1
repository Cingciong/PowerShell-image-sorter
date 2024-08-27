function Contains-NotString {
    param (
        [string]$path
    )
    return $path -match "\(not\)"
}

function List-Directories-And-Files {
    $dirs = Get-ChildItem -Path . -Directory
    if (-not $dirs) {
        Write-Host "No directories found in the current path."
        exit 0
    }

    $i = 0
    foreach ($dir in $dirs) {
        $i++
        $fileCount = (Get-ChildItem -Path $dir.FullName -Recurse -Include *.cr2, *.jpg | Measure-Object).Count
        Write-Host "$i`: $($dir.FullName) - $fileCount image(s)"
    }
    return $dirs
}

function Select-Directories {
    param (
        [array]$dirs
    )
    $selectedIndices = Read-Host "Choose directory numbers (comma-separated)"
    $selectedIndices = $selectedIndices -split ","
    $selectedDirs = @()

    foreach ($index in $selectedIndices) {
        $index = [int]$index.Trim()
        if ($index -lt 1 -or $index -gt $dirs.Length) {
            Write-Host "Invalid selection: $index. Skipping."
            continue
        }
        $selectedDirs += $dirs[$index - 1].FullName
    }
    return $selectedDirs
}

# List all directories and their files
$dirs = List-Directories-And-Files

# Prompt user to select directories
$selectedDirs = Select-Directories -dirs $dirs

foreach ($selectedDir in $selectedDirs) {
    # Skip sorting if the directory name contains "(not)"
    if ($selectedDir -match "\(not\)") {
        Write-Host "Skipping sorting for directory: $selectedDir"
        continue
    }

    # Check if there are any .cr2 or .jpg files in the directory using Measure-Object
    $photoCount = (Get-ChildItem -Path $selectedDir -Recurse -Include *.cr2, *.jpg | Measure-Object).Count
    if ($photoCount -eq 0) {
        Write-Host "There are no photos in the directory: $selectedDir"
        continue
    }

    # Loop through each photo
    $photos = Get-ChildItem -Path $selectedDir -Recurse -Include *.cr2, *.jpg -File
    foreach ($photo in $photos) {
        # Check if any part of the directory path contains "(not)"
        if (Contains-NotString -path $photo.FullName) {
            Write-Host "Skipping moving for photo: $($photo.FullName) because it contains '(not)' in the path"
            continue
        }

        # Extract the modification date from the photo metadata
        $photoDate = (Get-Item $photo.FullName).LastWriteTime.ToString("yyyy-MM-dd")

        # Check if the directory with the extracted date exists in the directory
        $targetPath = Join-Path -Path $selectedDir -ChildPath $photoDate
        if (-not (Test-Path -Path $targetPath)) {
            # Create the directory if it does not exist
            New-Item -ItemType Directory -Path $targetPath | Out-Null
        }

        # Define the destination path
        $destinationPath = Join-Path -Path $targetPath -ChildPath $photo.Name

        # Handle file name conflicts by appending a unique suffix
        $counter = 1
        while (Test-Path -Path $destinationPath) {
            $destinationPath = Join-Path -Path $targetPath -ChildPath ("{0}_{1}{2}" -f [System.IO.Path]::GetFileNameWithoutExtension($photo.Name), $counter, [System.IO.Path]::GetExtension($photo.Name))
            $counter++
        }

        # Move the photo to the corresponding directory
        Move-Item -Path $photo.FullName -Destination $destinationPath

        # Echo the directory where the photo was moved
        Write-Host "Moved $($photo.FullName) to $destinationPath"
    }
}