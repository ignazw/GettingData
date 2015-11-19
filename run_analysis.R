## analysis.R; assignment for Getting and Cleaning Data
##
## Raw data:
##         Activities: y_test.txt (category values: 1:6)
##         Individuals: subject_test.txt (values 1:30)
##         Measurements: X_test.txt
##         Features: features.txt
##         Activities: activity_labels.txt
##
## Two sets, test and training data, which should be merged
## Using unix wc -l on these files we find the number of records:
##         test set: 2947 values
##         training set: 7352 values
##         total (merged) set: 10299 values
##
## Tidy data requirements:
##         observations in rows
##         variables in columns
##
## Output is grouped by subject and by activity:
##
##        Subject  Activity  Avg_X  Avg_Y  Avg_Z  Std_X  Std_Y  Std_Z  ...
##              1  WALKING     ...    ...    ...    ...    ...    ...  ...
##              1  UPSTAIRS    ...    ...    ...    ...    ...    ...  ...
##            ...  ...         ...    ...    ...    ...    ...    ...  ...
##              2  WALKING     ...    ...    ...    ...    ...    ...  ...
##            ...  ...         ...    ...    ...    ...    ...    ...  ...
##             30  LAYING      ...    ...    ...    ...    ...    ...  ...
## There are 30 individuals (subjects) and 6 activities, so a total of 180 lines output
##
## Read the data
##
features <- read.table("features.txt", header=FALSE)
activityLabels <- read.table("activity_labels.txt, header=FALSE")
##
subjectTest <- read.table("test/subject_test.txt", header=FALSE)
subjectTrain <- read.table("train/subject_train.txt", header=FALSE)
activitiesTest <- read.table("test/y_test.txt", header=FALSE)
activitiesTrain <- read.table("train/y_train.txt", header=FALSE)
measurementsTest <- read.table("test/X_test.txt", header=FALSE)
measurementsTrain <- read.table("train/X_train.txt", header=FALSE)
##
## Merge the test and training sets, and use the feature vector to set the column names
## on the measurements
##
subjects <- rbind(subjectTest,subjectTrain)
colnames(subjects) <- c("Subject")
activities <- rbind(activitiesTest,activitiesTrain)
colnames(activities) <- c("Activity")
measurements <- rbind(measurementsTest,measurementsTrain)
colnames(measurements) <- features$V2
##
## Add the subject and activity vectors as the first two columns in the measurements data set,
## but only keep measurements that indicate a mean or a standard deviatian.
## Such measurements have column names with "mean" or "std"
##
tmpFrame <- subset.data.frame(measurements, select = grep("mean|std",features$V2))
measurementFrame <- cbind(subjects,activities,tmpFrame)
##
## We average over the measurements per subject and per activity,
## and we store the results in a new data frame
##
## First define the factors holding the categories to average over
##
subjectFactor <- as.factor(measurementFrame$Subject)
activityFactor <- as.factor(measurementFrame$Activity)
groupBy <- list(activityFactor,subjectFactor)
##
## Next split the data frame into subframes holding only the data to average over
##
splitFrame <- split(subset(measurementFrame),groupBy)
nFrames <- length(splitFrame)
summaryFrame <- sapply(splitFrame[[1]], mean)
for (i in 2:nFrames) {
  summaryFrame <- rbind(summaryFrame, sapply(splitFrame[[i]], mean))
}
## Instead of values 1,2, ..., 6 for the activities, we use the descriptive
## names WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
##
sFrame <- as.data.frame(summaryFrame,row.names = NULL)
activities <- sFrame$Activity
activities <- replace(activities,activities==1,"WALKING")
activities <- replace(activities,activities==2,"WALKING_UPSTAIRS")
activities <- replace(activities,activities==3,"WALKING_DOWNSTAIRS")
activities <- replace(activities,activities==4,"SITTING")
activities <- replace(activities,activities==5,"STANDING")
activities <- replace(activities,activities==6,"LAYING")
sFrame$Activity <- activities
##
## Now write the tidy output data to file
##
write.table(sFrame, file="tidyData.txt", row.names = FALSE)



