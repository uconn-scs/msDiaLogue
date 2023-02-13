

name <- "ProteinQuantReport.csv"

data <- preprocessing(name)

dataTrans <- transform(data)

dataSet <- dataTrans

dataNorm <- normalize(dataTrans, normalizeType = "Quantile")


dataOutput <- summarize(dataTrans)


mat <- matrix(c(2, 3, 6, 5, 5, 3, 6, 6, 
                4, 3, 5, 3, 3, 5, 4, 5, 
                5, 4, 3, 4, 7, 2, 5, 5, 
                3, 5, 4, 4, 5, 6, 3, 4, 
                4, 5, 5, 6, 6, 5, 5, 7
), byrow = TRUE, nrow = 8, ncol = 5)

mat.t <- t(mat)

dataPoints <- scale(mat.t, center = apply(mat.t,2,median), scale = FALSE)



orderSet = c()

orderSet <- cbind(orderSet, c(1:10))


matrix(rep(1:10, 6), ncol = 6)



######################################
#Testing normalize

normTest <- matrix(c(5, 4, 3,  
                2, 1, 4, 
                3, 4, 6,
                4, 2, 8
), byrow = TRUE, nrow = 4, ncol = 3)

normalize(normTest)

dataSet <- normTest

a <- matrix(rep(NA, 12), nrow = 4)

dataSet <- cbind(a, normTest)

normalize(dataSet)

order(dataSet[,4])


######################################
#Testing Imputation
mat <- matrix(c(2, 3, 6, 5, 5, "", 6, 6, 
                4, 3, 5, 3, 3, 5, 4, 5, 
                NaN, 4, 3, 4, 7, 2, NA, 5, 
                3, 5, 4, 4, 0.001, 6, 3, 4, 
                4, 5, 5, 6, 6, 5, 5, 7
), byrow = TRUE, nrow = 8, ncol = 5)

mat <- tibble(mat)

mat2 <- mat %>% 
  mutate(across(everything(), ~replace(.x, is.nan(.x), 0)))


mat2 <- data.frame(sapply(mat, function(x) ifelse(is.nan(x), NA, x)))


apply(mat,2, is.nan)


mat2 <- replace(mat, is.nan(as.matrix(mat)), NA)


tmp2 <- impute(mat)


x <-c(NaN)
is.nan(x)


