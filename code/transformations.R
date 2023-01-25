# Code for data transformation

# see https://pubmed.ncbi.nlm.nih.gov/15147579/
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4373093/

# simulate some data using gamma distribution - non-negative, positive skew
x <- rgamma(10000,shape = 0.4, 1/1000)

#plot histogram of pre transformed data
hist(x, main = "Pre-Transformation")

#specify log fold value 
logFold = 2

#create transformed data set
xTrans = log(x, 2)

#plot histogram of pre transformed data
hist(xTrans, main = "Post-Transformation")
