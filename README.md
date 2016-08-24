## ReadMe

The R script  *run_analysis.R* gets and cleans the data from the Human Activity Recognition Using Smartphones Data Set. You can review the details of the experiment in [the project's site] (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). 

The project's data can be donwloaded from [this zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). It has two main data sets: test and train. Each dataset is split in 3 files: 
- *X_test.txt* (& *X_train.txt*) with all the variables captured.
- *y_test.txt* (& *y_train.txt*) with the activity made by the subject. 
- *subject_test.txt* (& *subject_train.txt*) with the identifiers of the subjects who carried out the experiment.

The column names of the *"X_"* files are stored in the *features.txt* file.

The R script downloads and uncompresses the zip file to the current working directory, then it puts together the 3 files of each dataset (adding proper column names). Based on the exercise requirements, the script only keeps the columns with the average (mean()) and standard deviation (std()). 

Finally, the script puts together both train and test datasets and creates a new data frame with the averages of all the columns, grouping by subject and activity. This data frame gets written to the text file *tidyData.txt*

To run the script, you only have to type in R:
> source("run_analysis.R")

Please, keep in mind that the script uses the packages RCurl (to download to windows from an "https" url) and dplyr (to use the select, group_by and summarise functions). So if you don't have them installed, please make sure to do so:

> install.packages("RCurl")

> install.packages("dplyr")

