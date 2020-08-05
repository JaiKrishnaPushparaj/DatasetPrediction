Rintrain<- createDataPartition(data$Churn,p=0.2,list=FALSE)
set.seed(5342)
Rtraining<- data[Rintrain,]
Rtesting<- data[-Rintrain,]

rfModel <- randomForest(Churn ~ ., data = Rtraining)
print(rfModel)


pred_rf <- predict(rfModel, Rtesting)
confusionMatrix(pred_rf, Rtesting$Churn)

caret::confusionMatrix(pred_rf, Rtesting$Churn)


plot(rfModel)

t <- tuneRF(Rtraining[, -18], Rtraining[, 18], stepFactor = 0.5, 
            plot = TRUE, ntreeTry = 200, trace = TRUE, improve = 0.05)


rfModel_new <- randomForest(Churn ~., data = Rtraining, ntree = 200, mtry = 2, importance = TRUE, proximity = TRUE)
print(rfModel_new)

pred_rf_new <- predict(rfModel_new, Rtesting)
caret::confusionMatrix(pred_rf_new, Rtesting$Churn)


rfMat<-as.matrix(confusionMatrix(pred_rf_new, Rtesting$Churn))
rfMat
rfprecision<-(rfMat[2,2]/(rfMat[2,2]+rfMat[2,1]))
rfRecall<-(rfMat[2,2]/(rfMat[2,2]+rfMat[1,1]))
rfFscore<-2*((rfprecision*rfRecall)/(rfprecision+rfRecall))


rfaccu<-((rfMat[1,1]+rfMat[2,2])/(rfMat[1,1]+rfMat[1,2]+rfMat[2,1]+rfMat[2,2]))

varImpPlot(rfModel_new, sort=T, n.var = 10, main = 'Top 10 Feature Importance')

