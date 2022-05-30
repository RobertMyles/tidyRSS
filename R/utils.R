# error message
error_msg <- "Error in feed parse; please check URL.\n
  If you're certain that this is a valid rss feed,
  please file an issue at https://github.com/RobertMyles/tidyRSS/issues.
  Please note that the feed may also be undergoing maintenance."

# set user agent
set_user <- function(config) {
  if (length(config) == 0 | length(config$options$`user-agent`) == 0) {
    ua <- user_agent("tidyRSS/2.0.4")
    return(ua)
  } else {
    return(config) # nocov
  }
}

# check if JSON or XML
# simply reads 'content-type' of response to check type.
# if contains both atom & rss, prefers rss
type_check <- function(response) {
  if (!inherits(response, "response")) stop("`type_check` cannot evaluate this response.")
  content_type <- response$headers$`content-type`
  typ <- case_when(
    grepl(x = content_type, pattern = "atom") ~ "atom",
    grepl(x = content_type, pattern = "xml") ~ "rss",
    grepl(x = content_type, pattern = "rss") ~ "rss",
    grepl(x = content_type, pattern = "json") ~ "json",
    TRUE ~ "unknown"
  )
  if (typ %in% c("json", "unknown")) {
    return(typ) # nocov
  } else {
    # overwrite for cases like https://github.com/RobertMyles/tidyRSS/issues/38
    xmlns <- xml_attr(read_xml(response), "xmlns")
    if (grepl("Atom", xmlns)) typ <- "atom"
    return(typ) # nocov
  }
}

# geocheck - warning about geo feeds
geocheck <- function(x) {

  point <- xml_find_all(x, "//*[name()='georss:point']") %>% length()
  line <- xml_find_all(x, "//*[name()='georss:line']") %>% length()
  polygon <- xml_find_all(x, "//*[name()='georss:polygon']") %>% length()
  box <- xml_find_all(x, "//*[name()='georss:box']") %>% length()
  f_type <- xml_find_all(x, "//*[name()='georss:featuretypetag']") %>% length()
  r_tag <- xml_find_all(x, "//*[name()='georss:relationshiptag']") %>% length()
  f_name <- xml_find_all(x, "//*[name()='georss:featurename']") %>% length()
  geo_elements <- c(point, line, polygon, box, f_type, r_tag, f_name)

  if (any(geo_elements > 1)) {
    message("Parsing feeds with geographic information (geoRSS, geoJSON etc.) is
deprecated in tidyRSS as of version 2.0.0. The geo-fields in this feed will be ignored.
If you would like to fetch this information, try the tidygeoRSS package:
https://github.com/RobertMyles/tidygeoRSS")
  }
}

# default value for empty elements
def <- NA_character_

#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

# delist -- basically turn list-cols of 1 element into regular columns
delist <- function(df, listcol) {
  nn <- nrow(df)
  y <- vector("numeric", nn)
  for(i in 1:nn) {
    y[[i]] <- df[[get("listcol")]][[i]] %>% length()
  }
  if (all(y == 1)) {
    df[[get("listcol")]] <- unlist(df[[get("listcol")]])
  }
  df <- df[, get("listcol")]
  df
}

# return if exists
return_exists <- function(x) {
  if (!is.null(x)) {
    out <- x
  } else {
    out <- NA
  }
  out
}

# parse dates
date_parser <- function(df, kol) {
  column <- enquo(kol) %>% as_name()
  if (has_name(df, column)) {
    df <- df %>% mutate({{ kol }} := anytime({{ kol }}))
  }
  df
}

# clean HTML tags
# from https://stackoverflow.com/a/17227415/4296028
# removal != parsing!
cleanFun <- function(htmlString) {
  ht <- gsub("<.*?>", "", htmlString)
  ret <- gsub("[\n\t]", "", ht)
  ret <- trimws(ret)
  return(ret)
}

safe_join <- safely(full_join)
