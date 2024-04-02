##
## msDiaLogue: Analysis + Visuals for Data Indep. Aquisition Mass Spectrometry Data
## Copyright (C) 2024  Shiying Xiao, Timothy Moore and Charles Watt
## Shiying Xiao <shiying.xiao@uconn.edu>
##
## This file is part of the R package msDiaLogue.
##
## The R package msDiaLogue is free software: You can redistribute it and/or
## modify it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or any later
## version (at your option). See the GNU General Public License at
## <https://www.gnu.org/licenses/> for details.
##
## The R package wdnet is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
##

#' Trimming down a protein FASTA file to certain proteins
#' 
#' @description 
#' Trim down a FASTA file to only contain proteins present in an associated Spectronaut
#' report file.
#' 
#' @param FASTAFileName A character string specifying the name of the input FASTA .txt
#' file.
#' 
#' @param reportFileName A character string specifying the name of the Spectronaut report
#' .csv file.
#' 
#' @param by A character string (default = "PG.ProteinNames") specifying the identifier
#' (column name) used for selection in the report file.
#' 
#' @param outputFileName A character string (default = "trimFASTA_output.txt") specifying
#' the name of the output file.
#' 
#' @param selectString A character string specifying the regular expression to search for.
#' 
#' @details
#' Depending on the size of the FASTA file, this function may run slowly and take several
#' minutes. The FASTA file must be in .txt format; other formats will not work.
#' 
#' @import dplyr
#' @import tictoc
#' @importFrom data.table fread
#' @importFrom seqinr getName read.fasta write.fasta
#' @importFrom Rdpack reprompt
#' 
#' @returns A FASTA file with only the specified proteins present.
#' 
#' @autoglobal
#' 
#' @export

trimFASTA <- function(FASTAFileName,
                      reportFileName,
                      outputFileName = "trimFASTA_output.txt",
                      by = "PG.ProteinNames",
                      selectString = "*BOVIN") {
  
  message("Depending on the size of the FASTA files,
          this function may run slowly and take multiple minutes to run.")
  
  tic("Time to run trimFASTA")
  
  ## read in full fasta file
  full_Fasta <- read.fasta(FASTAFileName, seqtype = "AA", whole.header = TRUE)
  
  ## pull all of the names from the FASTA file
  allNames <- getName(full_Fasta)
  
  ## read only the `selectString` from the report file;
  ## split all selected strings into individual strings and keep only the unique ones;
  ## filter the unique strings based on the `selectString`;
  ## find the corresponding indices in the original data for the filtered strings
  index <- fread(reportFileName, select = by)[[1]] %>%
    unique() %>%
    strsplit(split = ";") %>%
    unlist() %>%
    unique() %>%
    grep(selectString, ., value = TRUE) %>%
    lapply(grep, x = allNames) %>%
    unlist()
  
  ## select the names and data that correspond
  part_names <- allNames[index]
  part_Fasta <- full_Fasta[index]
  
  ## write a fasta file with only the selected indices
  write.fasta(part_Fasta, part_names, outputFileName, nbchar = 60)
  
  toc()
}

