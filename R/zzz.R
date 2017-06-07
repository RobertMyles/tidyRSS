.onLoad <- function(libname = find.package("tidyRSS"), pkgname = "tidyRSS"){

  # CRAN Note avoidance
  if(getRversion() >= "2.15.1")
    utils::globalVariables(c(".", "feed_description", "feed_last_updated", "feed_link", "feed_title", "item_category1", "item_category2", "item_category3", "item_category4", "item_category5", "item_creator", "item_date_published", "item_link", "item_title"))
  invisible()
}

#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL


