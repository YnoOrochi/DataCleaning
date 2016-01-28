library(data.table)

# -------------------
# directories
# -------------------
dirBse <- "UCI HAR Dataset"
dirTst <- "test"
dirTrn <- "train"
dirSgn <- "Inertial Signals"

# -------------------
# base dir files
# -------------------

## vFeatLbl
# names vector (561) to the main data set
fFeatLbl <- paste(dirBse, "features.txt", sep="/")
vFeatLbl <- fread(fFeatLbl)[[2]]

## vActLbl
# activity labels vector (6)
fAtvLbl <- paste(dirBse, "activity_labels.txt", sep="/")
vAtvLbl <- fread(fAtvLbl)[[2]]

# -------------------
# auxiliary functions - used for Test and Train
# -------------------

#
# actor id / row
# read the subject vector from file
readSubject <- function( dirBse, dirLoc ) {
	fileName <- paste(dirBse, "/", dirLoc, "/", "subject_", dirLoc, ".txt", sep="")
	fread(fileName)[[1]]
}

#
# activity id / row
# read Y_Test/Y_Train and substitutes each value by his label from activity_labels
readActivity <- function( dirBse, dirLoc, labels ) {
	fileName <- paste(dirBse, "/", dirLoc, "/", "Y_", dirLoc, ".txt", sep="")
	## --- Project Goal 3
	sapply(fread(fileName)[[1]], function(x) labels[x])
}

#
# 561 vector variables for time and frequency / row
# read X_Test/X_Train file and put column names on it
readDataSet <- function( dirBse, dirLoc, labels ) {
	fileName <- paste(dirBse, "/", dirLoc, "/", "X_", dirLoc, ".txt", sep="")
	dtAux <- read.table(fileName)
	## --- Project Goal 4
	names(dtAux) <- labels
	dtAux
}

# -------------------
# test dir files
# -------------------

## dtSubTst
dtSubTst <- readSubject( dirBse, dirTst )

## dtAtvTst
dtAtvTst <- readActivity( dirBse, dirTst, vAtvLbl )

## dtTst
# create the main Test data frame, with Subject, Activity and the 561 DataSet cols
dtTst <- cbind( data.frame(Subject=dtSubTst, Activity=dtAtvTst), readDataSet(dirBse, dirTst, vFeatLbl) )

# -------------------
# train dir files
# -------------------

## dtSubTrn
dtSubTrn <- readSubject( dirBse, dirTrn )

## dtAtvTrn
dtAtvTrn <- readActivity( dirBse, dirTrn, vAtvLbl )

## dtTrn
# create the main Train data frame, with Subject, Activity and the 561 DataSet cols
dtTrn <- cbind( data.frame(Subject=dtSubTrn, Activity=dtAtvTrn), readDataSet(dirBse, dirTrn, vFeatLbl) )

# -------------------
# Merging Test and Train DataSets
# -------------------

## --- Project Goal 1
# row bind test and train datasets
dtMrg <- rbind(dtTst, dtTrn)
write.table(dtMrg, file="mergedData.txt", row.names=FALSE)

## --- Project Goal 2
# calculate the mean and std deviation for all numeric columns
# dtMnSd data.frame summarizes Mean and StdDev for all variables on dtMrg
Mean <- apply(dtMrg[,3:563], 2, mean)
StdDev <- apply(dtMrg[,3:563], 2, sd)
dtMnSd <- rbind(Mean, StdDev)

## --- Project Goal 5
# Calculate the average by Subject AND Activity groups
GroupMean <- aggregate(. ~ Subject + Activity, dtMrg, mean)
write.table(GroupMean, file="averageData.txt", row.names=FALSE)
