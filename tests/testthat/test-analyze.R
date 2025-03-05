
test_that("analyze_t-test", {
  
  ## load data from previous step in work flow
  load("../storedData/filterNA_Toy.RData")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze(filterNA_Toy, testType = "t-test", ref = "50pmol", adjust.method = "none")
  ))
  
  ## load stored correct data
  load("../storedData/analyze_t_test_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, analyze_t_test_Toy)
  
})


test_that("analyze_mod.t-test", {
  
  ## load data from previous step in work flow
  load("../storedData/filterNA_Toy.RData")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze(filterNA_Toy, testType = "mod.t-test", ref = "50pmol", adjust.method = "none")
  ))
  
  ## load stored correct data
  load("../storedData/analyze_mod.t_test_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, analyze_mod.t_test_Toy)
  
})


test_that("analyze_wilcox-test", {
  
  ## load data from previous step in work flow
  load("../storedData/filterNA_Toy.RData")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze(filterNA_Toy, testType = "wilcox-test", ref = "50pmol", adjust.method = "none")
  ))
  
  ## load stored correct data
  load("../storedData/analyze_wilcox_test_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, analyze_wilcox_test_Toy)
  
})


test_that("analyze_MA", {
  
  ## load data from previous step in work flow
  load("../storedData/filterNA_Toy.RData")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze(filterNA_Toy, testType = "MA", ref = "50pmol", adjust.method = "none")
  ))
  
  ## load stored correct data
  load("../storedData/analyze_MA_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, analyze_MA_Toy)
  
})