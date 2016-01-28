# Coursera - Get and Cleaning Data with R
## Final Assignment

# CodeBook
obs. this codebook describes only the modifications made on the original dataset

## mergeData.txt dataset
* it has 10299 lines and 563 columns
* it merges the training (X_Train.txt) and test (X_Test.txt)
* all 561 columns from both original datasets are in mergeData
* all lines from both original datasets were added in mergeData
* two new columns [1:2] were added
    * 1. Subject - contains the subject id from subject_test.txt and subject_train.txt
    * 2. Activity - contains the activity description label for the activity code from y_test.txt and y_train.txt
* all 561 columns merged were named using the label from feature.txt
    * obs. feature.txt has some duplicated labels <-bandsEnergy()-xx,yy>. As I don´t know why they created it that way, I opted to not try to resolve this.

## averageData.txt dataset
* it has 180 lines and 563 columns
* it summarizes mergeData lines to each variable mean, grouped by Subject and Activity
* its has the same columns and column names as mergeData

## run_analysis.R
* R commands used on the dataset manipulation

### variables
* dirBse, dirTst, dirTrn, dirSgn - text names for the directories used
* dirLoc - text name for test and train subdirectories
* fFeatLbl - complete filename for features.txt
* fAtvLbl - complete filename for activity_labels.txt
* fileName - auxiliar variable with the complete filename to be read

### Vectors
* vFeatLbl - labels read from features.txt
* vAtvLbl - labels read from activity_labels.txt
* vSubTst, vSubTrn - vector where the subject data, read from subject_test.txt and subject_train.txt, is stored
* vAtvTst, vAtvTrn - vector where the activity data, read from y_test.txt and y_train.txt, is stored, using the labels in place of the codes

### working Data.Tables
* dtAux - temporary data.table used inside a function
* dtTst, dtTrn - they stored the modified test and train data before they are merged. These data.frames have the same layout as their merged version (mergeData dataset). They are created binding the Subject (vSubTst or vSubTrn) and Activitye (vAtvTst or vAtvTrn) vectors with the modified (column named) data set (from X_test or X_train)

### goal Data.Tables
* **dtMrg** - it is created merging dtTst and dtTrn. It has the layout described on the mergeData dataset.
* **dtMnSd** - this data.frame has 561 columns, one for each test set variable, and 2 lines, the first with the mean of the the equivalent dtMrg column and the second with the standard deviation of the same column.
* **GroupMean** - this data.frame has 563 columns (Subject, Activity and the 561 columns from the original data set) and one line for each unique pair (Subject - Activity). The first two columns identify the pair and the others have the average of all values that pair have on the dtMrg data.table for that specific variable.

### functions
* readSubject <- function( dirBse, dirLoc )
  * reads the test or training subject data from the correct dirLoc directory and filename.
  * returns a vector with one subject id entry for each observation line on the dataset
* readActivity <- function( dirBse, dirLoc, labels )
  * reads the test or training activity data from the correct dirLoc directory and filename
  * labels receives the vector read from activity_labels.txt
  * changes each numeric code for its equivalent label from actvity_labels.txt
  * returns a vector with one activity label entry for each observation line on the dataset
* readDataSet <- function( dirBse, dirLoc, labels )
  * reads the test or training dataset (X_test or X_train) from the correct dirLoc directory and filename
  * labels receives the vector read from features.txt, with the names for each variable on the dataset
  * changes the column names using labels vector
  * returns a data.frame with all values on the dataset (with the columns renamed)
