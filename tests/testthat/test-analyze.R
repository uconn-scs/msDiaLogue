
test_that("analyze.t", {
  
  ## load data from previous step in work flow
  load("../storedData/filterNA_Toy.RData")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze.t(filterNA_Toy, ref = "50pmol", adjust.method = "none")
  ))
  
  ## load stored correct data
  load("../storedData/analyze.t_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, analyze.t_Toy)
  
})


test_that("analyze.mod_t", {
  
  ## load data from previous step in work flow
  load("../storedData/filterNA_Toy.RData")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze.mod_t(filterNA_Toy, ref = "50pmol", adjust.method = "none")
  ))
  
  ## load stored correct data
  load("../storedData/analyze.mod_t_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, analyze.mod_t_Toy)
  
})


test_that("analyze.wilcox", {
  
  ## load data from previous step in work flow
  load("../storedData/filterNA_Toy.RData")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze.wilcox(filterNA_Toy, ref = "50pmol", adjust.method = "none")
  ))
  
  ## load stored correct data
  load("../storedData/analyze.wilcox_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, analyze.wilcox_Toy)
  
})


test_that("analyze.ma", {
  
  ## load data from previous step in work flow
  load("../storedData/filterNA_Toy.RData")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    data <- analyze.ma(filterNA_Toy, ref = "50pmol")
  ))
  
  ## load stored correct data
  load("../storedData/analyze.ma_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, analyze.ma_Toy)
  
})


test_that("analyze.pca", {
  
  ## load data from previous step in work flow
  load("../storedData/filterNA_Toy.RData")
  
  ## execute current function 'analyze' on data file
  invisible(capture.output(
    rmName <- names(filterNA_Toy)[sapply(filterNA_Toy, function(col) {length(unique(col)) == 1})],
    dataPCA <- filterNA_Toy[, ! colnames(filterNA_Toy) %in% rmName],
    data <- analyze.pca(dataPCA)
  ))
  
  ## load stored correct data
  load("../storedData/analyze.pca_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, analyze.pca_Toy)
  
})