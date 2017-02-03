#Benjamin Roberts
#01/02/2017
#Introduction to linear regression, preparing a dataset for linear regression analysis.
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",sep="\t", header=TRUE)
structure(learning2014)
dim(learning2014)
#learning2014 is an array with 183 rows and 60 columns.
#learning2014 contains answers to a series of questions used to measure attitude, strategic learning, deep learning and surface learning along with the singular variables age, gender and points (exam score).

#combining variable questions/measures
strategic_questions<-c("ST01", "ST04", "ST09","ST12","ST17","ST20", "ST25", "ST28")
surface_questions<-c("SU02", "SU05", "SU08", "SU10", "SU13", "SU16", "SU18", "SU21", "SU24", "SU26", "SU29","SU32")
deep_questions<-c("D03", "D06", "D07", "D11", "D14","D15", "D19", "D22", "D23", "D27", "D30", "D31")
attitude_questions<-c("Da", "Db", "Dc", "Dd", "De", "Df", "Dg", "Dh", "Di", "Dj")
###
install.packages("dplyr")
library(dplyr)
###
#Taking the averages of these combined measures/questions in order to form singular columns/variables for attitude, surface learning, deep learning and strategic learning.
attitude_columns<-select(learning2014, one_of(attitude_questions))
learning2014$attitude<-rowMeans(attitude_columns)
deep_columns<-select(learning2014, one_of(deep_questions))
learning2014$deep<-rowMeans(deep_columns)
strategic_columns<-select(learning2014, one_of(strategic_questions))
learning2014$stra<-rowMeans(strategic_columns)
surface_columns<-select(learning2014, one_of(surface_questions))
learning2014$surf<-rowMeans(surface_columns)
###
#choosing the variables that will form the final dataset
keep_columns<-c("gender","Age","attitude","deep","stra","surf","Points")
lrn14<-select(learning2014,one_of(keep_columns))
###
dim(lrn14)
###
#filtering out responses in which exam scores were 0
lrn14<-filter(lrn14, (Points>0))
dim(lrn14)
str(lrn14)
###
#saving the dataset to the working directory (data folder)
setwd("~/Documents/IODS-project")
?write.csv
write.csv(lrn14,file="learning2014.csv")
lrn14<-read.csv("learning2014.csv", row.names = 1)
str(lrn14)
head(lrn14)
dim(lrn14)
