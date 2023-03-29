#Current Critical Errors

# code must be rewritten, without assuming all conditions will have the same number of replicates


#Default Methods Test ----

############### No user access


name <- "ProteinQuantReport.csv"


data <- preprocessing(name)


dataFilter1<- filterOutIn(data, TRUE, c("MYG_HORSE"))


############### Default input functions


combos.list <- sortcondition(dataFilter1)

vennMain(combos.list)
 
dataTrans <- transform(dataFilter1)

dataImput <- impute(dataTrans)

dataFilter2 <- filterNA(dataImput)

dataNorm <- normalize(dataFilter2, normalizeType = "Quant")


############### User entered input functions

dataOutput <- summarize(dataNorm, fileName = "")

compareValues <-c(1,2) 

testOutput <- analyze(dataNorm, compareValues, testType = "volcano")


visualize(testOutput)

#TODO 3
#Scatterplot of log fold change (a vs b) vs scaled abundance MA
#https://en.wikipedia.org/wiki/MA_plot
#GGplot and plotly for interactive plotting

#TODO 3 Add heatmap and dendogram by condition, not by protein





#Active Build Section ----

#pullProteinPath

dataSetList <- list(
  "Raw" = data, 
  "Filtered" = dataFilter1, 
  "Transformed" = dataTrans, 
  "Imputed" = dataImput, 
  "Filtered2" = dataFilter2, 
  "Normalized" = dataNorm)


proteinName <- "PAL4C_HUMAN"

PAL4C <- pullProteinPath(proteinName, dataSetList)



# Individual Unit Tests ----

###################################### Testing local imputation

dataTest <- read.csv("MissingDataTestFile.csv")

dataTestImpute <- impute(dataTest, imputeType = "LocalMinVal", reqPercentPresent = 51)

dataNAFiltered <- filterNA(dataTestImpute)



###################################### Testing trimFASTA

trimFASTA("jlb20220525_BosTaurus_RefUniprotproteome_UP000009136.txt", 
          "20230217_112231_hrf20230212_AAML1031_Plates124_Report.csv", 
          "test.txt")

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





