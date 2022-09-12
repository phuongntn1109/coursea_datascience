###This code conducts the necessary R work to generate the course project for
###the Gettinga and Cleaning Data Coursera class

setwd("C:/Coursea/Getting and Cleaning Data")

#import headers, table keys, etc
header <- read.table("C:/Coursea/Getting and Cleaning Data/UCI HAR Dataset/features.txt",
                     stringsAsFactors = FALSE)
header <- header[,-1]
activity_labels <- read.table("C:/Coursea/Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt")

#import test data
test <- read.table("C:/Coursea/Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt",
                   header = FALSE,col.names =header)
test$Group <- "Test"
activity_test <- read.table("C:/Coursea/Getting and Cleaning Data/UCI HAR Dataset/test/y_test.txt",
                   header = FALSE)
activity_test <- activity_test[,1]
test$activity_key <- activity_test
subject_key <- read.table("C:/Coursea/Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt",
                            header = FALSE)
subject_key <- subject_key[,1]
test$subject_key <- subject_key

#import train data
train <- read.table("C:/Coursea/Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt",
                   header = FALSE,col.names =header)
train$Group <- "train"
activity_train <- read.table("C:/Coursea/Getting and Cleaning Data/UCI HAR Dataset/train/y_train.txt",
                            header = FALSE)
activity_train <- activity_train[,1]
#makes it into a vector from a dataframe
train$activity_key <- activity_train
subject_key_train <- read.table("C:/Coursea/Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt",
                          header = FALSE)
#makes it into a vector from a dataframe
subject_key_train <- subject_key_train[,1]
train$subject_key <- subject_key_train

#Join test/train and use lookup tables on key values
data <-rbind(train,test)
data <- merge(x = data,y = activity_labels,by.x="activity_key",by.y="V1", all.x=TRUE)
#extract columns which have "std" or "mean"
library(base)
keep <- apply(cbind(grepl("std",header[1:50]), grepl("mean",header[1:50])),1,any)
##keep only "mean" and "std" columns
data_red <- data[,keep]
#add back last three columns from dataset which are group, activity, and subject
data_red <- cbind(data[,563:565],data_red)
colnames(data_red)[3] <- "activity_label"

###Summarizes data by activity and subject
library(doBy)
avg <- summaryBy(. ~ subject_key + activity_label, data = data_red[,-c(1,4)], FUN = mean)

#output avg
avg