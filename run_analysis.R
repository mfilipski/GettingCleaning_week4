# place this file into the folder containing the UCI HAR data after unzipped, namely: 
# - the folder contains the file features.txt
# - the folder contains two subfolders called 'train' and 'test' with the respective data inside. 
# the output of this file will be a text file named Averages_data.txt and will appead in that same folder



# Call packages needed for this file to run
library(dplyr)

# 1) GET THE TWO PACKAGES INTO R
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# A - TRAINING dataset.  
#---------------------------------------------
# X_train are the activity levels , Y_train are the activity labels (1 2 3 4 5 or 6)
xtrain <- read.table("./train/X_train.txt")
head(xtrain) 

# features (= variable names)
features <- read.table("features.txt", header=FALSE)
# make a vector of those names to use on xtrain
column_names <- features[,2]
column_names
# use 'features' as the names of xtrain columns
colnames(xtrain) <- column_names
head(xtrain)

# Training labels are in "Y_train", they can be merged as an additional column
ytrain <- read.table("./train/Y_train.txt")
head(ytrain)
# careful: can't have plyr as a package for this to work
ytrain <- rename(ytrain, activity = V1) 
head(ytrain)

# merge this with xtrain, using rownumbers
#ytrain$rnum = as.numeric(rownames(ytrain))
#xtrain$rnum = as.numeric(rownames(xtrain))
#head(ytrain)
#train <- merge(ytrain, xtrain)

# Test subects are in "subject_train" file
subtrain <- read.table("./train/subject_train.txt")
head(subtrain)
subtrain <- rename(subtrain, subject = V1) 
head(subtrain)



# Merge all three datasets using a variable called "rowNumber"
subtrain$rowNumber = as.numeric(rownames(ytrain))
ytrain$rowNumber = as.numeric(rownames(ytrain))
xtrain$rowNumber = as.numeric(rownames(xtrain))

#temporary merge:
merge1 <- merge(ytrain, xtrain)
#final merge: 
train <- merge(subtrain, merge1)


# B - Same with TEST dataset 
#---------------------------------------------
xtest <- read.table("./test/X_test.txt")
head(xtest) 
# names for test and train are the same
colnames(xtest) <- column_names
head(xtest)

# now get y_ file of test labels 
ytest <- read.table("./test/y_test.txt")
head(ytest)
ytest <- rename(ytest, activity = V1) 
head(ytest)

# Test subects are in "subject_train" file
subtest <- read.table("./subject_test.txt")
head(subttest)
subtest <- rename(subtest, subject = V1) 
head(subtest)


# make variables for merging: 
xtest$rowNumber = as.numeric(rownames(xtest))
ytest$rowNumber = as.numeric(rownames(ytest))
subtest$rowNumber = as.numeric(rownames(subtest))

# merge xtest and ytest (implied merge variable rowNumber)
testmerge <- merge( ytest, xtest)
test <- merge(subtest, testmerge)


#  C- APPEND TEST and TRAINING DATASETS:  
#--------------------------------------------------
# Make variables to distinguish the datasets: 
train$dataSet = 1 
test$dataSet = 2 
train$dataSetName = "train" 
test$dataSetName = "test" 



# check that the names are the same:
trainNames <-colnames(train)
testNames <-colnames(test)
all.equal(trainNames, testNames)
table(trainNames == testNames)

# append using rbind - why does it give me an error on the names?? 
FullData <- rbind(test,train)
# check a few things: 
head(FullData)
class(FullData$subject)
class(FullData$activity)
# Ok: 30 subjects, 6 activities
table(FullData$subject)
table(FullData$activity)

# Bring dataSetName to front, and remove rowNumber (which is now meaningless): 
FullData2 <- select(FullData, subject, activity, dataSet, dataSetName, everything())
FullData2 <- select(FullData2, -rowNumber)


# 2) EXTRACT MEAN AND STANDARD DEVIATION VARIABLES   
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
varnames <-colnames(FullData2)
# this is the vector of variables we want to keep
grep("mean|std", varnames)

# we also want to keep columns 1,2,3,4
FD <- FullData2[,c(1,2,3,4,grep("mean|std", varnames))]
head(FD)


# 3) GIVE DESCRIPTIVE NAMES TO ACTIVITIES   
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# they are described as follows: 
#1 WALKING
#2 WALKING_UPSTAIRS
#3 WALKING_DOWNSTAIRS
#4 SITTING
#5 STANDING
#6 LAYING
labs = c("Walk", "WalkUp", "WalkDown", "Sit", "Stand", "Lay")
table(FD$activity)
FD <- rename(FD, actCode = activity)
table(FD$actCode)
FD$actName <- factor(FD$actCode, levels = c(1,2,3,4,5,6), labels = labs)
table(FD$actName)

# 4) GIVE MEANINGFUL NAMES TO VARIABLES
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# Most of it already done in step 1.  These are likely meaningful when you know what an Accelerometer and Gyroscope measure 

#tBodyAcc-XYZ
#tGravityAcc-XYZ
#tBodyAccJerk-XYZ
#tBodyGyro-XYZ
#tBodyGyroJerk-XYZ
#tBodyAccMag
#tGravityAccMag
#tBodyAccJerkMag
#tBodyGyroMag
#tBodyGyroJerkMag
#fBodyAcc-XYZ
#fBodyAccJerk-XYZ
#fBodyGyro-XYZ
#fBodyAccMag
#fBodyAccJerkMag
#fBodyGyroMag
#fBodyGyroJerkMag

# Remove the useless "()" in all the variable names: (don't forget double \\)
oldNames <-names(FD)
oldNames
newNames <- sub("\\()","",names(FD))
# Remove repeated "BodyBody"
newNames <- sub("BodyBody", "Body", newNames)
newNames

# Replace dashes by underscores: 
newNames <- gsub("-", "_", newNames)
newNames

# Rename the dataset: 
colnames(FD) = newNames
head(FD)

# 5) AVERAGES PER SUBJECT AND ACTIVITY
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# first group by: 
FD_by_subj_act <- group_by(FD, subject, actName, actCode, dataSetName)

FD_avg <- summarize_each(FD_by_subj_act, funs(mean))
head(FD_avg)

# export for assignment: 
write.table(FD_avg, file="Averages_data.txt", row.names = FALSE)

