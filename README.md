==================================================================
Getting and Cleaning Data - Course Project
Version 1.0
==================================================================

The course requires us to prepare a tidy data set from the raw data provided to us. The purpose of this project is to demonstrate our ability to collect, 
work with, and clean a data set.

This repository hosts the R script, code book, and related files for the course project of Data Science's course "Getting and Cleaning data".

About the dataset:
==================

The dataset being used is: Human Activity Recognition Using Smartphones (getdata-projectfiles-UCI HAR Dataset.zip)

The key activities to be performed on the dataset are:
======================================================

1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names.
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.


The repository includes the following files:
============================================

- run_analysis.R: contains the code to perform the analyses described in the five steps above. They can be launched in RStudio by just importing the file.

- CodeBook.md: describes the variables, the data, and any transformations work that was performed to clean up the data.

- tidy_data.txt: it is the final tidy data set - output of Step 5.

Creating the tidy data set: 
===========================

1. Navigate to your working directory.
2. Unzip compressed raw data (getdata-projectfiles-UCI HAR Dataset.zip) in your working directory. The working directory should have the folder 'UCI HAR Dataset' 
   containing the raw data.
3. You need 'plyr' package to run the script successfully. If the package is not available, do the following steps:
	- run: install.packages("plyr")
	- run: library(plyr)
4. Source run_analysis.R: source('run_analysis.R')
5. The script will generate the final tidy data set 'tidy_data.txt'. You will find this file in the working directory.

Assumption: 
===========
- The run_analysis script assumes that all the data is present in the working directory, un-compressed, and names un-altered.
