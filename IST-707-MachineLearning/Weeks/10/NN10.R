# Code courtesy of https://rpubs.com/meisenbach/284590 by Mei Eisenbach

#install.packages("readr")
#install.packages("randomForest")
#install.packages("nnet")
library(readr)
library(randomForest)
library(nnet)

setwd("C:\\Users\\gregb\\OneDrive\\git\\iSchool\\ist707\\Weeks\\10")
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
plotTrain <- function(images, ds, labels){
  op <- par(no.readonly=TRUE)
  x <- ceiling(sqrt(length(images)))
  par(mfrow=c(x, x), mar=c(.1, .1, .1, .1))
  
  for (i in images){ #reverse and transpose each matrix to rotate images
    m <- matrix(data.matrix(ds[i,-1]), nrow=28, byrow=TRUE)
    m <- apply(m, 2, rev)
    image(t(m), col=grey.colors(255), axes=FALSE)
    text(0.05, 0.2, col="white", cex=1.2, labels[i])
  }
  par(op) #reset the original graphics parameters
}

test_orig_36 <- test_orig[1:36,]
test_orig_36$label <- c(2,0,9,0,3,7,0,3,0,3,5,7,4,0,4,3,3,1,9,0,9,1,1,5,7,4,2,7,4,7,7,5,4,2,6,2)

# Now let's use this function to look at the first 36 images. You can look at
# many images if you wanted too, e.g., plotTrain(1001:1100)
plotTrain(1:36, train_orig, train_orig$label)
plotTrain(1:36, test_orig_36, test_orig_36$label)

# first we are going to try a random forest
numTrees <- 25
# Train on entire training dataset and predict on the test
startTime <- proc.time()
rf <- randomForest(train_orig[-1], train_orig_labels, xtest=test_orig, ntree=numTrees)
proc.time() - startTime

##   user  system elapsed 
## 165.52    6.52  207.74

print(rf)
plot(rf,type="l")

## 
## Call:
##  randomForest(x = train_orig[-1], y = train_orig_labels, xtest = test_orig,      ntree = numTrees) 
##                Type of random forest: classification
##                      Number of trees: 25
## No. of variables tried at each split: 28
## 
##         OOB estimate of  error rate: 6.28%
## Confusion matrix:
##      0    1    2    3    4    5    6    7    8    9 class.error
## 0 4039    1    7   12    4   13   27    4   21    4  0.02250726
## 1    0 4588   25   20    5   11    5    8   14    8  0.02049530
## 2   27   20 3905   50   27   13   27   51   43   14  0.06511851
## 3   14   11   89 3905    9  124   14   43   96   46  0.10250517
## 4    7    6   19    3 3829    6   27   16   30  129  0.05967583
## 5   31   10   12  116   16 3457   46   11   63   33  0.08906456
## 6   32   10   16    6   20   37 3994    0   19    3  0.03456611
## 7   11   20   60   27   28    7    1 4149   12   86  0.05725971
## 8   20   26   37   88   35   73   29   14 3665   76  0.09795717
## 9   24    5   16   49  108   35    8   55   55 3833  0.08476600

# output predictions for submission
predictions <- data.frame(ImageId=1:nrow(test_orig), 
  Label=levels(train_orig_labels)[rf$test$predicted])
head(predictions)

##   ImageId Label
## 1       1     2
## 2       2     0
## 3       3     9
## 4       4     4
## 5       5     3
## 6       6     7

rotate <- function(x) t(apply(x, 2, rev)) # reverses (rotates the matrix)

par(mfrow=c(2,3)) # Plotting in 2*3 format (random forest)
lapply(1:6, 
       function(x) image( #norow = 28 because this is 28 pixel image
         rotate(matrix(unlist(test_orig[x,]),nrow = 28,byrow = T)),
         col=grey.colors(255),
         xlab=predictions[x,2]
       )
)

plotTrain(1:36, test_orig_36, predictions$Label)
predictions_36 <- predictions[1:36,2]
accuracy <- mean(predictions_36 == test_orig_36$label)
print(paste('Accuracy:', accuracy))

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
nn = nnet(train_norm, train_labels_matrix, size = 1, softmax = TRUE)

## # weights:  805
## initial  value 71631.780715 
## iter  10 value 64946.553191
## iter  20 value 57294.824640
## iter  30 value 55912.804141
## iter  40 value 54648.757612
## iter  50 value 53950.781576
## iter  60 value 52927.199756
## iter  70 value 52291.634751
## iter  80 value 51967.602466
## iter  90 value 51774.654787
## iter 100 value 51643.951402
## final  value 51643.951402 
## stopped after 100 iterations
proc.time() - startTime

##    user  system elapsed 
##   46.97    0.13   47.54
nn

## a 784-1-10 network with 805 weights
## options were - softmax modelling

# This is just to try out the nnet function. One hidden node is mostly likely
# not enough for the model. "softmax" should be set to TRUE when performing
# classification. The default maximum number of iterations is 100. The algorithm
# did not converge before reaching the maximum. It ran for 46 seconds.
# get predictions

pred = predict(nn, test_norm, type="class")
cbind(head(pred), head(test_labels))
##   head(pred) label
## 1          1     8
## 2          1     3
## 3          1     8
## 4          1     0
## 5          1     3
## 6          7     4

# The first six predictions do not look very good.

# evaluate the model
accuracy <- mean(pred == test_labels)
print(paste('Accuracy:', accuracy))

## [1] "Accuracy: 0.206174113165622"

par(mfrow=c(2,3)) # Plotting in 2*3 format (neural net)
lapply(1:6, 
       function(x) image( #norow = 28 because this is 28 pixel image
         rotate(matrix(unlist(test_orig[x,]),nrow = 28,byrow = T)),
         col=grey.colors(255),
         xlab=pred[x]
       )
)

