library(plyr)

setwd("C:/Users/chink/Desktop/Data Science Material/R_workingdir")
if(!dir.exists("UCI HAR Dataset")){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "UCI_HAR_Dataset.zip")
  unzip("UCI_HAR_Dataset.zip")
}

## Reading dataset

test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")

## Reading subject

test_sub <- read.table("UCI HAR Dataset/test/subject_test.txt")
train_sub <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Reading Activity

test_activity <- read.table("UCI HAR Dataset/test/y_test.txt")
train_activity <- read.table("UCI HAR Dataset/train/y_train.txt")

## Reading features

feature_data <- read.table("UCI HAR Dataset/features.txt")

## Reading activity Lables

activity_lab <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_lab[,2] <-as.character(activity_lab[,2])


## Merging the realated data

sub_data <- rbind(test_sub,train_sub)
activity_data <- rbind(test_activity,train_activity)
data_merge <- rbind(test_data,train_data)

## Naming the columns

names(sub_data) <- c("subject")
names(activity_data)<- c("activity")
names(data_merge)<-feature_data$V2

## Merging of all data
merged_data <- cbind(data_merge,sub_data,activity_data)

##Searching for only mean() and std() measurements

feature_data_sub <- feature_data$V2[grep("mean\\(\\)|std\\(\\)",feature_data$V2)]
select_col <- c(as.character(feature_data_sub),"subject","activity")

## Now selecting the columns related to mean() and std()

data <- subset(merged_data,select=select_col)


# remove special characters and clean names

names(data) <- gsub("[\\(\\)-]","",names(data))
names(data) <- gsub("^t","timeDomain",names(data))
names(data) <- gsub("^f","frequencyDomain",names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("Freq", "Frequency", names(data))
names(data) <- gsub("mean", "Mean", names(data))
names(data) <- gsub("std", "StandardDeviation", names(data))

## adding labels and turning into factors
data$activity <- factor(data$activity,levels = activity_lab[,1],labels = activity_lab[,2])
data$subject <- as.factor(data$subject)

## Creating tidy dataset 


tidy_data<-aggregate(. ~subject + activity,data,mean)
tidy_data <- tidy_data[order(tidy_data$subject,tidy_data$activity),]
write.table(tidy_data,file = "tidy_data.txt",row.names = FALSE)
