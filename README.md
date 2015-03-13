## Coursera Getting and Cleaning Data Project, March 2015

### Introduction

This README documents the project for Coursera's *Getting and Cleaning Data*
course, March 2015, and the steps taken to meet the project requirements.

The purpose of the project is to demonstrate our ability to collect, work with and
clean a data set.  The goal of the project is to prepare tidy data for use in
later analysis.  Tidy data can be defined as having a "specific structure, wherein
each variable is a column, each observation is a row, and each type of
observational unit is a table." See [@Wikham].  This is a peer reviewed and graded
project.

### Required Submissions

We are required to submit the following:

- a tidy data set submitted to the coursera course site
- a link to a Github repository containing an R script (run_analysis.R) for performing
the analysis, a code book (CodeBook.md) in markdown format which describes the variables,
the data and any transformations/work performed to clean the data, and this README.

The R script should perform the following operations:

- Merge the training and test data sets to create one data set
- Extract only the measurements on the mean and standard deviation of each measurements
- Uses descriptive activity names to label the activities in the data set
- Appropriately labels the data set with descriptive variable names
- From the data set in the above step, creates a second, independent tidy data set with
the average of each variable for each activity and each subject.

### Getting The Data

The data is made available [here][1] by the [UC Irvine Machine Learning Repository][2]

### Data Description

The data, titled *Human Activity Recognition Using Smartphones Data Set,* was generated
and built by recording 30 volunteer participants (subjects) performing daily living activities while
carrying a waist-mounted smartphone embedded with inertial sensors.




[@Wikham]: http://www.jstatsoft.org/v59/i10/paper
[1]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
[2]: http://archive.ics.uci.edu/ml/index.html