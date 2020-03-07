# safe version of GET, reads status code before continuing.
safe_get <- function(feed, user = NULL, config = list()) {
  safeget <- safely(GET)
  req <- safeget(feed, user, config)

  if (!is.null(req$error)) {
    msg <- paste0("Attempt to fetch feed resulted in an error: ", req$error)
    stop(msg)
  }
  status <- req$result$status_code
  if (status != 200L) {
    stop("Attempt to get feed was unsuccessful (non-200 response). Feed may not be available.")
  } else {
    message("GET request successful. Parsing...\n")
  }
  result <- req$result #nocov
  return(result) # nocov
}
