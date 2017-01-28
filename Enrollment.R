library(dplyr)
library(reshape2)
library(stringr)

df<-read.csv(file = "O:/Data Dashboard/All Raw Data/Postsecondary Indicators/Enrollment.csv", stringsAsFactors = FALSE)
TwoYear<- c("ATA College", "Elizabethtown Community & Technical College", "Jefferson Community and Technical College", "Ivy Tech Community College")

df <- melt(df[,2:length(df)], id=c("Institution.Name"), direction = "long")

df$variable<-sapply(strsplit(as.character(df$variable), "EF"), "[", 2)
df$variable<-sapply(strsplit(as.character(df$variable), "All"), "[", 1)
df$variable<-gsub("[[:punct:]]", "", df$variable)
df$Classification<- ifelse(df$Institution.Name %in% TwoYear, "2-Year", "4-Year" )

df<-df[,c(2,4,1,3)]
colnames(df)<-c("Year", "Classification","Institution","Enrolled")

write.csv(df,  file = "O:/Data Dashboard/Dashboard Data/Jefferson County Area College Enrollment.csv")
