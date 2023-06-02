name <- "20230510_msDIAlogue HeLa-6mix_Report.csv"

rawData <- read.csv(name)

data <- preprocessing(name, filterUnique = 2, filterNaN = TRUE)

#TODO Getting list csv of protein names to accession number mappings 
#add csv export of removed data

#add options to use only accessions numbers as protein names

dataFilter1<- filterOutIn(data, TRUE, c("MYG_HORSE"))


# Optional 1: generate venn diagram 
combos.list <- sortcondition(dataFilter1)

vennMain(combos.list)
#TODO work on the list of colors that are used for circles

#Optional 1

#TODO add regular expression filtering for filterOutIn

dataTrans <- transform(dataFilter1, logFold = 2)

#TODO make transformation graphs per protein per condition?

dataImput2 <- impute(dataTrans)

dataFilter2 <- filterNA(dataImput2)

dataNorm <- normalize(dataFilter2, normalizeType = "Mean")

compareValues <- c("100fmol","50fmol") 

testOutput1 <- analyze(dataNorm, compareValues, testType = "volcano")

visualize(testOutput1, conditionLabels = compareValues, transformType = "Log 2")

#TODO add labels for only specified set of proteins are named. 

testOutput2 <- analyze(dataNorm, compareValues, testType = "t-test")

visualize(testOutput2, graphType = "t-test",  conditionLabels = compareValues, transformType = "Log 2")

# TODO consider changing breaks  for t-test histograms

testOutput2 <- analyze(dataNorm, compareValues, testType = "MA")

visualize(testOutput2, graphType = "MA",  conditionLabels = compareValues, transformType = "Log 2")


visualize(dataNorm, graphType = "heatmap")


dataSetList <- list(
  "Initial" = data, 
  "Transformed" = dataTrans, 
  "Imputed" = dataImput2, 
  "Normalized" = dataNorm)

proteinName <- "ZC11B_HUMAN"

ZC11B <- pullProteinPath(proteinName, dataSetList)


