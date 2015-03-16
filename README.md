### Coursera Getting and Cleaning Data Project, March 2015

---

#### Introduction

This README documents the project for Coursera's *Getting and Cleaning Data*
course, March 2015, and the steps taken to meet the project requirements.

The purpose of the project is to demonstrate our ability to collect, work with and
clean a dataset.  The goal of the project is to prepare tidy data for use in
later analysis.  Tidy data can be defined as having a "specific structure, wherein
each variable is a column, each observation is a row, and each type of
observational unit is a table." See [Wickham][3].

This is a peer reviewed and graded project.

#### Required Submissions

We are required to submit the following:

- a tidy dataset submitted to the Coursera class site
- a link to a Github repository containing an R script (**run_analysis.R**) for performing
the analysis, a code book (**CodeBook.md**) in markdown format which describes the variables,
the data and any transformations performed to clean the data, and this README.

The R script should perform the following operations:

- Merge the training and test datasets to create one dataset.
- Extract only the measurements on the mean and standard deviation of each measurement.
- Use descriptive activity names to label the activities in the dataset.
- Appropriately label the dataset with descriptive variable names.
- From the dataset in the above step, create a second, independent tidy dataset with
the average of each variable for each activity and each subject.

#### Data Source and Getting the Data

The work of generating, pre-processing and compiling the data was done by a number of researchers at
[SmartLab][4], a Research Laboratory at the DITEN / DIBRIS Departments of the
University of Genova. The paper describing this work can be found [here][5].  The data, titled
*Human Activity Recognition Using Smartphones DataSet,*  was made available to us [here][1] by
the [UC Irvine Machine Learning Repository][2].

#### Data Description

According to the documentation provided with the dataset, the data was generated and built by
recording 30 volunteer participants (subjects) performing daily living activities while carrying
a waist-mounted smartphone embedded with inertial sensors. The daily activities are labelled
WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING.  The embedded
accelerometer and gyroscope sensors captured tri-axial linear acceleration and tri-axial angular
velocity readings at a constant rate of 50Hz. The resulting dataset was randomly partitioned into
two sets, with 70% of the subjects selected for generating the *"training"* data and 30% the *"test"*
data.  One of our tasks was to combine these two sets into one dataset.

The data pre-processing methodology and variable calculation was described as follows: 

>The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise
>filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap
>(128 readings/window). The sensor acceleration signal, which has gravitational and body
>motion components, was separated using a Butterworth low-pass filter into body acceleration
>and gravity. The gravitational force is assumed to have only low frequency components,
>therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of
>features was obtained by calculating variables from the time and frequency domain.

The *"raw"* data (which we were not required to operate on and clean) for each of the
training and test sets, was provided in in three parts:

- the total tri-axial acceleration (as measured by the accelerometer)
- the estimated body acceleration (generated by low-pass filtering out the acceleration due to gravity)
- the tri-axial angular velocity (as measured by the gyroscope)

This raw data is located in the "Inertial Signals" folder for each of the training and test sets.

As mentioned in the block quote above, these signals where then pre-processed
and used for calculating the 561 variables in the datasets we were required to merge, subset and clean.

The data we were required to work on were primarily contained in two text files: **X_train.txt** and
**X_test.txt**, for the training and test subjects respectively.  The first, having 70% of the data,
has 7,352 observations of 561 variables (7,352 x 561 table) and the second has 2,947 observations of
the same 561 variables (2,947 x 561 table).  All variables in these two files are numeric, with normalized
values in the range of [-1, 1].  Two accompanying files, **subject_train.txt** and
**subject_test.txt**, identified the subject (participant) for each observation.  The first file is
(7, 352 x 1) and the second is (2,947 x 1).  The subjects are identified by a number from 1 to 30.
Two additional files, **y_train.txt** and **y_test.txt** identified the activity the subjects were
engaged in for each observation.  These files are also (7, 352 x 1) and (2,947 x 1), respectively.
Since there were six activities (WALKING, WALKING_UPSTAIRS, etc.) these files contained values between
1 and 6. An **activity_labels.txt** file was provided that maps the values (1 to 6) in the
previous two files just mentioned, to the respective character strings describing each activity
(WALKING, WALKING_UPSTAIRS, etc.).  This file is a 6 x 2 table.  A **features.txt** file was included
that contains the names of all 561 numeric variables.

In addition to the above data files, a **README.txt** file contains information about the dataset, and
a **features-info.txt** file contains information about the numeric variables.

#### Data Manipulation

##### Merging the Data

The R script uses the *dplyr* package to operate on the data.  The **X_train.txt** and **X_test.txt** files
were read into data.frame objects using *read.table()*.  The two data frames were then "merged"
together using *bind_rows()* from the dplyr package.  (*rbind()* would have also worked.) This resulted
in a 10299 x 561 data frame object.

##### Selecting the Columns

We were required to subset this data frame object, extracting *"only the measurements on the mean
and standard deviation of each measurement."*  The **features.txt** file lists the
names of all 561 variables, with *mean()* and *std()* appearing as pairs *"of each measurement"* 33 times.
Twenty of these pairs represent measurements in the time domain, denoted by a leading "t" in their
names, and thirteen pairs, denoted by a leading "f" in their names, were calculated by applying
a Fast Fourier Transform to the time domain signals.  These 33 pairs, for a total of 66 variables, were
selected.  

There are thirteen frequency domain variables whose names end with *meanFreq(),* which were not
included in the selection since they were not paired with a corresponding *stdFreq()* variable.

There are also seven variables with *Mean* in their name, e.g. *gravityMean,* that were used in the
calculation of other variables relating to the angle of vector components, and these were also excluded
from the the selection process, as they appear to be intermediary variables and are also not paired up
with a std() variable.

The selection of the variables was accomplished by using the *grep()* function.  The **features.txt**
file was read using *readLines()* and *grep()* was passed the search string and the vector returned
by *readLines()* as arguments. (See the R script for the specific *grep()* call.)  This
yielded an index vector that was used to select the names of the variables as well as to subset the
data frame object containing all 561 variables.  Again, 66 variables and their corresponding names were
selected.

##### Descriptive Activity Names

We were asked to *"use descriptive activity names to label the activities in the dataset".*  This implies
adding another column to our data frame object with the information contained in the **y_train.txt** and
**y_test.txt** files. The files were read by opening a file connection and using *readLines()*.  Like
our numerical data, these files were split corresponding to the training and test split of the subjects.
After reading in these two files the resulting vectors were concatenated in the same order as the
numeric variable data frames.  The vector has values in the range of 1..6, which is not very descriptive.
To make it more descriptive, the **activity_labels.txt** file was used as a "lookup table" to substitute
the numerical values for the corresponding character strings (WALKING, etc.). After reading in the
**activity_labels.txt** file as a data frame, a simple function returning the string value for the
corresponding numerical value was passed anonymously to *sapply()*, along with the 10,299-long vector
of numerical values for each activity.  This gave the needed vector with which to make a descriptive
activity column.  This vector was inserted as a column to the "front" of the data frame and given the
name *activity.*  This was done by a call to *bind_cols().*

##### Descriptive Variable Names

This step was done prior to the Descriptive Activity Names step described above.  Up to this point the data frame
columns were by default named V1, V2, etc., as no column header was supplied with the numeric variables.  To generate
more descriptive names programmatically the supplied **features.txt** file was read and used.  This file
has names of the form *1 tBodyAcc-mean()-X* for each variable. Using *gsub()* the leading number and space
and were stripped out.  In the same way the *()* were removed, and the dashes were replaced with
underscores.  Also, some variables had a *BodyBody* string in their names, which appears to be an error,
so this string was replaced by *Body.*  This resulted in names like *BodyAcc_mean_X.* To these a leading
*mean_* string was attached using *paste0()*, to get names of the form *mean_BodyAcc_mean_X.* This might
seem weird at first, but we were given *mean* values and asked to generate the *mean()* of those mean
values.  See the R script for the *gsub()* function calls used to generate the variable names.

At this point another column was added to the front of the data
frame to identify the subject (participant).  This information was supplied to us in the form of two
files, **y_train.txt** and **y_test.txt**, as mentioned above.  For each observation in the dataset these
files contain a number between 1-30 identifying the subject.  The files were read using *readLines()*,
concatenated, and the column added to the front of the data frame using *bind_cols()* with the name
"subject".

##### Tidy Dataset

The required tidy dataset, with *"the average for each variable for each activity and each subject,"* was
generated by two dplyr function calls chained together:  a call to *group_by(activity, subject)* and
the output of that piped to a call to *summarise_each(funs(mean)).*  This resulted in a 180 x 68 table
with thirty observations for each activity (one for each subject) and the average of the numerical data
variables.  Before writing the table to file the tidy data frame was sorted by subject using the *dplyr
arrange()* function.  See the R script for details.  The table was written to a file named **tidy.txt**
using *write.table()* with the optional arguments *row.names* and *quote* both set to FALSE, and this file
was submitted to the Coursera class site as part of this project's requirements.  

The table can be read back into R using *read.table("tidy.txt", header = TRUE).*  Note that the data frame
that was written to file had the subject and activity columns as factors and all other columns as numeric.
The table read in by *read.table()* above will read the activity as factor and the subject as integer and
all other columns as numeric.

[3]: http://www.jstatsoft.org/v59/i10/paper
[1]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
[2]: http://archive.ics.uci.edu/ml/index.html
[4]: https://sites.google.com/site/smartlabdibrisunige/
[5]: http://link.springer.com/chapter/10.1007/978-3-642-35395-6_30