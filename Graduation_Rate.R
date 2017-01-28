setwd("O:/Data Dashboard/All Raw Data/High School Indicators/Graduation Rate")

library(dplyr)

grad13<-read.csv(file = "O:/Data Dashboard/All Raw Data/High School Indicators/Graduation Rate/GRADUATION_RATE_COHORT_1213.csv", stringsAsFactors = FALSE)
grad14<-read.csv(file = "O:/Data Dashboard/All Raw Data/High School Indicators/Graduation Rate/GRADUATION_RATE_COHORT_1314.csv", stringsAsFactors = FALSE)
grad15<-read.csv(file = "O:/Data Dashboard/All Raw Data/High School Indicators/Graduation Rate/GRADUATION_RATE_COHORT_1415.csv", stringsAsFactors = FALSE)
grad16<-read.csv(file = "O:/Data Dashboard/All Raw Data/High School Indicators/Graduation Rate/GRADUATION_RATE_COHORT_1516.csv", stringsAsFactors = FALSE)



convertGrad<-function(df){
(df %>%
    filter(DIST_NAME== "Jefferson County" ) %>% ## filter to County
    select(SCH_YEAR, SCH_NAME ,DISAGG_LABEL, COHORT_RATE) ## keep needed variables only
) -> df
df$COHORT_RATE<-as.numeric(df$COHORT_RATE)
df<-as.data.frame(df)
colnames(df)<-c("Year", "HighSchool", "Demographic", "Percentage")
df$Year<-as.numeric(strtrim(df$Year,4))+1
df$HighSchool <- gsub("[[:punct:]]", "", df$HighSchool)
df$HighSchool <- trimws(df$HighSchool)
return(df)
}

convertGrad1<-function(df){
  colnames(df)[16] <- "COHORT_RATE"
  (df %>%
     filter(DIST_NAME== "Jefferson County" & TARGET_LABEL == "Actual Score" & COHORT_TYPE == "FOUR YEAR") %>% ## filter to County
     select(SCH_YEAR, SCH_NAME ,DISAGG_LABEL, COHORT_RATE) ## keep needed variables only
  ) -> df
  df$COHORT_RATE<-as.numeric(df$COHORT_RATE)
  df<-as.data.frame(df)
  colnames(df)<-c("Year", "HighSchool", "Demographic", "Percentage")
  df$Year<-as.numeric(strtrim(df$Year,4))+1
  df$HighSchool <- gsub("[[:punct:]]", "", df$HighSchool)
  df$HighSchool <- trimws(df$HighSchool)
  return(df)
}

grad13<- convertGrad(grad13)
grad14<- convertGrad1(grad14)
grad15<- convertGrad1(grad15)
grad16<- convertGrad1(grad16)

Graduation <- rbind.data.frame(grad13, grad14,grad15,grad16)
Graduation$HighSchool <- gsub("Dupont","duPont",Graduation$HighSchool)
Graduation$HighSchool <- gsub(" MCA","",Graduation$HighSchool)
Graduation$HighSchool <- gsub("Traditional High","High School",Graduation$HighSchool)
Graduation$Demographic <- gsub("GAP","Gap Group (non-duplicated)",Graduation$Demographic)
Graduation$Demographic <- gsub("Limited English Proficiency","English Learners",Graduation$Demographic)

write.csv(Graduation, file = "O:/Data Dashboard/Dashboard Data/JCPS Graduation Data.csv")
