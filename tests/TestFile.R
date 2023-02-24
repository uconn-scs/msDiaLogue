

#Default Methods Test

############### No user access


name <- "ProteinQuantReport.csv"


data <- preprocessing(name)


#filter <- filter(data, contaminantList)


############### Default input functions


dataTrans <- transform(data)


dataImput <- impute(dataTrans)


dataNorm <- normalize(dataImput, normalizeType = "Quant")


#filter <- filter(dataNorm, conditionList, proteinList)


############### User entered input functions


dataOutput <- summarize(dataNorm, fileName = "")


compareValues <-c(1,2) 
testOutput <- analyze(dataNorm, compareValues, testType = "t-test")


visualize(testOutput)


#####################################



######################################
#Testing real format normalize

normTest <- matrix(c(5, 4, 3,  
                     2, 1, 4, 
                     3, 4, 6,
                     4, 2, 8
), byrow = TRUE, nrow = 4, ncol = 3)


normTest <- t(normTest)

a <- matrix(rep(NA, 9), nrow = 3)

dataSet <- cbind(a, normTest)

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





