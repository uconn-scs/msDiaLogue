
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