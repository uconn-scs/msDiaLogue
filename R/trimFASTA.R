#TODO check if it is creating a small number of replicates
#' Trimming down a protein FASTA file to certain proteins
#' 
#' @description 
#' Trim down a FASTA file to only contain proteins present in an associated Spectronaut
#' report file.
#' 
#' @param FASTAFileName A string indicating the FASTA .txt filename.
#' 
#' @param reportFileName A string indicating the Spectronaut report .csv filename.
#' 
#' @param outputFileName A string indicating the name for the new .txt FASTA file.
#' 
#' @param selectString A string containing a regular expression for which to search.
#' 
#' @details
#' Depending on the size of the FASTA file, this function may run slowly and take several
#' minutes. The FASTA file must be in .txt format; other formats will not work.
#' 
#' @import data.table
#' @import dplyr
#' @import seqinr
#' @import tictoc
#' @import tidyr
#' 
#' @returns A FASTA file with only the specified proteins present.
#' 
#' @export

trimFASTA <- function(FASTAFileName,
                      reportFileName,
                      outputFileName,
                      selectString = "*BOVIN") {
  
  message("Depending on the size of the FASTA files,
          this function may run slowly and take multiple minutes to run.")
  
  tic("Time to run trimFASTA")
  
  ## read in full fasta file
  full_Fasta <- read.fasta(FASTAFileName, seqtype = "AA", whole.header = TRUE)
  
  ## read in just the protein names from the report file
  namesList <- fread(reportFileName, select = "PG.ProteinNames")
  
  ## isolate the unique entries in the protein name list
  proteinIDs <- unique(namesList)
  
  ## split all the names into individual protein names
  SpecificIDs <- proteinIDs %>%
    mutate(PG.ProteinNames = strsplit(as.character(PG.ProteinNames), ";")) %>%
    unnest(PG.ProteinNames)
  
  uniqueSpecificIDs <- unique(SpecificIDs)
  
  ## keep only the protein names that meet the selectSTring criteria
  bovinOnlyIDs <- uniqueSpecificIDs[grep(selectString, uniqueSpecificIDs$PG.ProteinNames),]
  
  ## pull all of the names out the fasta file
  allNames <- getName(full_Fasta)
  
  ## intialize a list
  index <- list()
  
  ## measure how many bovine names there are in the report
  lengthBov <- dim(bovinOnlyIDs[,1])[1]
  
  ## for each bovin protein name
  for (i in 1:lengthBov) {
    
    ## find all instances of the name in the fasta file
    tmp <- grep(as.character(bovinOnlyIDs[i,]), allNames)
    
    ## save that list of instances
    index <- append(index, as.list(tmp))
  }
  
  ## transponse the index, and structure it as a data frame
  tmp <- t(data.frame(index))
  
  ## select the names and data that corespond
  part_names <- allNames[tmp]
  part_Fasta <- full_Fasta[tmp]
  
  ## write a fasta file with only the selected proteins
  write.fasta(part_Fasta, part_names, outputFileName, nbchar = 60)
  
  toc()
}

