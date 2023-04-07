% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sortcondition.R
\name{sortcondition}
\alias{sortcondition}
\title{Creating keyed list of conditions to the list of proteins that are present.}
\usage{
sortcondition(dataSet)
}
\arguments{
\item{dataSet}{The 2d data set of experimental values
.}
}
\value{
The function returns a list of lists.
}
\description{
sortcondition() creates a keyed dictionary, where every unique experimental
condition is the label for a list of every protein that has a value for
that condition.
}