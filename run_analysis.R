#Getting and Cleaning dAta: Course Project

#Download the zip file and load the datasets

path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")


features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Combine datasets

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

mergeddata <- cbind(subject, y, x)

#Clean data

library(dplyr)

cleand <- mergeddata %>% select(subject, code, contains("mean"), contains("std"))
cleand$code <- activities[cleand$code, 2]

names(cleand)[2] =  "activity"
names(cleand) <-gsub("Acc", "Accelerometer", names(cleand))
names(cleand) <-gsub("Gyro", "Gyroscope", names(cleand))
names(cleand) <-gsub("BodyBody", "Body", names(cleand))
names(cleand) <-gsub("Mag", "Magnitude", names(cleand))
names(cleand) <-gsub("^t", "Time", names(cleand))
names(cleand) <-gsub("^f", "Frequency", names(cleand))
names(cleand) <-gsub("tBody", "TimeBody", names(cleand))
names(cleand) <-gsub("-mean()", "Mean", names(cleand), ignore.case = TRUE)
names(cleand) <-gsub("-std()", "STD", names(cleand), ignore.case = TRUE)
names(cleand) <-gsub("-freq()", "Frequency", names(cleand), ignore.case = TRUE)
names(cleand) <-gsub("angle", "Angle", names(cleand))
names(cleand) <-gsub("gravity", "Gravity", names(cleand))

#Final cleaned and tidy data

ctdata <- cleand %>%
          group_by(subject, activity) %>%
          summarise_all(funs(mean))
write.table(ctdata, "ctdata.txt", row.name=FALSE)

