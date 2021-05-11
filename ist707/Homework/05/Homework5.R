#  HW #5 

knitr::opts_chunk$set(echo = TRUE)
#  INstalling packages
library(tm)
library(stringr)
library(wordcloud)
library(stringi)
library(Matrix)
library(tidytext)
library(dplyr)
library(ggplot2)
library(factoextra)
library(rpart)
#install.packages("rattle")
library(rattle)
#install.packages("rpart.plot")
library(rpart.plot)
library(RColorBrewer)
library(tidyr)
library(caret)


#Load the data
# Below, loading data (Federalist Papers) in Corpus format. 

####  Load Fed Papers Corpus
FedPapersCorpus <- Corpus(DirSource("C:\\Users\\micha\\OneDrive\\Documents\\IST 707\\HW 4\\FedPapersCorpus"))
#checks to see if it was loaded correctly - commented out after 1st run
(numberFedPapers<-length(FedPapersCorpus))

(summary(FedPapersCorpus))
(meta(FedPapersCorpus[[1]]))

(meta(FedPapersCorpus[[1]],5))

## Cleaning and Preparing
#Choosing some good stop words can really go a long way to improve modeling results. There are also many
#other parameters one can tweak and tune using the DocumentTermMatrix function. See many below.
#Data Preparation and Transformation on Fed Papers

##Remove punctuation,numbers, and space
(getTransformations())

(nFedPapersCorpus<-length(FedPapersCorpus))
(minTermFreq <-30)
(maxTermFreq <-1000)

#  Create a personalized list of stop words
MyStopwords <- c("will","one","two", "may","less","publius","Madison","Alexand", "Alexander", "James", "Hamilton", "Jay","well", "might",
                  "without", "small", "single" ,"several", "but", "very", "can", "must", "also", "any", "and", "are", "however", "into", 
                  "almost", "for", "add", "Author")
                  
STOPS <-stopwords('english')
                 
Papers_DTM <- DocumentTermMatrix(FedPapersCorpus,
                                 control = list(stopwords = TRUE, wordLengths=c(3, 15),
                                 removePunctuation = T, removeNumbers = T,
                                 tolower=T, stemming = T,
                                 remove_separators = T,
                                 stopwords = MyStopwords,
                                 removeWords=STOPS,
                                 removeWords=MyStopwords,
                                 bounds = list(global = c(minTermFreq, maxTermFreq))
                                                   ))
 ##inspect FedPapers Document Term Matrix (DTM)
DTM <- as.matrix(Papers_DTM)
#  Confirming 1st 11 are disputed
(DTM[1:11,1:10])

##  Vectorization
##  Vectorizing words is often done by encoding frequency information. Below we take a peak at the frequency
# of the words. Next some normalization techniques are tried. Which works best . . . ?? Try many and assess
# the results!!!
 ##Look at word frequencies
WordFreq <- colSums(as.matrix(Papers_DTM))
(head(WordFreq, 20))
(length(WordFreq))
ord <- order(WordFreq)
(WordFreq[head(ord, 20)])
                  
(WordFreq[tail(ord)])

# Creating a barplot for the top 20 words
#barplot(head(sort(WordFreq, decreasing = T),20))

# Creating aplot for the top 20 words
WF_2 <- t(WordFreq[tail(ord, 20, decreasing = F)])
plot(as.data.frame(WF_2)) 
plot(head(sort(WordFreq[71:85], decreasing = T, ),20),xlab = colnames(WordFreq[71:85]))
## Row Sums per Fed Papers
Row_Sum_Per_doc <- rowSums((as.matrix(Papers_DTM)))

 ## Create a normalized version of Papers_DTM
Papers_M <- as.matrix(Papers_DTM)
Papers_M_N1 <- apply(Papers_M, 1, function(i) round(i/sum(i),3))
Papers_Matrix_Norm <- t(Papers_M_N1)
                  ## Convert to matrix and view
Papers_dtm_matrix = as.matrix(Papers_DTM)
str(Papers_dtm_matrix)
(Papers_dtm_matrix[c(1:11),c(2:10)])

Papers_DF <- as.data.frame(as.matrix(Papers_Matrix_Norm))
Papers_DF1<- Papers_DF%>%add_rownames()

#  Labeling the data only for Hamilton and Madison.
names(Papers_DF1)[1]="Author"
Papers_DF1[1:11,1]="dispt"
Papers_DF1[12:62,1]="hamil" 
Papers_DF1[63:85,1]="madis"
head(Papers_DF1)

#  Experimental Design
#  Randomly selecting training (train) and testing (test) data sets
#  using function: sample.int() .

(head(sort(as.matrix(Papers_dtm_matrix)[11,], decreasing = TRUE), n=50))

##Make Train and Test sets
numDisputed = 11
numTotalPapers = nrow(Papers_DF1)

trainRatio <- .60
set.seed(11) # Set Seed so that same sample can be reproduced in future also

sample <- sample.int(n = numTotalPapers-numDisputed, size = floor(trainRatio*numTotalPapers), replace = F)
newSample = sample + numDisputed 

train <- Papers_DF1[newSample, ]
test <- Papers_DF1[-newSample, ]

# train / test ratio
length(newSample)/nrow(Papers_DF1)

#  Classification
#  Training and testing using classifiers
#  And using different decision tree models, parameters and pruning
#  Using fancyRpartPlot to visualize the learned tree models.

##Decision Tree Models
#Train Tree Model 1
train_tree1 <- rpart(Author ~ ., data = train, method="class", control=rpart.control(cp=0))
summary(train_tree1)


#predict the test dataset using the model for train tree No. 1
predicted1= predict(train_tree1, test, type="class")
(Results1 <- data.frame(Actual=test$Author, TrainTreeModel1 = predicted1))
#plot number of splits
rsq.rpart(train_tree1)

#plot the decision tree
fancyRpartPlot(train_tree1)

#confusion matrix to find correct and incorrect predictions
table(Authorship=predicted1, true=test$Author)

train_tree2 <- rpart(Author ~ ., data = train, method="class", control=rpart.control(cp=0), minsplit = 2, maxdepth = 5) 
(summary(train_tree2))

#predict the test dataset using the model for train tree No. 1
predicted2= predict(train_tree2, test, type="class")
#plot number of splits
rsq.rpart(train_tree2)

#plot the decision tree
fancyRpartPlot(train_tree2)

#Table
(Results1 <- data.frame(Actual=test$Author, TrainTreeModel1 = predicted1, TrainTreeModel2 = predicted2))

#confusion matrix to find correct and incorrect predictions
table(Authorship=predicted2, true=test$Author)

#  DT with words taken out
FedPapersCorpus2 <- Corpus(DirSource("C:\\Users\\micha\\OneDrive\\Documents\\IST 707\\HW 4\\FedPapersCorpus"))
(numberFedPapers<-length(FedPapersCorpus2))

getTransformations()

(nFedPapersCorpus2<-length(FedPapersCorpus2))

(minTermFreq <-30)
(maxTermFreq <-1000)

#  Stopwords
(MyStopwords2 <- c("will","one","two", "may","less","publius","Madison","Alexand", "alexand", "james", 
                   "madison", "jay", "hamilton", "jame", "author", "Alexander", "James", "Hamilton","Jay", 
                   "well","might","without","small", "single", "several", "but", "very", "can", "must", 
                   "also", "any", "and", "are", "however", "into", "almost", "can","for", "add", "Author", 
                   "alexander", "people", "peoples" , "author", "authors", "member", "latter", "members", 
                   "alexand", "james" ))
#(STOPS <-stopwords('english'))
FedPapersCorpus2<- tm_map(FedPapersCorpus2, tolower)
FedPapersCorpus2<- tm_map(FedPapersCorpus2, removeWords, MyStopwords)
FedPapersCorpus2<- tm_map(FedPapersCorpus2, removeWords, 
                          c("author", "latter", "members", "constitution", "communiti", "communities", 
                            "long", "act", "alexander", "alexand", "james", "jame", "madison", "hamil", 
                            "hamilton"))

Papers_DTM2 <- DocumentTermMatrix(FedPapersCorpus2,
                                  control = list(
                                    stopwords = TRUE,
                                    wordLengths=c(3, 15),
                                    removePunctuation = T,
                                    removeNumbers = T,
                                    tolower=T,
                                    stemming = T,
                                    remove_separators = T,
                                    stopwords = MyStopwords2,
                                    removeWords=STOPS,
                                    bounds = list(global = c(minTermFreq, maxTermFreq))
                                  ))

DTM2 <- as.matrix(Papers_DTM2)
(DTM2[12:65,1])

#Vectorizing
WordFreq2 <- colSums(as.matrix(Papers_DTM2))
(head(WordFreq2))
(length(WordFreq2))
ord2 <- order(WordFreq2)
(WordFreq2[head(ord2)])
(WordFreq2[tail(ord2)])
(Row_Sum_Per_doc <- rowSums((as.matrix(Papers_DTM2))))

Papers_M2 <- as.matrix(Papers_DTM2)
Papers_M_N12 <- apply(Papers_M2, 1, function(i) round(i/sum(i),3))
Papers_Matrix_Norm2 <- t(Papers_M_N12)
Papers_dtm_matrix2 = as.matrix(Papers_DTM2)
#  Relabeling the data assigning essays to each author
#                  Below we label the data, prepare for modeling, and create some wordclouds
                  ## Also convert to DF
Papers_DF2 <- as.data.frame(as.matrix(Papers_Matrix_Norm2))
Papers_df1_1<- Papers_DF2%>%add_rownames()

names(Papers_df1_1)[1] = "Author"
Papers_df1_1[1:11,1] = "dispt"
Papers_df1_1[12:62,1] = "hamil"
Papers_df1_1[63:65,1] = "ham-mad"
Papers_df1_1[66:70,1] = "jay"
Papers_df1_1[71:85,1 ]="madis"
head(Papers_df1_1, 15)
tail(Papers_df1_1, 20)
Papers_df1_1[62:71,1]  #  Checking row names

#Storing disputed essays in its own dataframe
disputedEssays <- Papers_df1_1[1:11,]

dE_Matrix <- as.matrix(disputedEssays)

#Wordcloud Visualization Hamilton, Madison and Disputed Papers
DisputedPapersWC<- wordcloud(colnames(Papers_dtm_matrix2), Papers_dtm_matrix2[1:11,],
                             rot.per = .35, colors = brewer.pal(n = 8, name = "Dark2"))

(head(sort(as.matrix(WordFreq2[1:11]), decreasing = TRUE), n=50))
#barplot(head(sort(WordFreq2, decreasing = T),11))

HamiltonPapersWC <-wordcloud(colnames(Papers_dtm_matrix2),Papers_dtm_matrix2[12:62,],
                             rot.per = .35, colors = brewer.pal(n = 8, name = "Dark2"))

# #barplot for Hamilton
#barplot(head(sort(WordFreq2[12:62], decreasing = T),20))

(head(sort(as.matrix(Papers_DTM[12:62,])[11,], decreasing = TRUE), n=50))

MadisonPapersWC <-wordcloud(colnames(Papers_dtm_matrix), Papers_dtm_matrix[71:85,], 
                            rot.per = .35, colors = brewer.pal(n = 8, "Dark2"))

(head(sort(as.matrix(Papers_DTM[71:85,])[11,], decreasing = TRUE), n=50))

# #barplot for Madison
#barplot(head(sort(WordFreq2[71:85], decreasing = T),20))

JayPapersWC <- wordcloud(colnames(Papers_dtm_matrix), Papers_dtm_matrix[63:70,], 
                                           rot.per = .35, colors = brewer.pal(n = 8, "Dark2"))
(head(sort(as.matrix(Papers_DTM[63:70,])[70-63,], decreasing = TRUE), n=50))
# #barplot for Jay
#barplot(head(sort(WordFreq2[63:70], decreasing = T),20))

Ham_MadWC <-wordcloud(colnames(Papers_dtm_matrix), Papers_dtm_matrix[60:62,], 
                            rot.per = .35, colors = brewer.pal(n = 8, "Dark2"))
(head(sort(as.matrix(Papers_DTM[60:62,])[3,], decreasing = TRUE), n=50))
# #barplot for Coauthors
#barplot(head(sort(WordFreq2[60:62], decreasing = T),20))

#  Experimental Design
#                  Now that the data is labeled, its time to design an experiment. Below we randomly select a train and test
#                  set for validation using function: sample.int() .

(head(sort(as.matrix(Papers_dtm_matrix)[11,], decreasing = TRUE), n=50))

##Make Train and Test sets
numDisputed = 11
numTotalPapers = nrow(Papers_df1_1)

trainRatio <- .60
set.seed(11) # Set Seed so that same sample can be reproduced in future also

sample <- sample.int(n = numTotalPapers-numDisputed, size = floor(trainRatio*numTotalPapers), replace = F)
newSample = sample + numDisputed 

train <- Papers_df1_1[newSample, ]
test <- Papers_df1_1[-newSample, ]
                                       
# train / test ratio
length(newSample)/nrow(Papers_df1_1)
                                       
#        Classification
#        Repeating above using different parameters

##Decision Tree Models
#Train Tree Model 1
train_tree1 <- rpart(Author ~ ., data = train, method="class", control=rpart.control(cp=0))
summary(train_tree1)
                                       

#predict the test dataset using the model for train tree No. 1
predicted1= predict(train_tree1, test, type="class")
                                       
#plot number of splits
rsq.rpart(train_tree1)

#plot the decision tree
fancyRpartPlot(train_tree1)

#confusion matrix to find correct and incorrect predictions
table(Authorship=predicted1, true=test$Author)

train_tree2 <- rpart(Author ~ ., data = train, method="class", control=rpart.control(cp=0), minsplit = 2, maxdepth = 5) 
(summary(train_tree2))

 #predict the test dataset using the model for train tree No. 1
predicted2= predict(train_tree2, test, type="class")
#plot number of splits
rsq.rpart(train_tree2)

#plot the decision tree
fancyRpartPlot(train_tree2)

#confusion matrix to find correct and incorrect predictions
table(Authorship=predicted2, true=test$Author)


#  DT with words taken out
FedPapersCorpus2 <- Corpus(DirSource("C:\\Users\\micha\\OneDrive\\Documents\\IST 707\\HW 4\\FedPapersCorpus"))
(numberFedPapers<-length(FedPapersCorpus2))

(getTransformations())

(nFedPapersCorpus2<-length(FedPapersCorpus2))

(minTermFreq <-30)
(maxTermFreq <-1000)

#  Stopwords remain the same
#(MyStopwords2 <- c("will","one","two", "may","less","publius","Madison","Alexand", "alexand", "james", 
#                   "madison", "jay", "hamilton", "jame", "author", "Alexander", "James", "Hamilton","Jay", 
#                   "well","might","without","small", "single", "several", "but", "very", "can", "must", 
#                   "also", "any", "and", "are", "however", "into", "almost", "can","for", "add", "Author", 
#                   "alexander", "people", "peoples" , "author", "authors", "member", "latter", "members", 
#                   "alexand", "james" ))
#(STOPS <-stopwords('english'))
FedPapersCorpus2<- tm_map(FedPapersCorpus2, tolower)
FedPapersCorpus2<- tm_map(FedPapersCorpus2, removeWords, MyStopwords)
FedPapersCorpus2<- tm_map(FedPapersCorpus2, removeWords, c("author", "latter", "members", "constitution", "communiti", "communities", "long", "act", "alexander", "alexand", "james", "jame", "madison", "hamil", "hamilton"))

Papers_DTM2 <- DocumentTermMatrix(FedPapersCorpus2,
                                  control = list(
                                    stopwords = TRUE,
                                    wordLengths=c(3, 15),
                                    removePunctuation = T,
                                    removeNumbers = T,
                                    tolower=T,
                                    stemming = T,
                                    remove_separators = T,
                                    stopwords = MyStopwords2,
                                    removeWords=STOPS,
                                    bounds = list(global = c(minTermFreq, maxTermFreq))
                                  ))

DTM2 <- as.matrix(Papers_DTM2)
(DTM[12:65,1])

#Vectorizing
WordFreq2 <- colSums(as.matrix(Papers_DTM2))
(head(WordFreq2))
(length(WordFreq2))
ord2 <- order(WordFreq2)
(WordFreq2[head(ord2)])
(WordFreq2[tail(ord2)])
(Row_Sum_Per_doc <- rowSums((as.matrix(Papers_DTM2))))

Papers_M2 <- as.matrix(Papers_DTM2)
Papers_M_N12 <- apply(Papers_M2, 1, function(i) round(i/sum(i),3))
Papers_Matrix_Norm2 <- t(Papers_M_N12)
Papers_dtm_matrix = as.matrix(Papers_DTM2)


Papers_DFNoJay <- as.data.frame(as.matrix(Papers_Matrix_Norm2))

#remove Jays papers
Papers_DFNoHM<-Papers_DFNoJay[-66:-70,]

# remove Ham Mad papers
Papers_DFHM <- Papers_DFNoJay[63:65]

Papers_DFNoHM <- Papers_DFNoHM%>%add_rownames()

#  Provide row names
names(Papers_DFNoHM)[1]<-"Author"
Papers_DFNoHM[1:11,1] = "dispt"
Papers_DFNoHM[12:62,1] = "hamil"
Papers_DFNoHM[63:80,1] = "madis"

##Make Train and Test sets using higher ratio
trainRatio <- .75
set.seed(11) # Set Seed so that same sample can be reproduced in future also
sampleNoHM <- sample.int(n = nrow(Papers_DFNoHM), size = floor(trainRatio*nrow(Papers_DFNoHM)), replace = FALSE)
trainNoHM <- Papers_DFNoHM[sampleNoHM, ]
testNoHM <- Papers_DFNoHM[-sampleNoHM, ]
# train / test ratio
length(sampleNoHM)/nrow(Papers_DFNoHM)

##Decision Tree Models
#Train Tree Model NoHM
train_treeNoHM <- rpart(Author ~ ., data = trainNoHM, method="class", control=rpart.control(cp=0))
summary(train_treeNoHM)

#predict the test dataset using the model for train tree No. 1
predictedNoHM = predict(train_treeNoHM, testNoHM, type="class")
(ResultsNoHM <- data.frame(Predicted=predictedNoHM,Actual=testNoHM$Author))

#plot number of splits
rsq.rpart(train_treeNoHM)
plotcp(train_treeNoHM)
fancyRpartPlot(train_treeNoHM)

#confusion matrix to find correct and incorrect predictions
table(Authorship=predictedNoHM, true=testNoHM$Author)

#attributed hamilton with disputed

#Train Tree Model 4
train_tree4NoHM <- rpart(Author ~ ., data = trainNoHM, method="class", control=rpart.control(cp=0, minsplit = 2, maxdepth = 5))
summary(train_tree4NoHM)

#predict the test dataset using the model for train tree No. 1
predicted4NoHM = predict(train_tree4NoHM, testNoHM, type="class")
#plot number of splits
rsq.rpart(train_tree4NoHM)
plotcp(train_tree4NoHM)
rpart.plot(train_tree4NoHM)

#confusion matrix to find correct and incorrect predictions
table(Authorship=predicted4NoHM, true=testNoHM$Author)
(Results4NoHM<-data.frame(Predicted=predicted4NoHM, Actual=testNoHM$Author))

#Train Tree 5
train_tree5NoHM <- rpart(Author ~ ., data = trainNoHM, method="class", control=rpart.control(cp=0, minsplit = 5, maxdepth = 7))
summary(train_tree5NoHM)

predicted5NoHM= predict(train_tree5NoHM, testNoHM, type="class")
rsq.rpart(train_tree5NoHM)
plotcp(train_tree5NoHM)
rpart.plot(train_tree5NoHM)
table(Authorship=predicted5NoHM, true = testNoHM$Author)
(Results5NoHM<-data.frame(Predicted=predicted5NoHM, Actual=testNoHM$Author))


##########################
##
## Leaving in HM papers
Papers_DFNoJay <- as.data.frame(as.matrix(Papers_Matrix_Norm2))

#remove Jays papers
Papers_DFNoJay<-Papers_DFNoJay[-66:-70,]

# remove Ham Mad papers
Papers_DFNoJay <- Papers_DFNoJay[63:65]

Papers_DFNoJay<- Papers_DFNoJay%>%add_rownames()

names(Papers_DFNoJay)[1]<-"Author"
Papers_DFNoJay[1:11,1]="dispt"
Papers_DFNoJay[12:65,1]="hamil"
Papers_DFNoJay[66:80,1]="madis"

##Make Train and Test sets
trainRatio <- .75
set.seed(11) # Set Seed so that same sample can be reproduced in future also
sampleNoJay <- sample.int(n = nrow(Papers_DFNoJay), size = floor(trainRatio*nrow(Papers_DFNoJay)), replace = FALSE)
train2NoJay <- Papers_DFNoJay[sampleNoJay, ]
test2NoJay <- Papers_DFNoJay[-sampleNoJay, ]
# train / test ratio
length(sampleNoJay)/nrow(Papers_DFNoJay)

##Decision Tree Models
#Train Tree Model 3 NoJay
train_tree3NoJay <- rpart(Author ~ ., data = train2NoJay, method="class", control=rpart.control(cp=0))
summary(train_tree3NoJay)

#predict the test dataset using the model for train tree No. 1
predicted3NoJay= predict(train_tree3NoJay, test2NoJay, type="class")
(Results3NoJay <- data.frame(Predicted=predicted3NoJay,Actual=test2NoJay$Author))

#plot number of splits
rsq.rpart(train_tree3NoJay)
plotcp(train_tree3NoJay)
fancyRpartPlot(train_tree3NoJay)

#confusion matrix to find correct and incorrect predictions
table(Authorship=predicted3NoJay, true=test2NoJay$Author)

#attributed hamilton with disputed

#Train Tree Model 4
train_tree4NoJay <- rpart(Author ~ ., data = train2NoJay, method="class", control=rpart.control(cp=0, minsplit = 5, maxdepth = 5))
summary(train_tree4NoJay)

#predict the test dataset using the model for train tree No. 1
predicted4NoJay= predict(train_tree4NoJay, test2NoJay, type="class")
#plot number of splits
rsq.rpart(train_tree4NoJay)
plotcp(train_tree4NoJay)
rpart.plot(train_tree4NoJay,cex = .8)

#confusion matrix to find correct and incorrect predictions
table(Authorship=predicted4NoJay, true=test2NoJay$Author)
(Results4NoJay<-data.frame(Predicted=predicted4NoJay, Actual=test2NoJay$Author))

#Train Tree 5
train_tree5NoJay <- rpart(Author ~ ., data = train2NoJay, method="class", control=rpart.control(cp=0, minsplit = 5, maxdepth = 7))
summary(train_tree5NoJay)

predicted5NoJay= predict(train_tree5NoJay, test2NoJay, type="class")
rsq.rpart(train_tree5NoJay)
plotcp(train_tree5NoJay)
rpart.plot(train_tree5NoJay, cex = .8)
table(Authorship=predicted5NoJay, true = test2NoJay$Author)

############################
#  All results

(ResultsAll <- data.frame(Actual=testNoHM$Author, Predicted4NoHM=predicted4NoHM, Predicted5NoHM=predicted5NoHM, 
                          Predicted4NoJay=predicted4NoJay, Predicted3NoJay=predicted3NoJay, Predicted4NoJay=predicted4NoJay, 
                          Predicted5NoHM=predicted5NoHM ))

feds.tree3 <- rpart(Author ~ . , data = train, method = 'class', control = rpart.control(cp = 0, minsplit = 5, maxdepth = 5))

rpart.plot(feds.tree3, cex = 0.8)

#######################
#### Saved 

####  Load Fed Papers Corpus
FedPapersCorpus <- Corpus(DirSource("C:\\Users\\micha\\OneDrive\\Documents\\IST 707\\HW 4\\FedPapersCorpus"))
(numberFedPapers<-length(FedPapersCorpus))

#(summary(FedPapersCorpus))
(meta(FedPapersCorpus[[1]]))

(meta(FedPapersCorpus[[1]],5))

## Cleaning and Preparing
#Choosing some good stop words can really go a long way to improve modeling results. There are also many
#other parameters one can tweak and tune using the DocumentTermMatrix function. See many below.
#Data Preparation and Transformation on Fed Papers

##Remove punctuation,numbers, and space
(getTransformations())

(nFedPapersCorpus<-length(FedPapersCorpus))
(minTermFreq <-30)
(maxTermFreq <-1000)

#  Create a personalized list of stop words
MyStopwords <- c("will","one","two", "may","less","publius","Madison","Alexand", "Alexander", "James", "Hamilton", "Jay","well", "might",
                 "without", "small", "single" ,"several", "but", "very", "can", "must", "also", "any", "and", "are", "however", "into", 
                 "almost", "for", "add", "Author")

STOPS <-stopwords('english')

Papers_DTM <- DocumentTermMatrix(FedPapersCorpus,
                                 control = list(stopwords = TRUE, wordLengths=c(3, 15),
                                                removePunctuation = T, removeNumbers = T,
                                                tolower=T, stemming = T,
                                                remove_separators = T,
                                                stopwords = MyStopwords,
                                                removeWords= c(STOPS,MyStopwords),
                                                removeWords=MyStopwords,
                                                bounds = list(global = c(minTermFreq, maxTermFreq))
                                 ))
##inspect FedPapers Document Term Matrix (DTM)
DTM <- as.matrix(Papers_DTM)
#  Confirming 1st 11 are disputed
#(DTM[1:11,1:10])

##  Vectorization
##Vectorizing words is often done by encoding frequency information. Below we take a peak at the frequency
# of the words. Next some normalization techniques are tried. Which works best . . . ?? Try many and assess
# the results!!!
##Look at word frequencies
WordFreq <- colSums(as.matrix(Papers_DTM))
#(head(WordFreq, 20))
#(length(WordFreq))
ord <- order(WordFreq)
#(WordFreq[head(ord, 20)])

#(WordFreq[tail(ord)])

## Row Sums per Fed Papers
Row_Sum_Per_doc <- rowSums((as.matrix(Papers_DTM)))

## Create a normalized version of Papers_DTM
Papers_M <- as.matrix(Papers_DTM)
Papers_M_N1 <- apply(Papers_M, 1, function(i) round(i/sum(i),3))
Papers_Matrix_Norm <- t(Papers_M_N1)
## Convert to matrix and view
Papers_dtm_matrix = as.matrix(Papers_DTM)
#str(Papers_dtm_matrix)
#(Papers_dtm_matrix[c(1:11),c(2:10)])

#                  Label the Data
#                  Below we label the data, prepare for modeling, and create some wordclouds for fun.
## Also convert to DF
Papers_DF <- as.data.frame(as.matrix(Papers_Matrix_Norm))
Papers_DF1<- Papers_DF%>%add_rownames()

names(Papers_DF1)[1]<-"Author"
Papers_DF1[1:11,1] = "dispt"
Papers_DF1[12:62,1] = "hamil"
Papers_DF1[63:65,1] = "ham-mad"
Papers_DF1[66:70,1] = "jay"
Papers_DF1[71:85,1 ]="madis"
#head(Papers_DF1, 15)
#tail(Papers_DF1, 20)
#Papers_DF1[62:71,1]  #  Checking row names

######  Removing both Jay and HM essays

#str(Papers_DF1)
#remove Jays papers
Papers_DFNoHM<-Papers_DF1[-66:-70,]

#str(Papers_DFNoHM)

# remove Ham Mad papers
Papers_DFNoHM <- Papers_DFNoHM[-63:-65,]

#str(Papers_DFNoHM)

Papers_DF22 <- Papers_DFNoHM

#  remove disputed papers

Papers_DFNoHM <- Papers_DFNoHM[-1:-11,]

#str(Papers_DFNoHM)

#head(Papers_DFNoHM, 15)
#tail(Papers_DFNoHM, 20)
#Papers_DFNoHM[42:61,1] 

##Make Train and Test sets
#  Disputed already removed

trainRatio <- .60
set.seed(11) # Set Seed so that same sample can be reproduced in future also

sampleNoHM <- sample.int(n = nrow(Papers_DFNoHM), size = floor(trainRatio*nrow(Papers_DFNoHM)), replace = F)

trainNoHM <- Papers_DFNoHM[sampleNoHM, ]

testNoHM <- Papers_DFNoHM[-sampleNoHM, ]

# train / test ratio
length(sampleNoHM)/nrow(Papers_DFNoHM)

#        Classification
#        We are now ready to train and test using classifiers. Below we use a few different decision tree models. Try
#        different params and prunings to get varied results.
#        Use fancyRpartPlot to visualize the learned tree models. What do these diagrams display???

##Decision Tree Models
#Train Tree Model 1
train_treeNoHM <- rpart(Author ~ ., data = trainNoHM, method="class", control=rpart.control(cp=0))
summary(train_treeNoHM)


#predict the test dataset using the model for train tree No. 1
predicted1= predict(train_treeNoHM, testNoHM, type="class")

#plot number of splits
rsq.rpart(train_treeNoHM)

## Classification tree:
classTree <- rpart(formula = Author ~ ., data = trainNoHM, method = "class", control = rpart.control(cp = 0))
summary(classTree)

#plot the decision tree
fancyRpartPlot(train_treeNoHM)

#confusion matrix to find correct and incorrect predictions
table(Authorship=predicted1, true=testNoHM$Author)

train_treeNoHM2 <- rpart(Author ~ ., data = trainNoHM, method="class", control=rpart.control(cp=0), minsplit = 2, maxdepth = 5) 
(summary(train_treeNoHM2))

#predict the test dataset using the model for train tree No. 1
predicted2= predict(train_treeNoHM2, testNoHM, type="class")
(ResultsP2Disp <- data.frame(Predicted=predicted2,Actual=testNoHM$Author))

#plot number of splits
rsq.rpart(train_treeNoHM2)

#plot the decision tree
fancyRpartPlot(train_treeNoHM2)

#confusion matrix to find correct and incorrect predictions
table(Authorship=predicted2, true=testNoHM$Author)

#  Comparing disputed against 
#predict the disputed dataset using the model for train tree No. 1

disputed <- Papers_DF1[1:11,]
#str(disputed)
predictedDisp= predict(train_treeNoHM2, Papers_DF22, type="class")
head(ResultsPDisp <- data.frame(Predicted=predictedDisp,Actual=Papers_DF22$Author),20)

#plot the decision tree
fancyRpartPlot(train_treeNoHM2)

#confusion matrix to find correct and incorrect predictions
table(Authorship=predictedDisp, true=Papers_DF22$Author)

