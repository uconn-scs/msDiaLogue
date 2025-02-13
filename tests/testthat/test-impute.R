
test_that("impute.min_global", {
  
  ## load data from previous step in work flow
  load("../storedData/normalize_quant_Toy.RData")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.min_global(normalize_quant_Toy, reportImputing = FALSE)
  ))
  
  ## load stored correct data
  load("../storedData/impute.min_global_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, impute.min_global_Toy)
  
})


test_that("impute.min_local", {
  
  ## load data from previous step in work flow
  load("../storedData/normalize_quant_Toy.RData")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.min_local(normalize_quant_Toy, reportImputing = FALSE,
                             reqPercentPresent = 0.51)
  ))
  
  ## load stored correct data
  load("../storedData/impute.min_local_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, impute.min_local_Toy)
  
})


test_that("impute.knn", {
  
  ## load data from previous step in work flow
  load("../storedData/normalize_quant_Toy.RData")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.knn(normalize_quant_Toy, reportImputing = FALSE,
                       k = 10, rowmax = 0.5, colmax = 0.8, maxp = 1500, seed = 362436069)
  ))
  
  ## load stored correct data
  load("../storedData/impute.knn_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, impute.knn_Toy)
  
})


test_that("impute.knn_seq", {
  
  ## load data from previous step in work flow
  load("../storedData/normalize_quant_Toy.RData")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.knn_seq(normalize_quant_Toy, reportImputing = FALSE,
                           k = 10)
  ))
  
  ## load stored correct data
  load("../storedData/impute.knn_seq_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, impute.knn_seq_Toy)
  
})


test_that("impute.knn_trunc", {
  
  ## load data from previous step in work flow
  load("../storedData/normalize_quant_Toy.RData")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.knn_trunc(normalize_quant_Toy, reportImputing = FALSE,
                             k = 4)
  ))
  
  ## load stored correct data
  load("../storedData/impute.knn_trunc_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, impute.knn_trunc_Toy)
  
})


test_that("impute.nuc_norm", {
  
  ## load data from previous step in work flow
  load("../storedData/normalize_quant_Toy.RData")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.nuc_norm(normalize_quant_Toy, reportImputing = FALSE,
                            rank.max = NULL, lambda = NULL, thresh = 1e-05, maxit = 500,
                            final.svd = TRUE, seed = 362436069)
  ))
  
  ## load stored correct data
  load("../storedData/impute.nuc_norm_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, impute.nuc_norm_Toy)
  
})


test_that("impute.mice_norm", {
  
  ## load data from previous step in work flow
  load("../storedData/normalize_quant_Toy.RData")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.mice_norm(normalize_quant_Toy, reportImputing = FALSE,
                             m = 5, seed = 362436069)
  ))
  
  ## load stored correct data
  load("../storedData/impute.mice_norm_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, impute.mice_norm_Toy)
  
})


test_that("impute.mice_cart", {
  
  ## load data from previous step in work flow
  load("../storedData/normalize_quant_Toy.RData")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.mice_cart(normalize_quant_Toy, reportImputing = FALSE,
                             m = 5, seed = 362436069)
  ))
  
  ## load stored correct data
  load("../storedData/impute.mice_cart_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, impute.mice_cart_Toy)
  
})


test_that("impute.pca_bayes", {
  
  ## load data from previous step in work flow
  load("../storedData/normalize_quant_Toy.RData")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.pca_bayes(normalize_quant_Toy, reportImputing = FALSE,
                             nPcs = NULL, maxSteps = 100)
  ))
  
  ## load stored correct data
  load("../storedData/impute.pca_bayes_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, impute.pca_bayes_Toy)
  
})


test_that("impute.pca_prob", {
  
  ## load data from previous step in work flow
  load("../storedData/normalize_quant_Toy.RData")
  
  ## execute current function 'impute' on data file
  invisible(capture.output(
    data <- impute.pca_prob(normalize_quant_Toy[c(5:8),], reportImputing = FALSE,
                            nPcs = NULL, maxIterations = 1000, seed = 362436069)
  ))
  
  ## load stored correct data
  load("../storedData/impute.pca_prob_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, impute.pca_prob_Toy)
  
})