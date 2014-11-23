RunAnalysis
===========

The data for the project is from this URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Before using the run_analysis.R file, you need to download the above zip file, decompress the file, and have the run_analysis.R file and the unzipped package in the same folder.
The run_analysis.R does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## 1. Merge training and test sets to create one data set.

First, I read in the feature data for naming the train and test data set and the activity names data for naming the activity set.

    ## Import feature
    features <- read.table("UCI HAR Dataset/features.txt")
    ## Import descriptive activity names
    activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityID", "activityName"))

Then I import the train data set and the test data set with column names, and merge the two raw data set together. Also, the activity label and subject data set are imported and merged.

    ## Import train set
    trainSet <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$V2)
    ## Import test set
    testSet <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$V2)
    ## Merges the training and the test sets to create one data set
    dataSet <- rbind(testSet, trainSet)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

First, I write a regular expression to identify whether the features are either std or mean via grep function.

    extractFeatures <- features[grep("(mean|std)\\()", features$V2),]

Then I filter the raw data set by the extracted features.

    filterdDataSet <- dataSet[,extractFeatures$V1]

## 3. Uses descriptive activity names to name the activities in the data set.

I use merge function to merge the activity data set and activity labels name as they have a same column name called "activityID", and I set the param sort as FALSE so that the order of activity data set will not change.

    activityIDNameSet <- merge(activityIDSet, activityLabels, sort = FALSE)

## 4. Appropriately label the data set with descriptive variable names.

In this step, I add the a column activityNamethe and a column subject to the filteredDataSet.

    filterdDataSet$activityName <- as.character(activityIDNameSet$activityName)
    filterdDataSet$subject <- subjectSet$subject
    
All the variables have their own name because when the data is imported the data set is labeled.

##5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In this step, I use the melt function to collapse the filteredDataSet dataframe and then use the dcast function to collapse the meltData into a new collapsed and tidy data frame.

    library(reshape2)
    # create the molten data set
    meltDataSet <- melt(filterdDataSet,id.vars = c("subject", "activityName"))
    # cast the molten data set into a collapsed tidy dataset
    tidy <- dcast(meltDataSet, subject + activityName ~ variable, mean)
    # write the dataset to a file
    write.table(tidy, "tidydataset.txt", row.name = FALSE, sep="\t")
