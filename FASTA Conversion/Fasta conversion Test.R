
library("data.table") 
library(seqinr)
library(tidyr)
library(dplyr)
library(tictoc)

tic()

# Read in full fasta file
full_Fasta <- read.fasta("jlb20220525_BosTaurus_RefUniprotproteome_UP000009136.txt", seqtype = "AA", whole.header = TRUE)

# Read in just the protein names from the report file
namesList <- fread("20230217_112231_hrf20230212_AAML1031_Plates124_Report.csv", select = "PG.ProteinNames")

# Isolate the unique entries in the protein name list
proteinIDs <- unique(namesList)

# Split all the names into individual protein names
SpecificIDs <- proteinIDs %>% 
  mutate(PG.ProteinNames = strsplit(as.character(PG.ProteinNames), ";")) %>% 
  unnest(PG.ProteinNames)

uniqueSpecificIDs <- unique(SpecificIDs)

# Keep only the protein names that end with "BOVIN"
bovinOnlyIDs <- uniqueSpecificIDs[grep("*BOVIN", uniqueSpecificIDs$PG.ProteinNames),]

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
write.fasta(part_Fasta,part_names,"test.txt",nbchar=60)

toc()