setwd("~/Documents/Data_Sci_Course/GettingData/week4/")
library(readr)
library(dplyr)

# script for Getting and Cleaning Data course assignment.
# see README.md file for details on what this script does.

#######
# Variables linking to the data set
#######
# (X) 561-feature vectors (and labels)
src.x.labels <- "./UCI HAR Dataset/features.txt"
src.x.test <- "./UCI HAR Dataset/test/X_test.txt"
src.x.train <- "./UCI HAR Dataset/train/X_train.txt"

#  (y) Activity (and labels)
src.y.labels <- "./UCI HAR Dataset/activity_labels.txt"
src.y.test <- "./UCI HAR Dataset/test/y_test.txt"
src.y.train <- "./UCI HAR Dataset/train/y_train.txt"

# Subject 
src.subject.test <- "./UCI HAR Dataset/test/subject_test.txt"
src.subject.train <- "./UCI HAR Dataset/train/subject_train.txt"

## process561VariableDataFile - Reads in fixed format file containing 561-variables
## and returns a tibble (via pacakge readr) of the file contents: 
##   inFile : path to 561-feature vector data file
##   labelFile : path to file containing labels for 561-feature vector
process561VariableDataFile <- function(inFile, labelFile){
       
        # gets the labels for the variable data
        # returns a vector with the variable labels.
        loadDataLabels <- function(labelFile){
                data <- read_delim(labelFile, delim=" ",
                                      col_names=c("no", "variable_name"),
                                      col_types=cols(
                                              no = col_integer(),
                                              variable_name = col_character()
                                              )             
                           )
                # clean the lables to be consistant with how i work
                data <- mutate(data, variable_name = tolower(paste0(no, "_",  gsub("[-,]","_",variable_name))))
                
                return(select(data, variable_name) %>% .[[1]])
        }
        
        # Reading in as a fixed position file - so will calculate the positions
        # calculate the fixed positions for all the varibles
        
        col_start_pos <- c()
        col_end_pos <- c()
        current_pos <- 1+1 # offset for initial space at begining of each line
        field_length <- 14
       
        for (n in 1:561){
 
                # set to next field position
                col_start_pos <- c(col_start_pos, current_pos)
                col_end_pos <- c(col_end_pos, current_pos+field_length)
                
                current_pos <- current_pos + field_length + 2
        }
        
        fwf_pos <- fwf_positions(
                               col_start_pos,
                               col_end_pos,
                               col_names=loadDataLabels(labelFile))
        
        read_fwf(inFile,col_positions=fwf_pos,
                                col_types=cols(.default = col_double())
                                )
}

## processActivityDataFile - Loads in the activity data and adds the activity description for each activity.
##        The function returns a tibble (via readr package)
##      inFile : path to activity data file
##      descFile : path to file with mapping from number to activity label
processActivityDataFile <- function(inFile, descFile){

        loadActivityDescriptions <- function(descFile){
                data <- read_delim(descFile, delim=" ",
                                   col_names=c("id", "activity_description"),
                                   col_types=cols(
                                           id = col_integer(),
                                           activity_description = col_character()
                                   )             
                )
  
                data <- data  %>% mutate(activity_description = tolower(gsub("_", "", activity_description)))
                
                return(data)
        }
        
        # read in data file (single column)
        data <- read_delim(inFile, delim=" ",
                           col_names=c("activity_id"),
                           col_types=c(activity_id = col_integer())
                           )
        
        # read in the activity descriptions 
        data.activity_desc <- loadActivityDescriptions(descFile)
        # to preserve original order
        # data <- cbind(c(1:nrow(data)),data)
        
        # merge results in sort error 
        # data <- merge(data, data.activity_desc, by.x="activity_id", by.y="id", all.x=TRUE)
        # So - - linking by the activity_id via cbind (and the function defined below)
        lookupDesc <- function(activity_id, lookup_source){
                filter(lookup_source,id==activity_id) %>% .[["activity_description"]]
        }
        
        data <- cbind(data, 
                      sapply(data$activity_id, lookupDesc, lookup_source=data.activity_desc))
        names(data)[ncol(data)] <- "activity_description"
        return(tbl_df(data))
        
}

processSubjectFile <- function(inFile){
        # read in data file (single column)
        data <- read_delim(inFile, delim=" ",
                           col_names=c("subject_id"),
                           col_types=c(subject_id = col_integer())
        )
}

# Process the data files
# Loads the files and does some work setting varaible names and joining description varibles when required.

# raw data
data.x.test <- process561VariableDataFile(src.x.test, src.x.labels)
data.x.train <- process561VariableDataFile(src.x.train, src.x.labels)

data.y.test <- processActivityDataFile(src.y.test, src.y.labels)
data.y.train <- processActivityDataFile(src.y.train, src.y.labels)

data.subject.test <- processSubjectFile(src.subject.test)
data.subject.train <- processSubjectFile(src.subject.train)

# merged loaded data
data.merge <- tbl_df(
                cbind(
                        rbind(data.subject.test, data.subject.train), # subject (cols 1) 
                        rbind(data.y.test, data.y.train),             # activity (cols 3:4)
                        rbind(data.x.test, data.x.train)              # 561-factor varibles (cols 5:564)
                )
        )

# select the relivant columns (or remove ones not wanted) : Keep 1:4, get mean and sd variables from the rest
data.merge.subset <- data.merge %>% select(1:4,matches("mean\\(\\)|std()"))
# excluded meanFreq - as not the mean, i believe its the frequency interval with which to calculate the mean
# excluded other variables with mean in the parameters past to function e.g. angle(tBodyAccJerkMean),gravityMean)

# summarise the subset of varaibles [data.merge.subset]
data.smy.by_activity_subject <- 
        data.merge.subset %>% 
           group_by(activity_description, subject_id) %>%
               summarise_at(vars(matches("mean\\(\\)|std()")), mean)

# tidy-up the summarised data for output
# 1. remove the number prefix from column names (added during processing) and prefix with "meanof" as it is summarised. 
# 2. remove the [()_] characters from column names
# 3. make activity description lowercase (done while processing files)

names(data.smy.by_activity_subject) <- sub("^[0-9]*_", "meanof", names(data.smy.by_activity_subject))
names(data.smy.by_activity_subject) <- gsub("[()_]", "", names(data.smy.by_activity_subject))
        
# Output the summary to a txt file

write.table(data.smy.by_activity_subject,file="assignmenttidydata.txt",row.name=FALSE)

## example to read in the table from file:
# test <- read.table("assignment_tidy_data.txt", header=TRUE)









