# This function reads and loads into memory the dataset UCI HAR Dataset
readUciHarData<-function(){
   # Clean workspace and load dplyr package
   #rm(list = ls()) 
   library(dplyr);
   # Check if the user is in the correct directory
   if(!file.exists("UCI HAR Dataset"))
   {print("Warning! Please set the directory containing `UCI HAR Dataset` as working directory");break}
   
   filePath<-"./UCI HAR Dataset/"
   
   # Read variable names
   conFeatures<-file(paste0(filePath,"features.txt"))
   features<-readLines(conFeatures) 
   close(conFeatures)
   
   # create auxiliary list to combine the data sets
   dataCases<-c("test","train")
   dataList<-vector("list",length(dataCases))
   dataSubjects<-vector("list",length(dataCases))
   dataActivities<-vector("list",length(dataCases))
   for (i in seq_along(dataCases)){ #load data pieces
      dataPath<-paste0(filePath,dataCases[i],"/X_",dataCases[i],".txt")
      dataList[[i]]<-read.table(dataPath,header=FALSE, col.names = features, stringsAsFactors=FALSE)
      subjectsPath<-paste0(filePath,dataCases[i],"/subject_",dataCases[i],".txt")
      dataSubjects[[i]]<-read.table(subjectsPath,header=FALSE, col.names = "subject")
      activitiesPath<-paste0(filePath,dataCases[i],"/y_",dataCases[i],".txt")
      dataActivities[[i]]<-read.table(activitiesPath,header=FALSE, col.names = "activity")
   } #take a few seconds...
   
   # combine data pieces of the same case in one data frame
   dataTest<-dataList[[1]]
   dataTest<-mutate(dataTest,subject=dataSubjects[[1]][[1]],activity=dataActivities[[1]][[1]])
   dataTest<-mutate(dataTest,session=rep(dataCases[1],nrow(dataTest)))
   
   dataTrain<-dataList[[2]]
   dataTrain<-mutate(dataTrain,subject=dataSubjects[[2]][[1]],activity=dataActivities[[2]][[1]])
   dataTrain<-mutate(dataTrain,session=rep(dataCases[2],nrow(dataTrain)))
   
   rm(dataList,dataSubjects,dataActivities) #clean workspace from auxiliary variables
   output<-list(test=dataTest,train=dataTrain);
   #return(output);
}      
