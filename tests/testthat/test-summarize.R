
test_that("summarize", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/filterNA_Toy.csv")
  
  ## execute current function 'summarize' on data file
  invisible(capture.output(
    data <- summarize(dataSet, saveSumm = FALSE)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/summarize_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})