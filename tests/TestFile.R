

#Default Methods Test ----

############### No user access


name <- "ProteinQuantReport.csv"


data <- preprocessing(name)


dataFilter1<- filterOutIn(data, TRUE, c("MYG_HORSE"))


############### Default input functions


#TODO 1 remove lists of proteins that are uniquely found in only one condition
#Sort Proteins to unique combinations of conditions, store as lists.

#TODO 1 venn diagram of all proteins sorted into conditions that is present 
# https://r-graph-gallery.com/14-venn-diagramm


dataTrans <- transform(dataFilter1)

requiredPercentPresent <- 50
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

testData <- read.csv("MissingDataTestFile.csv")

combos.list <- sortcondition(testData)

library(VennDiagram)

VennDiagram::venn.diagram(
                          x = combos.list[1:length(unique(df$cond))], 
                          filename = "test.tiff", 
                          fill = c("red", "green", "blue"), 
                          alpha = 0.2)

a <- VennDiagram::get.venn.partitions(combos.list[1:length(unique(df$cond))])

a$..values..







# Individual Unit Tests ----


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





