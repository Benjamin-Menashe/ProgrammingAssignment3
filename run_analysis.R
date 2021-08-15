## Getting and Cleaning Data final assignment - BMenashe


## load the data and merge into one big data frame
# get list of features
ftrs <- as.character(read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")[[2]])

# load and merge the test data
testdt <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", col.names = ftrs)
testsub <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", col.names = "subjectid")
testact <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", col.names = "activity")
alltest <- data.frame(testsub, testact, testdt)

# load and merge the train data
trndt <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", col.names = ftrs)
trnsub <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", col.names = "subjectid")
trnact <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", col.names = "activity")
alltrn <- data.frame(trnsub, trnact, trndt)

# merge both
alldata <- rbind(alltest, alltrn)


## clean up
# select only cols with "mean" or "std"
inds <- grepl("mean[^F]|std", ftrs)
alldata <- alldata[,inds]

# change subjectid and action to correct factors
alldata$subjectid <- as.factor(alldata$subjectid)
alldata$activity <- as.factor(alldata$activity)
levels(alldata$activity) <- read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")[[2]]

# save "alldata" dataset (optional)
# write.table(alldata, "alldata.txt", row.names = F)


## create new dataset with means per subject per action
grps <- group_by(alldata, subjectid, activity)
meandata <- summarize_all(grps, list(mean))

# save "meandata" dataset
write.table(meandata, "meandata.txt", row.names = F)

