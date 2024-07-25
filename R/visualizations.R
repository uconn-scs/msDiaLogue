##
## msDiaLogue: Analysis + Visuals for Data Indep. Aquisition Mass Spectrometry Data
## Copyright (C) 2024  Shiying Xiao, Timothy Moore and Charles Watt
## Shiying Xiao <shiying.xiao@uconn.edu>
##
## This file is part of the R package msDiaLogue.
##
## The R package msDiaLogue is free software: You can redistribute it and/or
## modify it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or any later
## version (at your option). See the GNU General Public License at
## <https://www.gnu.org/licenses/> for details.
##
## The R package msDiaLogue is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
##

#################################
#### Code for visualizations ####
#################################
#' 
#' Generating visualizations for MS Data
#' 
#' @description
#' Create specific graphics to illustrate the results of the data analysis function.
#' 
#' @param dataSet A 2D data frame that corresponds to the output from the function
#' \code{analyze()} for the same name.
#' 
#' @param graphType A string indicating the graph type.
#' Current options are:
#' \enumerate{
#' \item "heatmap"
#' \item "MA"
#' \item "normalize"
#' \item "PCA_biplot"
#' \item "PCA_ind"
#' \item "PCA_scree"
#' \item "PCA_var"
#' \item "t-test"
#' \item "Upset"
#' \item "Venn"
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
#' @param M.thres The absolute threshold value of M (log fold-change) (default = 1) used
#' to plot the two vertical lines (-M.thres and M.thres) on the MA plot when
#' \code{graphType = "MA"}.
#' 
#' @param transformLabel A string (default = "Log2") used to label the title and axes of
#' the transformation type for the transformed MA plot when \code{graphType = "MA"}.
#' 
#' @param center A boolean (default = TRUE) indicating whether the variables should be
#' shifted to be zero centered when \code{graphType = "PCA_scree"},
#' \code{graphType = "PCA_ind"}, \code{graphType = "PCA_var"}, or
#' \code{graphType = "PCA_biplot"}.
#' 
#' @param scale A boolean (default = TRUE) indicating whether the variables should be
#' scaled to have unit variance before the analysis takes place when
#' \code{graphType = "PCA_scree"}, \code{graphType = "PCA_ind"},
#' \code{graphType = "PCA_var"}, or \code{graphType = "PCA_biplot"}.
#' 
#' @param addlabels A boolean (default = TRUE) specifying whether the elements are labeled.
#' \itemize{
#' \item For \code{graphType = "PCA_scree"}, it specifies whether labels are added at the
#' top of bars or points to show the information retained by each dimension.
#' \item For \code{graphType = "PCA_ind"}, it specifies whether the active individuals to
#' be labeled.
#' \item For \code{graphType = "PCA_var"}, it specifies whether the active variables to be
#' labeled.
#' }
#' 
#' @param choice A text (default = "variance") specifying the PCA data to be plotted the
#' scree plot when \code{graphType = "PCA_scree"}. Allowed values are "variance" or
#' "eigenvalue".
#' 
#' @param ncp	A numeric value (default = 10) specifying the number of dimensions to be
#' shown when \code{graphType = "PCA_scree"}.
#' 
#' @param addEllipses A boolean (default = TRUE) specifying whether to draw ellipses
#' around the individuals when \code{graphType = "PCA_ind"} or
#' \code{graphType = "PCA_biplot"}.
#' 
#' @param ellipse.level A numeric value (default = 0.95) specifying the size of the
#' concentration ellipse in normal probability when \code{graphType = "PCA_ind"} or
#' \code{graphType = "PCA_biplot"}.
#' 
#' @param label A text (default = "all") specifying the elements to be labelled when
#' \code{graphType = "PCA_biplot"}. Allowed values:
#' \itemize{
#' \item "all": Label both active individuals and active variables.
#' \item "ind": Label only active individuals.
#' \item "var": Label only active variables.
#' \item "none": No labels.
#' }
#' 
#' @param show_percentage A boolean (default = TRUE) specifying whether to show the
#' percentage for each set when \code{graphType = "Venn"}.
#' 
#' @param fill_color A text (default = c("blue", "yellow", "green", "red")) specifying the
#' colors to fill in circles when \code{graphType = "Venn"}.
#' 
#' @param show_universal A boolean (default = FALSE) specifying whether to return a
#' data.frame with logical columns representing sets when \code{graphType = "Venn"}.
#' 
#' @param P.thres THe threshold value of P-value (default = 0.05) used to plot the
#' horizontal line (-log10(P.thres)) on the volcano plot when \code{graphType = "volcano"}.
#' 
#' @param logF.thres The absolute threshold value of log2(fold change) (default = 0.6)
#' used to plot the two vertical lines (-logF.thres and logF.thres) on the volcano plot
#' when \code{graphType = "volcano"}.
#' 
#' @details 
#' The function \code{visualize()} is designed to work directly with output from the
#' function \code{analyze()}. Please be sure that the arguments \code{graphType} and
#' \code{testType} match.
#' 
#' @import dplyr
#' @import factoextra
#' @import ggplot2
#' @import ggrepel
#' @import ggvenn
#' @import pheatmap
#' @import tibble
#' @import tidyr
#' @importFrom stats density prcomp
#' @importFrom UpSetR fromList upset
#' 
#' @returns An object of class \code{ggplot}.
#' 
#' @autoglobal
#' 
#' @export

visualize <- function(
    dataSet, graphType = "volcano",
    pkg = "pheatmap", cluster_cols = TRUE, cluster_rows = FALSE, show_colnames = TRUE, show_rownames = TRUE,
    M.thres = 1 , transformLabel = "Log2",
    center = TRUE, scale = TRUE,
    addlabels = TRUE, choice = "variance", ncp = 10, addEllipses = TRUE, ellipse.level = 0.95, label = "all",
    show_percentage = TRUE, fill_color = c("blue", "yellow", "green", "red"), show_universal = FALSE,
    P.thres = 0.05, logF.thres = 0.6) {
  
  if (graphType == "heatmap") {
    
    if(pkg == "pheatmap") {
      
      ## organize the data for pheatmap plotting
      plotData <- t(select(dataSet, -c(R.Condition, R.Replicate)))
      colnames(plotData) <- paste0(dataSet$R.Condition, "_", dataSet$R.Replicate)
      
      pheatmap(mat = plotData,
               cluster_cols = cluster_cols, cluster_rows = cluster_rows,
               show_colnames = show_colnames, show_rownames = show_rownames)
      
    } else if (pkg == "ggplot2") {
      
      ## performing wide-to-long data reshaping for ggplot2 plotting
      plotData <- dataSet %>%
        mutate(R.ConRep = paste0(R.Condition, "_", R.Replicate)) %>%
        select(-c(R.Condition, R.Replicate)) %>%
        pivot_longer(-R.ConRep)
      
      ggplot(plotData, aes(x= R.ConRep, y = name, fill = value)) +
        geom_tile() +
        guides(fill = guide_colourbar(title = NULL)) +
        scale_y_discrete(limits = rev) +
        scale_fill_distiller(palette = "RdYlBu") +
        theme(axis.text.x = element_text(angle = -90, vjust = .5)) +
        xlab(NULL) +
        ylab(NULL)
    }
    
  } else if (graphType == "MA") {
    
    ## list of two conditions
    conditionA <- rownames(dataSet)[1]
    conditionB <- rownames(dataSet)[2]
    
    plotData <- data.frame(A = colMeans(dataSet),
                           M = as.numeric(dataSet[conditionA,] - dataSet[conditionB,])) %>%
      mutate(Significant = case_when(
        M > M.thres & M < Inf ~ "Up",
        M < -M.thres & M > -Inf ~ "Down",
        M >= -M.thres & M <= M.thres ~ "No",
        TRUE ~ "Unknown")) %>% ## optional catch-all for other cases
      mutate(delabel = ifelse(Significant != "No",
                              gsub("_.*", "", colnames(dataSet)), NA))
    
    ggplot(plotData, aes(x = A, y = M, color = Significant, label = delabel)) +
      geom_hline(yintercept = c(-M.thres, M.thres), linetype = "dashed") +
      geom_point() +
      geom_text_repel(show.legend = FALSE) +
      scale_color_manual(values = c("Down" = "blue", "No" = "gray", "Up" = "red")) +
      labs(title = paste(transformLabel, "Transformed MA Plot"),
           x = paste(transformLabel, "average abundance"),
           y = paste(transformLabel, "fold change")) +
      theme_bw() +
      theme(legend.position = "bottom", plot.title = element_text(hjust = .5))
    
  } else if (graphType == "normalize") {
    
    plotData <- dataSet %>%
      pivot_longer(-c(R.Condition, R.Replicate))
    
    ggplot(plotData, aes(x = R.Condition, y = value,
                         fill = if (length(unique(R.Replicate)) == 1) R.Condition else R.Replicate)) +
      geom_boxplot(varwidth = TRUE) +
      guides(fill = guide_legend(
        title = ifelse(length(unique(plotData$R.Replicate)) == 1, "Condition", "Repilcate"))) +
      labs(title = "Normalization Boxplot") +
      xlab("Condition") +
      ylab("Signal value") +
      scale_fill_brewer(palette = "RdYlBu") +
      theme_bw() +
      theme(legend.position = ifelse(length(unique(plotData$R.Replicate)) == 1, "none", "bottom"),
            plot.title = element_text(hjust = .5))
    
  } else if (grepl("^PCA_", graphType)) {
    
    plotData <- dataSet %>%
      mutate(R.ConRep = paste0(R.Condition, "_", R.Replicate)) %>%
      column_to_rownames(var = "R.ConRep") %>%
      select(-c(R.Condition, R.Replicate))
    
    res.pca <- prcomp(plotData, center = center, scale = scale)
    
    if (graphType == "PCA_scree") {
      
      fviz_screeplot(res.pca, choice = choice, ncp = ncp, addlabels = addlabels,
                     barcolor = "gray", barfill = "gray") +
        theme_bw() +
        theme(plot.title = element_text(hjust = 0.5))
      
    } else if (graphType == "PCA_ind") {
      
      fviz_pca_ind(res.pca, habillage = dataSet$R.Condition,
                   label = ifelse(addlabels, "ind", "none"),
                   addEllipses = addEllipses, ellipse.level = ellipse.level) +
        ggtitle("PCA graph of individuals") +
        theme_bw() +
        theme(legend.position = "bottom",
              plot.title = element_text(hjust = 0.5))
      
    } else if (graphType == "PCA_var") {
      
      fviz_pca_var(res.pca, label = ifelse(addlabels, "var", "none")) +
        ggtitle("PCA graph of variables") +
        theme_bw() +
        theme(plot.title = element_text(hjust = 0.5))
      
    } else if (graphType == "PCA_biplot") {
      
      fviz_pca_biplot(res.pca, habillage = dataSet$R.Condition,
                      label = label, col.var = "black",
                      addEllipses = addEllipses, ellipse.level = ellipse.level) +
        ggtitle("PCA graph of individuals and variables") +
        theme_bw() +
        theme(legend.position = "bottom",
              plot.title = element_text(hjust = 0.5))
    }
    
  } else if (graphType == "t-test") {
    
    plotData <- as.data.frame(t(dataSet)) %>%
      rownames_to_column(var = "RowName") %>%
      pivot_longer(-RowName) %>%
      group_by(name) %>%
      ## binwidth information for reference
      mutate(binwidth = ceiling(density(value)$bw/0.05)*0.05)

    Reduce("+", plyr::llply(unique(plotData$binwidth), function(k) {
      geom_histogram(data = plotData %>% filter(binwidth == k), aes(x = value),
                     binwidth = k, fill = "gray70", color = "black")
    }), init = ggplot()) +
      ylab("Frequency") +
      facet_wrap(.~name, scales = "free") +
      theme_bw()
    
  } else if (graphType == "Upset") {
    
    upset(data = fromList(dataSet), nsets = length(dataSet), nintersects = NA, order.by = "freq")
    
  } else if (graphType == "Venn") {
    
    if (length(dataSet) > 4) {
      message("More than 4 sets in a Venn diagram
              may result in crowded visualization and information overload.")
    } else {
      plot <- ggvenn::ggvenn(dataSet, show_percentage = show_percentage, fill_color = fill_color)
      print(plot)
    }
    
    if (show_universal) {
      df <- tibble(protein = unique(unlist(dataSet)))
      for (name in names(dataSet)) {
        df[, name] <- df$protein %in% dataSet[[name]]
      }
      return(df)
    }
    
  } else if (graphType == "volcano") {
    
    plotData <- data.frame(t(dataSet)) %>%
      mutate(Significant = case_when(
        P.value < P.thres & Difference > logF.thres ~ "Up",
        P.value < P.thres & Difference < -logF.thres ~ "Down",
        P.value < P.thres & Difference >= -logF.thres & Difference <= logF.thres ~ "Inconclusive",
        P.value >= P.thres ~ "No",
        TRUE ~ "Unknown")) %>% ## optional catch-all for other cases
      mutate(delabel = ifelse(! Significant %in% c("No", "Inconclusive"),
                              gsub("_.*", "", colnames(dataSet)), NA))

    ggplot(plotData, aes(x = Difference, y = -log10(P.value),
                         col = Significant, label = delabel)) +
      geom_vline(xintercept = c(-logF.thres, logF.thres), linetype = "dashed") +
      geom_hline(yintercept = -log10(P.thres), linetype = "dashed") +
      geom_point() +
      geom_text_repel(show.legend = FALSE) +
      scale_color_manual(values = c("Down" = "blue", "Up" = "red",
                                    "Inconclusive" = "gray", "No" = "gray20")) +
      labs(x = expression("log"[2]*"FC"), y = expression("-log"[10]*"P-value")) +
      theme_bw() +
      theme(legend.position = "bottom", plot.title = element_text(hjust = 0.5))
    
  }
}

