library(dplyr)
library(tidyr)
library(reshape2)
library(stringr)

#Read in the File
df<-read.csv(file = "O:/Data Dashboard/All Raw Data/Postsecondary Indicators/Graduation Rates.csv", stringsAsFactors = FALSE)

#Convert the File to LONG form from Wide
df <- melt(df[,2:length(df)], id=c("Institution.Name"), direction = "long")

#Regular Expressions to identify data.
df$demo<-sapply(strsplit(as.character(df$variable), "GR"), "[", 1)
df$demo<-gsub("[[:punct:]]", " ", df$demo)
df$variable<-sapply(strsplit(as.character(df$variable), "GR"), "[", 2)

df$Year<-sapply(strsplit(as.character(df$variable), "//.."), "[", 1)
df$Year<-substring(df$Year,0 ,4)

df$variable<-sapply(strsplit(as.character(df$variable), df$Year), "[", 2)
df$variable<-sapply(strsplit(as.character(df$variable), "cohort"), "[", 2)
df$variable[!is.na(df$variable)]<-"Cohort"
df$variable[is.na(df$variable)]<-"Graduates"

df$demo<- gsub("total ","",df$demo)
df$demo<- gsub("Grand","All",df$demo)
df$demo<- gsub(" new","",df$demo)
df$demo<-trimws(df$demo)

df<-df[,c(5,1,4,2,3)]

df1<-df[df$variable=="Cohort",]
df2<-df[df$variable!="Cohort",]
df1$grad<-df2$value
df1$percent<- df1$grad/df1$value

colnames(df1)<- c("Year","Institution","Demographic","Variable","Cohort","Graduates","Percentage")
df1<-df1[,c(1,2,3,5,6,7)]
write.csv(df1, file = "o:/data dashboard/dashboard data/Jefferson County Graduation Rates.csv")
