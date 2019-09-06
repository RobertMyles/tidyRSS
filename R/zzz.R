.onLoad <- function(libname = find.package("tidyRSS"), pkgname = "tidyRSS"){

  # CRAN Note avoidance
  if(getRversion() >= "2.15.1")
    utils::globalVariables(c(".", "feed_description", "feed_last_updated",
                             "feed_link", "feed_title", "item_category1", "item_category2",
                             "item_category3", "item_category4", "item_category5", "item_creator",
                             "item_date_published", "item_link", "item_title", "feed_update_period",
                             "date_modified", "date_published", "temp"))
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

# time formats
formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
             "Y-m-d H:M:S z", "d b Y H:M:S",
             "d b Y H:M:S z", "a b d H:M:S z Y",
             "a b dH:M:S Y")

# remove all NA columns
no_na <- function(x) all(!is.na(x))

