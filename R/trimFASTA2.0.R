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

trimFASTA2.0 <- function(FASTAFileName,
                         reportFileName,
                         outputFileName,
                         selectString = "*BOVIN") {
  
  message("Depending on the size of the FASTA files,
          this function may run slowly and take multiple minutes to run.")
  
  tic("Time to run trimFASTA")
  
  ## read in full fasta file
  full_Fasta <- read.fasta(FASTAFileName, seqtype = "AA", whole.header = TRUE)
  
  ## read in just the accession names from the report file
  accessionList <- fread(reportFileName, select = "Accession Number")
  
  colnames(accessionList) <- "Accession.Number"
  
  ## clean the accession entries
  cleanIDs <- accessionList %>%
    mutate(Accession.Number = sub(" .*", "", as.character(Accession.Number)))
  
  ## isolate the unique entries in the protein name list
  uniqueIDs <- unique(cleanIDs)
  
  ## pull all of the names out the fasta file
  allNames <- getName(full_Fasta)
  
  ## intialize a list
  index <- list()
  
  ## measure how many accession numbers there are in the report
  lengthAccess <- dim(uniqueIDs[,1])[1]
  
  ## for each bovin protein name
  for (i in 1:lengthAccess) {
    
    ## find all instances of the name in the fasta file
    tmp <- grep(as.character(uniqueIDs[i,]), allNames)
    
    ## save that list of instances
    index <- append(index, as.list(tmp))
  }
  
  ## transponse the index, and structure it as a data frame
  tmp <- t(data.frame(index))
  
  ## select the names and data that correspond
  part_names <- allNames[tmp]
  part_Fasta <- full_Fasta[tmp]
  
  ## write a fasta file with only the selected proteins
  write.fasta(part_Fasta, part_names, outputFileName, nbchar = 60)
  
  toc()
}

