
test_that("analyze_t-test", {
  
  ## load data from previous step in work flow
  load("../storedData/filterNA_Toy.RData")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze(filterNA_Toy, method = "t-test", ref = "50pmol", adjust.method = "none")
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
    data <- analyze(filterNA_Toy, method = "mod.t-test", ref = "50pmol", adjust.method = "none")
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
    data <- analyze(filterNA_Toy, method = "wilcox-test", ref = "50pmol", adjust.method = "none")
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
    data <- analyze(filterNA_Toy, method = "MA", ref = "50pmol", adjust.method = "none")
  ))
  
  ## load stored correct data
  load("../storedData/analyze_MA_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, analyze_MA_Toy)
  
})


test_that("analyze_PCA", {
  
  ## load data from previous step in work flow
  load("../storedData/filterNA_Toy.RData")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    rmName <- names(filterNA_Toy)[sapply(filterNA_Toy, function(col) {length(unique(col)) == 1})],
    dataPCA <- filterNA_Toy[, ! colnames(filterNA_Toy) %in% rmName],
    data <- analyze(dataPCA, method = "PCA")
  ))
  
  ## load stored correct data
  load("../storedData/analyze_PCA_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, analyze_PCA_Toy)
  
})