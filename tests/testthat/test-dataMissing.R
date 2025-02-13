
test_that("dataMissing", {
  
  ## load data from previous step in work flow
  load("../storedData/normalize_quant_Toy.RData")
  
  ## execute current function 'dataMissing' on data file
  invisible(capture.output(
    data <- dataMissing(normalize_quant_Toy)
  ))
  
  ## load stored correct data
  load("../storedData/dataMissing_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, dataMissing_Toy)
  
})