tree <- ctree(Churn~Contract+tenure_group+PaperlessBilling, training)


pred_tree <- predict(tree, testing)
print("Confusion Matrix for Decision Tree"); table(Predicted = pred_tree, Actual = testing$Churn)


b1 <- predict(tree, training)
tab1 <- table(Predicted = b1, Actual = training$Churn)
tab2 <- table(Predicted = pred_tree, Actual = testing$Churn)
print(paste('Decision Tree Accuracy',sum(diag(tab2))/sum(tab2)))

treeMat<-as.matrix(table(Predicted = pred_tree, Actual = testing$Churn))

treeprecision<-(treeMat[2,2]/(treeMat[2,2]+treeMat[2,1]))
treeRecall<-(treeMat[2,2]/(treeMat[2,2]+treeMat[1,1]))
treeFscore<-2*((treeprecision*treeRecall)/(treeprecision+treeRecall))

