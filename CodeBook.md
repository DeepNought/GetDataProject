### Coursera Getting and Cleaning Data Project, March 2015

---

### Code Book

---

#### Background

The titled Coursera class project required us to obtain a dataset and manipulate it in order to produce a
tidy dataset for use in later analysis.

The original dataset was generated, pre-processed and compiled by a number of researchers at
[SmartLab][4], a Research Laboratory at the DITEN / DIBRIS Departments of the
University of Genova. The paper describing their work can be found [here][5].  The data, titled
*Human Activity Recognition Using Smartphones DataSet,*  was made available to us [here][1] by
the [UC Irvine Machine Learning Repository][2].

The experiment that was carried out to gather the data, and the methodology for processing the data was
described by the authors as follows:

>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

>The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 


The following files were included:

- **README.txt**: describes the experiment and methodology for gathering and pre-processing of the *"raw"*
data; describes what is provided for each observation; describes the contents of the various files included
with the data, and includes the licence under which the data was made available to the public.
- **features.txt**: a list of the 561 variable names.
- **features_info.txt**: briefly describes the 561 variables.
- **activity_labels.txt**: a 6 x 2 table that maps activity codes with their activity names.
- **X_train.txt**: a 7,352 x 561 table of numeric variables for the *training* set.
- **y_train.txt**: integer codes in the range of 1..30 identifying the subject in each observation of the
training set.
- **X_test.txt**: a 7,352 x 561 table of numeric variables for the *test* set.
- **y_test.txt**: integer codes in the range of 1..30 identifying the subject in each observation of the
test set.
- **subject_train.txt**: integer codes in the range of 1..6 identifying the activity the training
subjects were engaged in for each observation.
- **subject_test.txt**: same as above for the test subjects

The **features_info.txt** file gave the following information on the dataset variables (features):

>The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

>Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

>These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

>tBodyAcc-XYZ

>tGravityAcc-XYZ

>tBodyAccJerk-XYZ

>tBodyGyro-XYZ

>tBodyGyroJerk-XYZ

>tBodyAccMag

>tGravityAccMag

>tBodyAccJerkMag

>tBodyGyroMag

>tBodyGyroJerkMag

>fBodyAcc-XYZ

>fBodyAccJerk-XYZ

>fBodyGyro-XYZ

>fBodyAccMag

>fBodyAccJerkMag

>fBodyGyroMag

>fBodyGyroJerkMag

#### Data Manipulation

An R script, **run_analysis.R**, was written to read the above data files and manipulate the data with the
aim of selecting a subset of the variables and producing a tidy data set that grouped the activity and
subject variables and calculated the mean for each of the remaining numeric variables.  The script used
*dplyr* functions to perform the following data manipulations:

	1.  Downloaded the zipped data file and unzipped it.
	2.  Read the **X_train.txt** and **X_test.txt** files into data.frame objects using read.table() and
concatenated them using bind_rows().
	3.  Read the **features.txt** file to select a subset of the variables and to create descriptive names for
them.
	4.  Used *grep()* to select only variable names that had *mean()* and *std()* as part of their name.
	5.  The index vector returned by *grep()* was used to subset the data.frame object created in step 2 and
keep only the variables that had *mean()* or *std()* in their names.
	6.  *gsub()* was used to modify the names of the selected variables: leading digits and spaces were
removed, *()* were removed, dashes were replaced by underscores, and the string *mean_* was pasted to
the beginning of each variable name.  This was done because the mean of each variable constitutes the
columns of the output data. The resulting names were assigned to the columns of the data.frame
object in step 2.
	7.  The **y.train.txt** and **y.test.txt** files were read using *readLines()* and their contents
concatenated.
	8.  **activity_labels.txt** was read into a data.frame object, and was used as a lookup table to turn
the vector in step 7 above into a vector of activity labels using *sapply()* and an anonymous function.
	9.  The vector from step 8 above was inserted as a column into the front of the data.frame object from
step 2 above and named *activity*
	10.  **subject_train.txt** and **subject_test.txt** were read and concatenated.  The resulting vector was
inserted as a column into the front of the data.frame object from step 2 above and named *subject.*
	11.  This data.frame object was then grouped by the *activity* and *subject* using *group_by(),* and the
mean() of the numeric variables was calculated by a call to *summarise_each().*
	12.  The data.frame object was then ordered by a call to *arrange().*
	13.  Finally, the data.frame object was written to a file named **tidy.txt** by a call to write.table().

Note:  the file **tidy.txt** can be read into R using:
- *read.table("tidy.txt", header = TRUE, colClasses = c(activity = "factor", subject = "factor"))*

#### Data Dictionary

- activity:  factor with 6 levels (LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS WALKING_UPSTAIRS)

- subject:  factor with 30 levels (1..30)

All variables listed below are numeric and bounded in the range of [-1, 1].  (The corresponding variables
in the original dataset were normalized and bounded in the range [-1, 1].)  X, Y, Z in the variable names
denotes vector components for the respective axis.  All variable names begin with *mean_* because they are
the mean of the original variables.  Variable names beginning with *mean_t* indicate time domain variables,
and those beginning with *mean_f* indicate their frequency domain counterparts.

Units for the acceleration variables (Acc) are meters/square second

Units for the jerk variables (AccJerk) are meters/cube second

Units for the gyroscope reading variables (Gyro) are radians/second

Units for the gyroscope jerk variables (GyroJerk) are radians/square second

Units for the acceleration magnitude (AccMag) are meters/square sec

Units for the acceleration jerk magnitude (AccJerkMag) are meters/cube sec

Units for the gyroscope reading magnitude (GyroMag) are radians/second

Units for the gyroscope jerk magnitude (GyroJerkMag) are radians/square second

Units for the Fast Fourier Transform variables are the same as their corresponding time domain variables.

- mean_tBodyAcc_mean_X

- mean_tBodyAcc_mean_Y
 
- mean_tBodyAcc_mean_Z

- mean_tBodyAcc_std_X

- mean_tBodyAcc_std_Y

- mean_tBodyAcc_std_Z

- mean_tGravityAcc_mean_X

- mean_tGravityAcc_mean_Y

- mean_tGravityAcc_mean_Z

- mean_tGravityAcc_std_X

- mean_tGravityAcc_std_Y

- mean_tGravityAcc_std_Z

- mean_tBodyAccJerk_mean_X

- mean_tBodyAccJerk_mean_Y

- mean_tBodyAccJerk_mean_Z

- mean_tBodyAccJerk_std_X

- mean_tBodyAccJerk_std_Y

- mean_tBodyAccJerk_std_Z

- mean_tBodyGyro_mean_X 

- mean_tBodyGyro_mean_Y

- mean_tBodyGyro_mean_Z

- mean_tBodyGyro_std_X

- mean_tBodyGyro_std_Y

- mean_tBodyGyro_std_Z

- mean_tBodyGyroJerk_mean_X

- mean_tBodyGyroJerk_mean_Y

- mean_tBodyGyroJerk_mean_Z

- mean_tBodyGyroJerk_std_X

- mean_tBodyGyroJerk_std_Y

- mean_tBodyGyroJerk_std_Z

- mean_tBodyAccMag_mean

- mean_tBodyAccMag_std

- mean_tGravityAccMag_mean

- mean_tGravityAccMag_std

- mean_tBodyAccJerkMag_mean

- mean_tBodyAccJerkMag_std

- mean_tBodyGyroMag_mean

- mean_tBodyGyroMag_std

- mean_tBodyGyroJerkMag_mean

- mean_tBodyGyroJerkMag_std

- mean_fBodyAcc_mean_X

- mean_fBodyAcc_mean_Y

- mean_fBodyAcc_mean_Z

- mean_fBodyAcc_std_X

- mean_fBodyAcc_std_Y

- mean_fBodyAcc_std_Z

- mean_fBodyAccJerk_mean_X

- mean_fBodyAccJerk_mean_Y

- mean_fBodyAccJerk_mean_Z

- mean_fBodyAccJerk_std_X

- mean_fBodyAccJerk_std_Y

- mean_fBodyAccJerk_std_Z

- mean_fBodyGyro_mean_X

- mean_fBodyGyro_mean_Y

- mean_fBodyGyro_mean_Z

- mean_fBodyGyro_std_X

- mean_fBodyGyro_std_Y

- mean_fBodyGyro_std_Z

- mean_fBodyAccMag_mean

- mean_fBodyAccMag_std

- mean_fBodyAccJerkMag_mean

- mean_fBodyAccJerkMag_std

- mean_fBodyGyroMag_mean

- mean_fBodyGyroMag_std

- mean_fBodyGyroJerkMag_mean

- mean_fBodyGyroJerkMag_std


[1]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
[2]: http://archive.ics.uci.edu/ml/index.html
[4]: https://sites.google.com/site/smartlabdibrisunige/
[5]: http://link.springer.com/chapter/10.1007/978-3-642-35395-6_30