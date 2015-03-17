### Coursera Getting and Cleaning Data Project, March 2015

### Code Book

#### Background

The titled Coursera class project required us to obtain a dataset and manipulate
it in order to produce a tidy dataset for use in later analysis.

The original dataset was generated, pre-processed and compiled by a number of
researchers at [SmartLab][1], a Research Laboratory at the DITEN / DIBRIS
Departments of the University of Genova. The paper describing their work can be
found [here][2]. The data, titled *Human Activity Recognition Using Smartphones
DataSet,* was made available to us [here][3] by the [UC Irvine Machine Learning
Repository][4].

[1]: <https://sites.google.com/site/smartlabdibrisunige/>

[2]: <http://link.springer.com/chapter/10.1007/978-3-642-35395-6_30>

[3]: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

[4]: <http://archive.ics.uci.edu/ml/index.html>

The experiment that was carried out to gather the data, and the methodology for
processing the data was described by the authors as follows:

>   The experiments have been carried out with a group of 30 volunteers within
>   an age bracket of 19-48 years. Each person performed six activities
>   (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING)
>   wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded
>   accelerometer and gyroscope, we captured 3-axial linear acceleration and
>   3-axial angular velocity at a constant rate of 50Hz. The experiments have
>   been video-recorded to label the data manually. The obtained dataset has
>   been randomly partitioned into two sets, where 70% of the volunteers was
>   selected for generating the training data and 30% the test data.

>   The sensor signals (accelerometer and gyroscope) were pre-processed by
>   applying noise filters and then sampled in fixed-width sliding windows of
>   2.56 sec and 50% overlap (128 readings/window). The sensor acceleration
>   signal, which has gravitational and body motion components, was separated
>   using a Butterworth low-pass filter into body acceleration and gravity. The
>   gravitational force is assumed to have only low frequency components,
>   therefore a filter with 0.3 Hz cutoff frequency was used. From each window,
>   a vector of features was obtained by calculating variables from the time and
>   frequency domain. See 'features\_info.txt' for more details.

The following files were included:

-   **README.txt**: describes the experiment and methodology for gathering and
    pre-processing of the *"raw"* data; describes what is provided for each
    observation; describes the contents of the various files included with the
    data, and includes the licence under which the data was made available to
    the public.

-   **features.txt**: a list of the 561 variable names.

-   **features\_info.txt**: briefly describes the 561 variables.

-   **activity\_labels.txt**: a 6 x 2 table that maps activity codes with their
    activity names.

-   **X\_train.txt**: a 7,352 x 561 table of numeric variables for the
    *training* set.

-   **y\_train.txt**: integer codes in the range of 1..30 identifying the
    subject in each observation of the training set.

-   **X\_test.txt**: a 7,352 x 561 table of numeric variables for the *test*
    set.

-   **y\_test.txt**: integer codes in the range of 1..30 identifying the subject
    in each observation of the test set.

-   **subject\_train.txt**: integer codes in the range of 1..6 identifying the
    activity the training subjects were engaged in for each observation.

-   **subject\_test.txt**: same as above for the test subjects

The **features\_info.txt** file gave the following information on the dataset
variables (features):

>   The features selected for this database come from the accelerometer and
>   gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain
>   signals (prefix 't' to denote time) were captured at a constant rate of 50
>   Hz. Then they were filtered using a median filter and a 3rd order low pass
>   Butterworth filter with a corner frequency of 20 Hz to remove noise.
>   Similarly, the acceleration signal was then separated into body and gravity
>   acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low
>   pass Butterworth filter with a corner frequency of 0.3 Hz.

>   Subsequently, the body linear acceleration and angular velocity were derived
>   in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ).
>   Also the magnitude of these three-dimensional signals were calculated using
>   the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag,
>   tBodyGyroMag, tBodyGyroJerkMag).

>   Finally a Fast Fourier Transform (FFT) was applied to some of these signals
>   producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag,
>   fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain
>   signals).

>   These signals were used to estimate variables of the feature vector for each
>   pattern:  
>   '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

#### Data Manipulation

An R script, **run\_analysis.R**, was written to read the above data files and
manipulate the data with the aim of selecting a subset of the variables and
producing a tidy data set that grouped the activity and subject variables and
calculated the mean for each of the remaining numeric variables. The script used
*dplyr* functions to perform the following data manipulations:

-   Downloaded the zipped data file and unzipped it.

-   Read the **X\_train.txt** and **X\_test.txt** files into data.frame objects
    using read.table() and concatenated them using bind\_rows().

-   Read the **features.txt** file to select a subset of the variables and to
    create descriptive names for them.

-   Used *grep()* to select only variable names that had *mean()* and *std()* as
    part of their name.

-   The index vector returned by *grep()* was used to subset the data frame
    created in step 2 and keep only the variables that had *mean()* or *std()*
    in their names.

-   *gsub()* was used to modify the names of the selected variables: leading
    digits and spaces were removed, *()* were removed, dashes were replaced by
    underscores, and the string *mean\_* was pasted to the beginning of each
    variable name. The resulting names were assigned to the columns of the
    data.frame object.

-   The **y.train.txt** and **y.test.txt** files were read using *readLines()*
    and their contents concatenated.

-   **activity\_labels.txt** was read into a data.frame object, and was used as
    a lookup table to turn the vector in step 7 above into a vector of activity
    labels using *sapply()* and an anonymous function.

-   The vector from step 8 above was inserted into the data.frame object from
    step 2 above and named *activity*

-   **subject\_train.txt** and **subject\_test.txt** were read and concatenated.
    The resulting vector was inserted into the data.frame object from step 2
    above and named *subject.*

-   This data frame was then grouped by the *activity* and *subject* using
    *group\_by(),* and the mean() of the numeric variables was calculated by a
    call to *summarise\_each().*

-   The data frame was then ordered by a call to *arrange().*

-   Finally, the data frame was written to a file named **tidy.txt** by a call
    to write.table().

Note: the file **tidy.txt** can be read into R using: - *read.table("tidy.txt",
header = T, colClasses = c(activity = "factor", subject = "factor"))*

#### Data Dictionary

activity

factor with 6 levels

"LAYING" "SITTING" "STANDING" "WALKING"  
"WALKING\_DOWNSTAIRS" "WALKING\_UPSTAIRS"
