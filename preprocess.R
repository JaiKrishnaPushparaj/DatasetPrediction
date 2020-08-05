library(plyr)
library(corrplot)
library(ggplot2)
library(gridExtra)
library(caret)
library(MASS)
library(randomForest)
library(party)
library(RPostgreSQL)

data<-(read.csv("F:\\jaikrishna\\Major Project\\10march\\AnamolyDetection\\churn.csv"))
data<-as.data.frame(data)
data$customerID<-as.factor(data$customerID)
data$gender<-as.factor(data$gender)
data$SeniorCitizen<-as.factor(data$SeniorCitizen)
data$Partner<-as.factor(data$Partner)
data$Dependents<-as.factor(data$Dependents)
data$tenure<-as.integer(data$tenure)
data$PhoneService<-as.factor(data$PhoneService)
data$MultipleLines<-as.factor(data$MultipleLines)
data$InternetService<-as.factor(data$InternetService)
data$OnlineSecurity<-as.factor(data$OnlineSecurity)
data$OnlineBackup<-as.factor(data$OnlineBackup)
data$DeviceProtection<-as.factor(data$DeviceProtection)
data$TechSupport<-as.factor(data$TechSupport)
data$StreamingTV<-as.factor(data$StreamingTV)
data$StreamingMovies<-as.factor(data$StreamingMovies)
data$Contract<-as.factor(data$Contract)
data$PaperlessBilling<-as.factor(data$PaperlessBilling)
data$PaymentMethod<-as.factor(data$PaymentMethod)
data$MonthlyCharges<-as.numeric(data$MonthlyCharges)
data$TotalCharges<-as.numeric(data$TotalCharges)
data$Churn<-as.factor(data$Churn)
str(data)

sapply(data, function(x) sum(is.na(x)))
data <- data[complete.cases(data), ]

cols_recode1 <- c(10:15)
for(i in 1:ncol(data[,cols_recode1])) {
  data[,cols_recode1][,i] <- as.factor(mapvalues
    (data[,cols_recode1][,i], from =c("No internet service"),to=c("No")))
}

str(data$MultipleLines)
data$MultipleLines <- mapvalues(data$MultipleLines, 
                      from=c("No phone service"),
                      to=c("No"))

min(data$tenure); max(data$tenure)


group_tenure <- function(tenure){
  if (tenure >= 0 & tenure <= 12){
    return('0-12 Month')
  }else if(tenure > 12 & tenure <= 24){
    return('12-24 Month')
  }else if (tenure > 24 & tenure <= 48){
    return('24-48 Month')
  }else if (tenure > 48 & tenure <=60){
    return('48-60 Month')
  }else if (tenure > 60){
    return('> 60 Month')
  }
}
data$tenure_group <- sapply(data$tenure,group_tenure)
data$tenure_group <- as.factor(data$tenure_group)

data$SeniorCitizen <- as.factor(mapvalues(data$SeniorCitizen,
                    from=c("0","1"),to=c("No", "Yes")))

data$customerID <- NULL
data$tenure <- NULL
summary(data)
