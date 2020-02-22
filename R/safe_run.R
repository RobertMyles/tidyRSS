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
    ret <- read_xml("<p></p>")
  }
  return(ret)
}
