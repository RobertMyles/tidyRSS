#' @importFrom magrittr "%>%"
#' @importFrom tibble tibble
#' @importFrom httr GET
#' @importFrom lubridate parse_date_time
#' @importFrom xml2 read_xml
#' @importFrom xml2 xml_text
#' @importFrom xml2 xml_find_all
#' @importFrom xml2 xml_find_first
#' @importFrom dplyr select
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

#' # Atom feed:
#' r_j <- tidyfeed("http://journal.r-project.org/rss.atom")
#'
#' @export

tidyfeed <- function(feed, result = c("all", "feed", "items")){
  invisible({
  suppressWarnings({
  if(!grepl("http://", feed)){
    feed <- strsplit(feed, "://")[[1]][2]
    feed <-paste0("http://", feed)
  }

  msg <- "\nThis page does not appear to be a suitable feed.\nHave you checked that you entered the url correctly?\nIf you are certain that this is a valid rss feed, please file an issue at: https://github.com/RobertMyles/tidyRSS/issues"

  formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
               "Y-m-d H:M:S z", "d b Y H:M:S",
               "d b Y H:M:S z", "a b d H:M:S z Y",
               "a b dH:M:S Y")

  choice <- match.arg(result, choices = c("all", "feed", "items"))

  doc <- httr::GET(feed) %>% xml2::read_xml()


  if(grepl("http://www.w3.org/2005/Atom", xml2::xml_attr(doc, "xmlns"))){

    ns <- xml2::xml_ns_rename(xml2::xml_ns(doc), d1 = "atom")

    entries <- xml2::xml_find_all(doc, "atom:entry[position()>1]", ns = ns)

    res <- tibble::tibble(
      feed_title = xml2::xml_text(xml2::xml_find_all(doc, ns = ns, "atom:title")),
      feed_link = xml2::xml_text(xml2::xml_find_first(doc, ns = ns, "atom:id")),
      feed_author = xml2::xml_text(xml2::xml_find_first(doc, ns = ns, "atom:author")),
      feed_last_updated = xml2::xml_text(xml2::xml_find_first(doc, ns = ns, "atom:updated")),
      item_title = xml2::xml_text(xml2::xml_find_first(entries, ns = ns, "atom:title")),
      item_date_updated = xml2::xml_text(xml2::xml_find_first(entries, ns = ns,
                                                            "atom:updated")) %>%
        lubridate::parse_date_time(orders = formats),
      item_link = xml2::xml_text(xml2::xml_find_first(entries, ns = ns,
                                                    "atom:id")),
      item_content = xml2::xml_text(xml2::xml_find_first(entries, ns = ns, "atom:content"))
    )

    if(!grepl("http", res$feed_link)){
      res$feed_link <- xml2::xml_text(xml2::xml_find_first(entries, ns = ns, "atom:origLink"))
      if(!grepl("http", res$feed_link)){
        res$feed_link <- xml2::xml_text(xml2::xml_find_first(entries, ns = ns, "atom:link"))
      }
    }

    return(res)

  } else{

    channel <- xml2::xml_find_all(doc, "channel")

    if(length(channel) == 0){
      ns <- xml2::xml_ns_rename(xml2::xml_ns(doc), d1 = "rss")
      channel <- xml2::xml_find_all(doc, "rss:channel", ns = ns)
      site <- xml2::xml_find_all(doc, "rss:item", ns = ns)

      res <- tibble::tibble(
        feed_title = xml2::xml_text(xml2::xml_find_all(channel, "rss:title", ns = ns)),
        feed_link = xml2::xml_text(xml2::xml_find_all(channel, "rss:link", ns = ns)),
        feed_description = xml2::xml_text(xml2::xml_find_first(channel, "rss:description", ns = ns)),
        feed_last_updated = xml2::xml_text(xml2::xml_find_first(channel,
                                                                "rss:lastBuildDate", ns = ns)) %>%
          lubridate::parse_date_time(orders = formats),
        feed_language = xml2::xml_text(xml2::xml_find_first(channel, "rss:language", ns = ns)),
        feed_update_period = xml2::xml_text(xml2::xml_find_first(channel, "rss:updatePeriod", ns = ns)),
        item_title = xml2::xml_text(xml2::xml_find_all(site, "rss:title", ns = ns)),
        item_creator = xml2::xml_text(xml2::xml_find_first(site, "rss:creator", ns = ns)),
        item_date_published = xml2::xml_text(xml2::xml_find_first(site, "rss:pubDate", ns = ns)) %>%
          lubridate::parse_date_time(orders = formats),
        item_date =  xml2::xml_text(xml2::xml_find_first(site, "rss:date", ns = ns)) %>%
         lubridate::parse_date_time(orders = formats),
        item_subject = xml2::xml_text(xml2::xml_find_first(site, ns = ns, "rss:subject")),
        item_category1 = xml2::xml_text(xml2::xml_find_first(site, "rss:category[1]", ns = ns)),
        item_category2 = xml2::xml_text(xml2::xml_find_first(site, "rss:category[2]", ns = ns)),
        item_category3 = xml2::xml_text(xml2::xml_find_first(site, "rss:category[3]", ns = ns)),
        item_category4 = xml2::xml_text(xml2::xml_find_first(site, "rss:category[4]", ns = ns)),
        item_category5 = xml2::xml_text(xml2::xml_find_first(site, "rss:category[5]", ns = ns)),
        item_link = xml2::xml_text(xml2::xml_find_all(site, "rss:link", ns = ns)),
        item_description = xml2::xml_text(xml2::xml_find_first(site, "rss:description", ns = ns))
      )

      res <- Filter(function(x) !all(is.na(x)), res)

     if(choice == "feed"){
       res <- res %>%
        dplyr::select(feed_title, feed_link, feed_description, feed_last_updated)

      return(res)

    } else if(choice == "items"){
      res <- res %>%
        dplyr::select(item_title, item_creator, item_date_published,
                      item_category1, item_category2, item_category3,
                      item_category4, item_category5, item_link)

      return(res)

    } else{
      return(res)
      }
    } else{

      site <- xml2::xml_find_all(channel, "item")


      if(choice == "all"){

        res <- tibble::tibble(
          feed_title = xml2::xml_text(xml2::xml_find_first(channel, "id")),
          feed_link = xml2::xml_text(xml2::xml_find_first(channel, "link")),
          feed_description = xml2::xml_text(xml2::xml_find_first(channel, "description")),
          feed_last_updated = xml2::xml_text(xml2::xml_find_first(channel,
                                                                  "lastBuildDate")) %>%
            lubridate::parse_date_time(orders = formats),
          feed_language = xml2::xml_text(xml2::xml_find_first(channel, "language")),
          feed_update_period = xml2::xml_text(xml2::xml_find_first(channel, "updatePeriod")),
          item_title = xml2::xml_text(xml2::xml_find_first(site, "title")),
          item_creator = xml2::xml_text(xml2::xml_find_first(site, "dc:creator")),
          item_date_published = xml2::xml_text(xml2::xml_find_first(site, "pubDate")) %>%
            lubridate::parse_date_time(orders = formats),
          item_category1 = xml2::xml_text(xml2::xml_find_first(site, "category[1]")),
          item_category2 = xml2::xml_text(xml2::xml_find_first(site, "category[2]")),
          item_category3 = xml2::xml_text(xml2::xml_find_first(site, "category[3]")),
          item_category4 = xml2::xml_text(xml2::xml_find_first(site, "category[4]")),
          item_category5 = xml2::xml_text(xml2::xml_find_first(site, "category[5]")),
          item_link = xml2::xml_text(xml2::xml_find_first(site, "link"))
        )

        suppressWarnings(
          res$feed_update_period[is.na(res$feed_update_period)] <- xml2::xml_text(
            xml2::xml_find_first(channel, "sy:updatePeriod"))
        )
        suppressWarnings(
        res$feed_title[is.na(res$feed_title)] <- xml2::xml_text(
          xml2::xml_find_first(channel, "title"))
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
  })
  })
}
