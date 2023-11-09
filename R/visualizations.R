#################################
#### Code for visualizations ####
#################################
#' 
#' Generating visualizations for MS Data
#' 
#' @description
#' Create specific graphics to illustrate the results of the data analysis function.
#' 
#' @param outputData A 2D data frame that corresponds to the output from the function
#' \code{analyze()} for the same name.
#' 
#' @param graphType A string indicating the graph type.
#' Current options are:
#' \enumerate{
#' \item "heatmap": heatmap.
#' \item "MA"
#' \item "normalize"
#' \item "pca"
#' \item "t-test"
#' \item "venn"
#' \item "volcano"
#' }
#' 
#' @param pkg A string specifying the source package used to plot the heatmap.
#' Two options: \code{"pheatmap"} and \code{"ggplot2"}.
#' This argument only works when \code{graphType = "heatmap"}.
#' 
#' @param cluster_cols A boolean (default = TRUE) determining if rows should be clustered
#' or \code{hclust} object. This argument only works when \code{graphType = "heatmap"} and
#' \code{pkg = "pheatmap"}.
#' 
#' @param cluster_rows A boolean (default = FALSE) determining if columns should be
#' clustered or \code{hclust} object. This argument only works when
#' \code{graphType = "heatmap"} and \code{pkg = "pheatmap"}.
#' 
#' @param show_colnames A boolean (default = TRUE) specifying if column names are be shown.
#' This argument only works when \code{graphType = "heatmap"} and \code{pkg = "pheatmap"}.
#' 
#' @param show_rownames A boolean (default = TRUE) specifying if row names are be shown.
#' This argument only works when \code{graphType = "heatmap"} and \code{pkg = "pheatmap"}.
#' 
#' @param compareConditions A string specifying which two conditions to compare. This
#' argument only works when there are more than two conditions in \code{outputData}.
#' 
#' @param transformType A string used to label the title of the transformation type for
#' the transformed MA plot.
#' 
#' @param fileName Filename specifying the name for Venn image output, or if NULL, it
#' returns the grid object itself.
#' 
#' @details 
#' The function \code{visualize()} is designed to work directly with output from the
#' function \code{analyze()}. Please be sure that the arguments \code{graphType} and
#' \code{testType} match.
#' 
#' @import dplyr
#' @import FactoMineR
#' @import ggrepel
#' @import ggplot2
#' @import pheatmap
#' @import tidyr
#' @import VennDiagram
#' @importFrom ggplotify as.ggplot
#' @importFrom graphics hist
#' 
#' @returns An object of class \code{ggplot}.
#' 
#' @export

visualize <- function(outputData,
                      graphType = "volcano",
                      pkg = "pheatmap",
                      cluster_cols = TRUE, cluster_rows = FALSE,
                      show_colnames = TRUE, show_rownames = TRUE,
                      compareConditions = c(),
                      transformType = NULL,
                      fileName) {
  
  if (graphType == "heatmap") {
    
    if(pkg == "pheatmap") {
      
      ## organize the data for pheatmap plotting
      plotData <- t(select(outputData, -c(R.Condition, R.FileName, R.Replicate)))
      colnames(plotData) <- paste0(outputData$R.Condition, "_", outputData$R.Replicate)
      
      plot <- pheatmap(mat = plotData,
                       cluster_cols = cluster_cols, cluster_rows = cluster_rows,
                       show_colnames = show_colnames, show_rownames = show_rownames)
      plot <- ggplotify::as.ggplot(plot)
      
    } else if (pkg == "ggplot2") {
      
      ## performing wide-to-long data reshaping for ggplot2 plotting
      plotData <- outputData %>%
        mutate(R.ConRep = paste0(R.Condition, "_", R.Replicate)) %>%
        select(-c(R.Condition, R.FileName, R.Replicate)) %>%
        pivot_longer(-R.ConRep)
      
      plot <- ggplot(plotData, aes(x= R.ConRep, y = name, fill = value)) +
        geom_tile(aes(width = 1.1, height = 1.1), color = "grey60", lwd = .5) +
        guides(fill = guide_colourbar(title = NULL)) +
        scale_y_discrete(limits = rev) +
        scale_fill_distiller(palette = "RdYlBu") +
        theme(axis.text.x = element_text(angle = -90, vjust = .5)) +
        xlab(NULL) +
        ylab(NULL)
    }
    
    return(plot)
    
  } else if (graphType == "MA") {
    
    if (nrow(outputData) == 2) {
      compareConditions <- rownames(outputData)
    } else if (nrow(outputData) > 2 & is.null(compareConditions)) {
      stop("There are more than two conditions in the data,
           please specify the two conditions to compare using 'compareConditions'!")
    }
    
    compareA <- compareConditions[1]
    compareB <- compareConditions[2]
    
    plotData <- data.frame(A = colMeans(outputData),
                           M = as.numeric(outputData[compareA,]-outputData[compareB,])) %>%
      mutate(Significant = cut(M, breaks = c(-Inf, -1, 1, Inf),
                               labels = c("Down", "No", "Up"))) %>%
      mutate(delabel = ifelse(Significant != "No",
                              gsub("_.*", "", rownames(plotData)), NA))
    
    plot <- ggplot(plotData, aes(x = A, y = M, color = Significant, label = delabel)) +
      geom_hline(yintercept = c(-1, 1), linetype = "dashed") +
      geom_point() +
      geom_text_repel() +
      scale_color_manual(values = c("Down" = "blue", "No" = "gray", "Up" = "red")) +
      labs(title = paste(transformType, "Transformed MA Plot")) +
      theme_bw() +
      theme(legend.position = "bottom", plot.title = element_text(hjust = .5))
    
    return(plot)
    
  } else if (graphType == "normalize") {
    
    plotData <- outputData %>%
      select(-R.FileName) %>%
      pivot_longer(-c(R.Condition, R.Replicate))

    plot <- ggplot(plotData, aes(x = R.Condition, y = value, fill = as.character(R.Replicate))) +
      geom_boxplot(varwidth = TRUE) +
      guides(fill = guide_legend(title = "Repilcate")) +
      labs(title = "Normalization Boxplot") +
      xlab("Condition") +
      ylab("Signal value") +
      scale_fill_brewer(palette = "RdYlBu") +
      theme_bw() +
      theme(legend.position = "bottom", plot.title = element_text(hjust = .5))
    
    return(plot)
    
  } else if (graphType == "pca") {
    
    row.names(outputData) <- outputData$R.FileName
    
    outputData_trim.trans <- outputData[,-1:-3]
    
    res.pca <- PCA(outputData_trim.trans, scale.unit = TRUE, ncp = 5, graph = T)
    
    #TODO: screeplot appears to be deprecated or not found in current factoextra
    #fviz_screeplot(res.pca, addlabels = TRUE, ylim = c(0, 99))
    
    return(res.pca)
    
  } else if (graphType == "t-test") {
    
    df.tmp <- data.frame(t(outputData))
    
    ## create a histogram of the difference in means
    hist(df.tmp$Difference.in.Means, main = "Histogram of Differences in Means",
         xlab = "Difference in Means", breaks = "Scott")
    
    ## create a histogram of the p-values
    hist(df.tmp$P.value, main = "Histogram of P-Values",
         xlab = "P-Value", breaks = "Scott")
    
  } else if (graphType == "venn") {
    
    paletteTemp <- c("red", "blue", "yellow", "green", "white")
    
    combos.list <- outputData
    
    venn.diagram(x = combos.list[1:length(combos.list)],
                 filename = fileName,
                 fill = c(paletteTemp[1:length(combos.list)]),
                 alpha = 0.2)
    
  } else if (graphType == "volcano") {
    
    ## transpose the data for easy manipulation
    plotData <- data.frame(t(outputData))
    
    ## add a column of NAs for coloring indication
    plotData$diffexpressed <- "NO"
    
    # if P-value < 0.05, set it as "Diff" for both coloring and naming
    plotData$diffexpressed[plotData$P.value < 0.05] <- "Diff"
    
    ## add a column of NAs for labeling
    plotData$delabel <- NA
    
    ## only label genes that are differentially expressed
    plotData$delabel[plotData$diffexpressed != "NO"] <-
      row.names(plotData[plotData$diffexpressed != "NO",])
    
    ############# Ugly current fix to remove species names
    plotData$delabel <- gsub("_.*", "", plotData$delabel)
    #############
    
    ## create a volcano plot with P-value = 0.05 cutoff and hard-coded range and scope
    p1 <- ggplot(plotData, aes(x = Log.Fold.Change, y = -log10(P.value),
                               col = diffexpressed, label = delabel)) +
      geom_point() +
      # set more force to make data labels closer, ideally to eliminate long lines
      geom_text_repel(force_pull = 3) +
      scale_color_manual(values = c("red", "black")) +
      geom_hline(yintercept = -log10(0.05), col = "red") +
      xlab(sprintf("%s Transformed Fold Change", transformType)) +
      labs(title = paste(conditionLabels[1], "vs.", conditionLabels[2])) +
      theme_minimal()
    
    return(p1)
  }
}


##----------------------------------------------------------------------------------------
#' 
#' Operate the Venn diagram functions
#' 
#' @description
#' Create a Venn diagram if useful, and provide a universal protein list.
#' 
#' @param combos.list The output from \code{sortCondition}, lists of condition combinations.
#' 
#' @param showUniversal A boolean specifying whether to return a list of proteins that are
#' present in every condition.
#' 
#' @param fileName A string ending in .tiff, specifying the name for the Venn diagram.
#' 
#' @returns The unions of conditions with each proteins present.
#' 
#' @export

vennMain <- function(combos.list, showUniversal = FALSE, fileName = "test.tiff") {
  
  ## above 4 conditions, Venn diagrams become less useful
  if (length(combos.list) <= 4) {
    visualize(combos.list, "venn", fileName)
  }
  
  if (showUniversal) {
    a <- get.venn.partitions(combos.list[1:length(combos.list)])
    universalProt <- a$..values..[[1]]
    
    ## return the filtered data
    return(a)
  }
  
  return()
}

