# Code for data transformation

# see https://pubmed.ncbi.nlm.nih.gov/15147579/
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4373093/

# simulate some data using gamma distribution - non-negative, positive skew
x <- rgamma(10000,shape = 0.4, 1/1000)
hist(x)

# log2 transformation
hist(log2(x))

