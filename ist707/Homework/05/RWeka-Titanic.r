library(RWeka)
trainset <- read.csv("/Users/byu/Desktop/Data/titanic-train.csv")
testset <- read.csv("/Users/byu/Desktop/Data/titanic-test.csv")
NN <- make_Weka_filter("weka/filters/unsupervised/attribute/NumericToNominal")
trainset <- NN(data=trainset, control= Weka_control(R="1-3"), na.action = NULL)
testset <- NN(data=testset, control= Weka_control(R="1,3"), na.action = NULL)
MS <- make_Weka_filter("weka/filters/unsupervised/attribute/ReplaceMissingValues") 
trainset <-MS(data=trainset, na.action = NULL)
testset <-MS(data=testset, na.action = NULL)

model 1: no feature engineering

m=J48(Survived~., data = trainset, control=Weka_control(U=FALSE, M=2, C=0.5))
e <- evaluate_Weka_classifier(m, numFolds = 10, seed = 1, class = TRUE)
pred=predict (m, newdata = testset, type = c("class"))
myids=c("PassengerId")
id_col=testset[myids]
newpred=cbind(id_col, pred)
colnames(newpred)=c("Passengerid", "Survived")
write.csv(newpred, file="/Users/byu/Desktop/Data/titanic-J48-pred-05-17-2017.csv", row.names=FALSE)

#80.8%
#Kaggle .78469

model 2: some feature selection

myVars=c("Pclass", "Sex", "Age", "SibSp", "Parch", "Fare", "Survived")
newtrain=trainset[myVars]
newtest=testset[myVars]
m=J48(Survived~., data = newtrain)
m=J48(Survived~., data = newtrain, control=Weka_control(U=FALSE, M=2, C=0.5))
e=evaluate_Weka_classifier(m, seed=1, numFolds=10)
pred=predict (m, newdata = newtest, type = c("class"))
myids=c("PassengerId")
id_col=testset[myids]
newpred=cbind(id_col, pred)
colnames(newpred)=c("Passengerid", "Survived")
View(newpred)
write.csv(newpred, file="/Users/byu/Desktop/Data/titanic-J48-pred-05-17-2017-fs.csv", row.names=FALSE)

#81.7%
#Kaggle .78469
