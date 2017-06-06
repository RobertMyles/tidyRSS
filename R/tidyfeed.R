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

  formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
               "Y-m-d H:M:S z", "d b Y H:M:S",
               "d b Y H:M:S z", "a b d H:M:S z Y",
               "a b dH:M:S Y")

  # data("feeds")
  # feed <- sample(feeds$feeds, 1); tidyfeed(feed)

  choice <- match.arg(result, choice = c("all", "feed", "items"))

  doc <- httr::GET(feed) %>% xml2::read_xml()

  if(grepl("http://www.w3.org/2005/Atom", xml2::xml_attr(doc, "xmlns"))){

    ns <- xml2::xml_ns_rename(xml2::xml_ns(doc), d1 = "atom")

    entries <- xml2::xml_find_all(doc, "atom:entry[position()>1]", ns = ns)

    res <- tibble::tibble(
      feed_title = xml2::xml_text(xml2::xml_find_all(doc, ns = ns, "atom:title")),
      feed_link = xml2::xml_text(xml2::xml_find_all(doc, ns = ns, "atom:id")),
      feed_author = xml2::xml_text(xml2::xml_find_all(doc, ns = ns, "atom:author")),
      feed_last_updated = xml2::xml_text(xml2::xml_find_all(doc, ns = ns, "atom:updated")),
      item_title = xml2::xml_text(xml2::xml_find_all(entries, ns = ns, "atom:title")),
      item_date_updated = xml2::xml_text(xml2::xml_find_all(entries, ns = ns,
                                                            "atom:updated")) %>%
        lubridate::parse_date_time(orders = formats),
      item_link = xml2::xml_text(xml2::xml_find_all(entries, ns = ns,
                                                    "atom:id")),
      item_content = xml2::xml_text(xml2::xml_find_all(entries, ns = ns, "atom:content"))
    )

  } else{

    # checks & errors
    channel <- xml2::xml_find_all(doc, "channel")
    # if(length(channel) == 0){
    #   channel <- xml2::xml_children(doc)
    # }
    site <- xml2::xml_find_all(channel, "item")


    if(choice == "all"){
      res <- tibble::tibble(
        feed_title = xml2::xml_text(xml2::xml_find_all(channel, "title")),
        feed_link = xml2::xml_text(xml2::xml_find_all(channel, "link")),
        feed_description = xml2::xml_text(xml2::xml_find_all(channel, "description")),
        feed_last_updated = xml2::xml_text(xml2::xml_find_all(channel,
                                                               "lastBuildDate")) %>%
          lubridate::parse_date_time(orders = formats),
        feed_language = xml2::xml_text(xml2::xml_find_all(channel, "language")),
        feed_update_period = xml2::xml_text(xml2::xml_find_all(channel, "sy:updatePeriod")),
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

      res <- Filter(function(x) !all(is.na(x)), res)

      return(res)

    } else if(choice == "feed"){
      res <- res %>%
        dplyr::select(feed_title, feed_link, feed_description, feed_last_updated)

      return(res)

    } else{
      res <- res %>%
        dplyr::select(item_title, item_creator, item_date_published,
                      item_category1, item_category2, item_category3,
                      item_category4, item_category5, item_link)

      return(res)

    }
  }
}
