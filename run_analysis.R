## Import feature
features <- read.table("UCI HAR Dataset/features.txt")
## Import descriptive activity names
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityID", "activityName"))

## Import train set
trainSet <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$V2)
## Import test set
testSet <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$V2)
## Merges the training and the test sets to create one data set
dataSet <- rbind(testSet, trainSet)

## Import train labels
trainActivityID <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = c("activityID"))
## Import test labels
testActivityID <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = c("activityID"))
## Merges the train labels and the test labels
activityIDSet <- rbind(trainActivityID, testActivityID)

## Imports train subject
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("subject"))
## Imports test subject
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("subject"))
## Merges the train subject and the test subject
subjectSet <- rbind(trainSubject, testSubject)


## Extracts only the measurements on the mean and standard deviation for each measurement.
extractFeatures <- features[grep("(mean|std)\\()", features$V2),]
filterdDataSet <- dataSet[,extractFeatures$V1]

## Uses descriptive activity names to name the activities in the data set
activityIDNameSet <- merge(activityIDSet, activityLabels, sort = FALSE)
## Appropriately labels the data set with descriptive variable names
filterdDataSet$activityName <- as.character(activityIDNameSet$activityName)
filterdDataSet$subject <- subjectSet$subject
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(reshape2)
# create the molten data set
meltDataSet <- melt(filterdDataSet,id.vars = c("subject", "activityName"))
# cast the molten data set into a collapsed tidy dataset
tidy <- dcast(meltDataSet, subject + activityName ~ variable, mean)
# write the dataset to a file
write.table(tidy, "tidydataset.txt", row.name = FALSE, sep="\t")
