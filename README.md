The files contained in this repo allow the user to read the UCI HAR Dataset and 
create a tidy summary of the original data set.

## Contents
The repo contains the following files:
*readUciHarData.R
*run_analysis.R
*CodeBook.md
*README.md

## Scripts
1. The function "readUciHarData.R" requires that the UCI HAR Dataset is unzipped in the working directory, 
if not, it exit and a reminder is printed. The function has no input and returns a list with two elements, i.e. "test" and "train" consisting of two data frames relative to the original data set.
Note that there are many path references in the script which may cause problems if run on a non-Linux 
operating system.


2. The script "run_analyis.R" requires that the UCI HAR Dataset is in the working directory and that in the workspace there are two data frames, named "dataTest" and "dataTrain", with the same column names relative to the "features" of the original dataset. Note that the function "readUciHarData.R" returns a 
suitable input for this script. The output is a tidy data set in which are summarized values of interest.
Note that there are a few path references in the script which may cause problems if run on a non-Linux 
operating system.

## Details
All the information relative to the input and output of the script "run_analysis.R" are contained in the 
file "CodeBook.md".
