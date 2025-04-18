% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/analyze.R
\name{analyze.wilcox}
\alias{analyze.wilcox}
\title{Wilcoxon test}
\usage{
analyze.wilcox(dataSet, ref = NULL, adjust.method = "none", paired = FALSE)
}
\arguments{
\item{dataSet}{The 2d data set of data.}

\item{ref}{A string (default = NULL) specifying the reference condition for comparison.
If NULL, all pairwise comparisons are performed.}

\item{adjust.method}{A string (default = "none") specifying the correction method for
p-value adjustment: \itemize{
\item "BH" or its alias "fdr": \insertCite{benjamini1995controlling;textual}{msDiaLogue}.
\item "BY": \insertCite{benjamini2001control;textual}{msDiaLogue}.
\item "bonferroni": \insertCite{bonferroni1936teoria;textual}{msDiaLogue}.
\item "hochberg": \insertCite{hochberg1988sharper;textual}{msDiaLogue}.
\item "holm": \insertCite{holm1979simple;textual}{msDiaLogue}.
\item "hommel": \insertCite{hommel1988stagewise;textual}{msDiaLogue}.
\item "none": None
}
See \code{\link[stats]{p.adjust}} for more details.}

\item{paired}{A boolean (default = FALSE) specifying whether or not to perform a paired
test.}
}
\value{
A list comprising data frames for each comparison, with each data frame containing
the means of the two compared conditions for each protein, the difference in means,
and the p-values. Additionally, a separate data frame called "total" summarizes
the results of multiple comparisons.
}
\description{
Perform Wilcoxon tests on the data.
}
\references{
\insertAllCited{}
}
