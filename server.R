library(shiny)
source("preprocess.R")
source("DataTraining.R")
source("exporatory.R")
source("RandomForest.R")
source("Logistic.R")
source("Tree.R")
server <- function(input, output) {
  #Exploratoray
  output$Etab3p1<-renderPlot(ggplot(data=data, aes(x=MonthlyCharges, color=Churn))+
                               geom_histogram(aes(y=..density..),fill="White", bins = input$slider)+
                               geom_density(alpha=0.2))
  output$Etab3p2<-renderPlot(ggplot(data = data, aes(x=Churn, y=MonthlyCharges, fill=Churn))+
                               geom_boxplot())
  output$Etab3p3<-renderPlot(ggplot(data=data, aes(x=TotalCharges, color=Churn))+
                               geom_histogram(aes(y=..density..),fill="White", bins =input$slide)+
                               geom_density(alpha=0.2))
  output$Etab3p4<-renderPlot(ggplot(data =data, aes(x =Churn, y =TotalCharges, fill=Churn))+geom_boxplot())                           
  

  output$Etab2p6<-renderPlot(ggplot(data=ci, aes(x=`Internet Service`,y=`Total Churn`, 
                                                 fill=`Internet Service`))+geom_boxplot())
  output$Etab2p2 <- renderPlot(ggplot(data, aes(x=SeniorCitizen)) + ggtitle("Senior Citizen") + xlab("Senior Citizen") + 
                             geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5  ) + ylab("Percentage") + coord_flip() + theme_minimal())
  output$Etab2p4 <- renderPlot(ggplot(data, aes(x=Dependents)) + ggtitle("Dependents") + xlab("Dependents") +
                             geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal())
  output$Etab2p5<-renderPlot(pie(t,main="Tensure Chart"))

  #model
  output$Mlr1<-renderPrint(summary(LogModel))
  output$Mlr2<-renderPrint(anova(LogModel, test="Chisq"))
  output$Mlr3<-renderPrint(exp(cbind(OR=coef(LogModel), confint(LogModel))))
  output$MTree<-renderPlot(plot(tree))
  output$Mrf1<-renderPrint(print(rfModel))
  output$Mrf2<-renderPrint(caret::confusionMatrix(pred_rf, Rtesting$Churn))
  output$Mrf3<-renderPlot(plot(rfModel))
  output$Mrf4<-renderPlot(tuneRF(Rtraining[, -18], Rtraining[, 18], stepFactor = 0.5, 
                                 plot = TRUE, ntreeTry = 200, trace = TRUE, improve = 0.05))
  output$Mrf5<-renderPrint(randomForest(Churn ~., data = Rtraining, ntree = 200, mtry = 2, importance = TRUE, proximity = TRUE))
  output$Mrf6<-renderPlot(varImpPlot(rfModel_new, sort=T, n.var = 10, main = 'Top 10 Feature Importance'))
  #Model Evaluvation
  output$MEtreeCM<-renderPrint(table(Predicted = pred_tree, Actual = testing$Churn))
  output$MEtreeAccuracy <- renderValueBox({
   valueBox(
      format(round((sum(diag(tab2))/sum(tab2))*100,2)), "Decision Tree Accuracy", icon = icon("Percentage", lib = "glyphicon"),
      color = "purple")})
    output$MEtreePrecision<- renderValueBox({
      valueBox(
        format(round(treeprecision*100,2)), "Decision Tree Precision", icon = icon("precentage", lib = "font-awesome"),
        color = "blue")
    })
    output$MEtreeRecall<- renderValueBox({
      valueBox(
        format(round(treeRecall*100,2)), "Decision Tree Recall", icon = icon("Accuracy", lib = "glyphicon"),
        color = "red")
    })
    output$MEtreeFscore<- renderValueBox({
      valueBox(
        format(round(treeFscore*100,2)), "Decision Tree Fscore", icon = icon("Accuracy", lib = "glyphicon"),
        color = "green")
    })
    
  
  
  
  
  output$MElrCM<-renderPrint(table(testing$Churn, fitted.results > 0.5))
  output$MElrAccuracy <- renderValueBox({
    valueBox(
      format(round((1-misClasificError)*100,2)), "Logistic Regression Accuracy", icon = icon("Accuracy", lib = "glyphicon"),
      color = "yellow"
    )
  })
  output$MElrPrecision<- renderValueBox({
    valueBox(
      format(round(lrprecision*100,2)), "Logistic Regression Precision", icon = icon("Accuracy", lib = "glyphicon"),
      color = "blue")
  })
  output$MElrRecall<- renderValueBox({
    valueBox(
      format(round(lrRecall*100,2)), "Logistic Regression Recall", icon = icon("Accuracy", lib = "glyphicon"),
      color = "red")
  })
  output$MElrFscore<- renderValueBox({
    valueBox(
      format(round(lrFscore*100,2)), "Logistic Regression Fscore", icon = icon("Accuracy", lib = "glyphicon"),
      color = "green")
  })
  
  output$MErfCM<-renderPrint(as.matrix(confusionMatrix(pred_rf_new, Rtesting$Churn)))
  output$MErfAccuracy <- renderValueBox({
    valueBox(
      format(round(rfaccu*100,2)), "Random Forest Accuracy", icon = icon("Accuracy", lib = "glyphicon"),
      color = "purple")})
  output$MErfPrecision<- renderValueBox({
    valueBox(
      format(round(rfprecision*100,2)), "Random Forest Precision", icon = icon("Accuracy", lib = "glyphicon"),
      color = "blue")
  })
  output$MErfRecall<- renderValueBox({
    valueBox(
      format(round(rfRecall*100,2)), "Random Forest Recall", icon = icon("Accuracy", lib = "glyphicon"),
      color = "red")
  })
  output$MErfFscore<- renderValueBox({
    valueBox(
      format(round(rfFscore*100,2)), "Random Forest Fscore", icon = icon("Accuracy", lib = "glyphicon"),
      color = "green")
  })
  
  
  #output$Evtab2<-renderPlot(varImpPlot(rfModel_new, sort=T, n.var = 10, main = 'Top 10 Feature Importance'))
  }
