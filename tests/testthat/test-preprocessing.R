
test_that("preprocessing", {
  
  name <- "../Unit_Test_Data/Toy_Spectronaut_Data.csv"
  
  data <- preprocessing(name, filterUnique = 2, filterNaN = TRUE)
  
  storedData <- read.csv("../Unit_Test_Data/preprocessedToy.csv")
  
  storedData <- storedData[,2:length(storedData[1,])]
  
  expect_equal(data, storedData)
  
})
