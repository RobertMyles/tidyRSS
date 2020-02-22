#' @importFrom magrittr "%>%"
#' @importFrom tibble tibble
#' @importFrom httr GET user_agent
# @importFrom lubridate parse_date_time
#' @importFrom xml2 read_xml as_list xml_contents xml_text xml_find_all
#' @importFrom xml2 xml_ns xml_find_first xml_ns_rename xml_attr
#' @importFrom dplyr select full_join mutate_if mutate select_if
#' @importFrom sf st_as_sf
#' @importFrom stringr str_extract str_trim
#' @importFrom purrr map map_chr safely flatten compact
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
tidyfeed <- function(feed, config = list(), clean_tags = TRUE, list = FALSE) {
  # feed <- "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson"
  # feed <- "http://www.geonames.org/recent-changes.xml"
  # feed <- "http://journal.r-project.org/rss.atom"
  # checks
  if (!identical(length(feed), 1L)) stop("Please supply only one feed at a time.")
  if (!is.logical(list)) stop("`list` may be FALSE or TRUE only.")
  if (!is.logical(clean_tags)) stop("`clean_tags` may be FALSE or TRUE only.")
  if (!is.list(config)) stop("`config` should be a list only.")

  # send user agent
  ua <- set_user(config)
  # try to get response
  response <- safe_get(feed, config = ua)
  # check type
  typ <- type_check(response)
  # geo check happens in parsers

  # send to parsers
  if (typ == "rss") {
    parsed <- rss_parse(response)
  } else if (typ == "atom") {
    parsed <- atom_parse(response)
  } else if (typ == "json") {
    parsed <- json_parse(response)
  } else {
    # TODO
    stop("")
  }

  if (isTRUE())

  return(parsed)
}

#   # do generic parsing here:
#   # - dates, tags, as list, remove NA cols
#
#
#
#   invisible({
#   suppressWarnings({
#    # exit if more than 1 feed provided
#
#
#   # set user agent
#   if (length(config) == 0 | length(config$options$`user-agent`) == 0) {
#     ua <- user_agent("http://github.com/robertmyles/tidyRSS")
#   }
#
#   # make GET, get status, read attributes
#   # if geo-elements present, suggest tidygeoRSS and warn that geo elements are
#   # no longer parsed
#   # check type
#   # send to either json_parse, rss_parse or atom_parse
#   # don't use lubridate?
#   # minimize dependencies? It is supposed to do the tidying
#
#
#   doc <- try(GET(feed, ua, config), silent = TRUE) # need both ua and config??
#   # TODO: check status_code here
#   # TODO: testing strategy here
#   if(grepl("json", doc$headers$`content-type`)){
#     result <- json_parse(feed) %>%
#       select_if(no_na) %>%
#       select_if(no_empty_char)
#     return(result)
#   } else{
#     doc <- doc %>% read_xml()
#   }
#
#   if(unique(grepl('try-error', class(doc)))){
#     stop(msg)
#   }
#
#   if(grepl("http://www.w3.org/2005/Atom", xml_attr(doc, "xmlns"))){
#     result <- atom_parse(doc)
#   } else if(grepl("http://www.georss.org/georss", xml_attr(doc, "xmlns:georss"))){
#     result <- geo_parse(doc)
#     if(!exists('result$item_long')) {
#       result <- rss_parse(doc)
#     } else{
#       if(sf == TRUE){
#         result <- st_as_sf(x = result,
#                            coords = c("item_long", "item_lat"),
#                            crs = "+proj=longlat +datum=WGS84")
#       }
#     }
#   } else{
#     result <- rss_parse(doc)
#     }
#   })
#   })
#   result <- result %>%
#     select_if(no_na) %>%
#     select_if(no_empty_char)
#   return(result)
# }
