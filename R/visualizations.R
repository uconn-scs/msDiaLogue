# Code for visualizations
#https://biocorecrg.github.io/CRG_RIntroduction/volcano-plots.html


require(ggrepel)
require(dplyr)
require(tidyr)
require(ggplot2)

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
#' 
#' @details 
#' visualize() is designed to work directly with output from analyze. 
#' Be sure that the graphType and testType params match.
#' 
#' 
#' 
#' @returns The function does not return anything.
#################################################



visualize <- function(outputData, graphType = "volcano"){
  
  #transpose the data for easy manipulation
  plotData <- data.frame(t(outputData))
  
  # specify graph type
  if (graphType == "volcano") {
  
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
  p1 <- ggplot(data=plotData, aes(x=Log.2.Fold.Change, y= -log10(P.value), 
                                  col = diffexpressed, label = delabel)) +
    geom_point() +
    #x and y limits are currently hard-coded
    xlim(-1, 1) +
    ylim(0.001, 4.5)+
    theme_minimal() + 
    geom_text_repel() +
    scale_color_manual(values=c("red", "black")) +
    geom_hline(yintercept=-log10(0.05), col="red") 
  
  }

 return(p1)
}






