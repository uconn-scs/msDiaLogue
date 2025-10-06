
test_that("pullProteinPath", {
  
  ## load data from previous step in work flow
  load("../storedData/preprocessing_Toy.RData")
  load("../storedData/transform_Toy.RData")
  load("../storedData/normalize_quant_Toy.RData")
  load("../storedData/impute.min_local_Toy.RData")
  
  ## execute current function 'pullProteinPath' on data file
  invisible(capture.output(
    data <- pullProteinPath(
      listName = c("LYSC_CHICK", "BGAL_ECOLI"),
      regexName = c("BOVIN", "CHICK"),
      dataSetList = list(Initial = preprocessing_Toy,
                         Transformed = transform_Toy,
                         Normalized = normalize_quant_Toy,
                         Imputed = impute.min_local_Toy))
  ))
  
  ## load stored correct data
  load("../storedData/pullProteinPath_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, pullProteinPath_Toy)
  
})