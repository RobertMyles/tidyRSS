#' @importFrom magrittr "%>%"
#' @importFrom tibble tibble
#' @importFrom rlang has_name as_name enquo
#' @importFrom httr GET user_agent
#' @importFrom anytime anytime
#' @importFrom xml2 read_xml as_list xml_text xml_find_all xml_find_first
#' @importFrom xml2 xml_attr
#' @importFrom dplyr select full_join mutate_if mutate select_if bind_cols
#' @importFrom purrr map map_chr safely flatten compact
#' @importFrom jsonlite parse_json
#' @author Robert Myles McDonnell, \email{robertmylesmcdonnell@gmail.com}
#' @references \url{https://en.wikipedia.org/wiki/RSS}
#' @title Extract a tidy data frame from RSS, Atom and JSON feeds
#' @description \code{tidyfeed()} downloads and parses rss feeds. The function
#' produces either a tidy data frame or a named list, easy to use for further
#' manipulation and analysis.
#' @inheritParams httr::GET
#' @param feed \code{character}, the url for the feed that you want to parse,
#' e.g. "http://journal.r-project.org/rss.atom".
#' @param config Arguments passed off to \code{httr::GET()}.
#' @param clean_tags \code{logical}, default \code{TRUE}.
#' Cleans columns of HTML tags.
#' @param list \code{logical}, default \code{FALSE}.
#' Return metadata and content as separate dataframes in a named list.
#' @seealso \link[httr:GET]{GET()}
#' @examples
#' \dontrun{
#' # Atom feed:
#' tidyfeed("http://journal.r-project.org/rss.atom")
#' # rss/xml:
#' tidyfeed("http://fivethirtyeight.com/all/feed")
#' # jsonfeed:
#' tidyfeed("https://daringfireball.net/feeds/json")
#' }
#' @export
tidyfeed <- function(feed, config = list(), clean_tags = TRUE, list = FALSE) {
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
  # send to parsers
  if (typ == "rss") {
    parsed <- rss_parse(response, list)
  } else if (typ == "atom") {
    parsed <- atom_parse(response, list)
  } else if (typ == "json") {
    parsed <- json_parse(response, list)
  } else {
    stop(error_msg)
  }
  return(parsed)
}
