# IST 421 Weel 5
# Dr. Gregory Block

# load the mtcars dataset
data(mtcars)

# clear the plots window
dev.off()

# create a 2x2 grid for charts
# then create a compount plot of 4 boxplots using the MPG variable and transmission,
# transmission type, # of cylinders, horse power, and # of gears
par(mfrow=c(2,2))
boxplot(mpg ~ am, data = mtcars, col = "pink", main = "Transmission", ylab=NULL, xlab="(Manual/Automatic)")
boxplot(mpg ~ cyl, data = mtcars, col = "yellow", main = "Cylinders", ylab=NULL, xlab="(number)")
boxplot(mpg ~ hp, data = mtcars, col = "blue", main = "Horsepower", ylab=NULL, xlab="(units)")
boxplot(mpg ~ gear, data = mtcars, col = "orange", main = "Gears", ylab=NULL, xlab="(count)")

# add a shared title
mtext(~ bold("Motor Trend Cars - MPG"), side=3, col="blue", line=-1.5,outer=TRUE)
par(mfrow=c(1,1))

# create 3 charts on a facet
dev.off()
library(ggplot2)
ggplot(iris, aes(Sepal.Length, fill = Species)) +
  geom_histogram(bins = 20) +
  scale_fill_viridis_d() +
  facet_wrap(~ Species)

# Create a single plot with a pink background,and a legend
# with a blue title
IrisPlot <- ggplot(iris, aes(Sepal.Length, Petal.Length, colour=Species)) + 
  geom_point() + 
  theme(legend.title = element_text(color = "blue", size = 10, face = "bold")) +
  geom_point(color="firebrick") +
  theme(plot.background = element_rect(fill = 'pink'))
print(IrisPlot)

ggplot(iris, aes(x = Sepal.Length)) +
  geom_density(aes(fill = Species))

# create a plot using the species of iris as the color marker
ggplot(iris, aes(x = Sepal.Length)) +
  geom_density(aes(color=Species)) +
  facet_wrap(~Species)
