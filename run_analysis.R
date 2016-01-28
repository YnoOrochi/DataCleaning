library(data.table)

# -------------------
# directories
# -------------------
dirBse <- "../UCI HAR Dataset"
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
# cut ( and ) characters
vFeatLbl <- gsub("[(|)]","",vFeatLbl)
# change , charaters for -
vFeatLbl <- gsub(",","-",vFeatLbl)

## vActLbl
# activity labels vector (6)
fAtvLbl <- paste(dirBse, "activity_labels.txt", sep="/")
# changes to lowercase and without _
vAtvLbl <- tolower(gsub("_","",fread(fAtvLbl)[[2]]))

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
vSubTst <- readSubject( dirBse, dirTst )

## dtAtvTst
vAtvTst <- readActivity( dirBse, dirTst, vAtvLbl )

## dtTst
# create the main Test data frame, with Subject, Activity and the 561 DataSet cols
dtTst <- cbind( data.frame(Subject=vSubTst, Activity=vAtvTst), readDataSet(dirBse, dirTst, vFeatLbl) )

# -------------------
# train dir files
# -------------------

## dtSubTrn
vSubTrn <- readSubject( dirBse, dirTrn )

## dtAtvTrn
vAtvTrn <- readActivity( dirBse, dirTrn, vAtvLbl )

## dtTrn
# create the main Train data frame, with Subject, Activity and the 561 DataSet cols
dtTrn <- cbind( data.frame(Subject=vSubTrn, Activity=vAtvTrn), readDataSet(dirBse, dirTrn, vFeatLbl) )

# -------------------
# Merging Test and Train DataSets
# -------------------

## --- Project Goal 1
# row bind test and train datasets
dtMrg <- rbind(dtTst, dtTrn)
# Writing the file
write.table(dtMrg, file="mergedData.txt", row.names=FALSE)

## --- Project Goal 2
# calculate the mean and std deviation for all numeric columns
# dtMnSd data.frame summarizes Mean and StdDev for all variables on dtMrg
dtMnSd <- rbind(apply(dtMrg[,3:563], 2, mean), apply(dtMrg[,3:563], 2, sd))

## --- Project Goal 5
# Calculate the average by Subject AND Activity groups
GroupMean <- aggregate(dtMrg[,3:563], by=list(dtMrg$Subject, dtMrg$Activity), FUN=mean, na.rm=TRUE)
# Fixing the names changed by aggregate (I know it is not the best way, but it works)
names(GroupMean)[names(GroupMean)=="Group.1"] <- "Subject"
names(GroupMean)[names(GroupMean)=="Group.2"] <- "Activity"
# Writing the file
write.table(GroupMean, file="averageData.txt", row.names=FALSE)
