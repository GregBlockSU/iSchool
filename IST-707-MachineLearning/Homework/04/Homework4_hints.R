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
