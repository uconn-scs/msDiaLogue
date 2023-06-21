
name <- "Input_Data/20230530_103408_20230525_HeLa-6mix_cleanedMQdb_MS2quant_Report.csv"

rawData <- read.csv(name)

data <- preprocessing(name, filterUnique = 2)

#TODO: preprocessing returns data + "key" which is a data frame of protein name, gene name, accession number, and description.
  # key is for labeling: searching, look up, matching

dataFilter1<- filterOutIn(data, TRUE, listName =  c("MYG_HORSE"))

dataFilter1.5<- filterOutIn(data, FALSE, stringSearch = "MOUSE" )

# Optional 1: generate venn diagram 
combos.list <- sortcondition(dataFilter1)

vennMain(combos.list)
#Optional 1


dataTrans <- transform(dataFilter1)

dataImput2 <- impute(dataTrans)

imputDataStore <- impute(dataTrans, reportImputing = TRUE)
dataImput <- imputDataStore[[1]]
shadowImput <- imputDataStore[[2]]


dataFilter2 <- filterNA(dataImput2)

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

volcanoPlotObject <- visualize(testOutput1, conditionLabels = compareValues, transformType = "Log 2")

volcanoPlotObject

#T-Test
testOutput2 <- analyze(dataNorm, compareValues, testType = "t-test")

visualize(testOutput2, graphType = "t-test", conditionLabels = compareValues)


#MA Plot
testOutput3 <- analyze(dataNorm, compareValues, testType = "MA")

maPlotObject <- visualize(testOutput3, graphType = "MA", conditionLabels = compareValues, transformType = "Log 2")

maPlotObject


#PCA Plot 
pcaPlotObject <- visualize(dataNorm, graphType = "pca")


#Heat Map 
heatmapPlotObject <- visualize(dataNorm, graphType = "heatmap")
