#Default Methods Test ----

############### No user access


name <- "ProteinQuantReport.csv"


data <- preprocessing(name)


dataFilter1<- filterOutIn(data, TRUE, c("MYG_HORSE"))


############### Default input functions


combos.list <- sortcondition(testData)

# above 4 conditions, venn diagrams become less useful
if (length(combos.list) <= 4){
  visualize(combos.list, "venn", "test.tiff")
  #TODO 1 Return list of proteins that are present in all conditions
}

dataTrans <- transform(dataFilter1)

requiredPercentPresent <- 51
#TODO 2 impute only in cases where meets percentPresent, 
#Use protein x condition-specific minimum value
dataImput <- impute(dataTrans)

#TODO 2 remove proteins that don't meet PercentPresent
#create file with removed proteins, with average values and N
#from the values that do exist.
 #<- filterOutIn()

dataNorm <- normalize(dataImput, normalizeType = "Quant")


dataFilter2<- filterOutIn(dataNorm, FALSE, proteinList)


############### User entered input functions

#TODO 4 default if conditons = 2, include fold change in summarize output
dataOutput <- summarize(dataNorm, fileName = "")


compareValues <-c(1,2) 
testOutput <- analyze(dataNorm, compareValues, testType = "volcano")


#TODO 4 boxplots or rainforest plots 


visualize(testOutput)

#TODO 3
#Scatterplot of log fold change (a vs b) vs scaled abundance MA
#https://en.wikipedia.org/wiki/MA_plot
#GGplot and plotly for interactive plotting

#TODO 3 Add heatmap and dendogram by condition, not by protein










#Active Build Section ----

dataTest <- read.csv("MissingDataTestFile.csv")


# calculate how many values are present from each condition by protein
dtaTemp <- dataTest %>% 
  # do not include columns that are strings
  select(!c(R.FileName, R.Replicate)) %>%
      # group by experimental condition
      group_by(R.Condition) %>% 
          # apply to every numeric function a summation of the non-NA values
          mutate(across(case_when(
            
              sum(is.na) > 2 ~ min(.x))))




# Individual Unit Tests ----

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





