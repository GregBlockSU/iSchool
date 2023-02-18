# IST 421 Week 3

#library(vctrs)
#library(knitr)
library(dplyr)
#library(tibble)
library(readr)
#library (glue)
library(stringr)
#library(tidyverse)
library(ggplot2)
library(ggmap)

# when working with files, it is a good idea to establish your 'working directory'
# because the file paths can be relative to the 'working directory'

# a file path describes the drive letter, followed by the hierarchical of
# folder and sub-folders; on a Windows device, these sub-folders are separated
# by the backslash "\" character; however, you must replace the backslash
# with a forward slash, because the backslash is a special character

# set the working folder to "Labses"
setwd("C:/repos/SU/iSchool/CSP/421/Labses")

# if you get an error message that says " cannot change working directory" it may
# mean the directory you entered is not found in your filesystem. If you are using
# Windows, be careful when specifying a file path because Windows uses the "\"
# backslash character, and that is a special, reserved character in R

# double-check your working directory using getwd
getwd()

# the file is located in Labses / data, so we can open the file by specifying
# a file path relative to the current working directory; R will expect the file to be 
#located in the "data" subfolder of the "Labses" subfolder

fileName <- "data/nst-est2011-01.csv";
census <- read.csv(fileName)

# you can also open a file using an absolute reference; an absolute reference
# starts with a drive letter or has the "/" as its first character 
fileName <- "C:/repos/SU/iSchool/CSP/421/Labses/data/nst-est2011-01.csv";
census <- read.csv(fileName)


# finally. you can use the ".." notation to traverse a sub-folder's parent folder
# here the ".." notation means, traverse UP one folder, to the parent folder,
# then into the Labses sub-folder (essentially the same folder we started in)

fileName <- "../Labses/data/nst-est2011-01.csv"
census <- read.csv(fileName)

# if a file cannot be opened, you will see the following error:

# cannot open file '../Labses/data/nst-est2011-01.csv': No such file or directory

# here's another example using backslashes, the default Windows path separator
fileName <- "C:\repos\SU\iSchool\CSP\421\Labses\data\nst-est2011-01.csv";
census <- read.csv(fileName)

# Oops!

# Error: '\S' is an unrecognized escape in character string starting ""C:\repos\S"

# in order to use the backslash as a folder seperator, you must double them up
fileName <- "C:\\repos\\SU\\iSchool\\CSP\\421\\Labses\\data\\nst-est2011-01.csv";
census <- read.csv(fileName)

# now we will try to load a file from a web location; note that we can't
# guarantee that a file will be available at this location in perpetuity,
# but as of now, the file is available at this location for us to download

# the paste0 function allows us to join lengthy string values, like web URLs

census_url <- paste0("https://www2.census.gov/programs-surveys/",
  "popest/tables/2010-2011/state/totals/nst-est2011-01.csv")
dfStates <- read.csv(url(census_url), stringsAsFactors = FALSE)

# dfStates contains our data set, so let's save the file locally
# note that you may need to change the target location of the file
write.csv(dfStates, "c:/data/nst-est2011-01.csv")  

# explore the dataset
nrow(dfStates)

# 66
ncol(dfStates)

# 10

colnames(dfStates)

head(dfStates)
summary(dfStates)

# clean the dataset
# remove the first 8 rows, then keep the first 5 columns, 
# then remove rows 52 to 58

# the %>% sy,bol is defined here:
# https://cran.r-project.org/web/packages/magrittr/vignettes/magrittr.html

dfStates <- dfStates %>%
  slice(-1:-8) %>%
  select(1:5) %>%
  slice (-52:-58) %>%
    
  #define column Names
  rename(
    "stateName"=1, 
    "Census"=2,  
    "Estimated"=3, 
    "Pop2010"=4, 
    "Pop2011"=5)

# remove dots  
dfStates$stateName <- str_replace_all(dfStates$stateName, "\\.", "")

# remove spaces and convert to numeric type
dfStates$Census <- as.numeric(str_replace_all(dfStates$Census, ",", ""))
dfStates$Estimated <- as.numeric(str_replace_all(dfStates$Estimated, ",", ""))
dfStates$Pop2010 <- as.numeric(str_replace_all(dfStates$Pop2010, ",", ""))
dfStates$Pop2011 <- as.numeric(str_replace_all(dfStates$Pop2011, ",", ""))

#Make sure everything is lowercase
dfStates$state <- tolower(dfStates$stateName)

head(dfStates)

df <- dfStates[order(dfStates$Census,decreasing = TRUE),]
df <- df[order(-df$Census),][1:5,]
barplot(df$Census / 1000000, 
        main = '2010 Census', 
        xlab = 'States', 
        ylab = 'Population (millions)',
        names.arg = df$stateName)

# now let's plot using ggplot

ggplot(
  df,
  aes(x = stateName, Census/1000000)) +
  geom_bar(stat = "identity") +
  geom_text(aes(x = stateName, label = round(Census/1000000, 2)), nudge_y = 3) +
  labs(x = "Top 6 States", y = "Census (in Millions)"
  )

# the bars in the bar plot are ordered alphabetically, so let's change
# the order to the Census value in descemnding order using reorder

ggplot(df,
  aes(x = reorder(stateName, -Census),Census/1000000)) +
  geom_bar(stat = "identity") +
  geom_text(aes(x = stateName, label = round(Census/1000000, 2)), nudge_y = 3) +
  labs(x = "Top 6 States", y = "Census (in Millions)")

# rather than gray, let's use a gradient color, the higher the number,
# the darker the color
ggplot(df,
       aes(x = reorder(stateName, -Census),Census/1000000)) +
  geom_bar(stat = "identity", aes(fill = -Census), show.legend = FALSE) +
  geom_text(aes(x = stateName, label = round(Census/1000000,2)), nudge_y = 3) +
  labs(x = "Top 6 States", y = "Census (in Millions)") 

