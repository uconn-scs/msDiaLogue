#Current Critical Errors/Assumptions

#1: Impute(localMinVal) code must partially rewritten, 
#without assuming all conditions will have the same number of replicates.


#Default Methods Test ----

############### No user access


name <- "ProteinQuantReport.csv"


data <- preprocessing(name)


dataFilter1<- filterOutIn(data, TRUE, c("MYG_HORSE"))


############### Default input functions


combos.list <- sortcondition(dataFilter1)

vennMain(combos.list)
 
dataTrans <- transform(dataFilter1)

dataImput <- impute(dataTrans, imputeType = "GlobalMinVal")

dataFilter2 <- filterNA(dataImput)

dataNorm <- normalize(dataFilter2, normalizeType = "Quant")

############# Pull Protein Path

dataSetList <- list(
  "Initial" = data, 
  "Transformed" = dataTrans, 
  "Imputed" = dataImput, 
  "Normalized" = dataNorm)

proteinName <- "ZCRB1_HUMAN"

ZCRB1 <- pullProteinPath(proteinName, dataSetList)



############### User entered input functions

dataOutput <- summarize(dataNorm, fileName = "")




compareValues <-c(1,2) 

#Volcano Plot
testOutput1 <- analyze(dataNorm, compareValues, testType = "volcano")

visualize(testOutput1, transformType = "Log 2")

#T-Test
testOutput2 <- analyze(dataNorm, compareValues, testType = "t-test")


#MA Plot
testOutput3 <- analyze(dataNorm, compareValues, testType = "MA")

visualize(testOutput3, graphType = "MA", transformType = "Log 2")


#Heatmap Plot 
#TODO: Currently displays the top 30 proteins by abundance on heatmap
visualize(dataNorm, graphType = "heatmap")


#PCA Plot 
visualize(dataNorm, graphType = "pca")


#Active Build Section ----




# Individual Unit Tests ----

###################################### Testing local imputation

dataTest <- read.csv("MissingDataTestFile.csv")

dataTestImpute <- impute(dataTest, imputeType = "LocalMinVal", reqPercentPresent = 51)

dataNAFiltered <- filterNA(dataTestImpute)



###################################### Testing trimFASTA

trimFASTA("jlb20220525_BosTaurus_RefUniprotproteome_UP000009136.txt", 
          "20230217_112231_hrf20230212_AAML1031_Plates124_Report.csv", 
          "test.txt")


FASTAFileName <- "jlb20220327_SchistocephalusSolidus_Uniprot_UP000275846_Unassembled+WGS_updated16Aug2019.txt"
reportFileName <- "AWang Scaffold output.txt"
outputFileName <- "test4-19-23.txt"

trimFASTA2.0(FASTAFileName, reportFileName, outputFileName)

###################################### Testing real format normalize

normTest <- matrix(c(5, 4, 3,  
                     2, 1, 4, 
                     3, 4, 6,
                     4, 2, 8
), byrow = TRUE, nrow = 4, ncol = 3)


normTest <- t(normTest)

a <- matrix(rep(NA, 9), nrow = 3)

dataSet <- cbind(a, normTest)

test <- normalize(dataSet, normalizeType = "Quant")


###################################### Testing Imputation
mat <- matrix(c(2, 3, 6, 5, 5, "", 6, 6, 
                4, 3, 5, 3, 3, 5, 4, 5, 
                 "", 4, 3, 4, 7, 2, NA, 5, 
                3, 5, 4, 4, 0.001, 6, 3, 4, 
                4, 5, 5, 6, 6, 5, 5, 7
), byrow = TRUE, nrow = 8, ncol = 5)

tmp2 <- impute(mat)





