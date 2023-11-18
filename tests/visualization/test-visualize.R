#############
## heatmap ##
#############

dataSet <- read.csv("../storedData/filterOutIn_Toy.csv")

pdf("heatmap_pheatmap.pdf")

visualize(dataSet, graphType = "heatmap")

dev.off()

pdf("heatmap_ggplot2.pdf")

visualize(dataSet, graphType = "heatmap", pkg = "ggplot2")

dev.off()

##----------------------------------------------------------------------------------------
########
## MA ##
########

dataSet <- read.csv("../storedData/analyze_MA_Toy.csv", row.names = 1)

pdf("MA.pdf")

visualize(dataSet, graphType = "MA")

dev.off()

##----------------------------------------------------------------------------------------
###############
## normalize ##
###############

dataSet <- read.csv("../storedData/normalize_quant_Toy.csv")

pdf("normalize.pdf")

visualize(dataSet, graphType = "normalize")

dev.off()

##----------------------------------------------------------------------------------------
#########
## PCA ##
#########

dataSet <- read.csv("../storedData/filterNA_Toy.csv")

pdf("PCA_scree.pdf")

visualize(dataSet[,colnames(dataSet) != c("TEBP_HUMAN", "T126B_HUMAN")], graphType = "PCA_scree")

dev.off()

pdf("PCA_ind.pdf")

visualize(dataSet[,colnames(dataSet) != c("TEBP_HUMAN", "T126B_HUMAN")], graphType = "PCA_ind")

dev.off()

pdf("PCA_var.pdf")

visualize(dataSet[,colnames(dataSet) != c("TEBP_HUMAN", "T126B_HUMAN")], graphType = "PCA_var")

dev.off()

pdf("PCA_biplot.pdf")

visualize(dataSet[,colnames(dataSet) != c("TEBP_HUMAN", "T126B_HUMAN")], graphType = "PCA_biplot")

dev.off()

##----------------------------------------------------------------------------------------
############
## t-test ##
############

dataSet <- read.csv("../storedData/analyze_mod.t-test_Toy.csv", row.names = 1)

pdf("t-test.pdf")

visualize(dataSet, graphType = "t-test")

dev.off()

##----------------------------------------------------------------------------------------
##########
## Venn ##
##########

load("../storedData/sortcondition_Toy.RData")

pdf("Venn.pdf")

visualize(storedData, graphType = "Venn")

dev.off()

##----------------------------------------------------------------------------------------
#############
## volcano ##
#############

dataSet <- read.csv("../storedData/analyze_volcano_Toy.csv", row.names = 1)

pdf("volcano.pdf")

visualize(dataSet, graphType = "volcano")

dev.off()

