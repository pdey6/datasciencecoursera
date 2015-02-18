==================================================================
Getting and Cleaning Data - Course Project
CodeBook.md
Version 1.0
==================================================================

1. Introduction:
==================

The course requires us to prepare a tidy data set from the raw data provided to us. The purpose of this project is to demonstrate our ability to collect,
work with, and clean a data set.

This repository hosts the R script, code book, and related files for the course project of Data Science's course "Getting and Cleaning data".

2. About the CodeBook:
==================
CodeBook.md describes the data, variables, and any transformations work that was performed to clean up the data.

3. Source dataset:
==================

The source dataset being used is: Human Activity Recognition Using Smartphones (getdata-projectfiles-UCI HAR Dataset.zip)
It is assumed that all the data is present in the working directory, un-compressed, and names un-altered.
After unzipping the raw compressed zip file, the working directory should have the folder 'UCI HAR Dataset'

	The following code is executed to download the raw data set:

		fileUrl <‐ "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
		download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

	Downloaded file is unzipped using
		unzip(zipfile="./data/Dataset.zip",exdir="./data")

	The files are unzipped in 'UCI HAR Dataset' folder
		path_rf <‐ file.path("./data" , "UCI HAR Dataset")


4. The key activities to be performed on the dataset are:
=========================================================

1. Merge the training and the test sets to create one data set
2. Extract only the measurements on the mean and standard deviation for each measurement
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject

The code from executing each of the above steps is explained in section 6 below.

5. Variables used in the run_analysis.R script:
=========================================================

1.  subjectTrain	contains the subject data from the downloaded file subject_train.txt
2.  xTrain		contains the x data from the downloaded file X_train.txt
3.  yTrain	 	contains the y data from the downloaded file y_train.txt
4.  subjectTest	 	contains the subject data from the downloaded file subject_test.txt
5.  xTest	 	contains the x test data from the downloaded file X_test.txt
6.  yTest		contains the y test data from the downloaded file y_test.txt
7.  xData		contains the merged xTrain & xTest data 					===== output of step 4.1 above
8.  yData		contains the merged yTrain & yTest data						===== output of step 4.1 above
9.  subjectData		contains the merged subjectTrain & subjectTest data				===== output of step 4.1 above
10. features		contains the features data from the downloaded file features.txt
11. activityType	contains the activity type data from the downloaded file activity_labels.txt
12. meanFeatures	contains only 'mean' measurements extracted from features data. This is a numeric vector.
13. stdFeatures		contains only 'standard deviation' measurements extracted from features data. This is a numeric vector.
14. meanstdfeatures	contains the merged 'meanFeatures' & 'stdFeatures'. This is a numeric vector.
15. finalTidyData	contains the column-binded xData, yData & subjectData
16. tidyData		contains the final tidy data							===== output of step 4.5 above


Refer Section 8 if you want to see the properties of each of the variables.

6. Explanation of the run_analysis.R script:
============================================

1. Merge the training and the test sets to create one data set
---------------------------------------------------------------

	- The variables subjectTrain, xTrain, yTrain, subjectTest, xTest, and yTest are populated from the respective files using read.table()
	- Subject, Train, and Test data are merged into a single data set. Following code is executed:
		xData         <-  rbind(xTrain, xTest)
  		yData         <-  rbind(yTrain, yTest)
  		subjectData   <-  rbind(subjectTrain, subjectTest)

2. Extract only the measurements on the mean and standard deviation for each measurement
----------------------------------------------------------------------------------------

	- The variable features	is populated from the respective features.txt file using read.table()	
	- From the features variable , I extracted only those variables that contain 'mean' and 'std'. This is accomplished using the grep() function as shown below:
		meanFeatures <- grep("-(mean)\\(\\)", features[, 2])
  		stdFeatures <- grep("-(std)\\(\\)", features[, 2])
	- Both meanFeatures & stdFeatures are numeric vectors
	- The mean and std features are then merged into a single data set using
		meanstdfeatures <- rbind(meanFeatures, stdFeatures)
	- Using meanstdfeatures, only data related mean and std observations are extracted from xData using
		xData   <-  xData[, meanstdfeatures]
	- Appropriate column names are then assigned using
		names(xData)  <-  features[meanstdfeatures, 2]

3. Use descriptive activity names to name the activities in the data set
-------------------------------------------------------------------------
		
	- Original yData has values (or activity types) in numbers 1-6. We need to substitute this by actual activity name. E.g. 1=Walking; 5=Standing
	- The variable activityType is populated from the respective activity_labels.txt file using read.table()
	- The following code assigns the right activity labels
		yData[, 1]          <-  activityType[yData[, 1], 2]

4. Appropriately label the data set with descriptive variable names
--------------------------------------------------------------------

	- Following code labels the data set with descriptive variable names
		names(yData)        <-  "activity"
		names(subjectData)  <-  "subject" 
	- I then created a final combined tidy data set through
		finalTidyData <- cbind(xData, yData, subjectData)

5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
-----------------------------------------------------------------------------------------------------------------------------------------------
	- I use the finalTidyData data set created in Step 4 above
	- Now as per the project instructions, we need to produce a second data set with the average (mean) of each variable for each activity and subject
	- I used ddply() function from package plyr. The reason I used this function is because it applies specified function, and splits data frames by variables.
	- The output returned from ddply() is a data frame. The function I provided as input to ddply() is colMeans()
	- Below is the final code. The output is stored in the variable tidyData
		tidyData <- ddply(finalTidyData, .(subject, activity), function(x) colMeans(x[, 1:66]))
	- tidyData is then written into a text file tidy_data.txt. As per the instructions, argument row.name = FALSE is passed
		write.table(tidyData, "tidy_data.txt", row.name=FALSE)
	- To view the final data set, View command is written
		View(tidyData)

7. Note:
============================================
	- The files in the Inertial Signals sub-folders are not used.


8. Properties of variables defined in Section 5 above:
======================================================

1. str(subjectTrain) 	- 	'data.frame':	7352 obs. of  1 variable
					$ V1: int  1 1 1 1 1 1 1 1 1 1 ...
2. str(xTrain)		-	'data.frame':	7352 obs. of  561 variables
					$ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
 					$ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
 					$ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
 					$ V4  : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
3. str(yTrain)		-	'data.frame':	7352 obs. of  1 variable
					$ V1: int  5 5 5 5 5 5 5 5 5 5 ...
4. str(subjectTest)	-	'data.frame':	2947 obs. of  1 variable
					$ V1: int  2 2 2 2 2 2 2 2 2 2 ...
5. str(xTest)		-	'data.frame':	2947 obs. of  561 variables
					$ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
 					$ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
 					$ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
 					$ V4  : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...
6. str(yTest)		-	'data.frame':	2947 obs. of  1 variable
					$ V1: int  5 5 5 5 5 5 5 5 5 5 ...
7. str(xData)		-	'data.frame':	10299 obs. of  561 variables
					$ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
 					$ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
					$ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
					$ V4  : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
8. str(yData)		-	'data.frame':	10299 obs. of  1 variable
					$ V1: int  5 5 5 5 5 5 5 5 5 5 ...
9. str(subjectData)	-	'data.frame':	10299 obs. of  1 variable
					$ V1: int  1 1 1 1 1 1 1 1 1 1 ...
10. str(features)	-	'data.frame':	561 obs. of  2 variables	
					$ V1: int  1 2 3 4 5 6 7 8 9 10 ...	
					$ V1: int  1 2 3 4 5 6 7 8 9 10 ...
11. str(activityType)	-	'data.frame':	6 obs. of  2 variables 
					$ V1: int  1 2 3 4 5 6 
					$ V2: Factor w/ 6 levels "LAYING","SITTING",..: 4 6 5 2 3 1
12. str(meanFeatures)	-	int [1:33] 1 2 3 41 42 43 81 82 83 121 ...
13. str(stdFeatures)	-	int [1:33] 4 5 6 44 45 46 84 85 86 124 ...
14. str(meanstdfeatures)-	int [1:2, 1:33] 1 4 2 5 3 6 41 44 42 45 ...
15. str(xData)		-	'data.frame':	10299 obs. of  66 variables
					$ tBodyAcc-mean()-X          : num  0.289 0.278 0.28 0.279 0.277 ...
 					$ tBodyAcc-std()-X           : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
					$ tBodyAcc-mean()-Y          : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
					$ tBodyAcc-std()-Y           : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
16. str(yData)		-	'data.frame':	10299 obs. of  1 variable
					$ V1: Factor w/ 6 levels "LAYING","SITTING",..: 3 3 3 3 3 3 3 3 3 3 ...
17. str(finalTidyData)	-	'data.frame':	10299 obs. of  68 variables
					$ tBodyAcc-mean()-X          : num  0.289 0.278 0.28 0.279 0.277 ...
 					$ tBodyAcc-std()-X           : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
 					$ tBodyAcc-mean()-Y          : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
 					$ tBodyAcc-std()-Y           : num  -0.983 -0.975 -0.967 -0.983 -0.981 ... 	
18.str(tidyData)	-	'data.frame':	180 obs. of  68 variable
					$ subject                    : int  1 1 1 1 1 1 2 2 2 2 ...
 					$ activity                   : Factor w/ 6 levels "LAYING","SITTING",..: 1 2 3 4 5 6 1 2 3 4 ...
 					$ tBodyAcc-mean()-X          : num  0.222 0.261 0.279 0.277 0.289 ...
 					$ tBodyAcc-std()-X           : num  -0.928 -0.977 -0.996 -0.284 0.03 ...
 					$ tBodyAcc-mean()-Y          : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
 					$ tBodyAcc-std()-Y           : num  -0.8368 -0.9226 -0.9732 0.1145 -0.0319 ...
19. names(tidyData)	-	
				[1] "subject"                     "activity"                    "tBodyAcc-mean()-X"          
 				[4] "tBodyAcc-std()-X"            "tBodyAcc-mean()-Y"           "tBodyAcc-std()-Y"           
 				[7] "tBodyAcc-mean()-Z"           "tBodyAcc-std()-Z"            "tGravityAcc-mean()-X"       
				[10] "tGravityAcc-std()-X"         "tGravityAcc-mean()-Y"        "tGravityAcc-std()-Y"        
				[13] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-Z"         "tBodyAccJerk-mean()-X"      
				[16] "tBodyAccJerk-std()-X"        "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-std()-Y"       
				[19] "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-Z"        "tBodyGyro-mean()-X"         
				[22] "tBodyGyro-std()-X"           "tBodyGyro-mean()-Y"          "tBodyGyro-std()-Y"          
				[25] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-Z"           "tBodyGyroJerk-mean()-X"     
				[28] "tBodyGyroJerk-std()-X"       "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-std()-Y"      
				[31] "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-Z"       "tBodyAccMag-mean()"         
				[34] "tBodyAccMag-std()"           "tGravityAccMag-mean()"       "tGravityAccMag-std()"       
				[37] "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"       "tBodyGyroMag-mean()"        
				[40] "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
				[43] "fBodyAcc-mean()-X"           "fBodyAcc-std()-X"            "fBodyAcc-mean()-Y"          
				[46] "fBodyAcc-std()-Y"            "fBodyAcc-mean()-Z"           "fBodyAcc-std()-Z"           
				[49] "fBodyAccJerk-mean()-X"       "fBodyAccJerk-std()-X"        "fBodyAccJerk-mean()-Y"      
				[52] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-Z"       
				[55] "fBodyGyro-mean()-X"          "fBodyGyro-std()-X"           "fBodyGyro-mean()-Y"         
				[58] "fBodyGyro-std()-Y"           "fBodyGyro-mean()-Z"          "fBodyGyro-std()-Z"          
				[61] "fBodyAccMag-mean()"          "fBodyAccMag-std()"           "fBodyBodyAccJerkMag-mean()" 
				[64] "fBodyBodyAccJerkMag-std()"   "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
				[67] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()" 



