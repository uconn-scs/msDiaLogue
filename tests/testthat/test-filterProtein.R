
test_that("filterProtein", {
  
  ## load data from previous step in work flow
  load("../storedData/transform_Toy.RData")
  
  ## execute current function 'filterProtein' on data file
  invisible(capture.output(
    data <- filterProtein(transform_Toy,
                          proteinInformation = "../storedData/preprocess_protein_information_Toy.csv",
                          text = c("Putative zinc finger protein 840", "Bovine serum albumin"),
                          by = "PG.ProteinDescriptions",
                          removeList = FALSE)
  ))
  
  ## load stored correct data
  load("../storedData/filterProtein_Toy.RData")
  
  ## test if current function yields equal results to previous version
  expect_equal(data, filterProtein_Toy)
  
})