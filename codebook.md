CodeBook for the tidy dataset
=============================

Data source
-----------

This dataset is derived from a dataset referenced from the Coursera - Getting and Cleaning Data course assignment page [https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project]. This dataset is derived from the "Human Activity Recognition Using Smartphones Data Set" which was originally made avaiable here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Feature Selection. 

The dataset (Zip file) referenced from the assignment page at the time was available from here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The files within the dataset referenced were:

- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

For more information refer to the README.txt and features_info.txt within the dataset (zip file) used as the data source.


Variables Selected
-----------------

The variables selected for this dataset is based on the requirements for the assignment for week 4 of the Coursera - Getting and Cleaning Data course [https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project].

The assignment required the creation of a script called 'r_analysis.R' that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Before continuing you may want to reference the README.txt and features_info.txt files within the data source used for this analysis for background information (such as units etc) on variables.

For a quick reference the following text is taken from the feature_info.txt file from the data source used:

"The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions."

The variables that were selected from the data source based on requirement (2) are listed below:

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

The set of variables that were estimated (and kept for this assignment) from these signals are: 

* mean(): Mean value
* std(): Standard deviation


Notes:
* features are normalized and bounded within [-1,1].
* I made a choice to exclude the angle() variables as I believe they are calculated based on averages of other measurements so I believe they do not represent a mean/std of a measurement. 

Script Output
--------------
The resulting "Tidy" dataset is a summary(mean) of the mean and std values for measurements within the "X" files grouped by activitydescription, subjectid

The columns are:

* activity_description : Description of the activity the subject was doing at time of taking measurement
* subjectid            : A number between 1 and 30. Each number representing the subject carrying out the activity
* The following [64] columns are an average(mean) of the mean() and std() variables, grouped by activitydescription and subjectid for each measurement listed in the variables selected section of this document.The resulting variable names are of the following form: meanoffbodygyromeanx, which means the mean value of fBodyGyro-X -> which relates to the X in fBodyGyro-XYZ listed above.

The summary is output to file as a table. T

This is available in the github repository as 'assignmenttidydata.txt'. It was output to file with the write.table() command using row.name=FALSE parameter.

To read in the data file use a command similar to this: read.table("assignmenttidydata.txt", header=TRUE)








