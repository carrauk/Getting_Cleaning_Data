Assignment for Getting and Cleaning Data course
============================================================

Introduction
============

This is my submission for the assignment for Getting and Cleaning Data course run on Coursera (https://www.coursera.org/learn/data-cleaning/).

About Raw Data
===============

Details of the source data used is included in the Cook Book for this assignment -> [cookbook.md](https://github.com/carrauk/Getting_Cleaning_Data/blob/master/codebook.md) along with links to the raw data used for the assignment.


Script Output
==============
This section is duplicated from the Cook Book for this assignment. It is included here to give a quick brief on the "Tidy" data file produced.

The resulting "Tidy" dataset is a summary(mean) of the mean and std values for measurements within the "X" files grouped by activitydescription, subjectid

The columns are:

* activity_description : Description of the activity the subject was doing at time of taking measurement
* subjectid            : A number between 1 and 30. Each number representing the subject carrying out the activity
* The following [64] columns are an average(mean) of the mean() and std() variables, grouped by activitydescription and subjectid for each measurements listed in the "Variables Selected" section of the [Cook Book](https://github.com/carrauk/Getting_Cleaning_Data/blob/master/codebook.md).The resulting variable names are of the following form: meanoffbodygyromeanx, which means the mean value of fBodyGyro-X -> which relates to the X in fBodyGyro-XYZ listed above.

The summary is output to file as a table.

This is available in the github repository as 'assignmenttidydata.txt'. It was output to file with the write.table() command using row.name=FALSE parameter.

To read in the data file use a command similar to this: read.table("assignmenttidydata.txt", header=TRUE)

Instruction List/Script
==============

Below are the instructions for running the script to produce the output detailed in section Script Output.

Pre-requisite:

* Install the following packages: readr (version 1.0.0 or above), dplyr (version 0.5.0 or above)
* Created on a Mac OS X environment - so you may need to check paths if running on windows environments.

Steps:

1. Download the data from the data source defined in the Data Source section of this document.
2. Extract and place in a local directory - now referenced as [DataFolder] e.g. "~/data/UCI HAR Dataset"
3. Download the 'run_analysis.R' script - now referenced as [Script]
4. Set the working directory to [DataFolder]
5. Run the [Script]
6. Read in the produced dataset with a command similar to : 

Tested within RStudio (Version 0.99.903) with R (Version 3.1.3) on Mac OS X.
