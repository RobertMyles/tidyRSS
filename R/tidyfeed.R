#' @importFrom magrittr "%>%"
#' @importFrom tibble tibble
#' @importFrom httr GET
#' @importFrom lubridate parse_date_time
#' @importFrom xml2 read_xml
#' @importFrom xml2 xml_text
#' @importFrom xml2 xml_find_all
#' @importFrom xml2 xml_find_first
#' @author Robert Myles McDonnell, \email{robertmylesmcdonnell@gmail.com}
#' @references \url{https://en.wikipedia.org/wiki/RSS}
#' @title Extract a tidy data frame from RSS and Atom feeds
#' @description \code{tidyfeed()} downloads and parses rss feeds. The function
#' produces a tidy data frame, easy to use for further manipulation and
#' analysis.
#' @param feed (\code{character}). The url for the feed that you want to parse.
#' @param result (\code{character}), one of:
#'   - "all": both the feed information (title, url, etc.) and the item information (title, creator, etc.) are returned.
#'   - "feed": Only the information from the feed is returned, not the individual feed items.
#'   - "items": opposite of the above.
#' @examples
#' # RSS feed:
#'
#' tech <- tidyfeed("http://feeds.feedburner.com/techcrunch")
#'
#' # Atom feed:
#' r_j <- tidyfeed("http://journal.r-project.org/rss.atom")
#'
#' # raw xml feed:
#' cisc <- tidyfeed("http://tools.cisco.com/security/center/eventResponses_20.xml")
#' ## (not a feed)
#' ny <- tidyfeed("http://www.nytimes.com/index.html?partner=rssnyt")
#'
#'
#' @export

tidyfeed <- function(feed, result = c("all", "feed", "items")){

  if(!grepl("http://", feed)){
    feed <- strsplit(feed, "://")[[1]][2]
    feed <-paste0("http://", feed)
  }

  msg <- "\nThis page does not appear to be a suitable feed.\nHave you checked that you entered the url correctly?\nIf you are certain that this is a valid rss feed, please file an issue at: https://github.com/RobertMyles/tidyRSS/issues"

  # date formats, taken from R package feedeR by A. Collier;
  # https://github.com/DataWookie/feedeR/blob/master/R/read.R;
  # added one extra for an error that came up in testing and adjusted
  # the first.
  formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
               "Y-m-d H:M:S z", "d b Y H:M:S",
               "d b Y H:M:S z", "a b d H:M:S z Y",
               "a b dH:M:S Y")

  # data("feeds")
  # feed <- sample(feeds$feeds, 1)

  doc <- httr::GET(feed) %>% xml2::read_xml()

  # checks & errors
  channel <- xml2::xml_find_all(doc, "channel")
  site <- xml2::xml_find_all(channel, "item")

  choice <- match.arg(result, choice = c("all", "feed", "items"))

  if(choice == "all"){
    res <- tibble::tibble(
      feed_title = xml2::xml_text(xml2::xml_find_all(channel, "title")),
      feed_link = xml2::xml_text(xml2::xml_find_all(channel, "link")),
      feed_description = xml2::xml_text(xml2::xml_find_all(channel, "description")),
      feed_lastBuildDate = xml2::xml_text(xml2::xml_find_all(channel, "lastBuildDate")) %>%
        lubridate::parse_date_time(orders = formats),
      feed_language = xml2::xml_text(xml2::xml_find_all(channel, "language")),
      feed_updatePeriod = xml2::xml_text(xml2::xml_find_all(channel, "sy:updatePeriod")),
      item_title = xml2::xml_text(xml2::xml_find_all(site, "title")),
      item_creator = xml2::xml_text(xml2::xml_find_all(site, "dc:creator")),
      item_date_published = xml2::xml_text(xml2::xml_find_all(site, "pubDate")) %>%
        lubridate::parse_date_time(orders = formats),
      item_category1 = xml2::xml_text(xml2::xml_find_first(site, "category[1]")),
      item_category2 = xml2::xml_text(xml2::xml_find_first(site, "category[2]")),
      item_category3 = xml2::xml_text(xml2::xml_find_first(site, "category[3]")),
      item_category4 = xml2::xml_text(xml2::xml_find_first(site, "category[4]")),
      item_category5 = xml2::xml_text(xml2::xml_find_first(site, "category[5]")),
      item_link = xml2::xml_text(xml2::xml_find_all(site, "link"))
    )

    return(res)
  } else if(choice == "feed"){
    res <- tibble::tibble(
      feed_title = xml2::xml_text(xml2::xml_find_all(channel, "title")),
      feed_link = xml2::xml_text(xml2::xml_find_all(channel, "link")),
      feed_description = xml2::xml_text(xml2::xml_find_all(channel, "description")),
      feed_lastBuildDate = xml2::xml_text(xml2::xml_find_all(channel, "lastBuildDate")) %>%
        lubridate::parse_date_time(orders = formats),
      feed_language = xml2::xml_text(xml2::xml_find_all(channel, "language")),
      feed_updatePeriod = xml2::xml_text(xml2::xml_find_all(channel, "sy:updatePeriod"))
    )

    return(res)
  } else{
    res <- tibble::tibble(
      item_title = xml2::xml_text(xml2::xml_find_all(site, "title")),
      item_creator = xml2::xml_text(xml2::xml_find_all(site, "dc:creator")),
      item_date_published = xml2::xml_text(xml2::xml_find_all(site, "pubDate")) %>%
        lubridate::parse_date_time(orders = formats),
      item_category1 = xml2::xml_text(xml2::xml_find_first(site, "category[1]")),
      item_category2 = xml2::xml_text(xml2::xml_find_first(site, "category[2]")),
      item_category3 = xml2::xml_text(xml2::xml_find_first(site, "category[3]")),
      item_category4 = xml2::xml_text(xml2::xml_find_first(site, "category[4]")),
      item_category5 = xml2::xml_text(xml2::xml_find_first(site, "category[5]")),
      item_link = xml2::xml_text(xml2::xml_find_all(site, "link"))
    )

    return(res)
  }


}
