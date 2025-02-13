
test_that("preProcessFiltering", {
  
  ## load the raw data file
  dataSet <- read.csv("../testData/Toy_Spectronaut_Data.csv")
  
  ## execute current function 'preProcessFiltering' on raw data file
  invisible(capture.output(
    data <- preProcessFiltering(dataSet, filterNaN = TRUE, filterUnique = 2,
                                replaceBlank = TRUE, saveRm = FALSE)
  ))
  
  ## load stored correct data
  load("../storedData/preProcessFiltering_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, preProcessFiltering_Toy)
  
})