# safe versions of some xml2 functions.
# accounts for empty nodes in a tibble by reading a
# simple empty <span> element in the case of error.

safe_xml_find_first <- safely(xml_find_first)
safe_xml_find_all <- safely(xml_find_all)

safe_run <- function(response, type = c("first", "all"), ...) {
  if (type == "first") {
    result <- safe_xml_find_first(response, ...)
  } else {
    result <- safe_xml_find_all(response, ...)
  }
  if (is.null(result$error)) {
    ret <- result$result %>% xml_text()
    if (length(ret) == 0) ret <- def
  } else {
    ret <- read_xml("<span></span>") %>% #nocov
      xml_text() #nocov
  }
  return(ret)
}
