
library("data.table") 
library(seqinr)
library(tidyr)
library(dplyr)

full_Fasta <- read.fasta("jlb20220525_BosTaurus_RefUniprotproteome_UP000009136.txt")

namesList <- fread("20230217_112231_hrf20230212_AAML1031_Plates124_Report.csv", select = "PG.ProteinNames")

proteinIDs <- unique(namesList)

bovinSpecificIDs <- proteinIDs %>% 
  mutate(PG.ProteinNames = strsplit(as.character(PG.ProteinNames), ";")) %>% 
  unnest(PG.ProteinNames)

bovinOnlyIDs <- bovinSpecificIDs[grep("*BOVIN", bovinSpecificIDs$PG.ProteinNames),]

allNames <- getName(full_Fasta)

index <- list()

lengthBov <- dim(bovinOnlyIDs[,1])[1]

for (i in 1:lengthBov){
  
  tmp <- grep(as.character(bovinOnlyIDs[i,]), allNames)
  
  index <- append(index, as.list(tmp))
  
}

tmp <- t(data.frame(index))

part_names <- allNames[tmp]
part_Fasta <- full_Fasta[tmp]

write.fasta(part_Fasta,part_names,"test.txt",nbchar=60)

