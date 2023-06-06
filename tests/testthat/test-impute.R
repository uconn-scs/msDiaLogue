# context("report_p")
# 
# testthat::test_that("errors", {
#   testthat::expect_error(
#     report_p(-1),
#     "p cannot be less than 0"
#   )
#   
#   testthat::expect_error(
#     report_p(2),
#     "p cannot be greater than 1"
#   )
# })


# normTest <- matrix(c(5, 4, 3,  
#                      2, 1, 4, 
#                      3, 4, 6,
#                      4, 2, 8
# ), byrow = TRUE, nrow = 4, ncol = 3)
# 
# 
# correct_Data <- matrix(c(NA, NA, NA, 5.6666667, 2, 3.000000, 4.6666667,  
#                          NA, NA, NA, 4.6666667, 2, 5.6666667, 3.000000,  
#                          NA, NA, NA, 2.000000, 3, 4.6666667, 5.6666667
# ), byrow = TRUE, nrow = 3, ncol = 7, dimnames = c(NULL, NULL))
# 
# 
# normTest <- t(normTest)
# 
# a <- matrix(rep(NA, 9), nrow = 3)
# 
# dataSet <- cbind(a, normTest)
# 
# 
# 
# test <- normalize(dataSet, normalizeType = "Quant")
# dimnames(test)
# 
# dimnames(correct_Data)
# 
# 
# expect_identical(normalize(dataSet, normalizeType = "Quant"), correct_Data)

test_that("summation", {
  
  expect_equal(sum(2,3), 5)
  
})