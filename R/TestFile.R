

name <- "ProteinQuantReport.csv"

#data <- preprocessing(name)

#dataTrans <- transform(data)

#dataOutput <- summarize(dataTrans)



head(dataOutput %>% data.frame())

test <- dataOutput[, 1:3] 
test$grp <- LETTERS[1:8]

library(stringr)
dataOutput$grp <- LETTERS[1:8]
names(dataOutput)
tt <- dataOutput %>% pivot_longer(cols = !grp, names_to = "pp") %>% 
  separate(pp,'_', into = c("prot", "spp", "stat"), fill = "right") %>% 
  data.frame() %>% pivot_wider(names_from = prot, values_from = value, id_cols = c(grp, stat))
  

