#' @import dplyr
#' @importFrom magrittr "%>%"
#' @importFrom RCurl getURL
#' @importFrom purrr map
#' @import xml2
#' @importFrom lubridate parse_date_time
#' @author Robert Myles McDonnell, \email{robertmylesmcdonnell@gmail.com}
#' @references \url{https://en.wikipedia.org/wiki/RSS}
#' @title Extract a tidy data frame from RSS and Atom feeds
#' @description \code{tidyfeed()} downloads and parses rss feeds. The function
#' produces a tidy data frame, easy to use for further manipulation and
#' analysis.
#' @param feed (\code{character}). The url for the feed that you want to parse.
#' @return A tidy data frame that contains the following elements, assuming
#' they exist in the feed itself:
#'
#' - item_title: The title of each feed post.
#'
#' - item_date: The date of publciation. Returns \code{NA} if this
#' does not exist.
#'
#' - item_link: The original url of the item.
#'
#' - creator: The author of the item, if this exists in the feed.
#'
#' - categries: The categories used for indexing the item, separated
#'  by a semi-colon, if this exists in the feed.
#'
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
tidyfeed <- function(feed){

  # first, clean the feed
  if(!grepl("http://", feed)){
    feed <- strsplit(feed, "://")[[1]][2]
    feed <-paste0("http://", feed)
  }

  document <- try(
    getURL(feed) %>%
    xml2::read_xml() %>%
    xml2::as_list(),
    silent = F)

  if(class(document) == "try-error"){
    return(message("\nThis page does not appear to be a suitable feed.\nHave you checked that you entered the url correctly?"))
  }

  # date formats, taken from R package feedeR by A. Collier;
  # https://github.com/DataWookie/feedeR/blob/master/R/read.R;
  # added one extra for an error that came up in testing.
  formats <- c("a, d b Y H:M:S z", "a, d b Y H:M z",
               "Y-m-d H:M:S z", "d b Y H:M:S",
               "d b Y H:M:S z", "a b d H:M:S z Y",
               "a b dH:M:S Y")

  # RSS:
  suppressWarnings(
    if(names(document) == "channel"){

    document <- document[["channel"]]
    head_doc <- document[names(document) != "item"]
    item_doc <- document[names(document) == "item"]

    if(length(item_doc) == 0){

      items <- head_doc$items$Seq
      at <- list()
      for(i in 1:length(items)){
        at[[i]] <- attributes(items[i]$li)$resource
      }
      at <- unlist(at)
      df <- dplyr::data_frame(item_url = at,
                              head_title = unlist(head_doc$title),
                              head_link = unlist(head_doc$link),
                              last_updated = unlist(head_doc$date))

      df$last_updated <- parse_date_time(df$last_updated,
                                         orders = formats)
    } else{
      df <- dplyr::data_frame(item_title = unlist(map(item_doc,
                                                      "title")))

      # date
      if("pubDate" %in% names(item_doc[[1]])){
        df$item_date <- unlist(map(item_doc, "pubDate"))
        df$item_date <- parse_date_time(df$item_date, orders = formats)
      } else{
        df$item_date <- NA
      }

      # links
      if(grepl("origLink", item_doc$item[[1]])){
        df$item_link = unlist(map(item_doc, "origLink"))
      } else if("origLink" %in% names(item_doc$item)){
        df$item_link <- unlist(map(item_doc, "origLink"))
      } else{
        df$item_link = unlist(map(item_doc, "link"))
        }


      # creator:
      if(grepl("creator", names(item_doc$item))){
        df$creator <- unlist(map(item_doc, "creator"))
      }

      # get categories:
      if(grepl("category", item_doc$item)){
        cats <- list()
        for(i in 1:length(item_doc)){
          cats[[i]] <- item_doc[[i]][grep("category", names(item_doc[[i]]))]
        }
        cats <- map(cats, unlist)
        for(i in 1:length(cats)){
          attr(cats[[i]], "names") <- NULL
          cats[[i]] <- paste(cats[[i]], sep="", collapse="; ")
        }
        df$item_categories <- unlist(cats)
      }

      # head title
      df$head_title <- unlist(head_doc$title)

      # head link
      if(length(grep("link", names(head_doc))) > 1){
        x_link <- head_doc[grep("link", names(head_doc))]
        x_link <- unlist(x_link[grep("http", x_link)])
        attr(x_link, "names") <- NULL
        df$head_link <- x_link
      } else{
        df$head_link <- unlist(head_doc$link)
      }

      # dates
      if("lastBuildDate" %in% names(head_doc)){
        df$last_updated <- unlist(head_doc$lastBuildDate)
        df$last_updated <- parse_date_time(df$last_updated,
                                           orders = formats)
      }
    }
    return(df)
    } else{

        ## ATOM:
        entries <- document[grep("entry", names(document))]

        df <- dplyr::data_frame(item_title = unlist(map(entries, "title")),
                                item_date = unlist(map(entries, "updated")),
                                item_link = unlist(map(entries, "id")),
                                head_title = unlist(document$title))

        if(length(grep("link", names(document))) > 1){

          x_link <- document[grep("link", names(document))]
          x_link <- attr(x_link[[2]], "href")
          df$head_link <- x_link

          } else{
            df$head_link <- unlist(document$link)
          }

        df$last_update <- unlist(document$updated)

        # dates
        xx <- try(unlist(map(entries, "updated")), silent = F)
        if(class(xx) == "try-error"){
          df$item_date <- NA
        } else {
          df$item_date <- parse_date_time(xx, orders = formats)
          }

        return(df)
      }
    )
}
