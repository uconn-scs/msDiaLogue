##
## msDiaLogue: Analysis + Visuals for Data Indep. Aquisition Mass Spectrometry Data
## Copyright (C) 2025  Shiying Xiao, Timothy Moore and Charles Watt
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
#' Boxplot
#' 
#' @description
#' Generate a boxplot for the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @export

visualize.boxplot <- function(dataSet) {
  
  plotData <- dataSet %>%
    pivot_longer(-c(R.Condition, R.Replicate))
  
  ggplot(plotData, aes(x = R.Condition, y = value,
                       fill = if (length(unique(R.Replicate)) == 1) R.Condition else R.Replicate)) +
    geom_boxplot(varwidth = TRUE) +
    guides(fill = guide_legend(
      title = ifelse(length(unique(plotData$R.Replicate)) == 1, "Condition", "Replicate"))) +
    xlab("Condition") +
    ylab("Signal value") +
    scale_fill_brewer(palette = "RdYlBu") +
    theme_bw() +
    theme(legend.position = ifelse(length(unique(plotData$R.Replicate)) == 1, "none", "bottom"),
          plot.title = element_text(hjust = .5))
  
}


##----------------------------------------------------------------------------------------
#' 
#' Heatmap
#' 
#' @description
#' Generate a heatmap for the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @param pkg A string (default = "pheatmap") specifying the source package used to plot
#' the heatmap. Two options: \code{"pheatmap"} and \code{"ggplot2"}.
#' 
#' @param cluster_cols A boolean (default = TRUE) determining if rows should be clustered
#' or \code{hclust} object. This argument only works when \code{pkg = "pheatmap"}.
#' 
#' @param cluster_rows A boolean (default = FALSE) determining if columns should be
#' clustered or \code{hclust} object. This argument only works when \code{pkg = "pheatmap"}.
#' 
#' @param show_colnames A boolean (default = TRUE) specifying if column names are be shown.
#' This argument only works when \code{pkg = "pheatmap"}.
#' 
#' @param show_rownames A boolean (default = TRUE) specifying if row names are be shown.
#' This argument only works when \code{pkg = "pheatmap"}.
#' 
#' @import pheatmap
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @autoglobal
#' 
#' @export

visualize.heatmap <- function(dataSet, pkg = "pheatmap",
                              cluster_cols = TRUE, cluster_rows = FALSE,
                              show_colnames = TRUE, show_rownames = TRUE) {
  
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
    
    ggplot(plotData, aes(x = R.ConRep, y = name, fill = value)) +
      geom_tile() +
      guides(fill = guide_colourbar(title = NULL)) +
      scale_y_discrete(limits = rev) +
      scale_fill_distiller(palette = "RdYlBu") +
      theme(axis.text.x = element_text(angle = -90, vjust = .5)) +
      xlab(NULL) +
      ylab(NULL)
    
  }
}


##----------------------------------------------------------------------------------------
#' 
#' MA plot: plots fold change versus average abundance
#' 
#' @description
#' Generate an MA plot for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.ma}}.
#' 
#' @param M.thres The absolute threshold value of M (fold-change) (default = 1) used to
#' plot the two vertical lines (-M.thres and M.thres) on the MA plot.
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @autoglobal
#' 
#' @export

visualize.ma <- function(dataSet, M.thres = 1) {
  
  information <- read.csv("preprocess_protein_information.csv", check.names = FALSE)
  scaffoldCheck <- any(colnames(information) == "Visible?")
  IDcol <- ifelse(scaffoldCheck, "AccessionNumber", "PG.ProteinName")
  labelCol <- ifelse(scaffoldCheck, "AlternateID", "PG.ProteinName")
  
  if (is.data.frame(dataSet)) {
    plotData <- as.data.frame(t(dataSet[c("A","M"),])) %>%
      rownames_to_column(IDcol)
  } else {
    plotData <- lapply(dataSet, function(df) {
      t(df[c("A","M"),]) %>%
        as.data.frame() %>%
        rownames_to_column(IDcol)
    }) %>%
      bind_rows(.id = "Comparison")
  }
  
  plotData <- plotData %>%
    mutate(Regulation = case_when(
      M > M.thres & M < Inf ~ "Up",
      M < -M.thres & M > -Inf ~ "Down",
      M >= -M.thres & M <= M.thres ~ "No",
      TRUE ~ "Unknown")) %>% ## optional catch-all for other cases
    left_join(information, by = IDcol) %>%
    mutate(Label = ifelse(Regulation != "No", .data[[labelCol]], NA)) # gsub("_.*", "", .data[[labelCol]])
  
  ggplot(plotData, aes(x = A, y = M, color = Regulation, label = Label)) +
    geom_hline(yintercept = c(-M.thres, M.thres), linetype = "dashed") +
    geom_point() +
    geom_text_repel(show.legend = FALSE) +
    scale_color_manual(values = c("Down" = "blue", "No" = "gray", "Up" = "red")) +
    labs(x = "Average Abundance", y = "Fold Change") +
    theme_bw() +
    theme(legend.position = "bottom") +
    if (!is.data.frame(dataSet)) {facet_wrap("Comparison")}
  
}


##----------------------------------------------------------------------------------------
#' 
#' Rank abundance distribution plot (Whittaker plot)
#' 
#' @description
#' Generate a rank abundance distribution plot, also known as Whittaker plot, for the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @param listName A character vector of proteins to highlight.
#' 
#' @param regexName A character vector specifying proteins for regular expression pattern
#' matching to highlight.
#' 
#' @param by A character string (default = "PG.ProteinName" for Spectronaut, default =
#' "AccessionNumber" for Scaffold) specifying the information to which \code{listName}
#' and/or \code{regexName} filter is applied. Allowable options include:
#' \itemize{
#' \item For Spectronaut: "PG.Genes", "PG.ProteinAccession", "PG.ProteinDescriptions", and
#' "PG.ProteinName".
#' \item For Scaffold: "ProteinDescriptions", "AccessionNumber", and "AlternateID".
#' }
#' 
#' @param facet A character string (default = c("Replicate", "Condition")) specifying
#' grouping variables for faceting. Allowed values are "Condition", "Replicate",
#' c("Condition", "Replicate"), c("Replicate", "Condition"), or "none" for no grouping.
#' 
#' @param color A string (default = red") specifying the color used to highlight proteins.
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @autoglobal
#' 
#' @export

visualize.rank <- function(dataSet, listName = NULL, regexName = NULL, by = NULL,
                           facet = c("Condition", "Replicate"), color = "red") {
  
  information <- read.csv("preprocess_protein_information.csv", check.names = FALSE)
  scaffoldCheck <- any(colnames(information) == "Visible?")
  IDcol <- ifelse(scaffoldCheck, "AccessionNumber", "PG.ProteinName")
  labelCol <- ifelse(scaffoldCheck, "AlternateID", "PG.ProteinName")
  
  if (is.null(by)) {
    by <- IDcol
  }
  
  ## only list filter if listName is present
  if (length(listName) != 0) {
    listIndex <- which(information[[by]] %in% listName)
  } else {
    listIndex <- NULL
  }
  
  ## only regex filter if regexName is present
  if (length(regexName) != 0) {
    regexIndex <- grep(paste(regexName, collapse = "|"), information[[by]])
  } else {
    regexIndex <- NULL
  }
  
  ## combine protein names from list and regex names
  unionIndex <- sort(union(listIndex, regexIndex))
  unionName <- information[unionIndex, IDcol]
  
  plotData <- dataSet %>%
    rename(Condition = R.Condition, Replicate = R.Replicate) %>%
    pivot_longer(-c("Condition", "Replicate"), names_to = IDcol, values_to = "Abundance") %>%
    left_join(information, by = IDcol) %>%
    mutate(Type = ifelse(.data[[IDcol]] %in% unionName, "Highlight", "Other"),
           Label = case_when(
             Type == "Highlight" & identical(facet, "Condition") ~ paste(.data[[labelCol]], Replicate, sep = "_"),
             Type == "Highlight" & identical(facet, "Replicate") ~ paste(.data[[labelCol]], Condition, sep = "_"),
             Type == "Highlight" & length(facet) == 2 ~ .data[[labelCol]],
             Type == "Other" ~ NA))
  
  if (!any(plotData$Type == "Highlight")) {
    stop("No matching proteins found in the input dataset to highlight!")
  }
  
  if (all(facet %in% c("Condition", "Replicate"))) {
    plotData <- plotData %>%
      group_by(across(all_of(facet))) %>%
      arrange(desc(Abundance), .by_group = TRUE) %>%
      mutate(Rank = row_number()) %>%
      ungroup()
  } else {
    plotData <- plotData %>%
      arrange(desc(Abundance)) %>%
      mutate(Rank = row_number())
  }
  
  highlight_label <- if (length(unionName) == 1) unionName else "Highlight"
  
  plot <- ggplot(plotData, aes(x = Rank, y = Abundance, shape = Type, color = Type)) +
    geom_point() +
    scale_color_manual(values = c("Highlight" = color, "Other" = "black"),
                       labels = c("Highlight" = highlight_label, "Other" = "Other")) +
    scale_shape_manual(values = c("Highlight" = 17, "Other" = 16),
                       labels = c("Highlight" = highlight_label, "Other" = "Other")) +
    labs(x = "Rank", y = "Abundance") +
    theme_bw() +
    theme(legend.position = "bottom",
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
  
  if (length(facet) == 1) {
    plot <- plot + facet_wrap(as.formula(paste("~", facet)))
  } else {
    plot <- plot + facet_grid(as.formula(paste(facet[1], "~", facet[2])))
  }
  
  if (length(unionName) > 1) {
    plot <- plot + geom_text_repel(data = plotData, aes(label = Label), size = 2.5, show.legend = FALSE)
  }
  
  return(plot)
}


##----------------------------------------------------------------------------------------
#' 
#' Histograms of fold changes and p-values from test results
#' 
#' @description
#' Generate histograms of fold changes and p-values for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.mod_t}}, \code{\link[msDiaLogue]{analyze.t}}, or
#' \code{\link[msDiaLogue]{analyze.wilcox}}.
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @autoglobal
#' 
#' @export

visualize.test <- function(dataSet) {
  
  if (is.data.frame(dataSet)) {
    plotData <- t(dataSet[c("difference","p-value"),]) %>%
      as.data.frame(check.names = FALSE) %>%
      rownames_to_column("Variable") %>%
      pivot_longer(-Variable) %>%
      group_by(name) %>%
      ## binwidth information for reference
      mutate(binwidth = ceiling(density(value)$bw/0.05)*0.05)
  } else {
    plotData <- lapply(dataSet[names(dataSet) != "total"], function(df) {
      t(df[c("difference","p-value"),]) %>%
        as.data.frame(check.names = FALSE) %>%
        rownames_to_column("Variable")
    }) %>%
      bind_rows(.id = "Comparison") %>%
      # rename(p.value = "p-value") %>%
      pivot_longer(-c("Variable", "Comparison")) %>%
      group_by(name, Comparison) %>%
      ## binwidth information for reference
      mutate(binwidth = ceiling(density(value)$bw/0.05)*0.05)
  }
  
  Reduce("+", plyr::llply(unique(plotData$binwidth), function(k) {
    geom_histogram(data = plotData %>% filter(binwidth == k), aes(x = value),
                   binwidth = k, fill = "gray70", color = "black")
  }), init = ggplot()) +
    ylab("Frequency") +
    theme_bw() +
    if (is.data.frame(dataSet)) {facet_wrap(.~name, scales = "free")} else {facet_wrap(.~Comparison + name, scales = "free")}
  
}


##----------------------------------------------------------------------------------------
#' 
#' UpSet plot
#' 
#' @description
#' Generate an UpSet plot for the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @importFrom UpSetR upset
#' 
#' @export

visualize.upset <- function(dataSet) {
  
  data <- sortcondition(dataSet)
  suppressWarnings(
    upset(data = data + 0, nsets = ncol(data), nintersects = NA, order.by = "freq")
  )
  
} 


##----------------------------------------------------------------------------------------
#' 
#' Venn diagram
#' 
#' @description
#' Generate a Venn diagram for the data.
#' 
#' @param dataSet The 2d data set of data.
#' 
#' @param show_percentage A boolean (default = TRUE) specifying whether to show the
#' percentage for each set.
#' 
#' @param fill_color A text (default = c("blue", "yellow", "green", "red")) specifying the
#' colors to fill in circles.
#' 
#' @param saveRes A boolean (default = TRUE) specifying whether to save the data, with
#' logical columns representing sets, to current working directory.
#' 
#' @import ggvenn
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @export

visualize.venn <- function(dataSet, show_percentage = TRUE,
                           fill_color = c("blue", "yellow", "green", "red"),
                           saveRes = TRUE) {
  
  if (length(dataSet) > 4) {
    message("More than 4 sets in a Venn diagram
             may result in crowded visualization and information overload.")
  }
  
  if (saveRes) {
    
    information <- read.csv("preprocess_protein_information.csv", check.names = FALSE)
    scaffoldCheck <- any(colnames(information) == "Visible?")
    IDcol <- ifelse(scaffoldCheck, "AccessionNumber", "PG.ProteinName")
    
    df <- tibble(!!IDcol := unique(unlist(dataSet)))
    for (name in names(dataSet)) {
      df[,name] <- df[[IDcol]] %in% dataSet[[name]]
    }
    
    df <- left_join(df, information, by = IDcol)
      
    write.csv(df, file = "venn_information.csv", row.names = FALSE)
  }
  
  ggvenn::ggvenn(dataSet, show_percentage = show_percentage, fill_color = fill_color)
  
}


##----------------------------------------------------------------------------------------
#' 
#' Volcano plot
#' 
#' @description
#' Generate a volcano plot for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.mod_t}}, \code{\link[msDiaLogue]{analyze.t}}, or
#' \code{\link[msDiaLogue]{analyze.wilcox}}.
#' 
#' @param P.thres THe threshold value of p-value (default = 0.05) used to plot the
#' horizontal line (-log10(P.thres)) on the volcano plot.
#' 
#' @param F.thres The absolute threshold value of fold change (default = 1) used to plot
#' the two vertical lines (-F.thres and F.thres) on the volcano plot.
#' 
#' @import ggrepel
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @autoglobal
#' 
#' @export

visualize.volcano <- function(dataSet, P.thres = 0.05, F.thres = 1) {
  
  information <- read.csv("preprocess_protein_information.csv", check.names = FALSE)
  scaffoldCheck <- any(colnames(information) == "Visible?")
  IDcol <- ifelse(scaffoldCheck, "AccessionNumber", "PG.ProteinName")
  labelCol <- ifelse(scaffoldCheck, "AlternateID", "PG.ProteinName")
  
  if (is.data.frame(dataSet)) {
    plotData <- t(dataSet[c("difference","p-value"),]) %>%
      as.data.frame() %>%
      rownames_to_column(IDcol)
  } else {
    plotData <- lapply(dataSet, function(df) {
      t(df[c("difference","p-value"),]) %>%
        as.data.frame() %>%
        rownames_to_column(IDcol)
    }) %>%
      bind_rows(.id = "Comparison")
  }
  
  plotData <- plotData %>%
    mutate(Significant = case_when(
      `p-value` < P.thres & difference > F.thres ~ "Up",
      `p-value` < P.thres & difference < -F.thres ~ "Down",
      `p-value` < P.thres & difference >= -F.thres & difference <= F.thres ~ "Inconclusive",
      `p-value` >= P.thres ~ "No",
      TRUE ~ "Unknown")) %>% ## optional catch-all for other cases
    left_join(information, by = IDcol) %>%
    mutate(Label = ifelse(! Significant %in% c("No", "Inconclusive"), .data[[labelCol]], NA)) # gsub("_.*", "", .data[[labelCol]])
  
  ggplot(plotData, aes(x = difference, y = -log10(`p-value`), col = Significant, label = Label)) +
    geom_vline(xintercept = c(-F.thres, F.thres), linetype = "dashed") +
    geom_hline(yintercept = -log10(P.thres), linetype = "dashed") +
    geom_point() +
    geom_text_repel(show.legend = FALSE) +
    scale_color_manual(values = c("Down" = "blue", "Up" = "red",
                                  "Inconclusive" = "gray", "No" = "gray20")) +
    labs(x = "Fold Change", y = expression("-log"[10]*"p-value")) +
    theme_bw() +
    theme(legend.position = "bottom") +
    if (!is.data.frame(dataSet)) {facet_wrap("Comparison")}
  
}


##----------------------------------------------------------------------------------------
#' 
#' Scree plot
#' 
#' @description
#' Generate a scree plot for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.pca}}.
#' 
#' @param type A string (default = c("bar", "line"))specifying the plot type. Allowed
#' values are "bar" for a barplot, "line" for a line plot, or c("bar", "line") to use both
#' types.
#' 
#' @param bar.color Color of the bar outline in the bar plot. Defaults to "gray".
#' 
#' @param bar.fill Fill color of the bars in the bar plot. Defaults to "gray".
#' 
#' @param line.color Color of the line and point in the line plot. Defaults to "black".
#' 
#' @param label A boolean (default = TRUE) specifying whether labels are added at the top
#' of bars or points to show the information retained by each dimension.
#' 
#' @param ncp	A numeric value (default = 10) specifying the number of dimensions to be
#' shown.
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @export

visualize.scree <- function(dataSet, type = c("bar", "line"),
                            bar.color = "gray", bar.fill = "gray", line.color = "black",
                            label = TRUE, ncp = 10) {
  
  variance <- (dataSet$sdev)^2
  df <- data.frame(dim = factor(1:length(variance)), percent = 100*variance/sum(variance))
  df <- df[1:min(ncp, nrow(df)), , drop = FALSE]
  plot <- ggplot(df, aes(dim, percent, group = 1))
  if ("bar" %in% type) {
    plot <- plot + geom_bar(stat = "identity", color = bar.color, fill = bar.fill)
  }
  if ("line" %in% type) {
    plot <- plot + geom_line(linetype = "solid", color = line.color) +
      geom_point(color = line.color)
  }
  plot <- plot + labs(x = "Dimensions", y = "Percentage of explained variances") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
  
  if (label) {
    plot <- plot +
      geom_text(label = paste0(round(df$percent, 1), "%"), vjust = -0.4, hjust = 0)
  }
  
  return(plot)
  
}


##----------------------------------------------------------------------------------------
#' 
#' Score plot / graph of individuals
#' 
#' @description
#' Generate a scores plot (graph of individuals) for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.pca}} or \code{\link[msDiaLogue]{analyze.plsda}}.
#' 
#' @param ellipse A boolean (default = TRUE) specifying whether to draw ellipses around
#' the individuals.
#' 
#' @param ellipse.level A numeric value (default = 0.95) specifying the size of the
#' concentration ellipse in normal probability.
#' 
#' @param label A boolean (default = TRUE) specifying whether the active individuals to be
#' labeled.
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @export

visualize.score <- function(dataSet, ellipse = TRUE, ellipse.level = 0.95, label = TRUE) {
  
  ## individual coordinates (scores)
  ind.coord <- dataSet$scores
  colnames(ind.coord) <- paste0("Dim.", 1:ncol(ind.coord))
  
  ## percentage of variance explained by each component
  if (inherits(dataSet, "pca")) {
    variance <- dataSet$sdev^2
    variance <- 100 * variance / sum(variance)
  } else if (inherits(dataSet, "plsda")) {
    variance <- 100 * dataSet$Xvar / dataSet$Xtotvar
  }
  
  ## extract coordinates for selected axes
  ind <- data.frame(Group = factor(gsub("_.*", "", rownames(ind.coord))),
                    Name = gsub("^.*_", "", rownames(ind.coord)),
                    ind.coord[, c(1,2), drop = FALSE],
                    stringsAsFactors = TRUE)
  
  ggplot(ind, aes(x = Dim.1, y = Dim.2, color = Group, shape = Group)) +
    geom_point() +
    { if (ellipse) stat_ellipse(aes(group = Group, fill = Group),
                                geom = "polygon", alpha = 0.1,
                                type = "norm", level = ellipse.level,
                                linetype = "solid", size = 0.5, show.legend = TRUE) } +
    { if (label) geom_text_repel(aes(label = Name), size = 3,
                                 max.overlaps = Inf, show.legend = FALSE) } +
    geom_hline(yintercept = 0, color = "black", linetype = "dashed") +
    geom_vline(xintercept = 0, color = "black", linetype = "dashed") +
    labs(x = paste0("Dim.1 (", round(variance[1], 1), "%)"),
         y = paste0("Dim.2 (", round(variance[2], 1), "%)")) +
    theme_bw() +
    theme(legend.position = "bottom", plot.title = element_text(hjust = 0.5))
  
}


##----------------------------------------------------------------------------------------
#' 
#' Loading plot / graph of variables
#' 
#' @description
#' Generate a loadings plot (graph of variables) for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.pca}} or \code{\link[msDiaLogue]{analyze.plsda}}.
#' 
#' @param label A boolean (default = TRUE) specifying whether the active variables to be
#' labeled.
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @autoglobal
#' 
#' @export

visualize.loading <- function(dataSet, label = TRUE) {
  
  ## variable-component correlaiton
  ## percentage of variance explained by each component
  if (inherits(dataSet, "pca")) {
    var.coord <- sweep(dataSet$loadings, 2, dataSet$sdev, "*")
    variance <- dataSet$sdev^2
    variance <- 100 * variance / sum(variance)
  } else if (inherits(dataSet, "plsda")) {
    var.coord <- sweep(dataSet$loadings, 2, sqrt(dataSet$Xvar/dataSet$Xtotvar), "*")
    variance <- 100 * dataSet$Xvar / dataSet$Xtotvar
  }
  colnames(var.coord) <- paste0("Dim.", 1:ncol(var.coord))
  
  ## combine into result data frame
  var <- data.frame(Name = rownames(var.coord),
                    var.coord[, c(1,2), drop = FALSE],
                    xstart = 0, ystart = 0,
                    stringsAsFactors = TRUE)
  
  plot <- ggplot(var, aes(x = Dim.1, y = Dim.2)) +
    geom_segment(data = var, aes(x = 0, y = 0, xend = Dim.1, yend = Dim.2),
                 arrow = arrow(length = unit(0.2, "cm")), color = "black") +
    { if (label) geom_text_repel(aes(label = Name), size = 3, max.overlaps = Inf) } +
    geom_hline(yintercept = 0, color = "black", linetype = "dashed") +
    geom_vline(xintercept = 0, color = "black", linetype = "dashed") +
    labs(x = paste0("Dim1 (", round(variance[1], 1), "%)"),
         y = paste0("Dim2 (", round(variance[2], 1), "%)")) +
    theme_bw() +
    theme(legend.position = "bottom", plot.title = element_text(hjust = 0.5))
  
  ## add unit correlation circle if scaling was applied
  if (is.numeric(dataSet$scale)) {
    theta <- c(seq(-pi, pi, length = 50), seq(pi, -pi, length = 50))
    circle <- data.frame(xcircle = cos(theta), ycircle = sin(theta), stringsAsFactors = TRUE)
    plot <- plot +
      geom_path(data = circle, aes(xcircle, ycircle), color = "grey70", size = 0.5) +
      coord_fixed()
  }
  
  return(plot)
}


##----------------------------------------------------------------------------------------
#' 
#' Biplot of score (individuals) and loading (variables)
#' 
#' @description
#' Generate a biplot of individuals and variables for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.pca}} or \code{\link[msDiaLogue]{analyze.plsda}}.
#' 
#' @param ellipse A boolean (default = TRUE) specifying whether to draw ellipses around
#' the individuals.
#' 
#' @param ellipse.level A numeric value (default = 0.95) specifying the size of the
#' concentration ellipse in normal probability.
#' 
#' @param label A text (default = "all") specifying the elements to be labelled.
#' Allowed values:
#' \itemize{
#' \item "all": Label both active individuals and active variables.
#' \item "ind": Label only active individuals.
#' \item "var": Label only active variables.
#' \item "none": No labels.
#' }
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @export

visualize.biplot <- function(dataSet, ellipse = TRUE, ellipse.level = 0.95, label = "all") {
  
  ## individual coordinates (scores)
  ind.coord <- dataSet$scores
  colnames(ind.coord) <- paste0("Dim.", 1:ncol(ind.coord))
  
  ind <- data.frame(Group = factor(gsub("_.*", "", rownames(ind.coord))),
                    Name = gsub("^.*_", "", rownames(ind.coord)),
                    ind.coord[, c(1,2), drop = FALSE],
                    stringsAsFactors = TRUE)
  
  ## variable-component correlaiton
  ## percentage of variance explained by each component
  if (inherits(dataSet, "pca")) {
    var.coord <- sweep(dataSet$loadings, 2, dataSet$sdev, "*")
    variance <- dataSet$sdev^2
    variance <- 100 * variance / sum(variance)
  } else if (inherits(dataSet, "plsda")) {
    var.coord <- sweep(dataSet$loadings, 2, sqrt(dataSet$Xvar/dataSet$Xtotvar), "*")
    variance <- 100 * dataSet$Xvar / dataSet$Xtotvar
  }
  colnames(var.coord) <- paste0("Dim.", 1:ncol(var.coord))
  
  var <- data.frame(Name = rownames(var.coord),
                    var.coord[, c(1,2), drop = FALSE],
                    xstart = 0, ystart = 0,
                    stringsAsFactors = TRUE)
  
  r <- min(max(ind[, "Dim.1"]) - min(ind[, "Dim.1"])/(max(var[, "Dim.1"]) - min(var[, "Dim.1"])),
           max(ind[, "Dim.2"]) - min(ind[, "Dim.2"])/(max(var[, "Dim.2"]) - min(var[, "Dim.2"])))
  
  var[, c("Dim.1", "Dim.2")] <- var[, c("Dim.1", "Dim.2")] * r * 0.7
  
  ggplot(ind, aes(x = Dim.1, y = Dim.2, color = Group, shape = Group)) +
    geom_point() +
    { if (ellipse) stat_ellipse(aes(group = Group, fill = Group),
                                geom = "polygon", alpha = 0.1,
                                type = "norm", level = ellipse.level,
                                linetype = "solid", size = 0.5, show.legend = TRUE) } +
    { if (label %in% c("all", "ind")) geom_text_repel(aes(label = Name), size = 3,
                                                      max.overlaps = Inf, show.legend = FALSE) } +
    geom_segment(inherit.aes = FALSE, data = var,
                 aes(x = 0, y = 0, xend = Dim.1, yend = Dim.2),
                 arrow = arrow(length = unit(0.2, "cm")), color = "black") +
    { if (label %in% c("all", "var")) geom_text_repel(inherit.aes = FALSE, data = var,
                                                      aes(x = Dim.1, y = Dim.2, label = Name),
                                                      size = 3, max.overlaps = Inf) } +
    geom_hline(yintercept = 0, color = "black", linetype = "dashed") +
    geom_vline(xintercept = 0, color = "black", linetype = "dashed") +
    labs(x = paste0("Dim1 (", round(variance[1], 1), "%)"),
         y = paste0("Dim2 (", round(variance[2], 1), "%)")) +
    theme_bw() +
    theme(legend.position = "bottom", plot.title = element_text(hjust = 0.5))
  
}


##----------------------------------------------------------------------------------------
#' 
#' VIP scores plot
#' 
#' @description
#' Generate a variable importance in projection (VIP) scores plot for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.plsda}}.
#' 
#' @param comp An integer (default = 1) specifying the PLS-DA component to use when
#' ranking variables.
#' 
#' @param num An integer (default = 10) specifying the number of top variables (highest
#' VIP scores) to display.
#' 
#' @param thres A scalar (default = 1) specifying the vertical dashed line drawn at this
#' VIP value.
#' 
#' @param rel.widths A numerical vector specifying the proportion of relative widths for
#' the plot panels. Defaults to widths chosen based on the range of the top variables' VIP
#' scores and the number of group conditions.
#' 
#' @importFrom cowplot plot_grid
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @autoglobal
#' 
#' @export

visualize.vip <- function(dataSet, comp = 1, num = 10, thres = 1, rel.widths) {
  
  information <- read.csv("preprocess_protein_information.csv", check.names = FALSE)
  scaffoldCheck <- any(colnames(information) == "Visible?")
  IDcol <- ifelse(scaffoldCheck, "AccessionNumber", "PG.ProteinName")
  labelCol <- ifelse(scaffoldCheck, "AlternateID", "PG.ProteinName")
  
  vips <- as.data.frame(dataSet[["vips"]]) %>%
    select(Score = paste("Comp", comp)) %>%
    slice_max(order_by = Score, n = num, with_ties = FALSE) %>%
    arrange(Score) %>%
    rownames_to_column(IDcol) %>%
    left_join(information, by = IDcol) %>%
    mutate(!!IDcol := factor(.data[[IDcol]], levels = .data[[IDcol]]),
           !!labelCol := factor(.data[[labelCol]], levels = .data[[labelCol]]))
  
  plot1 <- ggplot(vips, aes(x = Score, y = .data[[labelCol]])) +
    geom_point() +
    geom_vline(xintercept = thres, linetype = "dashed", color = "black") +
    labs(x = "VIP scores", y = NULL) +
    theme_bw() +
    theme(panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_line(linetype = "dashed"))
  
  xs <- dataSet$model[["xs"]][,levels(vips[[IDcol]]), drop = FALSE]
  y <- dataSet$model[["y"]]
  group <- factor(colnames(y)[max.col(y, ties.method = "first")], levels = colnames(y))
  abundances <- do.call(cbind, by(xs, group, function(x) {apply(x, 2, mean, trim = 0.1)})) %>%
    as.data.frame() %>%
    rownames_to_column(IDcol) %>%
    mutate(!!IDcol := factor(.data[[IDcol]], levels = .data[[IDcol]])) %>%
    pivot_longer(-!!IDcol, names_to = "Group", values_to = "Abundance")
  
  plot2 <- ggplot(abundances, aes(x = Group, y = .data[[IDcol]], fill = Abundance)) +
    # geom_tile(width = 0.5, height = 0.5, color = "white") +
    geom_tile(color = "white", lwd = 7) +
    scale_x_discrete(position = "bottom") +
    guides(fill = guide_colourbar(title = NULL)) +
    scale_fill_distiller(palette = "RdYlBu") +
    xlab(NULL) +
    ylab(NULL) +
    coord_fixed(ratio = 1) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank())
  
  if (missing(rel.widths)) {
    rel.widths <- c(diff(range(vips$Score)), nlevels(group)/3)
  }
  
  plot_grid(plot1, plot2, ncol = 2, rel_widths = rel.widths, align = "h", axis = "b")
  
}

