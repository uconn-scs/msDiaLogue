# Code for visualizations
#https://biocorecrg.github.io/CRG_RIntroduction/volcano-plots.html


require(ggrepel)
require(dplyr)
require(tidyr)
require(ggplot2)
require(VennDiagram)
require(pheatmap)
require(FactoMineR)

#################################################
#' Generating visualizations for MS Data
#' 
#' @description 
#' visualize() produces specified graphics for the results of the data analysis function
#' 
#' @param outputData A 2d data frame that matches the output from the analyze() function for the same name
#' 
#' @param graphType A string indicating the graph type
#' 
#' @details 
#' visualize() is designed to work directly with output from analyze. 
#' Be sure that the graphType and testType params match.
#' 
#' 
#' @returns The function does not return anything.
#################################################


#' @export
visualize <- function(outputData, graphType = "volcano", fileName, transformType, conditionLabels ){
  
  
  # specify graph type
  if (graphType == "volcano") {
    
  #transpose the data for easy manipulation
  plotData <- data.frame(t(outputData))
  
  # add a column of NAs to indicate coloring
  plotData$diffexpressed <- "NO"
  
  # if pvalue < 0.05, set as "Diff" for coloring and naming
  plotData$diffexpressed[plotData$P.value < 0.05] <- "Diff"
  
  # add a column of NAs to provide labels
  plotData$delabel <- NA
  
  # only label genes that are differentially expressed
  plotData$delabel[plotData$diffexpressed != "NO"] <- row.names(plotData[plotData$diffexpressed != "NO",])
  
  ############# Ugly current fix to remove species names
  plotData$delabel <- gsub("_.*", "", plotData$delabel)
  #############
  
  #create volcano plot with p =0.05 cut off, and hard coded range and scope
  p1 <- ggplot(data=plotData, aes(x=Log.Fold.Change, y= -log10(P.value), 
                                  col = diffexpressed, label = delabel)) +
    geom_point() +
    theme_minimal() + 
    # Setting more force to make data labels closer, ideally to eliminate long lines
    geom_text_repel(force_pull = 3) +
    scale_color_manual(values=c("red", "black")) +
    geom_hline(yintercept=-log10(0.05), col="red") +
    xlab(sprintf("%s Transformed Fold Change", transformType)) +
    labs(title = paste(conditionLabels[1], "vs.", conditionLabels[2]))
  
  
  
  return(p1)
  
  }
  
  
  # specify graph type
  if (graphType == "venn") {
  
  combos.list <- outputData
    
   venn.diagram(
      x = combos.list[1:length(combos.list)], 
      filename = fileName, 
      fill = c("red", "green", "blue", "yellow"), 
      alpha = 0.2)
    
    
  return()
     
  }
  
  
  if (graphType == "MA") {
  #Future addition: use GGplot and plotly for interactive plotting if needed  
    
    #transpose the outputted data for easier manipulation
    tOutputData <- t(outputData)
    
    #calculate the A data 
    plotData <- data.frame(rowMeans(tOutputData))
    
    #Calculate the M data
    plotData <- cbind(plotData, data.frame(tOutputData[, 1]-tOutputData[, 2]) )
    
    #label the columns with their A and M names  
    colnames(plotData) <- c("A", "M")
    
    # add a column of NAs to indicate coloring
    plotData$diffexpressed <- "NO"
    
    # add a column of NAs to provide labels
    plotData$delabel <- NA
    
    # if M > 1, set as "Diff" for coloring and naming
    plotData$diffexpressed[plotData$M >= 1|plotData$M <= -1] <- "Change"
    
    
    # only label genes that are differentially expressed
    plotData$delabel[plotData$diffexpressed != "NO"] <- row.names(plotData[plotData$diffexpressed != "NO",])
    
    ############# Ugly current fix to remove species names
    plotData$delabel <- gsub("_.*", "", plotData$delabel)
    #############
    
    
    #create MA plot with M = +- 1 cut off
    p2 <- ggplot(data=plotData, aes(x=A, y= M, 
                                    col = diffexpressed, label = delabel)) +
      geom_point() +
      theme_minimal() + 
      geom_text_repel() +
      scale_color_manual(values=c("red", "black")) +
      geom_hline(yintercept=1, col="red") +
      geom_hline(yintercept=-1, col="red") +
      ggtitle(sprintf("%s Transformed MA Plot", transformType))
    
    return(p2)
    
    
  }
  
  
  if (graphType == "heatmap"){
    
    
    #create a new variable that is a unique combination of condition and replicate
    rownames(outputData) <- paste(outputData$R.Condition, "_", outputData$R.Replicate)
  
    #create and plot heat map with replicate clustering   
    objEHeat <- pheatmap(mat = t(outputData[,3:length(outputData[1,])]), 
                         cluster_row = FALSE, cluster_cols = TRUE, show_rownames = FALSE, show_colnames = TRUE)
    
    
  }
  
  
  
  if (graphType == "pca"){
    
    row.names(outputData) <- outputData$R.FileName
    
    outputData_trim.trans <- outputData[,-1:-3]
    
    res.pca <- PCA(outputData_trim.trans, scale.unit=TRUE, ncp=5, graph = T)
    
    fviz_screeplot(res.pca, addlabels = TRUE, ylim = c(0, 99))
    
  }
  
  
  
  if (graphType == "normalize"){
    
    
    #create a new variable that is a unique combination of condition and replicate
    outputData$R.UniqueID <- paste(outputData$R.Condition, "_", outputData$R.Replicate)
    
    #recast the data as a data table
    outputData <- data.table(outputData)
    
    #melt the data table into a very tall and narrow table
    outputData.Melt <- melt(outputData, id.vars = c("R.Condition", "R.FileName", "R.Replicate", "R.UniqueID"), value.name = "Signal_Value")
    
    # plot a boxplot of each replicate by condition
    print(ggplot(outputData.Melt, aes(R.UniqueID, Signal_Value)) + geom_boxplot() +
      labs(title = paste( conditionLabels, "Normalization Boxplot")))
    
    
  }
  
  if (graphType == "t-test"){
    
    df.tmp <- data.frame(t(outputData))
    
    #graph a histogram of the difference in means
    
    hist(df.tmp$Difference.in.Means, main = "Histogram of Differences in Means", 
         xlab = "Difference in Means", breaks = "Scott")
    
    # graph a histogram of the p-values
    
    hist(df.tmp$P.value, main = "Histogram of P-Values", 
         xlab = "P-Value", breaks = "Scott")
    
  }
  
  
  

   
}


#################################################
#' Operates the venn diagram functions 
#' 
#' @description 
#' Builds a venn diagram, if useful, and provides universal protein list 
#' 
#' @param combos.list The output from sortCondition: lists of condition combinations
#' 
#' @param showUniversal A Boolean specifiying if a list of proteins that are present 
#' in every condition should also be returned.
#' 
#'      
#' @returns The function returns nothing. 
#' 
#################################################
#' @export
vennMain <- function(combos.list, showUniversal = FALSE){
  
  # above 4 conditions, venn diagrams become less useful
  if (length(combos.list) <= 4){
    visualize(combos.list, "venn", "test.tiff")
  }
  
  if (showUniversal){
    a <- get.venn.partitions(combos.list[1:length(combos.list)])
    universalProt <- a$..values..[[1]]
  }
  
  #return the filtered data 
  return()
  
  
}




