#' @importFrom magrittr "%>%"
#' @importFrom tibble tibble
#' @importFrom httr GET
#' @importFrom httr user_agent
#' @importFrom lubridate parse_date_time
#' @importFrom xml2 read_xml
#' @importFrom xml2 as_list
#' @importFrom xml2 xml_contents
#' @importFrom xml2 xml_text
#' @importFrom xml2 xml_find_all
#' @importFrom xml2 xml_find_first
#' @importFrom xml2 xml_ns
#' @importFrom xml2 xml_ns_rename
#' @importFrom xml2 xml_attr
#' @importFrom dplyr select
#' @importFrom dplyr full_join
#' @importFrom dplyr mutate_if
#' @importFrom dplyr mutate
#' @importFrom dplyr select_if
#' @importFrom sf st_as_sf
#' @importFrom stringr str_extract
#' @importFrom stringr str_trim
#' @importFrom purrr map
#' @importFrom purrr map_chr
#' @importFrom purrr safely
#' @importFrom purrr flatten
#' @importFrom jsonlite fromJSON
#' @author Robert Myles McDonnell, \email{robertmylesmcdonnell@gmail.com}
#' @references \url{https://en.wikipedia.org/wiki/RSS}
#' @title Extract a tidy data frame from RSS and Atom and JSON feeds
#' @description \code{tidyfeed()} downloads and parses rss feeds. The function
#' produces a tidy data frame, easy to use for further manipulation and
#' analysis.
#' @inheritParams httr::GET
#' @param feed (\code{character}). The url for the feed that you want to parse.
#' @param sf . If TRUE, returns sf dataframe.
#' @param config . Passed off to httr::GET().
#' @examples
#' \dontrun{
#' # Atom feed:
#' tidyfeed("http://journal.r-project.org/rss.atom")
#' # rss/xml:
#' tidyfeed("http://fivethirtyeight.com/all/feed")
#' # jsonfeed:
#' tidyfeed("https://daringfireball.net/feeds/json")
#' # georss:
#' tidyfeed("http://www.geonames.org/recent-changes.xml")
#' }
#' @export
tidyfeed <- function(feed, sf = TRUE, config = list()){
  invisible({
  suppressWarnings({
  stopifnot(identical(length(feed), 1L)) # exit if more than 1 feed provided

  msg <- "Error in feed parse; please check URL.\nIf you're certain that this is a valid rss feed, please file an issue at https://github.com/RobertMyles/tidyRSS/issues. Please note that the feed may also be undergoing maintenance."
  # set user agent
  if (length(config) == 0 | length(config$`user-agent`) == 0) {
    ua <- user_agent("http://github.com/robertmyles/tidyRSS")
  }

  doc <- try(GET(feed, ua, config), silent = TRUE)

  if(grepl("json", doc$headers$`content-type`)){
    result <- json_parse(feed)
  } else{
    doc <- doc %>% read_xml()
  }

  if(unique(grepl('try-error', class(doc)))){
    stop(msg)
  }

  if(grepl("http://www.w3.org/2005/Atom", xml_attr(doc, "xmlns"))){
    result <- atom_parse(doc)
  } else if(grepl("http://www.georss.org/georss", xml_attr(doc, "xmlns:georss"))){
    result <- geo_parse(doc)
    if(!exists('result$item_long')) {
      result <- rss_parse(doc)
    } else{
      if(sf == TRUE){
        result <- st_as_sf(x = result,
                           coords = c("item_long", "item_lat"),
                           crs = "+proj=longlat +datum=WGS84")
      }
    }
  } else{
    result <- rss_parse(doc)
    }
  })
  })
  result <- result %>%
    select_if(no_na) %>%
    select_if(no_empty_char)
  return(result)
}
