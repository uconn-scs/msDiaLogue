name <- "Input_Data/Toy_Spectronaut_Data.csv"

rawData <- read.csv(name)

data <- preprocessing(name, filterUnique = 2, filterNaN = TRUE)

dataFilter1<- filterOutIn(data, TRUE, c("MYG_HORSE"))


# Optional 1: generate venn diagram 
combos.list <- sortcondition(dataFilter1)

vennMain(combos.list)
#Optional 1



dataTrans <- transform(dataFilter1, logFold = 2)

dataImput2 <- impute(dataTrans)

dataFilter2 <- filterNA(dataImput2)

dataNorm <- normalize(dataFilter2, normalizeType = "Mean")



compareValues <- c("100fmol","50fmol") 

testOutput1 <- analyze(dataNorm, compareValues, testType = "volcano")

visualize(testOutput1, conditionLabels = compareValues, transformType = "Log 2")



testOutput2 <- analyze(dataNorm, compareValues, testType = "t-test")

visualize(testOutput2, graphType = "t-test",  conditionLabels = compareValues, transformType = "Log 2")



testOutput3 <- analyze(dataNorm, compareValues, testType = "MA")

visualize(testOutput2, graphType = "MA",  conditionLabels = compareValues, transformType = "Log 2")



visualize(dataNorm, graphType = "heatmap")



dataSetList <- list(
  "Initial" = data, 
  "Transformed" = dataTrans, 
  "Imputed" = dataImput2, 
  "Normalized" = dataNorm)

proteinName <- "ZC11B_HUMAN"

ZC11B <- pullProteinPath(proteinName, dataSetList)


