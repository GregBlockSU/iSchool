library(tidyverse)
library(e1071)
library(caret)
library(klaR)
library(rpart)
library(rpart.plot)
library(factoextra)
library(rattle)
library(RColorBrewer)
library(questionr)
library(kernlab)
library(caretEnsemble)
library(class)

# Data loading and cleaning

trainingData_data_path <- "C:/Users/HQRGRS27/source/git/SU/iSchool/ist707/Homework/07/Kaggle-digit-train.csv"
# unseenData_data_path <- "C:/Users/trist/Desktop/Trist'n/School/Syracuse University/Q2 2021/IST707/Homework/Week 7/Kaggle-digit-test.csv"

training_df <- read.csv(trainingData_data_path)
# unseen_df <- read.csv(unseenData_data_path)
summary(training_df)
# summary(unseen_df)
# Need to convert the labels into factors
training_df$label <- as.factor(training_df$label)
# unseen_df$label <- as.factor(unseen_df$label)

# Splitting the data into test and train sets
split_ratio <- 0.6
set.seed(1234)
split_sample <- sample.int(n=nrow(training_df), size=floor(split_ratio*nrow(training_df)), replace=F)
trainData <- training_df[split_sample, ]
testData <- training_df[-split_sample, ]

# Modeling
## setting up the trainControl for cross-validation
train_control <- trainControl(method="cv", number=4)

# -- developing svm model 1
# svm_1 <- train(label ~ ., data=training_df, method="svmRadial", metric="Accuracy", trControl=train_control, tuneLength=5)
svm_1 <- ksvm(label ~ ., data=trainData, scale=F)
summary(svm_1)

# -- predictiong outcomes and testing svm model 1
testData$svm_1_predictions <- predict(svm_1, testData, type="votes")
svm_1_accuracy <- sum(testData$label == testData$svm_1_predictions)/nrow(testData)
svm_1_confusion_matrix <- table(Actual=testData$label, Predicted=testData$svm_1_predictions)

# -- developing knn model 1
knn_1 <- knn(train = trainData, test=testData, cl=trainData$label, k=5)
summary(knn_1)
# -- predictiong outcomes and testing knn model 1
testData$knn_1_predictions <- predict(knn_1, testData, type="votes")
knn_1_accuracy <- sum(testData$label == testData$knn_1_predictions)/nrow(testData)
knn_1_confusion_matrix <- table(Actual=testData$label, Predicted=testData$knn_1_predictions)
