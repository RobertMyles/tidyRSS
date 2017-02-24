.onLoad <- function(libname = find.package("tidyRSS"), pkgname = "tidyRSS"){

  # CRAN Note avoidance
  if(getRversion() >= "2.15.1")
    utils::globalVariables(c("."))
  invisible()
}
