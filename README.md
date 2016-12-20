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




