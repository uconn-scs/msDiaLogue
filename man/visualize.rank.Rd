% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/visualizations.R
\name{visualize.rank}
\alias{visualize.rank}
\title{Rank abundance distribution plot (Whittaker plot)}
\usage{
visualize.rank(
  dataSet,
  listName = NULL,
  regexName = NULL,
  facet = c("Condition", "Replicate"),
  color = "red"
)
}
\arguments{
\item{dataSet}{The 2d data set of data.}

\item{listName}{A character vector of proteins to highlight.}

\item{regexName}{A character vector specifying proteins for regular expression pattern
matching to highlight.}

\item{facet}{A character string (default = c("Replicate", "Condition")) specifying
grouping variables for faceting. Allowed values are "Condition", "Replicate",
c("Condition", "Replicate"), c("Replicate", "Condition"), or "none" for no grouping.}

\item{color}{A string (default = red") specifying the color used to highlight proteins.}
}
\value{
An object of class \code{ggplot}.
}
\description{
Generate a rank abundance distribution plot, also known as Whittaker plot, for the data.
}
