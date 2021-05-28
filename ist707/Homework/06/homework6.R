library(FactoMineR)
library(dplyr)
library(caret)
library(rpart.plot)
library(ggplot2)
library(e1071)

#First load the training data in csv format, and then convert "label" to nominal variable.
# setwd("C:/Users/HQRGRS27/source/git/SU/iSchool/ist707/Homework/06")
filename <-"digit_train.csv"
DigitTotalDF <- read.csv(filename, header = TRUE, stringsAsFactors = TRUE)
DigitTotalDF$label<-as.factor(DigitTotalDF$label)
dim(DigitTotalDF)
# [1] 42000   785

head(DigitTotalDF)

#Create a random sample of n% of train data set
pca_digits = PCA(t(select(DigitTotalDF,-label)))
DigitTotalDF = data.frame(DigitTotalDF$label,pca_digits$var$coord)
# reduce the total number of data samples used
percent <- .25
set.seed(275)
DigitSplit <- sample(nrow(DigitTotalDF),nrow(DigitTotalDF)*percent)
DigitDF <- DigitTotalDF[DigitSplit,]
dim(DigitDF)
## [1] 10500 6

(nrow(DigitDF))
## [1] 10500

# Don't use the test data set in this example since it's not labeled
# instead, run kfold crossvalidation using the data from the "train" csv file

# Create k-folds for k-fold cross validation
## Number of observations
N <- nrow(DigitDF)
## Number of desired splits
kfolds <- 10
## Generate indices of holdout observations
## Note if N is not a multiple of folds you will get a warning, but is OK.
holdout <- split(sample(1:N), 1:kfolds)

# Run training and Testing for each of the k-folds
AllResults<-list()
AllLabels<-list()
for (k in 1:kfolds){
  DigitDF_Test <- DigitDF[holdout[[k]], ]
  DigitDF_Train <- DigitDF[-holdout[[k]], ]
  ## View the created Test and Train sets
  #(head(DigitDF_Train))
  #(table(DigitDF_Test$DigitTotalDF.label))
  ## Make sure you take the labels out of the testing data
  #
  DigitDF_Test_justLabel <- DigitDF_Test$DigitTotalDF.label
  DigitDF_Test_noLabel <- DigitDF_Test[, -1]
  #(head(DigitDF_Test_noLabel))
  #### Naive Bayes prediction ussing e1071 package
  #Naive Bayes Train model
  train_naibayes <- naiveBayes(DigitTotalDF.label~., data=DigitDF_Train, na.action = na.pass)
  #train_naibayes
  #summary(train_naibayes)
  #Naive Bayes model Prediction
  nb_Pred <- predict(train_naibayes, DigitDF_Test_noLabel)
  #nb_Pred
  #Testing accurancy of naive bayes model with Kaggle train data sub set
  (confusionMatrix(nb_Pred, DigitDF_Test$DigitTotalDF.label))
  
  confusionMatrix(nb_Pred, DigitDF_Test$DigitTotalDF.label)
  # Accumulate results from each fold, if you like
  AllResults <- c(AllResults,nb_Pred)
  AllLabels <- c(AllLabels, DigitDF_Test_justLabel)
  ##Visualize
  plot(nb_Pred, ylab = "Density", main = "Naive Bayes Plot")
}
confusionMatrix(nb_Pred, DigitDF_Test$DigitTotalDF.label)
### end crossvalidation -- present results for all folds
(table(unlist(AllResults),unlist(AllLabels)))

# decision tree approach
filename <-"digit_train.csv"
DigitTrainDF <- read.csv(filename, header = TRUE, stringsAsFactors = TRUE)
DigitTrainDF$label = as.factor(DigitTrainDF$label)

test_filename <-"digit_test.csv"
DigitTestDF <- read.csv(test_filename, header = TRUE, stringsAsFactors = TRUE)


trainSplit <- sample(nrow(DigitTrainDF), nrow(DigitTrainDF) * .1)
testSplit <- sample(nrow(DigitTestDF), nrow(DigitTestDF) * .1)

trainSubset = DigitTrainDF[trainSplit,]
testSubset = DigitTestDF[testSplit,]


decTreeTrain = rpart(label ~ ., data=trainSubset, method='class', control=rpart.control(cp = 0), minsplit=100, maxdepth=11)

trainPred = data.frame(predict(decTreeTrain, trainSubset))
trainPred = as.data.frame(names(trainPred[apply(trainPred,1,which.max)]))
colnames(trainPred) = 'prediction'
trainPred$number = substr(trainPred$prediction, 2,2)
trainPred = trainSubset %>% bind_cols(trainPred) %>% select(label, number) %>% mutate(label=as.factor(label), number=as.factor(number))
confusionMatrix(trainPred$label, trainPred$number)
#plot the decision tree
library(rpart)
## Warning: package 'rpart.plot' was built under R version 3.6.3
library(rattle)
fancyRpartPlot(decTreeTrain)
