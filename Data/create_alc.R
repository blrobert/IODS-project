#Benjamin Roberts
#07/02/2017
#Introduction to logistic regression and cross validation. 
#reading data into R
math<-read.table("student-mat.csv",sep=";",header=TRUE)
por<-read.csv("student-por.csv",sep=";",header=TRUE)
str(math)
str(por)
dim(math)
dim(por)
#Math is an array with 395 rows and 33 columns. Por is an array with 649 rows and 33 columns. 
library(dplyr)
#Joining the two arrays/datasets using 13 variables/student identifiers and only keeping students that are in both datasets. 
join_by<-c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
math_por<-inner_join(math, por, by=join_by)
str(math_por)
dim(math_por)
#The combined dataset math_por has 382 rows and 53 columns. 
alc<-select(math_por, one_of(join_by))
notjoined_columns<-colnames(math)[!colnames(math)%in%join_by]
for(column_name in notjoined_columns){
  two_columns<-select(math_por,starts_with(column_name))
  first_column<-select(two_columns,1)[[1]]
  if(is.numeric(first_column)){
    alc[column_name]<-round(rowMeans(two_columns))
  }else {
    alc[column_name]<-first_column
  }
}
#Combining duplicate answers from columns that were not joined within the new dataset math_por to create the dataset alc, which has only the joined columns and the combined duplicate nonjoined columns. 
alc<-mutate(alc, alc_use=(Dalc+Walc)/2)
alc<-mutate(alc, high_use=alc_use>2)
#Creating two new columns: alc_use, which is the average alcohol consumption across the weekend and weekdays; high_use, which is TRUE if alcohol_use is greater than 2, FALSE if not. 
dim(alc)
glimpse(alc)
#The final dataset alc has 382 rows and 35 columns/variables. 
setwd("~/Documents/IODS-project")
write.csv(alc, file="alc.csv")
alc<-read.csv("alc.csv",row.names=1)
dim(alc)
#saving the dataset alc to the working directory 
