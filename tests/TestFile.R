#Default Methods Test

name <- "ProteinQuantReport.csv"


data <- preprocessing(name)


dataTrans <- transform(data)


dataImput <- impute(dataTrans)


dataNorm <- normalize(dataImput, normalizeType = "Quant")


dataOutput <- summarize(dataNorm)







######################################
#Testing normalize

normTest <- matrix(c(5, 4, 3,  
                2, 1, 4, 
                3, 4, 6,
                4, 2, 8
), byrow = TRUE, nrow = 4, ncol = 3)

a <- matrix(rep(NA, 12), nrow = 4)

dataSet <- cbind(a, normTest)

transform(dataSet)

test <- normalize(dataSet, normalizeType = "Quant")

######################################
#Testing Imputation
mat <- matrix(c(2, 3, 6, 5, 5, "", 6, 6, 
                4, 3, 5, 3, 3, 5, 4, 5, 
                 "", 4, 3, 4, 7, 2, NA, 5, 
                3, 5, 4, 4, 0.001, 6, 3, 4, 
                4, 5, 5, 6, 6, 5, 5, 7
), byrow = TRUE, nrow = 8, ncol = 5)

tmp2 <- impute(mat)


# mat <- tibble(mat)
# mat2 <- mat %>% 
#   mutate(across(everything(), ~replace(.x, is.nan(.x), 0)))
# mat2 <- data.frame(sapply(mat, function(x) ifelse(is.nan(x), NA, x)))
# apply(mat,2, is.nan)
# mat2 <- replace(mat, is.nan(as.matrix(mat)), NA)
# x <-c(NaN)
# is.nan(x)


