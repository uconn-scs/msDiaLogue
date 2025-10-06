
test_that("preProcessFiltering", {
  
  ## load the raw data file
  dataSet <- read.csv("../testData/Toy_Spectronaut_Data.csv") %>%
    mutate(PG.ProteinName = firstName(PG.ProteinNames),
           PG.ProteinAccession = firstName(PG.ProteinAccessions))
  
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


test_that("filterOutIn", {
  
  ## load data from previous step in work flow
  load("../storedData/transform_Toy.RData")
  
  ## execute current function 'filterOutIn' on data file
  invisible(capture.output(
    data <- filterOutIn(transform_Toy, listName = "ALBU_BOVIN", regexName = "HUMAN",
                        removeList = TRUE, saveRm = FALSE)
  ))
  
  ## load stored correct data
  load("../storedData/filterOutIn_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, filterOutIn_Toy)
  
})


test_that("filterNA", {
  
  ## load data from previous step in work flow
  load("../storedData/impute.min_local_Toy.RData")
  
  ## execute current function 'filterNA' on data file
  invisible(capture.output(
    data <- filterNA(impute.min_local_Toy, saveRm = FALSE)
  ))
  
  ## load stored correct data
  load("../storedData/filterNA_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, filterNA_Toy)
  
})