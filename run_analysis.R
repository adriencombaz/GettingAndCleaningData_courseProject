rm(list = ls())
dataDir <- file.path("/home/adrien/Work/Data/mooc/data-scientist-specialization/assignment-data/03-Getting-and-Cleaning-Data/GettingAndCleaningData_courseProject/"
                     , "UCI HAR Dataset")

#=======================================================================================================
# Merges the training and the test sets to create one data set
#=======================================================================================================
featList        <- read.table( file.path( dataDir, "features.txt" ), col.names = c("number", "desc") )
xTrain          <- read.table( file.path( dataDir, "train", "X_train.txt" ) )
xTest           <- read.table( file.path( dataDir, "test", "X_test.txt" ) )
yTrain          <- read.table( file.path( dataDir, "train", "y_train.txt" ) )
yTest           <- read.table( file.path( dataDir, "test", "y_test.txt" ) )
subTrain        <- read.table( file.path( dataDir, "train", "subject_train.txt" ) )
subTest         <- read.table( file.path( dataDir, "test", "subject_test.txt" ) )
data            <- cbind( rbind(xTrain, xTest), rbind(subTrain, subTest), rbind(yTrain, yTest) )
colnames(data)  <- c(as.character(featList$desc), "subjectID", "activityID")

#=======================================================================================================
# Extracts only the measurements on the mean and standard deviation for each measurement
#=======================================================================================================
data <- cbind( data[, grep("mean\\(\\)|std\\(\\)", featList$desc)], data[, c("subjectID", "activityID")] )
str(data)

#=======================================================================================================
# Uses descriptive activity names to name the activities in the data set
#=======================================================================================================
activities      <- read.table( file.path( dataDir, "activity_labels.txt"), col.names=c("id", "activityLabel") )
data            <- merge(data, activities, by.x="activityID", by.y="id")
data$activityID <- NULL # no need for it anymore (redundant with "acivityID")

#=======================================================================================================
# Appropriately labels the data set with descriptive variable names
#=======================================================================================================
names(data) <- gsub("\\(\\)", "", names(data))
names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))
str(data) 

#=======================================================================================================
# From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject
#=======================================================================================================
data2 <- aggregate(. ~ subjectID + activityLabel, data=data, mean)

# Write the resulting data set in a text file
write.table( data2,  file.path( dataDir, "tidy_data.txt" ), row.name=FALSE )


