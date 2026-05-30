# install.packages('wordcloud')
# install.packages('tm')
# install.packages('slam') 
# install.packages('quanteda')
# install.packages('SnowballC') 
# install.packages('arules')
# install.packages('proxy')
# install.packages('cluster')
# install.packages('stringi') 
# install.packages('Matrix')
# install.packages('tidytext')
# install.packages('plyr')
# install.packages('ggplot2')
# install.packages('factoextra')
# install.packages('mclust')
# install.packages('dplyr')
# install.packages('rdwplus')
# install.packages('corpus')

library(wordcloud)
library(tm)
library(slam) 
library(quanteda)
library(SnowballC) 
library(arules)
library(proxy)
library(cluster)
library(stringi) 
library(Matrix)
library(tidytext)
library(plyr)
library(ggplot2)
library(factoextra)
library(mclust)
library(dplyr)
library(rdwplus)
library(corpus)

# setwd("C:/Users/HQRGRS27/OneDrive/Courses/Syracuse/IST707/Homework/04/")
FederalistPapers <- read.csv("fedPapers85.csv", row.names = 2, na.strings = c(""))

# Create backup of FederalistPapers in case it's needed
FederalistPapers_Orig <- FederalistPapers

# Check for NAs and missing values
sum(is.na(FederalistPapers))
FederalistPapers <- FederalistPapers[,-1]
# first, remove the file and author names for a word cloud gallery
FedPapers_wc <- as.matrix(as.dfm(FederalistPapers)) #FederalistPapers[,3:72]
hamPapers = FedPapers_wc[12:62,]
DisputedPapersWC <- wordcloud(colnames(FedPapers_wc), FedPapers_wc[11,], 
                              rot.per = .35, colors = brewer.pal(n = 8, name = "Dark2"))
HamiltonPapersWC <- wordcloud(colnames(FedPapers_wc), FedPapers_wc[12:62,],
                              rot.per = .35, colors = brewer.pal(n = 8, name = "Dark2"))

MadisonPapersWC <- wordcloud(colnames(FedPapers_wc), FedPapers_wc[71:85,],
                             rot.per = .35, colors = brewer.pal(n = 8, name = "Dark2"))
JayPapersWC <- wordcloud(colnames(FedPapers_wc), FedPapers_wc [66:70,],
                         rot.per = .35, colors = brewer.pal(n = 8, name = "Dark2"))

# K means
#  Need to clean the data by removing the labels and determining the 
# optimal numbers of clusters for the clustering algorithm. 

# Remove author names from dataset for clustering purposes
FederalistPapers <- read.csv("fedPapers85.csv", na.strings = c(""))

# Make the file names the row names. Need a dataframe of numerical values for k-means
FedPapers_km <- FederalistPapers[,2:72]
# Make the file names the row names. Need a dataframe of numerical values for k-means
rownames(FedPapers_km) <- FedPapers_km[,1]
FedPapers_km[,1] <- NULL


# Set seed for fixed random seed
set.seed(20)

# run k-means
Clusters <- kmeans(FedPapers_km, 6)
FedPapers_km$Clusters <- as.factor(Clusters$cluster)
str(Clusters)
Clusters$centers[]

# Add clusters to dataframe original dataframe with author name
FedPapers_km2 <- FederalistPapers
FedPapers_km2$Clusters <- as.factor(Clusters$cluster)
# Plot results
clusplot(FedPapers_km, FedPapers_km$Clusters, color=TRUE, shade=TRUE, labels=0, lines=0)

clusplot(FedPapers_km, FedPapers_km$Clusters, color=TRUE, shade=TRUE, labels=0, lines=T)

# word clouds based on authorship

#Loop
cluster_loop <- c(2,3,4,5,6,7,8,9)
set.seed(20)
for (x in cluster_loop){
  print(x)
  # run k-means
  Clusters <- kmeans(FedPapers_km, x)
  FedPapers_km$Clusters <- as.factor(Clusters$cluster)
  str(Clusters)
  #print(Clusters$centers)
  # Plot results
  clusplot(FedPapers_km, FedPapers_km$Clusters, color=T, shade=T, labels=4, lines=T)
}

## Hierachical Clustering Algorithms (HAC)

# Remove author names from dataset
FedPapers_HAC <- FederalistPapers[,c(2:72)]

# Make the file names the row names. Need a dataframe of numerical values for HAC
rownames(FedPapers_HAC) <- FedPapers_HAC[,1]
FedPapers_HAC[,1] <- NULL
View(FedPapers_HAC)

# Calculate distance in a variety of ways
distance <- dist(FedPapers_HAC, method = "euclidean")
distance2 <- dist(FedPapers_HAC, method = "maximum")
distance3 <- dist(FedPapers_HAC, method = "manhattan")
distance4 <- dist(FedPapers_HAC, method = "canberra")
distance5 <- dist(FedPapers_HAC, method = "binary")
distance6 <- dist(FedPapers_HAC, method = "minkowski", p = 3)

Clusters1 <- kmeans(FedPapers_km, 9)
FedPapers_km2$Clusters <- as.factor(Clusters1$cluster)
str(Clusters)

ggplot(data=FedPapers_km2, aes(x=author, fill=Clusters))+
  geom_bar(stat="count") +
  labs(title = "K = ?") +
  theme(plot.title = element_text(hjust=0.5), text=element_text(size=15))

#  Madison essays
Madison_Leaning <- FederalistPapers[which(FedPapers_km2$Clusters[c(1:11)]== 8 | FedPapers_km$Clusters[c(1:11)]== 4 | FedPapers_km$Clusters[c(1:11)]== 3),2]
Madison_Leaning


#  A loop to plot multiple HACs
hac_loop <- c(2,3,4,5,6,7,8,9)
for (y in hac_loop) {
  HAC <- hclust(distance, method="complete")
  plot(HAC, cex=0.6, hang=-1, main = c("HAC Cluster Euclidean Complete", y, "Clusters"))
  rect.hclust(HAC, k = y, border=2:5)

  HACSingle <- hclust(distance, method="single")
  plot(HACSingle, cex=0.6, hang=-1, main = c("HAC Cluster Euclidean Single", y, "Clusters"))
  rect.hclust(HACSingle, k = y, border=2:5)
  
  HAC2 <- hclust(distance2, method="complete")
  plot(HAC2, cex=.1, hang=-1, main = c("HAC Cluster Maximum Complete", y, "Clusters"))
  rect.hclust(HAC2, k =y, border=2:5)
  
  HAC3 <- hclust(distance3, method="complete")
  plot(HAC3, cex=0.6, hang=-1, main = c("HAC Cluster Manhattan Complete", y, "Clusters"))
  rect.hclust(HAC3, k =y, border=2:5)

  HAC4 <- hclust(distance4, method="complete")
  plot(HAC4, cex=0.6, hang=-1, main = c("HAC Cluster Canberra Complete", y, "Clusters"))
  rect.hclust(HAC4, k =y, border=2:5)
  
  HAC5 <- hclust(distance5, method="complete")
  plot(HAC5, cex=0.6, hang=-1, main = c("HAC Cluster Minkowski Complete", y, "Clusters"))
  rect.hclust(HAC5, k =y, border=2:5)
  
  HAC6 <- hclust(distance6, method="complete")
  plot(HAC6, cex=0.6, hang=-1, main = c("HAC Cluster Maximum Complete", y, "Clusters"))
  rect.hclust(HAC6, k =y, border=2:5)
}


#  Other analysis
#  Load Data (as Corpus).
#  In this example, we will load the data in corpus form. We will need to do much of the data cleaning, text processing, ourselves.
###Load Fed Papers Corpus
FedPapersCorpus <- Corpus(DirSource("FedPapersCorpus"))
(numberFedPapers<-length(FedPapersCorpus))

##The following will show you that you read in all the documents
(summary(FedPapersCorpus))

# Data Cleaning
# Here we investigate the data and vectorize it using DocumentTermMatrix. 
# We will ignore very infrequent words and very frequent words during the vectorization process. 
# Note: The DocumentTermMatrix method will perform much data cleaning for us.
# Data Preparation and Transformation on Fed Papers
# Remove punctuation,numbers, and space
(getTransformations())
(nFedPapersCorpus<-length(FedPapersCorpus))

### ignore extremely rare words i.e. terms that appear in less then 1% of the documents
(minTermFreq <- nFedPapersCorpus * 0.0001)
(minTermFreqNum <- 30)  #  min terms as a number

###Ignore overly common words i.e. terms that appear in more than 50% of the documents
(maxTermFreq <- nFedPapersCorpus * 1)
(maxTermFreqNum <- 1000)  # max terms as a number

MyStopwords <- c("will","one","two", "may","less", "well","might","withou","small", "single", "several",
                 "but", "very", "can", "must", "also", "very", "can", "any", "and", "are", "however",
                 "into", "almost", "can","for","add")

(STOPS <-stopwords('english'))
Papers_DTM <- DocumentTermMatrix(FedPapersCorpus, control = list( stopwords = TRUE, wordLengths=c(3, 15), 
                                                                  removePunctuation = T, removeNumbers = T, tolower=T, stemming = T, remove_separators = T, 
                                                                  stopwords = MyStopwords, bounds = list(global = c(minTermFreq, maxTermFreq)) ))

# use the "built-in" STOP words
#inspect FedPapers Document Term Matrix (DTM)
DTM <- as.matrix(Papers_DTM)
(DTM[1:11,1:10])

# Inspect Initial Cleaning Results
# Look at word freuquncies
WordFreq <- colSums(as.matrix(Papers_DTM))
(head(WordFreq))	

(length(WordFreq))	

ord <- order(WordFreq) 
(WordFreq[head(ord)])	

(WordFreq[tail(ord)])	

(Row_Sum_Per_doc <- rowSums((as.matrix(Papers_DTM))))	

# Normalization
# Create a normalized version of Papers_DTM
Papers_M <- as.matrix(Papers_DTM)
Papers_M_N1 <- apply(Papers_M, 1, function(i) round(i/sum(i),3))
Papers_Matrix_Norm <- t(Papers_M_N1)
(Papers_M[c(1:11),c(1000:1010)])
Terms

(Papers_Matrix_Norm[c(1:11),c(1000:1010)])

# Data Structures
# Convert to matrix and view
Papers_dtm_matrix = as.matrix(Papers_DTM) 
str(Papers_dtm_matrix)

(Papers_dtm_matrix[c(1:11),c(2:10)])

#Also convert to DF
Papers_DF <- as.data.frame(as.matrix(Papers_DTM)) 
str(Papers_DF)				

(Papers_DF$abolit)

(nrow(Papers_DF))	## Each row is Paper

#  Add row names
Papers_DF1<- Papers_DF%>%add_rownames()
names(Papers_DF1)[1]<-"Author"
Papers_DF1[1:11,1]="dispt"
Papers_DF1[12:65,1]="hamil"
Papers_DF1[66:70,1]="jay"
Papers_DF1[71:85,1]="madis"
head(Papers_DF1[,1:2],20)
tail(Papers_DF1[,1:2],20)

#################
# Example Word Cloud
#################
# Wordcloud Visualization Hamilton, Madison and Disputed Papers

DisputedPapersWC<- wordcloud(colnames(Papers_dtm_matrix), Papers_dtm_matrix[11, ],
                             rot.per = .35, colors = brewer.pal(n = 8, name = "Dark2"))

(head(sort(as.matrix(Papers_DTM)[11,], decreasing = TRUE), n=50))

HamiltonPapersWC <- wordcloud(colnames(Papers_dtm_matrix), Papers_dtm_matrix[12:65, ],
                              rot.per = .35, colors = brewer.pal(n = 8, name = "Dark2"))
MadisonPapersHW <- wordcloud(colnames(Papers_dtm_matrix), Papers_dtm_matrix[71:85, ],
                             rot.per = .35, colors = brewer.pal(n = 8, name = "Dark2"))
JayPapersHW <- wordcloud(colnames(Papers_dtm_matrix), Papers_dtm_matrix[66:70, ],
                         rot.per = .35, colors = brewer.pal(n = 8, name = "Dark2"))
DisputedWC <- wordcloud(colnames(Papers_dtm_matrix), Papers_dtm_matrix[1:11, ],
                              rot.per = .35, colors = brewer.pal(n = 8, name = "Dark2"))

##################
# Analysis
##################
# Distance Metrics
##################
#Computing different distance matrices to determine which seems to work the best!
###Distance Measure 
m <- Papers_dtm_matrix 
m_norm <- Papers_Matrix_Norm
#m <- [1:2, 1:3] 
distMatrix_E <- dist(m, method="euclidean")
#print(distMatrix_E) 
distMatrix_M <- dist(m, method="manhattan")
#print(distMatrix_M) 
distMatrix_C <- dist(m, method="cosine")
#  print(distMatrix_C) 
distMatrix_C_norm <- dist(m_norm, method="cosine")
#print(distMatrix_C_norm)

###################
## Clustering
###################
###Clustering Methods:
## HAC: Hierarchical Algorithm Clustering Method 
## Euclidean
groups_E <- hclust(distMatrix_E,method="ward.D")
plot(groups_E, cex=0.5, font=22, hang=-1, main = "HAC Cluster Dendrogram with Euclidean Similarity")

#  Plots the separations
rect.hclust(groups_E, k=2)

#HAC Cluster Dendrogram with Euclidean Similarity
distMatrix_E1 <- hclust(distMatrix_E, "ward.D2")
plot(distMatrix_E1, cex=0.5, font=22, hang=-1, main = "HAC Cluster Dendrogram with Euclidean Similarity #2")
rect.hclust(distMatrix_E1, k=2)

#  HAC Cluster Dendrogram with Cosine Similarity
groups_C <- hclust(distMatrix_C,method="ward.D")
plot(groups_C, cex=0.5,font=22, hang=-1,main = "HAC Cluster Dendrogram with Cosine Similarity")
rect.hclust(groups_C, k=6)

## Cosine Similarity for Normalized Matrix
groups_C_n <- hclust(distMatrix_C_norm,method="ward.D")
plot(groups_C_n, cex=0.5, font=22, hang=-1, main = "HAC Cluster Dendrogram with Cosine Similarity Normalized Matrix")
rect.hclust(groups_C_n, k=2)

#####################
# k means clustering Methods 
#####################

X <- m_norm
k2 <- kmeans(X, centers = 2, nstart = 100, iter.max = 50) 
str(k2)

k3 <- kmeans(X, centers = 7, nstart = 50, iter.max= 50) 
str(k3)

# k means visualization results
distance1 <- get_dist(X,method = "manhattan")
fviz_dist(distance1, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

distance2 <- get_dist(X,method = "euclidean")
fviz_dist(distance2, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

distance3 <- get_dist(X,method = "spearman")
fviz_dist(distance3, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07", title= "Distance"))

#  Visualize the k-means results 
str(X)
kmeansFIT_1 <- kmeans(X, centers = 4)
summary(kmeansFIT_1)

#Loop to be fancy
x <- c(2,3,4,5,6,7,8,9)
set.seed(20)
for (val in x){
  print(val)
  # run k-means
  Clusters <- kmeans(FedPapers_km, val)
  FedPapers_km$Clusters <- as.factor(Clusters$cluster)
  str(Clusters)
  Clusters$centers
  
  # Add clusters to dataframe original dataframe with author name
  FedPapers_km2 <- FederalistPapers
  FedPapers_km2$Clusters <- as.factor(Clusters$cluster)
  # Plot results
  #clusplot(FedPapers_km, FedPapers_km$Clusters, color=TRUE, shade=TRUE, labels=0, lines=0)
  
  clusplot(FedPapers_km, FedPapers_km$Clusters, color=T, shade=T, labels=4, lines=T)
  
  }

#Cosine Assignment of essays

plot(groups_C, main = "Fed Paper Cosine Clustering", cex = 0.5)
rect.hclust(groups_C, k=6)

authorCut <- cutree(groups_C, k = 6)

(Madison_cos <- FedPapers_km2[which((authorCut == "1") & FedPapers_km2$author == "dispt") ,c(1,2)])

(Hamilton_cos <- FedPapers_km2[which((authorCut == "2") & FedPapers_km2$author == "dispt") ,c(1,2)])
