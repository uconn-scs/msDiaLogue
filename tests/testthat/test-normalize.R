
test_that("normalize_auto", {
  
  ## load data from previous step in work flow
  load("../storedData/transform_Toy.RData")
  
  ## execute current function 'normalize' on data file
  invisible(capture.output(
    data <- normalize(transform_Toy, normalizeType = "auto")
  ))
  
  ## load stored correct data
  load("../storedData/normalize_auto_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, normalize_auto_Toy)
  
})


test_that("normalize_level", {
  
  ## load data from previous step in work flow
  load("../storedData/transform_Toy.RData")
  
  ## execute current function 'normalize' on data file
  invisible(capture.output(
    data <- normalize(transform_Toy, normalizeType = "level")
  ))
  
  ## load stored correct data
  load("../storedData/normalize_level_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, normalize_level_Toy)
  
})


test_that("normalize_mean", {
  
  ## load data from previous step in work flow
  load("../storedData/transform_Toy.RData")
  
  ## execute current function 'normalize' on data file
  invisible(capture.output(
    data <- normalize(transform_Toy, normalizeType = "mean")
  ))
  
  ## load stored correct data
  load("../storedData/normalize_mean_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, normalize_mean_Toy)
  
})


test_that("normalize_median", {
  
  ## load data from previous step in work flow
  load("../storedData/transform_Toy.RData")
  
  ## execute current function 'normalize' on data file
  invisible(capture.output(
    data <- normalize(transform_Toy, normalizeType = "median")
  ))
  
  ## load stored correct data
  load("../storedData/normalize_median_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, normalize_median_Toy)
  
})


test_that("normalize_pareto", {
  
  ## load data from previous step in work flow
  load("../storedData/transform_Toy.RData")
  
  ## execute current function 'normalize' on data file
  invisible(capture.output(
    data <- normalize(transform_Toy, normalizeType = "pareto")
  ))
  
  ## load stored correct data
  load("../storedData/normalize_pareto_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, normalize_pareto_Toy)
  
})


test_that("normalize_quant", {
  
  ## load data from previous step in work flow
  load("../storedData/transform_Toy.RData")
  
  ## execute current function 'normalize' on data file
  invisible(capture.output(
    data <- normalize(transform_Toy, normalizeType = "quant")
  ))
  
  ## load stored correct data
  load("../storedData/normalize_quant_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, normalize_quant_Toy)
  
})


test_that("normalize_range", {
  
  ## load data from previous step in work flow
  load("../storedData/transform_Toy.RData")
  
  ## execute current function 'normalize' on data file
  invisible(capture.output(
    data <- normalize(transform_Toy, normalizeType = "range")
  ))
  
  ## load stored correct data
  load("../storedData/normalize_range_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, normalize_range_Toy)
  
})


test_that("normalize_vast", {
  
  ## load data from previous step in work flow
  load("../storedData/transform_Toy.RData")
  
  ## execute current function 'normalize' on data file
  invisible(capture.output(
    data <- normalize(transform_Toy, normalizeType = "vast")
  ))
  
  ## load stored correct data
  load("../storedData/normalize_vast_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, normalize_vast_Toy)
  
})