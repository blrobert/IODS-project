#Benjamin Roberts
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")
str(hd)
dim(hd)
#hd is an array with 195 rows (countries) and 8 columns/variables. The variables are the components of the Human Development Index, including HDI Rank, Country, HDI, Life Expectancy at Birth, Expected Years of Education, Mean Years of Education, Gross National Income per capita, GNI per capita rank minus HDI rank. 
str(gii)
dim(gii)
#gii is an array with 195 rows (countries) and 10 columns/variables. The variables are the components of the Gender Inequality Index, including GII rank, Country, GII, Maternal Mortality Ratio, Adolescent Birth Rate, Female Share of Seats in Parliament, Female Population with Secondary Education, Male Population with Secondary Education, Female Labor Force Participation rate, Male Labor Force Participation Rate.
library(plyr)
hd<-plyr::rename(hd, c("HDI.Rank"="HDI_Rank", "Country"="Country", "Human.Development.Index..HDI."="HDI", "Life.Expectancy.at.Birth"="life_exp", "Expected.Years.of.Education"="edu_exp", "Mean.Years.of.Education"="edu_mean", "Gross.National.Income..GNI..per.Capita"="GNI_pc","GNI.per.Capita.Rank.Minus.HDI.Rank"="GNI_HDI"))
gii<-plyr::rename(gii, c("GII.Rank"="GII_Rank", "Country"="Country", "Gender.Inequality.Index..GII."="GII", "Maternal.Mortality.Ratio"="MMR", "Adolescent.Birth.Rate"="ABR", "Percent.Representation.in.Parliament"="fem_rep", "Population.with.Secondary.Education..Female."="fem_2edu", "Population.with.Secondary.Education..Male."="male_2edu", "Labour.Force.Participation.Rate..Female."="fem_labor", "Labour.Force.Participation.Rate..Male."="male_labor"))
library(dplyr)
gii<-mutate(gii, edu_ratio=(fem_2edu+male_2edu)/2)
gii<-mutate(gii, labor_ratio=(fem_labor+male_labor)/2)
join_by<-c("Country")
human<-inner_join(hd, gii, by=join_by)
dim(human)
str(human)



library(tidyr)
library(stringr)
GNIstring<-str_replace(human$GNI_pc, pattern=",", replace="")%>%as.numeric
human<-mutate(human, GNI=GNIstring)

keep_columns<-c("Country", "edu_ratio", "labor_ratio", "edu_exp", "life_exp", "GNI", "MMR","ABR", "fem_rep")
human<-select(human, one_of(keep_columns))
human<-filter(human, complete.cases(human)==TRUE)
tail(human, n=10)
last<-nrow(human)-7
human<-human[1:last,]
rownames(human)<-human$Country
human<-select(human, -Country)
dim(human)
str(human)
human

setwd("~/Documents/IODS-project")
write.csv(human, file="create_human.csv")
human<-read.csv("create_human.csv",row.names=1)

