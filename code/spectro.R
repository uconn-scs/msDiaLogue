library(tidyr)
library(dplyr)
dat <- read.csv("ProteinQuantReport.csv")

head(dat)
names(dat)
library(tictoc)

tic()
dat %>% filter(PG.Coverage=="0%")
toc()

unique(dat$R.FileName)

foo <- dat %>%filter(!is.nan(PG.Quantity))

dat2 <- dat %>%filter(!is.nan(PG.Quantity)) %>% 
  select(R.FileName, R.Replicate,  PG.Quantity, PG.ProteinNames) %>%
      pivot_wider(id_cols = c(R.FileName, R.Replicate), names_from = PG.ProteinNames, 
              values_from = PG.Quantity) %>% data.frame()
str(dat2[, 5])

hist(log2(dat$PG.Quantity))

summary(dat$PG.Quantity)

