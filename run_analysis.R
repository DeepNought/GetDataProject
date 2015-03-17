# run_analysis.R
#
# Project for Coursera's Getting and Cleaning Data course, March 2015
#
# The code below is over-commented, but briefly:  reads a number of text
# files and constructs a data frame with appropriate columns and column names.
# Generates a new data frame first by grouping, and then summarizing by applying
# mean() to the columns. Writes the resulting data frame to file.
#
library(dplyr)    # data frame manipulations done with dplyr

setwd("C:\\Users\\paul\\Coursera\\Getting Data\\Project")

# check if the file is already here...if not, download it and unzip it
zipfilename <- "./getdata_projectfiles_UCIHARDataset.zip"
if(!file.exists(zipfilename)) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, zipfilename, mode = "wb")
    unzip(zipfilename)
}
# set the paths and read the X_train.txt and X_test.txt files with read.table()
train_file <- "./UCI HAR Dataset/train/X_train.txt"
test_file <- "./UCI HAR Dataset/test/X_test.txt"
x_train_df <- read.table(train_file, colClasses = "numeric")
x_test_df <- read.table(test_file, colClasses = "numeric")

# "Merge" the two data frames using dplyr::bind_rows().  This gives
# a data frame with 10299 rows and 561 columns...rbind() would also work
df <- bind_rows(x_train_df, x_test_df)

# Read the features.txt file to make the column names for the data frame.
# Open a file connection and call readLines().
features_file <- "./UCI HAR Dataset/features.txt"
fileCon <- file(features_file, open = "r")          # open for reading
col_names <- readLines(fileCon)
close(fileCon)                                      # close the connection

# col_names now contains all 561 names given in features.txt.
# grep this vector for "mean()" or "std()" and store the resulting
# index vector in idx.  Subset the col_names vector to get the
# names of the columns.  There are 66 names.
idx <- grep("(mean\\(\\)|std\\(\\))", col_names)
col_names <- col_names[idx]

# Subset the data frame by extracting columns based on the above index.
# These are the columns that correspond to the names in col_names above.
# See the README file for an explanation on why I chose these variables.
df <- select(df, idx)    # dplyr's subset() function

# Clean up the names a bit before assigning them to the data frame.
# Use gsub() to strip out the leading number and space from the
# features.txt names.  (This is necessary because I read this file using
# readLines().  An alternative was to read it as a table and take the names
# from the second column of the table.)  Also, strip out the () from the mean()
# and std() parts of the column names.  Replace "-" with "_".
# Replace occurrences of "BodyBody" with "Body".  This produces names
# of the form:  BodyAcc_mean_X. Paste "mean_" to beginning of these
# names to get names of the form: mean_tBodyAcc_mean_X, etc.  See the
# README for an explanation.
col_names <- gsub("^[0-9]+\\s+", "", col_names)
col_names <- gsub("\\(\\)", "", col_names)
col_names <- gsub("-", "_", col_names)
col_names <- gsub("BodyBody", "Body", col_names)
col_names <- paste0("mean_", col_names)

# assign the resulting vector to the names of the df columns.
colnames(df) <- col_names

# Read the y.train.txt, y.test.txt files.  Use these to create
# an activity column for the data frame.
y_train_file <- "./UCI HAR Dataset/train/y_train.txt"
fileCon <- file(y_train_file, open = "r")
y_train <- readLines(fileCon)
close(fileCon)

y_test_file <- "./UCI HAR Dataset/test/y_test.txt"
fileCon <- file(y_test_file, open = "r")
y_test <- readLines(fileCon)
close(fileCon)

# Now combine the y_train and y_test vectors above. The result,
# ys, is a 10299-long vector of the activities as given in the y_train.txt
# and y_test.txt files
ys <- c(y_train, y_test)

# Read the activity labels file as a data frame and use
# it to map the activity labels to the activity vector, ys, above.
activity_labels_file <- "./UCI HAR Dataset/activity_labels.txt"
act_labels_df <- read.table(activity_labels_file,
                            colClasses = c("numeric", "character")
							)
# Use sapply() and an anonymous function that returns the string in the
# second column of act_labels_df for the corresponding number in the first
# column, and apply this function to the activities vector ys, above. 
activity <- sapply(ys, function(x) act_labels_df[x, 2])

# activity is now a 10299-long vector with the activities represented
# by the labels from activity_labels.txt  Add this as a column to the
# "front" of the data frame.  Use dplyr::bind_cols().
df <- bind_cols(as.data.frame(activity), df)  # column name is "activity"

# Need to add the subject column to the data frame.  First read
# the subject_train.txt and subject_test.txt files and c() them
subj_train_file <- "./UCI HAR Dataset/train/subject_train.txt"
fileCon <- file(subj_train_file, open = "r")
subject_train <- readLines(fileCon)
close(fileCon)

subj_test_file <- "./UCI HAR Dataset/test/subject_test.txt"
fileCon <- file(subj_test_file, open = "r")
subject_test <- readLines(fileCon)
close(fileCon)

subject <- c(subject_train, subject_test)

# Make the subject vector the first column of the data frame
df <- bind_cols(as.data.frame(subject), df)  # column name is "subject"

# The point of all this:  group the data frame by activity and subject, and
# find the mean of each column for the resulting groupings, using
# the dplyr group_by() and summarise_each() functions chained together
out_df <- df %>% 
    group_by(activity, subject) %>%
    summarise_each(funs(mean))
    
# Though I don't think it's required, to order by subject, first temporarily
# convert the subject variable's type from factor to numeric, order, then
# convert back to factor. Because, according to the help file:  "the ordering
# is done in C++ code which does not have access to the local specific ordering
# usually done in R. This means that strings are ordered as if in the C locale."
# Which means "10" comes before "2" unless we change to numeric for ordering.
out_df$subject <- as.numeric(out_df$subject)
out_df <- arrange(out_df, subject)             # dplyr order function
out_df$subject <- as.factor(out_df$subject)

print(out_df, n = 35)     # just to see if it's working

# write the output table..." " is default separator, no row names, no quotes
write.table(out_df, "tidy.txt", row.names = FALSE, quote = FALSE)

# the table can be read back into R with:
# read.table("tidy.txt", header = TRUE,
#  									  colClasses = c(activity = "factor",
#												     subject = "factor")
#									)