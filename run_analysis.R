library(reshape2)

filename <- "getdata_projectfiles_UCI HAR Dataset.zip"

#To download and unzip the dataset if it's not already downloaded in the directory
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

#To load activity labels and features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#To extract only the required data on mean and standard deviation
reqfeatures <- grep(".*mean.*|.*std.*", features[,2])
reqfeatures.names <- features[reqfeatures,2]
reqfeatures.names = gsub('-mean', 'Mean', reqfeatures.names)
reqfeatures.names = gsub('-std', 'Std', reqfeatures.names)
reqfeatures.names <- gsub('[-()]', '', reqfeatures.names)


#To load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[reqfeatures]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[reqfeatures]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

#To merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", reqfeatures.names)

#To turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

#To create the required tidy.txt file
write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
