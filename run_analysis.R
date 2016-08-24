###########################################################################################
# NOTE: This code needs the packages RCurl, dplyr. 
# Please install them before runing it
# install.packages("RCurl")
# install.packages("dplyr")
###########################################################################################

library(RCurl)
library(dplyr)

URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile = "./data/UCI HAR Dataset.zip"
# Download and unzip the files
if(!file.exists(zipFile)) {
    print("File doesn´t exist. It will be downloaded.")
    download.file(URL, zipFile)
    outDir <- "./data"
    unzip(zipFile,exdir=outDir)
} else print("File already exists. Nothing was downloaded.")


# Read into a vector the file with the names of the columns.
colNames <- read.table("./data/UCI HAR Dataset/features.txt")
colNames <- select (colNames, V2)
colNames <- as.vector(t(colNames))

# Get the list of the "mean()" and "std()" columns.
meanAndStdCols <- grep("mean\\(\\)|std\\(\\)",colNames)
colNames <- gsub( "\\()", "", colNames)

# Function to read into a single data frame the 3 files that contain the labels, subjects and activities.
# The resulting dataframe will only include the columns with the mean and standard deviation.
readData <- function(labelsfile, datafile, subjectsfile){
    # Read the file with the labels
    labels_test<- read.table(labelsfile)
    labels_test<-rename(labels_test, activity=V1)
    labels_test$activity<-as.character(labels_test$activity)
    
    labels_test$activity <- sapply(labels_test$activity
                                   , function(x)  
                                        switch(x,
                                            "1"="walking",
                                            "2"="walkingupstairs",
                                            "3"="walkingdownstairs",
                                            "4"="sitting",
                                            "5"="standing",
                                            "6"="laying"
                                        )
                            )
    
    # Read the file with the tests, keeping only the "mean()" and "std()" columns.
    data_test<- read.table(datafile, col.names = colNames)
    data_test<-data_test[,meanAndStdCols]
    
    # Read the subjects file.
    subject_test<- read.table(subjectsfile)
    subject_test<- rename(subject_test, subject=V1)
    
    # Put in one dataframe the 3 datasets: subjects, labels and data
    data <- cbind(subject_test,labels_test, data_test)
    
    return(data)
}

# Get test data
print("Reading test data")
test <- readData(labelsfile = "./data/UCI HAR Dataset/test/y_test.txt"
                 , datafile = "./data/UCI HAR Dataset/test/X_test.txt"
                 , subjectsfile = "./data/UCI HAR Dataset/test/subject_test.txt")
print("Reading test data - Done!")

# Get train data
print("Reading train data")

train <- readData(labelsfile = "./data/UCI HAR Dataset/train/y_train.txt"
                 , datafile = "./data/UCI HAR Dataset/train/X_train.txt"
                 , subjectsfile = "./data/UCI HAR Dataset/train/subject_train.txt")

print("Reading train data - Done!")

# Put together the test and train datasets
# Note: harus stands for Human Activity Recognition Using Smartphones.
harus <-rbind(test, train)

# Clean up
rm(list=c("test", "train"))

print("HARUS data ready")
##write.csv(harus, file="harus.csv", row.names=FALSE)

# Get the average of all the columns, grouping by subject and activity, and save it to a text file
harus_agg <- harus %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(harus_agg, "tidyData.txt", row.name=FALSE)

print(paste("The file 'tidyData.txt' has been created in ", getwd()))
