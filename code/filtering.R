# Code for data filtering

# simulate some data using normal distribution - non-negative, positive skew
x <- rnorm(10000,mean = 0, sd = 5)

hist(x, breaks = 50)

# log2 transformation
hist(x[x<5], breaks = 50)
