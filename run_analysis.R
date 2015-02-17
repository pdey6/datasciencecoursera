## Clean workspace and change working directory
rm(list=ls())
library(plyr)

## Part 1 start
## 1.Merge the training and the test sets to create one data set.
  
  ## Let us read all the 'train' and 'test' files first
  subjectTrain  <-  read.table(".\\UCI HAR Dataset\\train\\subject_train.txt", header=FALSE)
  xTrain        <-  read.table(".\\UCI HAR Dataset\\train\\X_train.txt", header=FALSE)
  yTrain        <-  read.table(".\\UCI HAR Dataset\\train\\y_train.txt", header=FALSE)
  subjectTest   <-  read.table(".\\UCI HAR Dataset\\test\\subject_test.txt", header=FALSE)
  xTest         <-  read.table(".\\UCI HAR Dataset\\test\\X_test.txt", header=FALSE)
  yTest         <-  read.table(".\\UCI HAR Dataset\\test\\y_test.txt", header=FALSE)

  ## Now merge the 'train', 'test', and 'subject' data
  xData         <-  rbind(xTrain, xTest)
  yData         <-  rbind(yTrain, yTest)
  subjectData   <-  rbind(subjectTrain, subjectTest)
  
## Part 1 end

## Part 2 start
## 2. Extract only the measurements on the mean and standard deviation for each measurement.
  
  features      <-  read.table(".\\UCI HAR Dataset\\features.txt", header=FALSE) ## features contains 561 variables
  activityType  <-  read.table(".\\UCI HAR Dataset\\activity_labels.txt", header=FALSE) ## activityType contains 6 variables

  ## From the features, we need to extract only those variables that contain 'mean' and 'std'
  ## So let us first search for 'mean' and 'std' from features using grep
  
  meanFeatures <- grep("-(mean)\\(\\)", features[, 2])
  stdFeatures <- grep("-(std)\\(\\)", features[, 2])
  meanstdfeatures <- rbind(meanFeatures, stdFeatures)

  ## subset xData by 'mean' and 'std' features.   
  xData   <-  xData[, meanstdfeatures]
  
  ## Assign column names to xData from mean_and_std_features
  names(xData)  <-  features[meanstdfeatures, 2]

## Part 2 end

## Part 3 start
## 3. Use descriptive activity names to name the activities in the data set

  ## Original yData has values (or activity types) 1-6. 
  ## We need to substitute this by actual activity name. E.g. 1=Walking; 5=Standing
  
  yData[, 1]          <-  activityType[yData[, 1], 2]

## Part 3 end

## Part 4 begin
## 4. Appropriately label the data set with descriptive variable names.

    ## Assign yData column name "activity"
    names(yData)        <-  "activity"

    ## Assign subjectData column name "subject"
    names(subjectData)  <-  "subject"

## Now combine all the data sets
finalTidyData <- cbind(xData, yData, subjectData)

## 5. From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

tidyData <- ddply(finalTidyData, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(tidyData, "tidy_data.txt", row.name=FALSE)
View(tidyData)

