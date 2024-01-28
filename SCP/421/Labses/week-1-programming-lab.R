# IST 421 Lab 1
# Dr. Gregory Block

# R basics
# any line that starts with the '#' symbol is a comment

# a statement is a line in an R program that can be executed; you can
# execute a statement using the Run button

# the line below is a statement; the statement assigns a value, .75
# to a variable named m using the assignment operator, <-

m <- .75

# a variable is a named symbol in an R program that stores a value; 
# in this case, the symbol is named 'm' and the value it stores is .75

# you can display the value that this variable stores by using it as a statement

m

# the value stored in the symbol 'm' is displayed in the R console window;
# you can also enter statements in the R console window, and the statements
# are executed when you press the Enter key

# a few more simple statements
x <- 10
b <- 7

# how would you display the values of x and b?

# a formula; the '*' symbol and the '+' symbols are 'operators' you can 
# use to perform a mathematical operation; the assignment operator '<-' 
# assigns the results of the operation to the variable 'y'

y <- m * x + b

y

# y is 14.5

# R Studio is a program editor that allows you to enter lines into a text file,
# open a text file and execute the lines it contains; it is important to save
# the text file frequently; the file is saved in the file system

# more sophisticated operations are encapsulated in blocks of statements called
# functions; functions are similar to formulas in Excel; each formula (or function)
# has a name, accepts additional inputs (called parameters) and can provide a value
# as a result; for example, there is an Excel formula called SQRT that accepts a
# numeric value as an input, such as SQRT(25); R's sqrt function does the same

# displays the value '5' in the console window
sqrt(25)

# calculates the square root of y, assigns it to z, and displays the value of z

z <- sqrt(y)

# displays 3.807887 in the console window

z

# note that a function name is followed by open & closing parenthesis; within
# the parantheses you can provide the input parameters to the function

# a variable can also be used to define a list of values; the statement below
# assigns a list of values to the variable myList; the list is created by 
# calling the function c(); each individual element provided to the c() function
# is separated by a comma

myList <- c(21, 12, 17, 14)

myList

# displays 21, 12, 17, 14

# note that these are all numeric values; when you work with textual values in 
## R, you surround the textual value with quote symbols ""

# now that we have a variable called myList with 4 values, we can make a graph!

# the plots we explore in this lecture belong to the R Studio base plots; we will
# study more advanced plots in further lessons

pie(myList)

# the pie 'plot' displays in the Plots window in R Studio; the pie
# function is used to generate the plot, and the pie() function uses
# the variable myList as its input (this is also known as "passing" the
# variable to the function)

# we can use the same source input to generate a bar plot, which
# displays vertical columns whose heights are proportionate to the
# input values

barplot(myList)

# again, the plot is displayed in the Plots window; you can use the
# arrow buttons to view the different plots you create

# you can add ornamentation to the plot, for example, by labeling
# the plot and the 'x' and y axes; you can define this ornamentation
# by providing additional parameters to thhe barplot() function. To discover
# what parameters are supported, you can type "? barplot"

? barplot

# barplot(height, width = 1, space = NULL,
#         names.arg = NULL, legend.text = NULL, beside = FALSE,
#         horiz = FALSE, density = NULL, angle = 45,
#         col = NULL, border = par("fg"),
#         main = NULL, sub = NULL, xlab = NULL, ylab = NULL,
#         xlim = NULL, ylim = NULL, xpd = TRUE, log = "",
#         axes = TRUE, axisnames = TRUE,
#         cex.axis = par("cex.axis"), cex.names = par("cex.axis"),
#         inside = TRUE, plot = TRUE, axis.lty = 0, offset = 0,
#         add = FALSE, ann = !add && par("ann"), args.legend = NULL, ...)

# let's set the main plot title, as well as the x & y axes

# note that the parameters main, ylab and xlab are specified by name, using 
# the notation name = value; whereas the variable myList is passed by position
barplot(myList, main = 'Tortoise burrows', ylab = 'Feet', xlab = 'Tortoise')

# to label each column, we use the names.arg parameter

# we can also change the orientation to horizontal using the horiz parameter
barplot(myList, main = 'Tortoise burrows', ylab = 'Feet', xlab = 'Tortoise',
        horiz = TRUE,
        names.arg = c('Felix', 'OddOne', 'Scamper', 'Blue'))

# note that the single statement above appears on multiple lines; this is 
# for readability; it is still one statement

# also, ypu may recognize the c() function again, only this time we are
# passing a list of textual values to the c() function to represent
# our list of names

# let's use the c() function to create a list of colors
myColors <- c('green', 'red', 'purple', 'blue')

barplot(myList, main = 'Tortoise burrows', ylab = 'Feet', xlab = 'Tortoise',
        horiz = TRUE,
        col = myColors,
        names.arg = c('Felix', 'OddOne', 'Scamper', 'Blue'))

# now we can experiment with different data inputs and different plot types

# the dev.off() command clears the current plot
dev.off()

# graphics.off() clears all plots
graphics.off()

# note the syntax of these commands is a little different than the commands
# and functions we've used so far; for example, dev.off() is used to instruct
# the graphics device ("dev") to turn off, so the command 'off' is issued
# to the graphics device

# another common graph is the histogram; histograms are used to display
# a distribution of values; R makes it easy for us to generate a normal
# distribution using random values with the rnorm() function

# for help on rnorm(), typpe "? rnorm"
? rnorm

# use set.seed to generate repeatable results
set.seed(123)

# generate sample data in the x and y variables; note that we are reusing
# the x variable from the start of the lecture

x <- rnorm(5000)
y <- x + rnorm(5000)

# inspect the two variables
summary(x)
summary(y)

# Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
# -3.93879 -0.69858 -0.01247 -0.01629  0.65481  3.33469 
# 
# Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
# -4.93557 -0.97337  0.00125 -0.01262  0.94893  5.86582 

# x ranges from ~ -4 to ~ +3.33
# y ranges from ~-5 to ~ + 5.87

# let's plot the two variables using a histogram
hist(x, main = 'The x distribution')
hist(y, main = 'The y distribution')

# both distributions approximate the normal distribution, but
# y tends to be less normal and more subject to noise

# we can now plot x against y:

plot(x, y)

# this creates a scatterplot of x and y; the plot command
# determined this was the best plot to represent the two
# lists

# finally, we will use the par() command to draw our 3 plots together
# in the same plot window

? par

par(mfrow = c(1, 3))

hist(x, main = 'The x distribution')
hist(y, main = 'The y distribution')
plot(x, y)

par(mfrow = c(3, 1))
hist(x, main = 'The x distribution')
hist(y, main = 'The y distribution')
plot(x, y)
