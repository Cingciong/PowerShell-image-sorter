# What does it do?

A PowerShell script that scans directories for folders containing images.
The script should allow you to sort the images within each folder by their modification date.
If a folder corresponding to the modification date doesn't exist,
the script will automatically create one and then move the images into the correct folder.

# How to use it

Simply place the script in the folder you wish to sort. Keep in mind that the script will sort the entire folder, including all its subfolders.
When you're ready, open the terminal, navigate to the directory where the script is located, and type: './sort.ps1'.
You'll then be prompted to select the folder you'd like to sort.
If you want to exclude any folder from being sorted, just add "(not)" wherever to its name, and the script will skip sorting images in that folder.

# How does it work?

1. Define a Function to Check if the Directory Path Contains the String "(not)"
1.1 Define a function named Contains-NotString that takes a directory path as input.

1.2 This function checks if any part of the directory path contains the string "(not)".

1.3 If the path includes this string, the function returns True.

2. Define a Function to List All Directories in the Current Path (One Level Deep)
2.1 Define a function called List-Directories-And-Files.

2.2 Get all directories in the current path.

2.3 If no directories are found, print a message and exit.

2.4 For each directory, count the number of image files with extensions *.cr2 and *.jpg within it.

2.5 Print the directory name and the corresponding number of image files.

2.6 Return the list of directories.

3. Define a Function to Prompt the User to Select Directories by Number
3.1 Define a function named Select-Directories that takes an array of directories as input.

3.2 Prompt the user to choose directory numbers, allowing multiple selections separated by commas.

3.3 Split the input into an array of indices.

3.4 For each index, validate it and add the corresponding directory to the selected directories list.

3.5 Return the list of selected directories.

4. List All Directories and Their Files
4.1 Call List-Directories-And-Files to get the list of directories.

5. Prompt the User to Select Directories
5.1 Call Select-Directories with the list of directories to get the selected directories.

6. Process Each Selected Directory
6.1 For each selected directory, skip sorting if the directory name contains "(not)".

6.2 Check if there are any .cr2 or .jpg files in the directory.

6.3 If no photos are found, print a message and continue to the next directory.

7. Loop Through Each Photo in the Directory
7.1 Check if any part of the directory path contains "(not)". If true, skip moving the photo and print a message.

7.2 Extract the modification date from the photo metadata.

7.3 Check if a directory with the extracted date exists in the directory.

7.4 If not, create the directory.

7.5 Define the destination path for the photo.

7.6 Handle file name conflicts by appending a unique suffix.

7.7 Move the photo to the corresponding directory.

7.8 Print the directory where the photo was moved.
