#' @import dplyr
#' @importFrom magrittr "%>%"
#' @importFrom RCurl getURL
#' @import utils
#' @import httr
#' @import XML
#' @importFrom purrr map
#' @importFrom xml2 read_xml
#' @importFrom xml2 as_list
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
#'  item_title: The title of each feed post.
#'
#'  item_date: The date of publciation. Returns \code{NA} if this
#' does not exist.
#'
#'  item_link: The original url of the item.
#'
#'  summary: a brief summary of the item, if it exists..
#'
#'  subtitle: the subtitle of the item, if it exists.
#'
#'  creator: The author of the item, if this exists in the feed.
#'
#'  categories: The categories used for indexing the item, separated
#'  by a semi-colon, if this exists in the feed.
#'
#'  head_title: title of the url from the header of the feed
#'
#'  head_link: url for header
#'
#'  last_updated: date (POSIXct format) last updated.
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

  # error message
  msg <- "\nThis page does not appear to be a suitable feed.\nHave you checked that you entered the url correctly?\nIf you are certain that this is a valid rss feed, please file an issue at: https://github.com/RobertMyles/tidyRSS/issues"

  # tidy the feeds
  tidy_all <- function(document){

    # date formats, taken from R package feedeR by A. Collier;
    # https://github.com/DataWookie/feedeR/blob/master/R/read.R;
    # added one extra for an error that came up in testing and adjusted
    # the first.
    formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
                 "Y-m-d H:M:S z", "d b Y H:M:S",
                 "d b Y H:M:S z", "a b d H:M:S z Y",
                 "a b dH:M:S Y")

    if(class(document) != "list"){
      return(message(msg))
    }


    rss_tidy <- function(document){

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
        } else if("pubdate" %in% names(item_doc[[1]])){
          df$item_date <- unlist(map(item_doc, "pubdate"))
          df$item_date <- parse_date_time(df$item_date, orders = formats)
        } else {
          df$item_date <- NA
        }

        # links
        if("origLink" %in% names(item_doc$item)){
          df$item_link <- unlist(map(item_doc, "origLink"))
        } else if(!is.null(item_doc$item$link)){
          df$item_link <- unlist(map(item_doc, "link"))
        } else{
          df$item_link <- "None provided"
        }

        # subtitle
        if("subtitle" %in% names(item_doc$item)){
          df$subtitle <- unlist(map(item_doc, "subtitle"))
        }

        # summary
        if("summary" %in% names(item_doc$item)){
          df$summary <- unlist(map(item_doc, "summary"))
        }

        # creator:
        if("creator" %in% names(item_doc$item)){
          cre <- vector("list", length(item_doc))
          for(i in 1:length(item_doc)){
            if("creator" %in% names(item_doc[[i]])){
              cre[[i]] <- item_doc[[i]][grep("creator",
                                             names(item_doc[[i]]))]
              attr(cre[[i]], "names") <- NULL
              cre <- map(cre, unlist)
              cre[[i]] <- paste(cre[[i]], sep="", collapse="; ")
              cre[i] <- unlist(cre[i])
              for(i in 1:length(cre)){
                if(is.null(cre[[i]])){
                  cre[[i]] <- NA
                }
                }
              }
          }
          df$creator <- unlist(cre)
        } else if("author" %in% names(item_doc$item)){
            df$creator <- unlist(map(item_doc, "author"))
            }

        # get categories:
        if("category" %in% names(item_doc$item)){
          cat_check <- unlist(map(item_doc, "category"))
          if(!is.null(cat_check)){
            cats <- vector("list", length(item_doc))
            for(i in 1:length(item_doc)){
              if("category" %in% names(item_doc[[i]])){
                cats[[i]] <- item_doc[[i]][grep("category",
                                                names(item_doc[[i]]))]
                attr(cats[[i]], "names") <- NULL
                cats <- map(cats, unlist)
                cats[[i]] <- paste(cats[[i]], sep="", collapse="; ")
                cats[i] <- unlist(cats[i])
              }
            }
            for(i in 1:length(cats)){
              if(is.null(cats[[i]])){
                cats[[i]] <- NA
              }
            }
            df$item_categories <- unlist(cats)
            }
          }

        # head title
        df$head_title <- unlist(head_doc$title)

        # head link
        if(length(grep("link", names(head_doc))) > 1){
          x_link <- head_doc[grep("link", names(head_doc))]
          x_link <- unlist(x_link[grep("http", x_link)])
          attr(x_link, "names") <- NULL
          df$head_link <- x_link[1]
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
    }

    atom_tidy <- function(document){

      entries <- document[grep("entry", names(document))]

      if(length(entries) == 0){
        return(message(msg))
      }

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

      df$last_update <- parse_date_time(unlist(document$updated),
                                        orders = formats)

      # dates
      xx <- try(unlist(map(entries, "updated")), silent = F)
      if(class(xx) == "try-error"){
        df$item_date <- NA
      } else {
        df$item_date <- parse_date_time(xx, orders = formats)
      }

      return(df)
    }


    names(document) <- tolower(names(document))


    if(names(document)[1] == "channel"){
      document <- rss_tidy(document)
    } else{
      document <- atom_tidy(document)
    }
    return(document)
  }


  options(show.error.messages= FALSE)


  # get url requests

  suppressWarnings(
  document1 <- try(
      getURL(feed) %>%
      read_xml() %>%
      as_list(),
      silent = F)
  )

  suppressWarnings(
  document2 <- try(
    httr::GET(feed) %>%
    XML::htmlParse() %>%
    XML::xmlToList() %>%
      .[[1]] %>%
      .[[1]],
    silent = F)
  )

  if(class(document1) != "try-error"){
    rss <- tidy_all(document1)
  } else if(class(document2) != "try-error"){
    rss <- tidy_all(document2)
  } else{
    suppressWarnings(
    document <- try(
      httr::GET(feed) %>%
        read_xml() %>%
        as_list(),
      silent = F)
    )

    if(class(document) == "try-error"){

      return(message(msg))

    } else{
      rss <- tidy_all(document)
    }
    options(show.error.messages = TRUE)
  }
  return(rss)
}
