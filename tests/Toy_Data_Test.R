name <- "Toy_Spectronaut_Data.csv"

data <- preprocessing(name, filterUnique = 2)

dataFilter1<- filterOutIn(data, TRUE, c("MYG_HORSE"))

dataTrans <- transform(dataFilter1)

dataImput2 <- impute(dataTrans)

dataFilter2 <- filterNA(dataImput2)

dataNorm <- normalize(dataFilter2, normalizeType = "Mean")

compareValues <- c("100fmol","50fmol") 

testOutput1 <- analyze(dataNorm, compareValues, testType = "volcano")

visualize(testOutput1, conditionLabels = compareValues, transformType = "Log 2")


dataSetList <- list(
  "Initial" = data, 
  "Transformed" = dataTrans, 
  "Imputed" = dataImput2, 
  "Normalized" = dataNorm)


proteinName <- "ZC11B_HUMAN"

ZC11B <- pullProteinPath(proteinName, dataSetList)
