df<- read.csv("c:/temp/postsecondary indicators/retention rates.csv", stringsAsFactors = FALSE)

df <- melt(df[,2:length(df)], id=c("Institution.Name"), direction = "long")
df$Year<-sapply(strsplit(as.character(df$variable), "EF"), "[", 2)
df$Year<-substring(df$Year,0 ,4)
df$variable<-substring(df$variable,0 ,4)

df1<-df[df$variable=="Full",]
df2<-df[df$variable=="Stud",]
df1$returned<-df2$value
df1$percent<- df1$returned/df1$value
df1$percent[df1$percent=="NaN"]<-NA

colnames(df1)<-c("Institution", "variable", "Cohort", "Year", "Returned", "Percent")
df1<-df1[,c(4,1,3,5,6)]

write.csv(df1, file = "c:/temp/Jefferson County Retention Rates.csv")
