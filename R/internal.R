##################
#### Internal ####
##################
#'
#' Extract the first name from a semicolon-separated names
#'
#' @description
#' Take a character vector. If an element contains multiple names separated by
#' semicolons (e.g., "A;B;C"), only the first name is kept and annotated with
#' the number of additional names (e.g., "A (+2)"). Single names (e.g., "A")
#' are returned unchanged.
#'
#' @param vecName A character vector, with elements possibly containing multiple
#' names separated by semicolons.
#'
#' @return
#' A character vector of the same length as \code{vecName}, with either
#' the original name (if only one) or the first name followed by the count of
#' additional names.
#'
#' @noRd

firstName <- function(vecName) {
  sapply(vecName, function(element) {
    parts <- unlist(strsplit(element, ";", fixed = TRUE))
    if (length(parts) > 1) {
      paste0(parts[1], " (+", length(parts)-1, ")")
    } else {
      element
    }
  })
}

