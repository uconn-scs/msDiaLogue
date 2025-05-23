% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/visualizations.R
\name{visualize.venn}
\alias{visualize.venn}
\title{Venn diagram}
\usage{
visualize.venn(
  dataSet,
  show_percentage = TRUE,
  fill_color = c("blue", "yellow", "green", "red"),
  saveVenn = TRUE,
  proteinInformation = "preprocess_protein_information.csv"
)
}
\arguments{
\item{dataSet}{The 2d data set of data.}

\item{show_percentage}{A boolean (default = TRUE) specifying whether to show the
percentage for each set.}

\item{fill_color}{A text (default = c("blue", "yellow", "green", "red")) specifying the
colors to fill in circles.}

\item{saveVenn}{A boolean (default = TRUE) specifying whether to save the data, with
logical columns representing sets, to current working directory.}

\item{proteinInformation}{The name of the .csv file containing protein information data
(including the path to the file, if needed). This file is automatically generated by
the function \code{\link[msDiaLogue]{preprocessing}}.}
}
\value{
An object of class \code{ggplot}.
}
\description{
Generate a Venn diagram for the data.
}
