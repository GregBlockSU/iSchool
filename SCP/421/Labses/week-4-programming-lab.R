# IST 421 Week 4
# Dr. Gregory Block

# be sure to install ggplot2
# install.packages("ggplot2")
library("ggplot2")

# create dummy data to illustrate the ggplot colors
data <- data.frame(x = 1:9, y = 1:9)

# data is a data frame with 9 rows and 2 columns
data

# create a plot using the default ggplot2 colors
# note that the graph is created and assigned to the
# variable ggp; to display the graph, we simply "inspect"
# the ggp variable

ggp <- ggplot(data, aes(x, y, col = factor(x))) + 
  geom_point(size = 10)
ggp 

# be sure to install ggplot2
# install.packages("RColorBrewer")
library("RColorBrewer")

# add the scale colors to our ggp graph and display
# using a variety of palettes
ggp + scale_colour_brewer(palette = 3)

ggp + ?scale_colour_brewer(palette = 7)


# If a string, will use that named palette. If a number, will index into the
# list of palettes of appropriate type. The list of available palettes can found
# in the Palettes section. E.g. Blues, BuGn, BuPu, GnBu, Greens, Grey

ggp + scale_colour_brewer(palette = 'Blues')

ggp + scale_colour_brewer(palette = 'Greens')


# display all the palettes
display.brewer.all(colorblindFriendly = TRUE)

# Generate some data
set.seed(133)
df <- data.frame(xval=rnorm(50), yval=rnorm(50))

# Make color depend on yval
ggplot(df, aes(x=xval, y=yval, colour=yval)) + 
  geom_point()

# load the mtcars data frame
data(mtcars)
p <- ggplot(mtcars, aes(wt, mpg))
p + geom_point()

# set the color to the # of cylinders
p + geom_point(aes(colour = factor(cyl)))

# set the shape to the # of cylinders
p <- ggplot(mtcars, aes(mpg, wt, shape = factor(cyl))) +
  geom_point(aes(colour = factor(cyl)), size = 4) +
  geom_point(colour = "grey45", size = 1)

p

# using gradient values based on the dat
# set the seed to ensure the random distribution is the same each time
set.seed(1234)

# generate the data; x has 200 observations with the
# followig shape

x <- rnorm(200)

# Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
# -2.85576 -0.77408 -0.17189 -0.05776  0.55326  3.04377 

length(x)
summary(x)

# create a basic  histogram from x
hist<-qplot(x =x, fill=-..count.., geom="histogram") 

#display it
hist

# note the color density matches the frequency of
# occurrences - the highest frequency (in the center
# of the histogram) is the darkest color; this is
# achieved by setting the fill parameter to the negative
# of the frequency (e.g. -..count..)

# change the color scheme to sequential gradient, with
# the low frequency in green, shifting to red as 
# the frequency increases
hist + scale_fill_gradient(low="red", high="green")

# load the tidyverse and gghilight libraries
#install.packages('tidyverse')
#install.packages('gghighlight')
library(tidyverse)
library(gghighlight)

# set the theme to black & white

# The current/active theme (see theme()) is automatically applied to every plot
# you draw. Use theme_get() to get the current theme, and theme_set() to
# completely override it. theme_
?theme_set
theme_set(theme_bw())

#load the iris data frame
data(iris)
summary(iris)

# draw a histogram of the iris length, using the
# species as the fill color
ggplot(iris, aes(Sepal.Length, fill = Species)) +
  geom_histogram(bins = 30)

# change the color palette to viridis; The viridis scales provide colour maps
# that are perceptually uniform in both colour and black-and-white. They are
# also designed to be perceived by viewers with common forms of colour
# blindness. 

ggplot(iris, aes(Sepal.Length, fill = Species)) +
  geom_histogram(bins = 30) +
  scale_fill_viridis_d() 

# the facet wrap will generate a separate graph per species
ggplot(iris, aes(Sepal.Length, fill = Species)) +
  geom_histogram(bins = 30) +
  scale_fill_viridis_d() +
  facet_wrap(~ Species)

# now we can highlight the adjoining bars across all facets
ggplot(iris, aes(Sepal.Length, fill = Species)) +
  geom_histogram(bins = 30) +
  scale_fill_viridis_d() +
  gghighlight() + 
  facet_wrap(~ Species)
  
