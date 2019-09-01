safe_xml_find_first <- safely(xml_find_first)
safe_xml_find_all <- safely(xml_find_all)

safe_run <- function(res) {
  if (is.null(res$error)) {
    ret <- res$result
  } else {
    ret <- read_xml("<p></p>")
  }
  return(ret)
}

