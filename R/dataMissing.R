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

########################################
#### Code for counting missing data ####
########################################
#' 
#' Counting missing data
#' 
#' @description
#' Calculate and plot the missingness.
#' 
#' @param dataSet The 2d data set of experimental values.
#' 
#' @param sort_miss A boolean (default = FALSE) specifying whether to arrange the columns
#' in order of missingness.
#' 
#' @param plot A boolean (default = FALSE) specifying whether to plot the missingness.
#' 
#' @param show_pct_legend A boolean (default = TRUE) specifying whether the percentages of
#' missing and present values in the entire dataset are shown in the legend of the
#' visualization when \code{plot = TRUE}.
#' 
#' @param show_labels A boolean (default = TRUE) specifying whether protein names are
#' shown in the visualization when \code{plot = TRUE}.
#' 
#' @param show_pct_col A boolean (default = TRUE) specifying whether the percentages of
#' missing data in the samples for that protein are shown in the labels of the
#' visualization when \code{show_labels = TRUE}.
#' 
#' @import dplyr
#' @import ggplot2
#' @import tidyr
#' @importFrom glue glue
#' @importFrom scales percent
#' 
#' @returns A 2d dataframe including:
#' \itemize{
#' \item "count_miss": The count of missing values for each protein.
#' \item "pct_miss_col": The percentage of missing values for each protein.
#' \item "pct_miss_tot": The percentage of missing values for each protein relative to
#' the total missing values in the entire dataset.
#' }
#' 
#' @autoglobal
#' 
#' @export

dataMissing <- function(dataSet, sort_miss = FALSE,
                        plot = FALSE, show_pct_legend = TRUE,
                        show_labels = TRUE, show_pct_col = TRUE) {
  
  dataMissing <- select(dataSet, -c(R.Condition, R.Replicate))
  
  if (sort_miss) {
    dataMissing <- dataMissing[,names(sort(colSums(is.na(dataMissing)), decreasing = TRUE))]
  }
  
  if (plot) {
    
    plotdf <- dataMissing %>%
      mutate(row = row_number()) %>%
      pivot_longer(cols = -row, names_to = "variable", values_to = "value",
                   values_transform = list(value = is.na))
    
    if (show_pct_legend) {
      pct_missing <- mean(is.na(dataMissing))*100
      if (pct_missing == 0) {
        lab_missing <- "No Missing Values"
        lab_present <- "Present (100%)"
      } else if (pct_missing < 0.1) {
        lab_missing <- "Missing (< 0.1%)"
        lab_present <- "Present (> 99.9%)"
      } else {
        pct_missing <- round(pct_missing, 1)
        pct_present <- 100 - pct_missing
        lab_missing <- glue::glue("Missing\n({pct_missing}%)")
        lab_present <- glue::glue("Present\n({pct_present}%)")
      }
    } else {
      lab_missing <- "Missing"
      lab_present <- "Present"
    }
    
    plot <- ggplot(plotdf, aes(x = variable, y = row)) +
      geom_raster(aes(fill = value)) +
      scale_fill_manual(name = "", breaks = c("TRUE", "FALSE"),
                        values = c("grey20", "grey80"),
                        labels = c(lab_missing, lab_present)) +
      scale_y_reverse() +
      theme_minimal() +
      labs(x = "", y = "Observations") +
      theme(legend.position = "bottom",
            axis.text.x = element_text(angle = 45, hjust = 0))
    
   if (show_labels) {
     if (show_pct_col) {
       lab_pct_miss_col <- colMeans(is.na(dataMissing)) %>%
         sapply(function(x) {
           case_when(x == 0 ~  "0%",
                     x < 0.001 ~ "<0.1%",
                     x < 0.01 ~ "<1%",
                     x >= 0.01 ~ scales::percent(x, accuracy = 1))
         })
       plot <- plot +
         scale_x_discrete(position = "top", limits = names(dataMissing),
                          labels = glue::glue("{names(lab_pct_miss_col)} ({lab_pct_miss_col})"))
     } else {
       plot <- plot +
         scale_x_discrete(position = "top", limits = names(dataMissing))
     }
    } else {
      plot <- plot +
        scale_x_discrete(position = "top", labels = element_blank())
    }
    
    print(plot)
  }
  
  count_miss <- colSums(is.na(dataMissing))
  result <- data.frame(count_miss,
                       pct_miss_col = colMeans(is.na(dataMissing))*100,
                       pct_miss_tot = count_miss/sum(count_miss)*100)
  return(as.data.frame(t(result)))
}

