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

### working Data.Tables
* dtAux
* dtSubTst, dtSubTrn
* dtAtvTst, dtAtvTrn
* dtTst, dtAtvTrn
### goal Data.Tables
* **dtMrg**
* **dtMnSd**
* **GroupMean**
### functions
* readSubject <- function( dirBse, dirLoc )
* readActivity <- function( dirBse, dirLoc, labels )
* readDataSet <- function( dirBse, dirLoc, labels )
