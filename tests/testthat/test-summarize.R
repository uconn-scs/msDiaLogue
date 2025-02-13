
test_that("summarize", {
  
  ## load data from previous step in work flow
  load("../storedData/filterNA_Toy.RData")
  
  ## execute current function 'summarize' on data file
  invisible(capture.output(
    data <- summarize(filterNA_Toy, saveSumm = FALSE)
  ))
  
  ## load stored correct data
  load("../storedData/summarize_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, summarize_Toy)
  
})