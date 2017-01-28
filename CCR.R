setwd("C:/Temp")

library(dplyr)

df1015<-read.csv(file = "C:/Temp/DELIVERY_TARGET_CCR_1015.csv", stringsAsFactors = FALSE)
df1516<-read.csv(file = "C:/Temp/DELIVERY_TARGET_CCR_1516.csv", stringsAsFactors = FALSE)

convertCCR<-function(df){
  (df %>%
      filter(DIST_NAME== "Jefferson County" & TARGET_LABEL == "Actual Score") %>% ## filter to County
      select(SCH_NAME ,CCR_2010, CCR_2011,CCR_2012,CCR_2013,CCR_2014,CCR_2015) ## keep needed variables only
  ) -> df
  df$SCH_NAME <- gsub("[[:punct:]]", "", df$SCH_NAME)
  df$SCH_NAME <- trimws(df$SCH_NAME)
  return(df)
}

convertCCR1<-function(df){
  (df %>%
     filter(DIST_NAME== "Jefferson County" & TARGET_LABEL == "Actual Score") %>% ## filter to County
     select(SCH_NAME,CCR_2015,CCR_2016,CCR_2017,CCR_2018,CCR_2019,CCR_2020) ## keep needed variables only
  ) -> df
  df$SCH_NAME <- gsub("[[:punct:]]", "", df$SCH_NAME)
  df$SCH_NAME <- trimws(df$SCH_NAME)
  df<-df[, colSums(is.na(df)) != nrow(df)]
  return(df)
}

df1015<-convertCCR(df1015)
df1516<-convertCCR1(df1516)

SCH <- unique(df1015$SCH_NAME)
SCH1 <- unique(df1516$SCH_NAME)

if(SCH[length(SCH)]==SCH1[length(SCH)]){df1015<-cbind(df1015,df1516[3:length(df1516)])}

CCR<-as.data.frame(stack(df1015[2:length(df1015)]))
CCR$HighSchool <- SCH
CCR$ind<-gsub("CCR_","",CCR$ind)
colnames(CCR)<- c("CCR","Year","HighSchool") 

write.csv(CCR, file = "c:/temp/CCR.csv")
