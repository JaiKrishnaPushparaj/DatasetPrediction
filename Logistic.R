LogModel <- glm(Churn ~ .,family=binomial(link="logit"),data=training)
print(summary(LogModel))

anova(LogModel, test="Chisq")

testing$Churn <- as.character(testing$Churn)
testing$Churn[testing$Churn=="No"] <- "0"
testing$Churn[testing$Churn=="Yes"] <- "1"
fitted.results <- predict(LogModel,newdata=testing,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != testing$Churn)
print(paste('Logistic Regression Accuracy',1-misClasificError))


print("Confusion Matrix for Logistic Regression");table(testing$Churn, fitted.results > 0.5)


lrMat<-as.matrix(table(testing$Churn, fitted.results > 0.5))
lrMat
lrprecision<-(lrMat[2,2]/(lrMat[2,2]+lrMat[2,1]))
lrRecall<-(lrMat[2,2]/(lrMat[2,2]+lrMat[1,1]))
lrFscore<-2*((lrprecision*lrRecall)/(lrprecision+lrRecall))

lrprecision;lrRecall;lrFscore



exp(cbind(OR=coef(LogModel), confint(LogModel)))

