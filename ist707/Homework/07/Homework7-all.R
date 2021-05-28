# install.packages("klaR")
# install.packages("rattle")
# install.packages("imager")
# install.packages("parallel")
# install.packages("kernlab")
# install.packages("doParallel")

library(readr)

# Needed to introduce tuning parameters for machine learning
library(caret) # Machine Learning
library(caretEnsemble) # To ensemble predictions
library(questionr)# Required run Naive in caret
library(klaR) # Required for Naive Bayes in caret
library(e1071) # Required for Naive Bayes faster

# Needed for Decision tree model and plot
library(rpart) # decision tree
library(rpart.plot) # used for model plot
library(rattle) # used for model plot

# Needed for image manipulation
library(imager)

# Needed to extract cumulative proportion in PCA analysis
library(factoextra) 

starTime <- Sys.time()

#Enabling parallel computing 
library(parallel)
library(doParallel)

print(detectCores()) # Prints the total CPU cores available

# As seen from the output, there are 12 cpu cores available on the machine this
# experiment is currently conducted. Therefore, this project will enable 5 cores
# to perform parallel computing wherever applicable.This should decrease time to
# execute the program.

cl <- makeCluster(detectCores())

registerDoParallel(cl)

# For simplicity this project utilizes the data that are sampled and stored into train and test data.
setwd("C:/Users/HQRGRS27/source/git/SU/iSchool/ist707/Homework/07")
train <- read_csv("Kaggle-digit-train-sample-small-1400.csv")
test <- read_csv("Kaggle-digit-test.csv")
test <- test[,-1] # removing the column named label from the test data

# Plotting training data to check images 

rotate <- function(x) t(apply(x, 2, rev)) # reverses (rotates the matrix)

par(mfrow=c(2,2)) # Plotting in 2*2 format
lapply(1:4, 
       function(x) image( #norow = 28 because this is 28 pixel image
         rotate(matrix(unlist(train[x,-1]),nrow = 28,byrow = T)),
         col=grey.colors(255),
         xlab=train[x,1]
       )
)

#Checking the size of the train data

dim(train) 

# Checking the size of the test data

dim(test)

# From the above query, it is now visible that this project has 1400 data for
# training the machine learning model and 28000 rows of data to test the model.
# Data can be explored using head(test) and it can be seen that the first column
# of the train data has a factor label.However to keep the report compact head
# command in not shown to be executed in this document. This column basically
# defines to which digit does the pixel columns is actually associated with.
#
# Similarly, the training data also needs to be explored using head(test).The
# label column is removed from the test data in this project, it is done so
# because this data will be use to make predictions in later analysis.


# To make fair comparison between these five different algorithm, this project
# will set the default tuning parameters for the project. All of the algorithms
# will be run with same parameters and with same data.To keep the process
# repeatable this project utilizes the set.seed function.

# Changing label to factor
train$label <- as.factor(train$label)

# Creating a control with cross validation of 3
control <- trainControl(method ='cv',number = 3)

# Metric for comparison will be accuracy for this project
metric <-  "Accuracy"

# As seen in the codes above, first the parameters are defined.This is done
# because at the end all of the model's performance will be measured with same
# metric (i,e accuracy).Also to train each of the model 3-fold cross validation
# process will be used.Cross validation method is very effective specially if
# the data has any outlier.

# Now the next step is to create the model for each of the algorithms using the
# parameters defined in the process earlier.

set.seed(10)

# Decision Tree

tree.model <- train(label ~ ., data = train, method="rpart", metric=metric, trControl=control,
                    tuneLength = 5)

# Naive Bayes 

nab.model <- train(label ~ ., data = train,method="nb", laplace=1,metric=metric, trControl=control,
                   tuneLength = 5)

# Support Vector Machine (SVM)

svm.model <- train(label ~ ., data = train, method="svmRadial",metric=metric,trControl=control,
                   tuneLength = 5)

# kNN

knn.model <- train(label ~ ., data = train, method="knn", metric=metric, trControl=control,
                   tuneLength = 5)

# Random Forest
set.seed(10)
rf.model <- train(label ~ ., data = train, method="rf", metric=metric, trControl=control,
                  tuneLength = 5)

# summarize accuracy of models
results <- resamples(list(Decesion_Tree=tree.model,
                          Naive_Bayes=nab.model,knn=knn.model,
                          SVM=svm.model,Random_Forest=rf.model))

dotplot(results)

# It can be seen from the plot above that, when measured using "accuracy" as a
# metrics of performance, SVM & Random Forest performed the best.

# Faster Naive Bayes Now that all of the algorithms has been accessed.This
# project created a new faster model for Naive Bayes to use it for prediction
# purpose.Since Naive Bayes is normally used for smaller training data set,
# however the data used in this project is bigger and has multiple
# dimensions.Therefore, instead of predicting from the model created using caret
# package, this project will utilize e1071 package keeping the tuning parameters
# same as before.

nb.model=naiveBayes(label~., data = train, laplace = 1, na.action = na.pass, metric=metric,
                    trControl=control)

# Now that the model is created and also high level overview of performance of 5
# different model is observed.This project will inspect the performance of each
# model thoroughly.Carefully inspecting the final version of the model
# considering accuracy.Accuracy (%) of the model will be stored in the dataframe
# called "Accuracy".This will be discussed in the conclusion section at the end
# of the project.

# Accuracy of Decsion Tree Model

print(tree.model)

# cp = 0.047 is the final model, therefore taking accuracy value from it
tree_acc = 48
Accuracy <- data.frame(tree_acc)

# Plotting decision tree model
plot(tree.model)

# The code above and graphics displays the summary of the model just created in
# the process. It is important to make a note of the final model that has the
# highest accuracy associated with it.To do so it is important to check the
# value of CP out of 3 fold such that it has highest accuracy on y-axis.For the
# decision tree model CP has the highest accuracy at cp = 0.047.

# Accuracy of Naive Bayes Model
summary(nb.model)

nb_acc = 19 # from the comparison plot
Accuracy <- data.frame(cbind(Accuracy,nb_acc))

# Naive Bayes is a probabilistic model therefore,there is no graphics before the
# test data is feed into the model. However looking at the algorithm performance
# graph earlier, the accuracy of the model seems to be at 19%.

# Accuracy of Support Vector Machine (SVM)
print(svm.model)

# Plotting Support Vector Machine Model
plot(svm.model)

# The code above and graphics displays the summary of the model just created in
# the process. It is important to make a note of the final model having the
# highest accuracy.To do so in svm out of 3 fold, one needs to check the value
# of c such that it has the highest accuracy associated with it, in this example
# it was found to be at c = 4.

# However comparing it will the lower cost solution with c = 1, there seems to
# be only 2% difference in the accuracy. Therefore this project will change the
# tune length to 3.This way c = 1 will be implemented as the final model for
# prediction.

# c = 1 is the final model this project will utilize, 
# therefore taking accuracy value from it is also stored into Accuracy table

svm.model <- train(label ~ ., data = train, method="svmRadial",metric=metric,
                   trControl=control,tuneLength = 3)

svm_acc = 92
Accuracy <- data.frame(cbind(Accuracy,svm_acc))


# Accuracy of kNN model
print(knn.model)

# k = 5 is the final model, therefore taking accuracy value from it
kNN_acc = 88
Accuracy <- data.frame(cbind(Accuracy,kNN_acc))

# Plotting kNN model
plot(knn.model)

# The code above and graphics displays the summary of the model just created in
# the process. It is important to make a note and find the final model having
# the highest accuracy.To do so in kNN out of 3 fold, one needs to check the
# value k in which it has the highest accuracy, in this example it was found to
# be at k = 7.

# Accuracy of Random Forest Model
print(rf.model)

# mtry = 39 is the final model, therefore taking accuracy value from it
rf_acc = 90
Accuracy <- data.frame(cbind(Accuracy,rf_acc))

# Plotting random forest model
plot(rf.model)

# The code above and graphics displays the summary of the model just created in
# the process. It is important to note and find the final model that is selected
# which has the highest accuracy.To do so in random forest model out of 3 fold,
# one needs to check which value of mtry that yielded the most accuracy, in this
# example it was mtry = 39.However as the mtry is increased the accuracy of the
# model seems to go down.

# The random forest algorithm selects the random label and creates the tree of
# it's own. The final model is the one that yields the highest accuracy. Mtry is
# the number associated with that specific tree.

# Prediction on the test data using decision tree

dt <- predict(tree.model, test)

prediction <- data.frame(dt)

# Prediction on the test data using Naive Bayes

nb <- predict(nb.model, test)

prediction <- data.frame(cbind(prediction, nb))

# Prediction on the test data using svm
svm <- predict(svm.model, test)

prediction <- data.frame(cbind(prediction, svm))

# Prediction on the test data using knn
knn <- predict(knn.model, test)

prediction <- data.frame(cbind(prediction, knn))

# Prediction on the test data using random forest
random_f <- predict(rf.model, test)

prediction <- data.frame(cbind(prediction, random_f))

# In the above codes execution,prediction were made utilizing several machine
# learning model created in the earlier steps. Also a new dataframe is created,
# which stores the prediction made by each model. The same dataframe is utilized
# to add prediction made by the successive models.New columns will be added and
# named to the appropriate model for comparing prediction made by various model.

# Checking first six predictions against actual image

# Plotting training data check images 

rotate <- function(x) t(apply(x, 2, rev)) # reverses (rotates the matrix)

par(mfrow=c(2,3)) # Plotting in 2*3 format (random forest)
lapply(1:6, 
       function(x) image( #norow = 28 because this is 28 pixel image
         rotate(matrix(unlist(test[x,]),nrow = 28,byrow = T)),
         col=grey.colors(255),
         xlab=prediction[x,3]
       )
)

# Cheeking the prediction table

head(prediction)

# Comparing first six actual image with the prediction made by the models,it was
# observed that SVM and Random Forest correctly predicted 5 of them. However
# both models incorrectly predicted 0 as a 4.
