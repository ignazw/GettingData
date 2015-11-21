# GettingData Repository

This repository contains files required for the Getting and Cleaning Data assignment of the Coursera course.
Files in this repository:

* README.md: this file
* run_analysis.R: R script to run the analysis on the Samsung Data. This script is described in the Script section below
* Samsung input data set, divided into a test and a training set:
  * features.txt: Contains the names of the measurements
  * activity_labels.txt: Contains the names of the activities
  * test/subject_test.txt: Contains the vector of subjects (1:30) for which measurements exist 
  * test/X_test.txt: Contains the data frame of measurements
  * test/Y_test.txt: Contains the vector of activities (1:6) performed by the subjects for the measurements
  * test/subject_train.txt: Contains the vector of subjects (1:30) for which measurements exist 
  * train/X_train.txt: Contains the data frame of measurements
  * train/Y_train.txt: Contains the vector of activities (1:6) performed by the subjects for the measurements

For a full description of the Samsung data set, see, [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]

The Samsung data plus descriptions can be downloaded from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]

# Script
The R script is contained in the run_analysis.R file.

## Usage
To use the script, download the files from this repository, and leave the directory structure. All files, except the README.md file are required.

Start R, and at the prompt, type `source("run_analysis.R")`.
This will create a file `tidy_data.txt` in the same directory as `run_analysis.R`.

## What it is supposed to do
The goal of the script is to load the Samsung data, combine the test and training sets, and the average over the measurements per subject and per activity. There are 30 subjects and 6 activities, so the resulting data set will contain 30*6=180 rows of data.

Not all measurements are required for this analysis. Only those denoting a mean or a standard deviation measurement should be retained in the analysis. From the `features.txt` file, we find that there are 79 such measurement columns. 

Tidy data means that we have the result measurements in rows, and the different parameters in columns. The subject is held in a column, and the activity the subject performed is thus also held in a column. The total number of columns thus becomes 81.

The activities of the original data set are defined by integers 1-6, but meaningful values have to be given. The `activity_labels.txt` file contains the list of meaningful values

## How it works

See the `run_analysis.R` code itself to see the actual implementation, plus additional
implementation detail comments. The script code follows the following steps.

1. Read the data:
  * a feature vector
  * an activity label vector
  * for both test and training sets:
    * an activities vector
    * a subject vector
    * a measurements frame
2. Merge the test and training sets into a measurements data frame
3. Set the column names of the subject and activities vectors
4. Using the feature vector, set the column names of the measurements data frame
5. Add the subject and activities vector to the measurements data frame
6. Remove any column that is not a mean or standard deviation
7. Define the data categories that we need to average over: subject and activity
8. Split the measurements data frame according to the data categories subject and activity.
   This results in a list of data frames, where each data frame contains measurements per 
   subject and per activity
9. For each data frame in the list, calculate the mean of the measurements. We use the lapply
   function for this. We now have a list of frames, where each fram contains only one row.
10. Coerce the list of one-row frames into a normal data frame
11. Replace the activity values 1 to 6 by their labels
12. write the resulting data frame to the output file `tidy_data.txt`

# Codebook

This codebook is a description of the data in the `tidy_data.txt` file, which is the result of
the `run_analysis.R` script.

The background information of the data can be obtained from the original Samsung documentation:

```
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

```
The set of variables that were estimated from these signals, and are included in the tidy data set, are: 

* mean(): Mean value
* std(): Standard deviation

The features are per Subject and per activity. There are 30 different subjects, identified by an integer number. There are 6 different activities: walking, walking upstairs, walking downstairs, standing, sitting and laying.

Subjects are  in column 1, activities in column 2, and the features in columns 3 to 81.
Units of the features are in standard gravity g. Features starting with `t` are from measurements in the
time domain, whereas those starting with `f` are in the frequency domain, after a fast Fourier transform
of the time-domain measurements.

|Column|variable|description|
|------|--------|-----------|
|  1 | Subject | The identifier of the subject who performed the activity |
|  2 | Activity | The type of activity performed by the subject |
|  3 | tBodyAcc-mean()-X | Average of mean body acceleration, X value |
|  4 | tBodyAcc-mean()-Y | Id., Y value                                      |
|  5 | tBodyAcc-mean()-Z | Id., Z value                                      |
|  6 | tBodyAcc-std()-X | Average of standard deviation of body acceleration, X value |
|  7 | tBodyAcc-std()-Y | Id., Y value                                                       |
|  8 | tBodyAcc-std()-Z | Id., Z value                                                       |
|  9 | tGravityAcc-mean()-X | Average of mean gravity acceleration, X value |
| 10 | tGravityAcc-mean()-Y | Id., Y value                                         |
| 11 | tGravityAcc-mean()-Z | Id., Z value                                         |
| 12 | tGravityAcc-std()-X | Average of standard deviation of gravity accelartion |
| 13 | tGravityAcc-std()-Y | Id., Y value                                                |
| 14 | tGravityAcc-std()-Z | Id., Z value                                                |
| 15 | tBodyAccJerk-mean()-X | Average of mean body linear acceleration jerk, X value |
| 16 | tBodyAccJerk-mean()-Y | Id., Y value       |
| 17 | tBodyAccJerk-mean()-Z | Id., Z value       |
| 18 | tBodyAccJerk-std()-X | Average of standard deviation of body linear acceleration jerk, X value |
| 19 | tBodyAccJerk-std()-Y | Id., Y value        |
| 20 | tBodyAccJerk-std()-Z | Id., Z value        |
| 21 | tBodyGyro-mean()-X | Average of mean body angular velocity, X value |
| 22 | tBodyGyro-mean()-Y | Id., Y value          |
| 23 | tBodyGyro-mean()-Z | Id., Z value          |
| 24 | tBodyGyro-std()-X | Average of standard deviation of body angular velocity, X value |
| 25 | tBodyGyro-std()-Y | Id., Y value           |
| 26 | tBodyGyro-std()-Z | Id., Z value           |
| 27 | tBodyGyroJerk-mean()-X | Average of mean body angular velocity jerk, X value |
| 28 | tBodyGyroJerk-mean()-Y | Id., Y value      |
| 29 | tBodyGyroJerk-mean()-Z | Id., Z value      |
| 30 | tBodyGyroJerk-std()-X | Average of standard deviation of body angular velocity jerk, X value |
| 31 | tBodyGyroJerk-std()-Y | Id., Y value       |
| 32 | tBodyGyroJerk-std()-Z | Id., Z value       |
| 33 | tBodyAccMag-mean() | Average of mean body acceleration magnitude |
| 34 | tBodyAccMag-std() | Average of standard deviation of body acceleration magnitude |
| 35 | tGravityAccMag-mean() | Average of mean gravity acceleration magnitude |
| 36 | tGravityAccMag-std() | Average of standard deviation of gravity accelartion magnitude |
| 37 | tBodyAccJerkMag-mean() | Average of mean body linear acceleration jerk magnitude |
| 38 | tBodyAccJerkMag-std() | Average of standard deviation of body linear acceleration jerk magnitude |
| 39 | tBodyGyroMag-mean() | Average of mean body angular velocity magnitude |
| 40 | tBodyGyroMag-std() | Average of standard deviation of body angular velocity magnitude |
| 41 | tBodyGyroJerkMag-mean() | Average of mean body angular velocity jerk magnitude |
| 42 | tBodyGyroJerkMag-std() | Average of standard deviation of body angular velocity jerk magnitude |
| 43 | fBodyAcc-mean()-X | Average of mean body acceleration, X value |
| 44 | fBodyAcc-mean()-Y | Id., Y value           |
| 45 | fBodyAcc-mean()-Z | Id., Z value             |
| 46 | fBodyAcc-std()-X | Average of standard deviation of body acceleration, X value |
| 47 | fBodyAcc-std()-Y | Id., Y value            |
| 48 | fBodyAcc-std()-Z | Id., Z value              |
| 49 | fBodyAcc-meanFreq()-X | Average of mean frequency of body acceleration, X value |
| 50 | fBodyAcc-meanFreq()-Y | Id., Y value       |
| 51 | fBodyAcc-meanFreq()-Z | Id., Z value         |
| 52 | fBodyAccJerk-mean()-X | Average of mean body linear acceleration jerk, X value |
| 53 | fBodyAccJerk-mean()-Y | Id., Y value       |
| 54 | fBodyAccJerk-mean()-Z | Id., Z value         |
| 55 | fBodyAccJerk-std()-X | Average of standard deviation of body linear acceleration jerk, X value |
| 56 | fBodyAccJerk-std()-Y | Id., Y value        |
| 57 | fBodyAccJerk-std()-Z | Id., Z value          |
| 58 | fBodyAccJerk-meanFreq()-X | Average of mean frequency of body linear acceleration jerk, X value |
| 59 | fBodyAccJerk-meanFreq()-Y | Id., Y value   |
| 60 | fBodyAccJerk-meanFreq()-Z | Id., Z value     |
| 61 | fBodyGyro-mean()-X | Average of mean body angular velocity, X value |
| 62 | fBodyGyro-mean()-Y | Id., Y value          |
| 63 | fBodyGyro-mean()-Z | Id., Z value            |
| 64 | fBodyGyro-std()-X | Average of standard deviation of body angular velocity, X value |
| 65 | fBodyGyro-std()-Y | Id., Y value           |
| 66 | fBodyGyro-std()-Z | Id., Z value             |
| 67 | fBodyGyro-meanFreq()-X | Average of mean frequency of body angular velocity, X value |
| 68 | fBodyGyro-meanFreq()-Y | Id., Y value      |
| 69 | fBodyGyro-meanFreq()-Z | Id., Z value        |
| 70 | fBodyAccMag-mean() | Average of mean body acceleration magnitude |
| 71 | fBodyAccMag-std() | Average of standard deviation of body acceleration magnitude |
| 72 | fBodyAccMag-meanFreq() | Average of mean frequency of body acceleration magnitude |
| 73 | fBodyBodyAccJerkMag-mean() | Average of mean body linear acceleration jerk magnitude |
| 74 | fBodyBodyAccJerkMag-std() | Average of standard deviation of body linear acceleration jerk magnitude |
| 75 | fBodyBodyAccJerkMag-meanFreq() | Average of mean frequency of body linear acceleration jerk magnitude |
| 76 | fBodyBodyGyroMag-mean() | Average of mean body angular velocity magnitude |
| 77 | fBodyBodyGyroMag-std() | Average of standard deviation of body angular velocity magnitude |
| 78 | fBodyBodyGyroMag-meanFreq() | Average of mean frequency of body angular velocity magnitude |
| 79 | fBodyBodyGyroJerkMag-mean() | Average of mean body angular velocity jerk magnitude |
| 80 | fBodyBodyGyroJerkMag-std() | Average of standard deviation of body angular velocity jerk magnitude |
| 81 | fBodyBodyGyroJerkMag-meanFreq() | Average of mean frequency of body angular velocity jerk magnitude |

N.B. Variable names in columns 73-81 contain an extra "Body", which is not present in the original
Samsung descriptive notes, but which does exist in the original features.txt file of Samsung.
