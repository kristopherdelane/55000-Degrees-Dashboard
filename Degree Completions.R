library(dplyr)
library(reshape2)
library(stringr)

#Read in the File
df<-read.csv(file = "O:/Data Dashboard/All Raw Data/Postsecondary Indicators/Degree Completions.csv", stringsAsFactors = FALSE)

#Convert the File to LONG form from Wide
df <- melt(df[,2:length(df)], id=c("Institution.Name"), direction = "long")

#Regular Expressions to identify data.
df$demo<-sapply(strsplit(as.character(df$variable), "C"), "[", 1)
df$demo<-gsub("[[:punct:]]", " ", df$demo)
df$variable<-sapply(strsplit(as.character(df$variable), "C"), "[", 2)
df$Year<-sapply(strsplit(as.character(df$variable), "A"), "[", 1)
df$Year<-gsub("[[:punct:]]", " ", df$Year)
df$variable<-sapply(strsplit(as.character(df$variable), "total"), "[", 2)
df$variable<-gsub("[[:punct:]]", " ", df$variable)
df$variable<-gsub(" s degree", "", df$variable)
df$variable<-gsub("lor", "lor's", df$variable)
df$demo<- gsub("total ","",df$demo)
df$demo<- gsub("Grand","All",df$demo)
df$demo<- gsub(" new","",df$demo)
df$demo<-trimws(df$demo)

#College Classification Lists
TwoYear<- c("ATA College", "Elizabethtown Community & Technical College", "Jefferson Community and Technical College", "Ivy Tech Community College")
Public<-c("Elizabethtown Community & Technical College","Jefferson Community and Technical College","Ivy Tech Community College","Indiana University-Southeast",
          "University of Louisville")
Profit<-c("Galen College of Nursing-Louisville","ITT Technical Institute-Louisville","Spencerian College-Louisville","Sullivan College of Technology and Design"
          ,"Sullivan University","University of Phoenix-Kentucky","ATA College","Brown Mackie College-Louisville","Daymar College-Louisville")

#Apply College Classifications
df$ClassificationYear<- ifelse(df$Institution.Name %in% TwoYear, "2-Year", "4-Year" )
df$ClassificationType<- ifelse(df$Institution.Name %in% Public, "Public", "Private" )
df$ClassificationProfit<- ifelse(df$Institution.Name %in% Profit, "Profit", "Non-Profit" )

#Reorder and Rename the Columns
df<-df[,c(6,7,8,5,1,2,4,3)]
colnames(df)<-c("ClassificationYear", "ClassificationType", "ClassificationProfit", "Year", "Institution", "Degree", "Demographic", "Graduates")   

#Save final version of data
write.csv(df, file = "O:/Data Dashboard/Dashboard Data/Jefferson County Area College Graduations.csv")
