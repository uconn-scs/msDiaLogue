

name <- "ProteinQuantReport.csv"

data <- preprocessing(name)

dataTrans <- transform(data)

dataNorm <- normalize(dataTrans)

dataOutput <- summarize(dataTrans)


mat <- matrix(c(2, 3, 6, 5, 5, 3, 6, 6, 
                4, 3, 5, 3, 3, 5, 4, 5, 
                5, 4, 3, 4, 7, 2, 5, 5, 
                3, 5, 4, 4, 5, 6, 3, 4, 
                4, 5, 5, 6, 6, 5, 5, 7
), byrow = TRUE, nrow = 8, ncol = 5)

mat.t <- t(mat)

dataPoints <- scale(mat.t, center = apply(mat.t,2,median), scale = FALSE)



orderSet = c()

orderSet <- cbind(orderSet, c(1:10))


matrix(rep(1:10, 6), ncol = 6)


