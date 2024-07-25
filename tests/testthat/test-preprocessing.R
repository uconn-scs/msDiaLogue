
test_that("preprocessing", {
  
  ## start with name of raw data file
  fileName <- "../testData/Toy_Spectronaut_Data.csv"
  
  ## execute current function 'preprocessing' on raw data file
  invisible(capture.output(
    data <- preprocessing(fileName, filterNaN = TRUE, filterUnique = 2,
                          replaceBlank = TRUE, saveRm = FALSE)
  ))
  
  ## load stored correct data 
  storedData <- read.csv("../storedData/preprocessing_Toy.csv")
  storedData$R.Replicate <- as.character(storedData$R.Replicate)
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})