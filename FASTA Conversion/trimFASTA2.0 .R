
require("data.table") 
require(seqinr)
require(tidyr)
require(dplyr)
require(tictoc)



FASTAFileName <- "jlb20220327_SchistocephalusSolidus_Uniprot_UP000275846_Unassembled+WGS_updated16Aug2019.txt"

reportFileName <- "AWang Scaffold output.txt"


message("Depending on the size of the FASTA files, this function can be slow and
        take multiple minutes to run.")


tic("Time to run trimFASTA")

# Read in full fasta file
full_Fasta <- read.fasta(FASTAFileName, seqtype = "AA", whole.header = TRUE)

# Read in just the accession names from the report file
accessionList <- fread(reportFileName, select = "Accession Number")

colnames(accessionList) <- "Accession.Number"

#clean the accession entries
SpecificIDs <- accessionList %>% 
  mutate(Accession.Number = sub(" .*", "", as.character(Accession.Number))) 


head(SpecificIDs
     )

# Isolate the unique entries in the protein name list
proteinIDs <- unique(namesList)

# Split all the names into individual protein names
SpecificIDs <- proteinIDs %>% 
  mutate(PG.ProteinNames = strsplit(as.character(PG.ProteinNames), ";")) %>% 
  unnest(PG.ProteinNames)

uniqueSpecificIDs <- unique(SpecificIDs)

# Keep only the protein names that meet the selectSTring criteria
bovinOnlyIDs <- uniqueSpecificIDs[grep(selectString, uniqueSpecificIDs$PG.ProteinNames),]

#Pull all of the names out the fasta file
allNames <- getName(full_Fasta)

# intialize a list
index <- list()

# Measure how many bovine names there are in the report
lengthBov <- dim(bovinOnlyIDs[,1])[1]

# for each bovin protein name
for (i in 1:lengthBov){
  
  # find all instances of the name in the fasta file
  tmp <- grep(as.character(bovinOnlyIDs[i,]), allNames)
  
  # save that list of instances 
  index <- append(index, as.list(tmp))
  
}

# transponse the index, and structure it as a data frame
tmp <- t(data.frame(index))

# select the names and data that corespond 
part_names <- allNames[tmp]
part_Fasta <- full_Fasta[tmp]

# write a fasta file with only the selected proteins
write.fasta(part_Fasta,part_names,outputFileName,nbchar=60)

toc()
