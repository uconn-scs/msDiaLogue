dataMissing <- function(dataSet) {
  dataMissing <- select(dataSet, -c("R.Condition", "R.FileName", "R.Replicate"))
  result <- data.frame(Missing = colSums(is.na(dataMissing)))
  naniar::vis_miss(dataMissing)
}