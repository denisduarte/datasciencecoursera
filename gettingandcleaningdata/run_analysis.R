#Loading list of activites 
activities <- read.table("UCI HAR Dataset\\activity_labels.txt", col.names=c('Activity_Code', "Activity_Name"))

#Loading list of features
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("Feature_Code","Feature_Name"))

#Replacing feature names with more descriptive labels
features$Feature_Name <- gsub("^t", "Time_", features$Feature_Name)
features$Feature_Name <- gsub("^f", "Frequency_", features$Feature_Name)
features$Feature_Name <- gsub("^angle", "Angle_", features$Feature_Name)
features$Feature_Name <- gsub("Acc", "Acceleration", features$Feature_Name)
features$Feature_Name <- gsub("Gyro", "Gyroscope", features$Feature_Name)
features$Feature_Name <- gsub("mean\\(\\)", "Mean", features$Feature_Name)
features$Feature_Name <- gsub("std\\(\\)", "SD", features$Feature_Name)
features$Feature_Name <- gsub("-meanFreq\\(\\)", "MeanFrequency", features$Feature_Name)

#Loading Train data
train_x <- read.table("UCI HAR Dataset\\train\\X_train.txt", col.names=features$Feature_Name)
train_y <- read.table("UCI HAR Dataset\\train\\y_train.txt", col.names=c("Activity_Code"))
train_subject <- read.table("UCI HAR Dataset\\train\\subject_train.txt", col.names=c("Subject"))

#Loading Test data
test_x <- read.table("UCI HAR Dataset\\test\\X_test.txt", col.names=features$Feature_Name)
test_y <- read.table("UCI HAR Dataset\\test\\y_test.txt", col.names=c("Activity_Code"))
test_subject <- read.table("UCI HAR Dataset\\test\\subject_test.txt", col.names=c("Subject"))

#Merging X, Y and Subject from Train and Test datasets
merged_x <- rbind(train_x, test_x)
merged_y <- rbind(train_y, test_y) 
merged_subject <- rbind(train_subject, test_subject)

#Creating final data_set in 3 steps:
#  1- combine X, Y and Subjects in a single dataset 
#  2- append column with activity name
#  3- remove from X data columns not related to mean or standart deviation
merged_data <- cbind(merged_subject, merged_y, merged_x) %>%
               merge(activities, by="Activity_Code", sort=FALSE)  %>%
               select(Subject, Activity_Code, Activity_Name, contains("Mean"), contains("SD"))


#Creating another dataset with the mean for each variable from X dataset group by Subject and Activity
tidyDataset <- merged_data %>% group_by(Subject, Activity_Name) %>% summarise_all(list(mean))

#Saving dataset to text file
write.table(tidyDataset, "tidyDataset.txt", row.name=FALSE)
