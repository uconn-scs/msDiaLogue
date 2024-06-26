% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trimFASTA.R
\name{trimFASTA}
\alias{trimFASTA}
\title{Trimming down a protein FASTA file to certain proteins}
\usage{
trimFASTA(
  FASTAFileName,
  reportFileName,
  outputFileName = "trimFASTA_output.txt",
  by = "PG.ProteinNames",
  selectString = "*BOVIN"
)
}
\arguments{
\item{FASTAFileName}{A character string specifying the name of the input FASTA .txt
file.}

\item{reportFileName}{A character string specifying the name of the Spectronaut report
.csv file.}

\item{outputFileName}{A character string (default = "trimFASTA_output.txt") specifying
the name of the output file.}

\item{by}{A character string (default = "PG.ProteinNames") specifying the identifier
(column name) used for selection in the report file.}

\item{selectString}{A character string specifying the regular expression to search for.}
}
\value{
A FASTA file with only the specified proteins present.
}
\description{
Trim down a FASTA file to only contain proteins present in an associated Spectronaut
report file.
}
\details{
Depending on the size of the FASTA file, this function may run slowly and take several
minutes. The FASTA file must be in .txt format; other formats will not work.
}
