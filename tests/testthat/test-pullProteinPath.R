
test_that("pullProteinPath", {
  
  ## load data from previous step in work flow
  dataSet <- read.csv("../storedData/preprocessing_Toy.csv")
  dataTran <- read.csv("../storedData/transform_Toy.csv")
  dataNorm <- read.csv("../storedData/normalize_quant_Toy.csv")
  dataImput <- read.csv("../storedData/impute.min_local_Toy.csv")
  
  ## execute current function 'pullProteinPath' on data file
  invisible(capture.output(
    data <- pullProteinPath(proteinName = "ZC11B_HUMAN",
                            dataSetList = list(Initial = dataSet,
                                               Transformed = dataTran,
                                               Normalized = dataNorm,
                                               Imputed = dataImput))
  ))
  
  ## load stored correct data
  storedData <- read.csv("../storedData/pullProteinPath_Toy.csv")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, storedData)
  
})