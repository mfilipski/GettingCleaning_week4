# GettingCleaning_week4_project
week4 assignment of Getting and Cleaning Data course on coursera


# Overview: 
The file *run_analysis* loads data from the UCI human activity measurements dataset, then compiles averages
It will work if it is placed in the appropriate unzipped data folder which can be downloaded [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).  

For everything to function well the file *run_analysis* must be in the folder that: 
 - contains the file features.txt
 - contains the two subfolders 'train' and 'test' with the respective data inside 

The output of this file will be a text file named Averages_data.txt and will appear in that same folder


# How the script works 
## Required packages 
dplyr

## Data sources 
Each of the folders __test__ and __train__ contains three relevant files: 
- X_name.txt contains the measurement data (where name is either test or train) (561 variables)
- Y_name.txt contains the activity corresponding to the measurement (coded 1 through 6, see __activity_labels.txt__ file for codes) 
- subject_name.txt contains the identifier of each subject

These files correspond to each other by row number, meaning that the nth row of __subject_train.txt__ is the identifyier of the training subject whose data is reported in the nth row of X_train.txt, etc. 

The file __features.txt__ contains the names of the variables in the "X" datasets (561 variables)

## Major Steps:
1. reads data in using the read.table commands
  * merges the __X_train__ (measurements), __Y_train__ (activities) and __subject_train__(subject identifiers) datasets by row number 
  * extracts the names from __features.txt__ and applies them to the merged data set, called __train__
  * repeats the exact same procedure for __X_test__, __Y_test__ and __subject_test__, calles it __test__
  * uses rbind command to append __train__ with __test__.    
2. Extracts the means and standard deviation variables only
  * using a grep command
3. Renames activities 
  * Info found in the__activity_labels.txt__ file, applied to the values coming from __Y_test__.  
  * Activities are Walk, WalkUp, WalkDown, Sit, Stand, and Lay (where Up and Down refer to walking on stairs)
4. Renames variables
  * Removes unhelpful () and - and duplicated words in the variables names
  * Uses sub and gsub commands
5. Computes averages per subject and activity 
  * using group_by command and summarize_each from the dplyr library. 
6. Exports data into "Averages_data.txt" 


# Codebook 

1. The dataset contains the following variables: 
  * subject : the identifyer of the test/train subject (1 through 30) 
  * actName : factor (text) variable with the name of the activity
  * actCode : factor (numeric) variable with the code of the activity, 1 through 6:  
(1 WALKING 2 WALKING_UPSTAIRS 3 WALKING_DOWNSTAIRS 4 SITTING 5 STANDING 6 LAYING)
  * datSetName : factor (text) variable containing either "test" or "train" to identify which dataset the observation came from
  * datSetCode : factor (numeric) variable containing either 1 for "train" or 2 for "test" 
  * All other variables variables are named after the original measurements (see below), with with either "mean" of "std" suffixes to denote the mean of measurements 
  * All numeric data for these variables denotes the average of all such measurements taken for a given individual doing a given activity. 

2. Variables are named after the original measurements, described below:  
  tBodyAcc_XYZ  
  tGravityAcc_XYZ   
  tBodyAccJerk_XYZ  
  tBodyGyro_XYZ  
  tBodyGyroJerk_XYZ  
  tBodyAccMag  
  tGravityAccMag  
  tBodyAccJerkMag  
  tBodyGyroMag  
  tBodyGyroJerkMag  
  fBodyAcc_XYZ  
  fBodyAccJerk_XYZ  
  fBodyGyro_XYZ  
  fBodyAccMag  
  fBodyAccJerkMag  
  fBodyGyroMag  
  fBodyGyroJerkMag  

3. Variables description from the original codebook: 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

