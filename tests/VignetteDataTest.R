
name <- "20230510_msDIAlogue HeLa-6mix_Report.csv"

data <- preprocessing(name, filterUnique = 2)

dataFilter1<- filterOutIn(data, TRUE, c("MYG_HORSE"))



# Optional 1: generate venn diagram 
combos.list <- sortcondition(dataFilter1)

vennMain(combos.list)
#Optional 1



dataTrans <- transform(dataFilter1)

dataImput <- impute(dataTrans)

dataFilter2 <- filterNA(dataImput)

dataNorm <- normalize(dataFilter2, normalizeType = "Quant")



# Optional 2: viewing of individual protein path
dataSetList <- list(
  "Initial" = data, 
  "Transformed" = dataTrans, 
  "Imputed" = dataImput, 
  "Normalized" = dataNorm)

proteinName <- "A0A024R4E5_HUMAN"

A0A024R4E5 <- pullProteinPath(proteinName, dataSetList)
#Optional 2





dataOutput <- summarize(dataNorm, fileName = "")


compareValues <- c("100fmol","50fmol") 


#Volcano Plot
testOutput1 <- analyze(dataNorm, compareValues, testType = "volcano")

visualize(testOutput1, transformType = "Log 2")


#T-Test
testOutput2 <- analyze(dataNorm, compareValues, testType = "t-test")


#MA Plot
testOutput3 <- analyze(dataNorm, compareValues, testType = "MA")

visualize(testOutput3, graphType = "MA", transformType = "Log 2")


#PCA Plot 
visualize(dataNorm, graphType = "pca")


#Heatmap 
visualize(dataNorm, graphType = "heatmap")
