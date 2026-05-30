# Code courtesy of https://rpubs.com/meisenbach/284590 by Mei Eisenbach

library(readr)
library(randomForest)
library(nnet)
library(caret)

# setwd("C:/Users/gregb/OneDrive/git/iSchool/ist707/Homework/11")

train_orig <- read_csv("digit_train.csv")
test_orig <- read_csv("digit_test.csv")

# save the training labels
train_orig_labels <- train_orig[, 1]
train_orig_labels <- as.factor(train_orig_labels$label)
summary(train_orig_labels)

barplot(table(train_orig[,1]), col=rainbow(10, 0.5), main="n Digits in Train")

# There is around 4000 observations for each digit. Each row has 784 columns
# (pixels) which form a 28x28 image. Let's see what the handwritten digits look
# like by plotting them. Here is a function to plot a selection of digits from
# the train dataset.
plotTrain <- function(images){
  op <- par(no.readonly=TRUE)
  x <- ceiling(sqrt(length(images)))
  par(mfrow=c(x, x), mar=c(.1, .1, .1, .1))
  
  for (i in images){ #reverse and transpose each matrix to rotate images
    m <- matrix(data.matrix(train_orig[i,-1]), nrow=28, byrow=TRUE)
    m <- apply(m, 2, rev)
    image(t(m), col=grey.colors(255), axes=FALSE)
    text(0.05, 0.2, col="white", cex=1.2, train_orig[i, 1])
  }
  par(op) #reset the original graphics parameters
}

# Now let's use this function to look at the first 36 images. You can look at
# many images if you wanted too, e.g., plotTrain(1001:1100)
plotTrain(1:36)


# split the training data into train and test to do local evaluation
set.seed(123)
rows <- sample(1:nrow(train_orig), as.integer(0.7*nrow(train_orig)))

# Get train and test labels
train_labels <- train_orig[rows, 1]
test_labels <- train_orig[-rows, 1]

# convert the labels to factors
train_labels <- as.factor(train_labels$label)

# custom normalization function
normalize <- function(x) { 
  return(x / 255)
}

# create the train and test datasets and apply normalization
train_norm <- as.data.frame(lapply(train_orig[rows, -1], normalize))
test_norm <- as.data.frame(lapply(train_orig[-rows,-1], normalize))


# check a random pixel to see if the normalization worked
summary(train_orig$pixel350)

##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    0.00    0.00    0.00   89.51  228.00  255.00

summary(train_norm$pixel350)

##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
## 0.000000 0.000000 0.003922 0.350500 0.890200 1.000000

summary(test_norm$pixel350)

##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.0000  0.0000  0.0000  0.3521  0.9059  1.0000

# create the class indicator matrix
train_labels_matrix = class.ind(train_labels)
head(train_labels)

## [1] 2 2 9 2 8 7
## Levels: 0 1 2 3 4 5 6 7 8 9

head(train_labels_matrix)
##      0 1 2 3 4 5 6 7 8 9
## [1,] 0 0 1 0 0 0 0 0 0 0
## [2,] 0 0 1 0 0 0 0 0 0 0
## [3,] 0 0 0 0 0 0 0 0 0 1
## [4,] 0 0 1 0 0 0 0 0 0 0
## [5,] 0 0 0 0 0 0 0 0 1 0
## [6,] 0 0 0 0 0 0 0 1 0 0

# train model
set.seed(123)
startTime <- proc.time()
nn = nnet(train_norm, train_labels_matrix, size = 15, MaxNWts = 11935,softmax = TRUE)
# weights:  11935
# initial  value 77652.264787 
# iter  10 value 25689.721754
# iter  20 value 11783.111226
# iter  30 value 7601.432558
# iter  40 value 6292.938229
# iter  50 value 4694.783429
# iter  60 value 3507.892804
# iter  70 value 2824.075657
# iter  80 value 2365.522255
# iter  90 value 2049.536331
# iter 100 value 1809.000375
# final  value 1809.000375 
proc.time() - startTime

##    user  system elapsed 
##   46.97    0.13   47.54
nn

## a 784-15-10 network with 11935 weights
## options were - softmax modelling

# This is just to try out the nnet function. One hidden node is mostly likely
# not enough for the model. "softmax" should be set to TRUE when performing
# classification. The default maximum number of iterations is 100. The algorithm
# did not converge before reaching the maximum. It ran for 46 seconds.
# get predictions

pred = predict(nn, test_norm, type="class")
cbind(head(pred), head(test_labels))
# 1          9     9
# 2          2     2
# 3          0     0
# 4          6     6
# 5          9     9
# 6          1     1

# The first six predictions look good.

# evaluate the model
accuracy <- mean(pred == test_labels)
print(paste('Accuracy:', accuracy))

## [1] "Accuracy: 0.915244821839537"

par(mfrow=c(2,3)) # Plotting in 2*3 format (neural net)
lapply(1:6, 
       function(x) image( #norow = 28 because this is 28 pixel image
         rotate(matrix(unlist(test_orig[x,]),nrow = 28,byrow = T)),
         col=grey.colors(255),
         xlab=pred[x]
       )
)

plotTest <- function(images){
  op <- par(no.readonly=TRUE)
  x <- ceiling(sqrt(length(images)))
  par(mfrow=c(x, x), mar=c(.1, .1, .1, .1))
  
  for (i in images){ #reverse and transpose each matrix to rotate images
    m <- matrix(data.matrix(test_norm[i,-1]), nrow=28, byrow=TRUE)
    m <- apply(m, 2, rev)
    image(t(m), col=grey.colors(255), axes=FALSE)
    text(0.05, 0.2, col="white", cex=1.2, test_labels[i, 1])
  }
  par(op) #reset the original graphics parameters
}

plotTest(1:36)
