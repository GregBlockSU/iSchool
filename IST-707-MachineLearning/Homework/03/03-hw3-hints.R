library(arules)
library(arulesViz)

# load the dataset
bank <- read.csv("C:/Users/HQRGRS27/OneDrive/Courses/Syracuse/IST707/Homework/03/bankdata_csv_all.csv")
length(which(is.na(bank)))
str(bank)

# preprocess
# remove ID fields
bank <- bank[,-1]
# discretize or convert fields to nominal
# using factor
bank$sex <- factor(bank$sex)
bank$region <- factor(bank$region)
bank$married <- factor(bank$married)
bank$children <- factor(bank$children)
bank$car <- factor(bank$car)
bank$save_act <- factor(bank$save_act)
bank$current_act <- factor(bank$current_act)
bank$mortgage <- factor(bank$mortgage)
bank$pep <- factor(bank$pep)
# using cut
bank$age <- cut(bank$age, breaks = c(10,20,30,40,50,60,70), 
                labels=c("teens", "twenties", "thirties", "fourties", "fifties", 
                         "sixties"))
min_inc <- min(bank$income) - 1
max_inc <- max(bank$income)
bins <- 5
width <- (max_inc - min_inc)/bins
bank$income <- cut(bank$income, breaks=seq(min_inc, max_inc, width))
str(bank)
# any missing values? 
length(which(is.na(bank)))
# check for incomplete rows
nrow(bank[!complete.cases(bank),])
# check for complete rows
nrow(bank[complete.cases(bank),])

# generate rules and explore data; note the low support level at this point
rules <- apriori(bank, parameter = list(supp=0.001, conf = 0.8))

# Rounding rules to 2 digits
options(digits=2)

# get summary info about all rules
summary(rules)

# sort the rules to view most relevant first (confidence)
rules <- sort(rules, by="confidence", decreasing=TRUE)
inspect(rules[1:20])

# sort the rules to view based on lift
rules <- sort(rules, by="lift", decreasing=TRUE)
inspect(rules[1:20])

# "minlen" is to avoid empty LHS items
rules2 <- apriori(data = bank, parameter=list(supp=0.001,conf=0.08,minlen=3))
rules2 <- sort(rules2, by="lift", decreasing=TRUE)
inspect(rules2[1:20])


# if we want to target items to generate rules (for example, pep=YES)
rules3 <- apriori(data = bank, parameter=list(supp=0.001,conf=0.08,minlen=2),
                  appearance = list(default="lhs", rhs="pep=YES"), 
                  control=list(verbose=F))
rules3 <- sort(rules3, decreasing = TRUE, by="lift")
inspect(rules3[1:20])

# we can set the left hand side to be "pep=YES" and find its antecedents
rules4 <- apriori(data = bank, parameter=list(supp=0.001,conf=0.08,minlen=2),
                  appearance = list(default="rhs", lhs="pep=YES"), 
                  control=list(verbose=F))
rules4 <- sort(rules4, decreasing = TRUE, by="lift")
rules4 <- sort(rules4, decreasing = TRUE, by="confidence")
inspect(rules4[1:5])
