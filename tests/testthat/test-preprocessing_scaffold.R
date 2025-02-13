
test_that("preprocessing_scaffold", {
  
  ## start with name of raw data file
  fileName <- "../testData/Toy_Scaffold_Data.xls"
  
  ## execute current function 'preprocessing_scaffold' on raw data file
  invisible(capture.output(
    data <- preprocessing_scaffold(fileName)
  ))
  
  ## load stored correct data 
  load("../storedData/preprocessing_scaffold_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, preprocessing_scaffold_Toy)
  
})