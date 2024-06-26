% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/imputations.R
\name{impute.pca_bayes}
\alias{impute.pca_bayes}
\title{Imputation by Bayesian principal components analysis}
\usage{
impute.pca_bayes(dataSet, reportImputing = FALSE, nPcs = NULL, maxSteps = 100)
}
\arguments{
\item{dataSet}{The 2d dataset of experimental values.}

\item{reportImputing}{A boolean (default = FALSE) specifying whether to provide a
shadow data frame with imputed data labels, where 1 indicates the corresponding entries
have been imputed, and 0 indicates otherwise. Alters the return structure.}

\item{nPcs}{An integer specifying the number of principal components to calculate. The
default is set to the minimum between the number of samples and the number of proteins.}

\item{maxSteps}{An integer (default = 100) specifying the maximum number of estimation
steps.}
}
\value{
\itemize{
\item If \code{reportImputing = FALSE}, the function returns the imputed 2d dataframe.
\item If \code{reportImputing = TRUE}, the function returns a list of the imputed 2d
dataframe and a shadow matrix showing which proteins by replicate were imputed.
}
}
\description{
Apply imputation to the dataset by Bayesian principal components analysis
\insertCite{oba2003bayesian}{msDiaLogue}.
}
\references{
\insertAllCited{}
}
