#######################
#### Visualization ####
#######################
#' 
#' Boxplot
#' 
#' @description
#' Generate a boxplot for the data.
#' 
#' @param dataSet A data frame containing the data signals.
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @export

visualize.boxplot <- function(dataSet) {
  
  plotData <- dataSet %>%
    pivot_longer(-c(R.Condition, R.Replicate))
  
  if (length(unique(dataSet$R.Replicate)) == 1) {
    fill_var <- "R.Condition"
    nfill <- length(unique(dataSet$R.Condition))
  } else {
    fill_var <- "R.Replicate"
    nfill <- length(unique(dataSet$R.Replicate))
  }
  
  if (nfill <= 11) {
    fill_scale <- scale_fill_brewer(palette = "RdYlBu")
  } else {
    cols <- colorRampPalette(brewer.pal(11, "RdYlBu"))(nfill)
    fill_scale <- scale_fill_manual(values = cols)
  }
  
  ggplot(plotData, aes(x = R.Condition, y = value, fill = .data[[fill_var]])) +
    geom_boxplot(varwidth = TRUE) +
    guides(fill = guide_legend(
      title = ifelse(fill_var == "R.Condition", "Condition", "Replicate"))) +
    xlab("Condition") +
    ylab("Signal value") +
    fill_scale +
    theme_bw() +
    theme(legend.position = ifelse(fill_var == "R.Condition", "none", "bottom"),
          plot.title = element_text(hjust = .5))

}

##------------------------------------------------------------------------------
#'
#' Abundance distributions
#'
#' @description
#' Generate distribution plots for protein abundance values.
#' 
#' @param dataSet A data frame containing the data signals, or a list of data
#' frames.
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @details
#' If \code{dataSet} is a single data frame, the function summarizes
#' the distribution of proteins' average abundance across conditions  
#' and replicates, including both a kernel density estimate and an empirical  
#' cumulative distribution function (ECDF).
#' 
#' If \code{dataSet} is a list of data frames, the function produces comparative
#' density plots across data sets (e.g., before vs after imputation), stratified
#' by "R.Condition".
#' 
#' @autoglobal
#' 
#' @export

visualize.dist <- function(dataSet) {
  
  if (is.data.frame(dataSet)) {
    
    plotData <- dataSet %>%
      pivot_longer(-c(R.Condition, R.Replicate)) %>%
      group_by(name) %>%
      summarise(mean  = mean(value, na.rm = TRUE),
                Group = if_else(any(is.na(value)), "Missing", "Valid"),
                .groups = "drop")
    
    if(n_distinct(plotData$Group) > 1) {
      
      ggplot() +
        stat_density(
          data = plotData %>%
            mutate(Panel = factor("Probability Density",
                                  levels = c("Probability Density",
                                             "Cumulative Probability"))),
          aes(x = mean, color = Group), na.rm = TRUE, geom = "line") +
        stat_ecdf(
          data = plotData %>%
            mutate(Panel = factor("Cumulative Probability",
                                  levels = c("Probability Density",
                                             "Cumulative Probability"))),
          aes(x = mean, col = Group), na.rm = TRUE, geom = "line", pad = FALSE) +
        facet_wrap(~ Panel, scales = "free_y") +
        labs(x = "Average Abundance", y = NULL) +
        theme_bw() +
        theme(legend.position = "bottom")
      
    } else {
      
      ggplot() +
        stat_density(
          data = plotData %>%
            mutate(Panel = factor("Probability Density",
                                  levels = c("Probability Density",
                                             "Cumulative Probability"))),
          aes(x = mean), na.rm = TRUE, geom = "line") +
        stat_ecdf(
          data = plotData %>%
            mutate(Panel = factor("Cumulative Probability",
                                  levels = c("Probability Density",
                                             "Cumulative Probability"))),
          aes(x = mean), na.rm = TRUE, geom = "line", pad = FALSE) +
        facet_wrap(~ Panel, scales = "free_y") +
        labs(x = "Average Abundance", y = NULL) +
        theme_bw()
      
    }
  } else if (is.list(dataSet)) {
    
    nm <- names(dataSet)
    if (is.null(nm) || any(nm == "")) {
      nm <- paste("Data", seq_along(dataSet))
    }
    
    plotData <- lapply(seq_along(dataSet), function(k) {
      dataSet[[k]] %>%
        pivot_longer(cols = -c(R.Condition, R.Replicate),
                     names_to = "name", values_to = "value") %>%
        mutate(Panel = nm[k], .before = 1)
    }) %>%
      bind_rows() %>%
      rename(Condition = R.Condition) %>%
      mutate(Panel = factor(Panel, levels = nm))
    
    ggplot(plotData, aes(value, color = Condition)) +
      stat_density(geom = "line", na.rm = TRUE) +
      facet_wrap(~ Panel) +
      labs(x = "Abundance", y = "Density") +
      theme_bw() +
      theme(legend.position = "bottom")
    
  }
  
}

##------------------------------------------------------------------------------
#' 
#' Heatmap
#' 
#' @description
#' Generate a heatmap for the data.
#' 
#' @param dataSet A data frame containing the data signals.
#' 
#' @param pkg A character string (default = "pheatmap") specifying
#' the source package used to plot the heatmap.
#' Two options: \code{"pheatmap"} and \code{"ggplot2"}.
#' 
#' @param cluster_cols A logical value (default = TRUE) determining
#' if rows should be clustered or \code{hclust} object.
#' This argument only works when \code{pkg = "pheatmap"}.
#' 
#' @param cluster_rows A logical value (default = FALSE) determining
#' if columns should be clustered or \code{hclust} object.
#' This argument only works when \code{pkg = "pheatmap"}.
#' 
#' @param show_colnames A logical value (default = TRUE) specifying
#' if column names are be shown.
#' This argument only works when \code{pkg = "pheatmap"}.
#' 
#' @param show_rownames A logical value (default = TRUE) specifying
#' if row names are be shown.
#' This argument only works when \code{pkg = "pheatmap"}.
#' 
#' @param show_pct_cols A logical value (default = FALSE) specifying whether
#' to append the percentage of missing values to the column names.
#' Only applied when \code{dataSet} contains missing values.
#' 
#' @param show_pct_rows A logical value (default = TRUE) specifying whether
#' to append the percentage of missing values to the row names.
#' Only applied when \code{dataSet} contains missing values.
#' 
#' @param show_pct_legend A logical value (default = TRUE) specifying whether
#' the percentages of missing and present values in the entire data set
#' are shown in the legend.
#' Only applied when \code{dataSet} contains missing values.
#' 
#' @param saveRes A logical value (default = TRUE) specifying whether
#' to save a summary of missingness information.
#' Only applied when \code{dataSet} contains missing values.
#' 
#' @import pheatmap
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @details
#' A summary of missingness information including:
#' \itemize{
#' \item "count_missing_protein": The count of missing values for each protein.
#' \item "pct_missing_protein": The percentage of missing values for each protein.
#' \item "pct_missing_total": The percentage of missing values for each protein
#' relative to the total missing values in the entire data set.
#' }
#' 
#' @autoglobal
#' 
#' @export

visualize.heatmap <- function(dataSet, pkg = "pheatmap",
                              cluster_cols = TRUE, cluster_rows = FALSE,
                              show_colnames = TRUE, show_rownames = TRUE,
                              show_pct_cols = FALSE, show_pct_rows = TRUE,
                              show_pct_legend = TRUE, saveRes = TRUE) {
  
  plotData <- select(dataSet, -c(R.Condition, R.Replicate))
  rownames(plotData) <- paste0(dataSet$R.Condition, "_", dataSet$R.Replicate)
  
  if (anyNA(dataSet)) {
    
    dataMissing <- is.na(plotData)
    count_missing_protein <- colSums(dataMissing)
    pct_missing_conrep <- rowMeans(dataMissing) * 100
    pct_missing_protein <- colMeans(dataMissing) * 100
    pct_missing_total <- count_missing_protein / sum(count_missing_protein) * 100
    pct_missing <- mean(dataMissing) * 100
    
    if (show_pct_legend) {
      if (pct_missing < 1) {
        lab_missing <- "Missing (< 1%)"
        lab_present <- "Present (> 99%)"
      } else {
        lab_missing <- sprintf("Missing (%.1f%%)", pct_missing)
        lab_present <- sprintf("Present (%.1f%%)", 100 - pct_missing)
      }
    } else {
      lab_missing <- "Missing"
      lab_present <- "Present"
    }
    
    ## protein
    if (show_pct_rows) {
      pct_rows <- ifelse(pct_missing_protein == 0, "",
                         sprintf(" (%.1f%%)", pct_missing_protein))
      colnames(plotData) <- paste0(colnames(plotData), pct_rows)
    }
    
    ## condition-replicate
    if (show_pct_cols) {
      pct_cols <- ifelse(pct_missing_conrep == 0, "",
                         sprintf(" (%.1f%%)", pct_missing_conrep))
      rownames(plotData) <- paste0(rownames(plotData), pct_cols)
    }
    
    if (saveRes) {
      
      information <- read.csv("preprocess_protein_information.csv", check.names = FALSE)
      scaffoldCheck <- any(colnames(information) == "Visible?")
      IDcol <- ifelse(scaffoldCheck, "AccessionNumber", "PG.ProteinName")
      
      df <- data.frame(count_missing_protein,
                       pct_missing_protein,
                       pct_missing_total) %>%
        rownames_to_column(IDcol) %>%
        left_join(information, by = IDcol)
      
      write.csv(df, file = "missing_information.csv", row.names = FALSE)
    }
    
    if(pkg == "pheatmap") {
      
      pheatmap(mat = t(ifelse(is.na(plotData), 0, 1)),
               color = c("grey20", "grey80"), legend_breaks = c(0, 1),
               legend_labels = c(lab_missing, lab_present),
               cluster_cols = cluster_cols, cluster_rows = cluster_rows,
               show_colnames = show_colnames, show_rownames = show_rownames)
      
    } else if (pkg == "ggplot2") {
      
      ## performing wide-to-long data reshaping for ggplot2 plotting
      plotData <- as.data.frame(plotData) %>%
        rownames_to_column("R.ConRep") %>%
        pivot_longer(-R.ConRep)
      
      ggplot(plotData, aes(x = R.ConRep, y = name, fill = factor(is.na(value)))) +
        geom_tile(color = "grey60") +
        guides(fill = guide_legend(title = NULL)) +
        labs(x = NULL, y = NULL) +
        scale_fill_manual(values = c("TRUE" = "grey20", "FALSE" = "grey80"),
                          labels = c("TRUE" = lab_missing, "FALSE" = lab_present),
                          drop = FALSE) +
        scale_y_discrete(limits = rev) +
        theme(axis.text.x = element_text(angle = -90, vjust = .5),
              axis.ticks = element_blank(),
              panel.background = element_blank())
      
    }
    
  } else {
    
    if (pkg == "pheatmap") {
      
      pheatmap(mat = t(plotData),
               cluster_cols = cluster_cols, cluster_rows = cluster_rows,
               show_colnames = show_colnames, show_rownames = show_rownames)
      
    } else if (pkg == "ggplot2") {
      
      ## performing wide-to-long data reshaping for ggplot2 plotting
      plotData <- as.data.frame(plotData) %>%
        rownames_to_column("R.ConRep") %>%
        pivot_longer(-R.ConRep)
      
      ggplot(plotData, aes(x = R.ConRep, y = name, fill = value)) +
        geom_tile(color = "grey60") +
        guides(fill = guide_colourbar(title = NULL)) +
        labs(x = NULL, y = NULL) +
        scale_y_discrete(limits = rev) +
        scale_fill_distiller(palette = "RdYlBu") +
        theme(axis.text.x = element_text(angle = -90, vjust = .5),
              axis.ticks = element_blank(),
              panel.background = element_blank())
      
    }
  }
}

##------------------------------------------------------------------------------
#' 
#' MA plot: plots fold change versus average abundance
#' 
#' @description
#' Generate an MA plot for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.ma}}.
#' 
#' @param M.thres The absolute threshold value of M (fold-change) (default = 1)
#' used to plot the two vertical lines (-M.thres and M.thres) on the MA plot.
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

##------------------------------------------------------------------------------
#' 
#' Rank abundance distribution plot (Whittaker plot)
#' 
#' @description
#' Generate a rank abundance distribution plot, also known as Whittaker plot,
#' for the data.
#' 
#' @param dataSet A data frame containing the data signals.
#' 
#' @param listName A character vector specifying
#' proteins for exact matching to highlight.
#' 
#' @param regexName A character vector specifying
#' proteins for regular expression pattern matching to highlight.
#' 
#' @param by A character string (default = "PG.ProteinName" for Spectronaut,
#' default = "AccessionNumber" for Scaffold) specifying
#' the information to which \code{listName} and/or \code{regexName} filter
#' is applied. Allowable options include:
#' \itemize{
#' \item For Spectronaut: "PG.Genes", "PG.ProteinAccession",
#' "PG.ProteinDescriptions", and "PG.ProteinName".
#' \item For Scaffold: "ProteinDescriptions", "AccessionNumber", and
#' "AlternateID".
#' }
#' 
#' @param facet A character string (default = c("Replicate", "Condition"))
#' specifying grouping variables for faceting. Allowed values are:
#' \itemize{
#' \item "Condition": Abundance values are averaged across replicates.
#' \item "Replicate": Abundance values are averaged across conditions.
#' \item c("Condition", "Replicate"): No averaging is performed.
#' \item c("Replicate", "Condition"): No averaging is performed.
#' }
#' 
#' @param ht.color A character string (default = "black") specifying
#' the point color of highlighted proteins.
#'
#' @param ht.shape A numeric value (default = 17) specifying
#' the point shape of highlighted points.
#' See [ggplot2: Elegant Graphics for Data Analysis](https://ggplot2-book.org/scales-other.html#sec-scale-shape)
#' for more details.
#' 
#' @param ht.size A numeric value (default = 1.5) specifying
#' the point size of highlighted proteins.
#' 
#' @param ht.textcolor A character string (default = "black") specifying
#' the font color of text labels for highlighted proteins.
#' 
#' @param ht.textsize A numeric value (default = 2) specifying
#' the font size of text labels for highlighted proteins.
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @autoglobal
#' 
#' @export

visualize.rank <- function(dataSet, listName = c(), regexName = c(), by = NULL,
                           facet = c("Condition", "Replicate"),
                           ht.color = "black", ht.shape = 17, ht.size = 1.5,
                           ht.textcolor = "black", ht.textsize = 2) {
  
  information <- read.csv("preprocess_protein_information.csv", check.names = FALSE)
  scaffoldCheck <- "Visible?" %in% colnames(information)
  IDcol <- if (scaffoldCheck) "AccessionNumber" else "PG.ProteinName"
  labelCol <- if (scaffoldCheck) "AlternateID" else "PG.ProteinName"
  by <- if (is.null(by)) IDcol else by
  
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
  
  if (length(unionName) == 0) {
    message("No matching proteins found to highlight!")
  }
  
  plotData <- dataSet %>%
    rename(Condition = R.Condition, Replicate = R.Replicate) %>%
    pivot_longer(-c("Condition", "Replicate"), names_to = IDcol, values_to = "Abundance")
  
  if (!setequal(facet, c("Condition", "Replicate"))) {
    plotData <- plotData %>%
      group_by(across(all_of(c(facet, IDcol)))) %>%
      summarise(Abundance = mean(Abundance, na.rm = TRUE), .groups = "drop")
  }
  
  plotData <- plotData %>%
    left_join(information, by = IDcol) %>%
    mutate(Type = if_else(.data[[IDcol]] %in% unionName, "Highlight", "Other"),
           Label = if_else(Type == "Highlight", .data[[labelCol]], NA_character_)) %>%
    group_by(across(all_of(facet))) %>%
    arrange(desc(Abundance), .by_group = TRUE) %>%
    mutate(Rank = row_number()) %>%
    ungroup()
  
  plot <- ggplot(plotData, aes(x = Rank, y = Abundance)) +
    geom_point(data = subset(plotData, Type == "Other"), shape = 16, color = "gray") +
    geom_point(data = subset(plotData, Type == "Highlight"),
               color = ht.color, shape = ht.shape, size = ht.size) +
    labs(x = "Rank", y = "Abundance") +
    theme_bw() +
    theme(legend.position = "none",
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())
  
  if (length(facet) == 1) {
    plot <- plot + facet_wrap(as.formula(paste("~", facet)))
  } else {
    plot <- plot + facet_grid(as.formula(paste(facet[1], "~", facet[2])))
  }
  
  if (length(unionName) != 0) {
    plot <- plot +
      geom_text_repel(data = subset(plotData, Type == "Highlight"),
                      aes(label = Label),
                      color = ht.textcolor, size = ht.textsize,
                      show.legend = FALSE)
  }
  
  return(plot)
}

##------------------------------------------------------------------------------
#'
#' Target protein abundance plot
#'
#' @description
#' Generate bar, box, or violin plots for selected protein(s) of interest.
#' 
#' @param dataSet A data frame containing the data signals.
#' 
#' @param type A character string specifying the plot type.
#' Allowable options include:
#' \itemize{
#' \item "bar": Bar chart.
#' \item "boxplot": Boxplot.
#' \item "violin": Violin plot.
#' }
#' 
#' @param facet A logical value (default = TRUE) specifying whether
#' to facet the plot by protein.
#' 
#' @param listName A character vector specifying
#' proteins for exact matching to highlight.
#' 
#' @param regexName A character vector specifying
#' proteins for regular expression pattern matching to highlight.
#' 
#' @param by A character string (default = "PG.ProteinName" for Spectronaut,
#' default = "AccessionNumber" for Scaffold) specifying
#' the information to which \code{listName} and/or \code{regexName} filter
#' is applied. Allowable options include:
#' \itemize{
#' \item For Spectronaut: "PG.Genes", "PG.ProteinAccession",
#' "PG.ProteinDescriptions", and "PG.ProteinName".
#' \item For Scaffold: "ProteinDescriptions", "AccessionNumber", and
#' "AlternateID".
#' }
#' 
#' @return
#' An object of class \code{ggplot}.
#'
#' @autoglobal
#'
#' @export

visualize.target <- function(dataSet, type = "bar", facet = TRUE,
                             listName = c(), regexName = c(), by = NULL) {
  
  information <- read.csv("preprocess_protein_information.csv", check.names = FALSE)
  scaffoldCheck <- "Visible?" %in% colnames(information)
  IDcol <- if (scaffoldCheck) "AccessionNumber" else "PG.ProteinName"
  by <- if (is.null(by)) IDcol else by
  
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
  
  if (length(unionName) == 0) {
    stop("No matching proteins found to plot!")
  }
  
  plotData <- dataSet %>%
    rename(Condition = R.Condition, Replicate = R.Replicate) %>%
    pivot_longer(-c("Condition", "Replicate"),
                 names_to = "Protein", values_to = "Abundance") %>%
    filter(Protein %in% unionName, !is.na(Abundance))
  
  if (type == "bar") {
    smrData <- plotData %>%
      group_by(Protein, Condition) %>%
      summarise(mean = mean(Abundance, na.rm = TRUE),
                sd = sd(Abundance, na.rm = TRUE),
                n = n(), .groups = "drop") %>%
      mutate(error = qnorm(0.975) * sd / sqrt(n))
    if (facet) {
      ggplot(smrData, aes(x = Condition, y = mean)) +
        geom_col(width = 0.7, color = "black", fill = "gray") +
        geom_errorbar(aes(ymin = mean - error, ymax = mean + error),
                      width = 0.3) +
        geom_point(data = plotData, aes(x = Condition, y = Abundance, color = Replicate),
                   shape = 18, position = position_dodge(width = 0.3), size = 2) +
        facet_wrap(~Protein) +
        labs(y = expression("Abundance"~"(\u00B195% CI)")) +
        theme_bw() +
        theme(legend.position = "bottom")
    } else {
      ggplot(smrData, aes(x = Protein, y = mean, fill = Condition)) +
        geom_col(width = 0.7, position = position_dodge(width = 0.8)) +
        geom_errorbar(aes(ymin = mean - error, ymax = mean + error),
                      position = position_dodge(width = 0.8),
                      width = 0.3) +
        geom_point(data = plotData, aes(x = Protein, y = Abundance,
                                        group = Condition, shape = Replicate),
                   position = position_jitterdodge(dodge.width = 0.8,
                                                   jitter.width = 0.3),
                   size = 1) +
        guides(fill = guide_legend(override.aes = list(shape = NA)), shape = "none") +
        labs(x = NULL, y = expression("Abundance"~"(\u00B195% CI)")) +
        theme_bw() +
        theme(legend.position = "bottom")
    }
  } else if (type == "boxplot") {
    if (facet) {
      ggplot(plotData, aes(x = Condition, y = Abundance)) +
        geom_boxplot(width = 0.7) +
        geom_point(aes(color = Replicate),
                   shape = 18, position = position_dodge(width = 0.3), size = 2) +
        facet_wrap(~Protein) +
        theme_bw() +
        theme(legend.position = "bottom")
    } else {
      ggplot(plotData, aes(x = Protein, y = Abundance, fill = Condition,
                           group = interaction(Protein, Condition))) +
        geom_boxplot(position = position_dodge(width = 0.8)) +
        geom_point(aes(shape = Replicate),
                   position = position_jitterdodge(dodge.width = 0.8,
                                                   jitter.width = 0.3),
                   size = 1) +
        guides(fill = guide_legend(override.aes = list(shape = NA)), shape = "none") +
        labs(x = NULL) +
        theme_bw() +
        theme(legend.position = "bottom")
    }
  } else if (type == "violin") {
    if (facet) {
      ggplot(plotData, aes(x = Condition, y = Abundance)) +
        geom_violin(width = 0.7) +
        geom_point(aes(color = Replicate),
                   shape = 18, position = position_dodge(width = 0.1), size = 2) +
        facet_wrap(~Protein) +
        theme_bw() +
        theme(legend.position = "bottom")
    } else {
      ggplot(plotData, aes(x = Protein, y = Abundance, fill = Condition,
                           group = interaction(Protein, Condition))) +
        geom_violin(position = position_dodge(width = 0.8)) +
        geom_point(aes(shape = Replicate),
                   position = position_jitterdodge(dodge.width = 0.8,
                                                   jitter.width = 0.1),
                   size = 1) +
        guides(fill = guide_legend(override.aes = list(shape = NA)), shape = "none") +
        labs(x = NULL) +
        theme_bw() +
        theme(legend.position = "bottom")
    }
  }
}

##------------------------------------------------------------------------------
#' 
#' Histograms of fold changes and p-values from test results
#' 
#' @description
#' Generate histograms of fold changes and p-values for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.mod_t}}, \code{\link[msDiaLogue]{analyze.t}},
#' or \code{\link[msDiaLogue]{analyze.wilcox}}.
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
    if (is.data.frame(dataSet)) {
      facet_wrap(.~name, scales = "free")
    } else {
      facet_wrap(.~Comparison + name, scales = "free")
    }
  
}

##------------------------------------------------------------------------------
#' 
#' UpSet plot
#' 
#' @description
#' Generate an UpSet plot for the data.
#' 
#' @param dataSet A data frame containing the data signals.
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

##------------------------------------------------------------------------------
#' 
#' Venn diagram
#' 
#' @description
#' Generate a Venn diagram for the data.
#' 
#' @param dataSet A data frame containing the data signals.
#' 
#' @param show_percentage A logical value (default = TRUE) specifying whether
#' to show the percentage for each set.
#' 
#' @param fill_color A character vector
#' (default = c("blue", "yellow", "green", "red")) specifying
#' the colors to fill in circles.
#' 
#' @param saveRes A logical value (default = TRUE) specifying whether
#' to save the data, with logical columns representing sets, to current working
#' directory.
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
  
  data <- sortcondition(dataSet)
  
  if (length(data) > 4) {
    message("More than 4 sets in a Venn diagram
             may result in crowded visualization and information overload.")
  }
  
  if (saveRes) {
    
    information <- read.csv("preprocess_protein_information.csv", check.names = FALSE)
    scaffoldCheck <- any(colnames(information) == "Visible?")
    IDcol <- ifelse(scaffoldCheck, "AccessionNumber", "PG.ProteinName")
    
    df <- data %>%
      rownames_to_column(IDcol) %>%
      left_join(information, by = IDcol)
      
    write.csv(df, file = "venn_information.csv", row.names = FALSE)
  }
  
  ggvenn::ggvenn(data, show_percentage = show_percentage, fill_color = fill_color)
  
}

##------------------------------------------------------------------------------
#' 
#' Volcano plot
#' 
#' @description
#' Generate a volcano plot for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.mod_t}}, \code{\link[msDiaLogue]{analyze.t}},
#' or \code{\link[msDiaLogue]{analyze.wilcox}}.
#' 
#' @param P.thres A numeric value (default = 0.05) specifying
#' the p-value threshold used to draw the horizontal line at -log10(\code{P.thres})
#' on the volcano plot.
#' 
#' @param F.thres threshold (default = 1) specifying
#' the absolute fold change threshold used to draw the vertical lines
#' at \code{-F.thres} and \code{F.thres} on the volcano plot.
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

##------------------------------------------------------------------------------
#' 
#' Scree plot
#' 
#' @description
#' Generate a scree plot for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.pca}}.
#' 
#' @param type A character vector (default = c("bar", "line")) specifying
#' the plot type. Allowed values are:
#' \itemize{
#' \item "bar": Bar plot.
#' \item "line": Line plot.
#' \item c("bar", "line"): Display both bar and line plots.
#' }
#' 
#' @param bar.color Color of the bar outline in the bar plot.
#' Defaults to "gray".
#' 
#' @param bar.fill Fill color of the bars in the bar plot.
#' Defaults to "gray".
#' 
#' @param line.color Color of the line and point in the line plot.
#' Defaults to "black".
#' 
#' @param label A logical value (default = TRUE) specifying whether
#' labels are added at the top of bars or points to show the information
#' retained by each dimension.
#' 
#' @param ncp	A numeric value (default = 10) specifying
#' the number of dimensions to be shown.
#' 
#' @return
#' An object of class \code{ggplot}.
#' 
#' @autoglobal
#' 
#' @export

visualize.scree <- function(dataSet, type = c("bar", "line"),
                            bar.color = "gray", bar.fill = "gray",
                            line.color = "black", label = TRUE, ncp = 10) {
  
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

##------------------------------------------------------------------------------
#' 
#' Score plot / graph of individuals
#' 
#' @description
#' Generate a scores plot (graph of individuals) for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.pca}} or \code{\link[msDiaLogue]{analyze.plsda}}.
#' 
#' @param ellipse A logical value (default = TRUE) specifying whether
#' to draw ellipses around the individuals.
#' 
#' @param ellipse.level A numeric value (default = 0.95) specifying
#' the size of the concentration ellipse in normal probability.
#' 
#' @param label A logical value (default = TRUE) specifying whether
#' the active individuals to be labeled.
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

##------------------------------------------------------------------------------
#' 
#' Loading plot / graph of variables
#' 
#' @description
#' Generate a loadings plot (graph of variables) for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.pca}} or \code{\link[msDiaLogue]{analyze.plsda}}.
#' 
#' @param label A logical value (default = TRUE) specifying whether
#' the active variables to be labeled.
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

##------------------------------------------------------------------------------
#' 
#' Biplot of score (individuals) and loading (variables)
#' 
#' @description
#' Generate a biplot of individuals and variables for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.pca}} or \code{\link[msDiaLogue]{analyze.plsda}}.
#' 
#' @param ellipse A logical value (default = TRUE) specifying whether
#' to draw ellipses around the individuals.
#' 
#' @param ellipse.level A numeric value (default = 0.95) specifying the size of
#' the concentration ellipse in normal probability.
#' 
#' @param label A character string (default = "all") specifying the elements
#' to be labelled. Allowed values:
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

##------------------------------------------------------------------------------
#' 
#' VIP scores plot
#' 
#' @description
#' Generate a variable importance in projection (VIP) scores plot for the data.
#' 
#' @param dataSet The data set corresponds to the output from the function
#' \code{\link[msDiaLogue]{analyze.plsda}}.
#' 
#' @param comp An integer (default = 1) specifying
#' the PLS-DA component to use when ranking variables.
#' 
#' @param num An integer (default = 10) specifying
#' the number of top variables (highest VIP scores) to display.
#' 
#' @param thres A numeric value (default = 1) specifying
#' the vertical dashed line drawn at this VIP value.
#' 
#' @param rel.widths A numeric value specifying the proportion of relative
#' widths for the plot panels. Defaults to widths chosen based on the range of
#' the top variables' VIP scores and the number of group conditions.
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

