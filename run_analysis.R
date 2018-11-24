# This script requires the output of the function readUciHarData(), i.e. 
# a list containing the data frames relative to the "test" and "train" data from the UCI HAR Dataset
# (for more details see http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

# The output is a tidy dataset containing the mean of measurements of interest calculated 
# for each subject and each activity. All information regarding the analysis performed and 
# the variables caluclated are stored in "Codebook.md"

# Set the path
library(dplyr)
filePath<-"./UCI HAR Dataset/"

# 1. Merges the train and the test sets to create one data set.

# Combine together the two data sets
dataComb<-rbind(dataTest,dataTrain) # 10299 obs x 564 var.


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

dataSub<-select(dataComb,subject,activity,session,grep("mean|std",names(dataComb),value = TRUE))

# 3. Uses descriptive activity names to name the activities in the data set
# Read activity names
conActivities<-file(paste0(filePath,"activity_labels.txt"))
labels<-readLines(conActivities)
close(conActivities)
# Modify strings
activityLabels<-tolower(gsub("[0-9] ","",labels));
activityLabels<-sub("_u","U",activityLabels);
activityLabels<-sub("_d","D",activityLabels);

# Change names into the dataset
dataSub<-mutate(dataSub,activity=factor(activity,levels = as.character(1:6),labels = activityLabels))

# 4. Appropriately labels the data set with descriptive variable names.
# Modify strings
namesOld<-names(dataSub);
varNamesSub<-gsub("X(.*)[0-9].","",namesOld);
varNamesSub<-gsub(".mean","Mean",varNamesSub);
varNamesSub<-gsub(".std","Std",varNamesSub);
varNamesSub<-gsub("\\.","",varNamesSub);
varNamesSub<-gsub("^t","T",varNamesSub);
varNamesSub<-gsub("^f","F",varNamesSub);

# Change names into the dataset
dataSub<- rename_at(dataSub,vars(namesOld), ~ varNamesSub)


# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject.

# Prepare data set for grouping
dataSub %>% select(-session) %>% mutate(subject=factor(subject));
# Group data set by subject and activity
groupSubAct<-group_by(dataSub,subject,activity)

# Create tidy data set with the average of each measurement for each activity and each subject
tidyData<-summarise_at(groupSubAct,grep("^T|F",names(groupSubAct),value=TRUE),funs(mean))

# Rename columns 
namesGroup<-grep("^T|F",names(groupSubAct),value=TRUE);
namesGroup<-paste0("Mean",namesGroup)
tidyData<- rename_at(tidyData,vars((grep("^T|F",names(groupSubAct),value=TRUE))), ~ namesGroup)

