
name <- "20230510_msDIAlogue HeLa-yeast_Report.csv"

dataraw <- read.csv(name)


data <- preprocessing(name)


dataFilter1<- filterOutIn(data, TRUE, c("MYG_HORSE"))


combos.list <- sortcondition(dataFilter1)

vennMain(combos.list)



dataTrans <- transform(dataFilter1)

dataImput <- impute(dataTrans)

dataFilter2 <- filterNA(dataImput)

dataNorm <- normalize(dataFilter2, normalizeType = "Quant")


dataSetList <- list(
  "Initial" = data, 
  "Transformed" = dataTrans, 
  "Imputed" = dataImput, 
  "Normalized" = dataNorm)

proteinName <- "A0A024R4E5_HUMAN"

A0A024R4E5 <- pullProteinPath(proteinName, dataSetList)



dataOutput <- summarize(dataNorm, fileName = "")



compareValues <-c("pt5x","1x") 

#Volcano Plot
testOutput1 <- analyze(dataNorm, compareValues, testType = "volcano")

visualize(testOutput1, transformType = "Log 2")

#T-Test
testOutput2 <- analyze(dataNorm, compareValues, testType = "t-test")

