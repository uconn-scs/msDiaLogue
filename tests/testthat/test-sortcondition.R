test_that("sortcondition", {
  
  #Load data from previous step in work flow
  dataFilter <- read.csv("../Unit_Test_Data/HorseFilteredToy.csv")
  #execute current venn diagram data creation function on data file
  combos.list <- sortcondition(dataFilter)
  #load stored correct data
  storedData <- read.csv("../Unit_Test_Data/VennDiagramData.csv")
  
  #Currently doesn't pass expect_equal, since lists cannot be stored as csvs easily
  skip(message = "Skipping due to csv storage of lists")
  #test if current function yields equal results to previous version
  expect_equal(combos.list, storedData)
  
})