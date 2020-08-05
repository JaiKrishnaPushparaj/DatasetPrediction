intrain<- createDataPartition(data$Churn,p=0.2,list=FALSE)
set.seed(5342)
training<- data[intrain,]
testing<- data[-intrain,]

dim(training); dim(testing)



