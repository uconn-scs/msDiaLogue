
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