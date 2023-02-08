library(devtools)
library(msDiaLogue)

name <- "ProteinQuantReport.csv"

data <- preprocessing(name)

dataTrans <- transform(data)

dataOutput <- summarize(dataTrans)

