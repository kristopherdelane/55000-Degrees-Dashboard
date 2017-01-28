setwd("C:/Temp")
library(reshape2)
library(dplyr)

df11<-read.csv(file = "C:/Temp/ASSESSMENT_ACT_1112.csv", stringsAsFactors = FALSE)
df12<-read.csv(file = "C:/Temp/ASSESSMENT_ACT_1213.csv", stringsAsFactors = FALSE)
df13<-read.csv(file = "C:/Temp/ASSESSMENT_ACT_1314.csv", stringsAsFactors = FALSE)
df14<-read.csv(file = "C:/Temp/ASSESSMENT_ACT_1415.csv", stringsAsFactors = FALSE)
df15<-read.csv(file = "C:/Temp/ASSESSMENT_ACT_1516.csv", stringsAsFactors = FALSE)

convertACT<-function(df){
  (df %>%
     filter(DIST_NAME== "Jefferson County") %>% ## filter to County
     select(SCH_YEAR, SCH_NAME, DISAGG_LABEL, ENGLISH_MEAN_SCORE, MATHEMATICS_MEAN_SCORE, SCIENCE_MEAN_SCORE, READING_MEAN_SCORE, COMPOSITE_MEAN_SCORE) ## keep needed variables only
  ) -> df
  df$SCH_NAME <- gsub("[[:punct:]]", "", df$SCH_NAME)
  df$SCH_NAME <- trimws(df$SCH_NAME)
  df$SCH_NAME <- gsub("Dupont","duPont",df$SCH_NAME)
  df$SCH_NAME <- gsub(" MCA","",df$SCH_NAME)
  df$SCH_NAME <- gsub("Traditional High","High School",df$SCH_NAME)
  df$DISAGG_LABEL <- gsub("GAP","Gap Group (non-duplicated)",df$DISAGG_LABEL)
  df$DISAGG_LABEL <- gsub("Limited English Proficiency","English Learners",df$DISAGG_LABEL)
  df$SCH_YEAR<-as.numeric(strtrim(df$SCH_YEAR,4))+1
  return(df)
}

HSClean <- function(df){
  (df %>%
     filter(SCH_NAME %in% SCH) ## filter to County
  ) -> df
  return(df)
}

df11<-convertACT(df11)
df12<-convertACT(df12)
df13<-convertACT(df13)
df14<-convertACT(df14)
df15<-convertACT(df15)

SCH<-unique(df11$SCH_NAME)

df11<-HSClean(df11)
df12<-HSClean(df12)
df13<-HSClean(df13)
df14<-HSClean(df14)
df15<-HSClean(df15)

ACT<-rbind(df11,df12,df13,df14,df15)

ACT <- melt(ACT, id=c("SCH_YEAR","SCH_NAME", "DISAGG_LABEL"), direction = "long")

ACT$variable <- gsub("[[:punct:]]", " ", ACT$variable)
colnames(ACT)<-c("Year","High School", "Demographic","Subject", "Score")

write.csv(ACT, file = "C:/Temp/ACT.csv")
