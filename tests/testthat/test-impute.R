
test_that("impute.min_local", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.min_local(dataSet, reportImputing = FALSE,
                             reqPercentPresent = 0.51)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute.min_local_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("impute.min_global", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.min_global(dataSet, reportImputing = FALSE)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute.min_global_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("impute.knn", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.knn(dataSet, reportImputing = FALSE,
                   k = 10, rowmax = 0.5, colmax = 0.8, maxp = 1500, seed = 362436069)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute.knn_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("impute.knn_seq", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.knn_seq(dataSet, reportImputing = FALSE,
                           k = 10)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute.knn_seq_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("impute.knn_trunc", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.knn_trunc(dataSet, reportImputing = FALSE,
                             k = 5)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute.knn_trunc_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("impute.nuc_norm", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.nuc_norm(dataSet, reportImputing = FALSE,
                            rank.max = NULL, lambda = NULL, thresh = 1e-05, maxit = 500,
                            final.svd = TRUE, seed = 362436069)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute.nuc_norm_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("impute.mice_norm", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.mice_norm(dataSet, reportImputing = FALSE,
                             m = 5, seed = 362436069)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute.mice_norm_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("impute.mice_cart", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.mice_cart(dataSet, reportImputing = FALSE,
                             m = 5, seed = 362436069)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute.mice_cart_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("impute.pca_bayes", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.pca_bayes(dataSet, reportImputing = FALSE,
                             nPcs = NULL, maxSteps = 100)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute.pca_bayes_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})


test_that("impute.pca_prob", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.pca_prob(dataSet, reportImputing = FALSE,
                            nPcs = NULL, maxIterations = 1000, seed = 362436069)
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/impute.pca_prob_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})