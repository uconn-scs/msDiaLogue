#############
## heatmap ##
#############

dataSet <- read.csv("../storedData/normalize_Toy.csv")

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

dataSet <- read.csv("../storedData/normalize_Toy.csv")

pdf("normalize.pdf")

visualize(dataSet, graphType = "normalize")

dev.off()

##----------------------------------------------------------------------------------------
#########
## PCA ##
#########

dataSet <- read.csv("../storedData/normalize_Toy.csv")

pdf("PCA_scree.pdf")

visualize(dataSet, graphType = "PCA_scree")

dev.off()

pdf("PCA_ind.pdf")

visualize(dataSet, graphType = "PCA_ind")

dev.off()

pdf("PCA_var.pdf")

visualize(dataSet, graphType = "PCA_var")

dev.off()

pdf("PCA_biplot.pdf")

visualize(dataSet, graphType = "PCA_biplot")

dev.off()

##----------------------------------------------------------------------------------------
############
## t-test ##
############

dataSet <- read.csv("../storedData/analyze_t-test_Toy.csv", row.names = 1)

pdf("t-test.pdf")

visualize(dataSet, graphType = "t-test")

dev.off()

##----------------------------------------------------------------------------------------
##########
## Venn ##
##########

##----------------------------------------------------------------------------------------
#############
## volcano ##
#############

dataSet <- read.csv("../storedData/analyze_volcano_Toy.csv", row.names = 1)

pdf("volcano.pdf")

visualize(dataSet, graphType = "volcano")

dev.off()

