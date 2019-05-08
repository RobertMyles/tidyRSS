formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
             "Y-m-d H:M:S z", "d b Y H:M:S",
             "d b Y H:M:S z", "a b d H:M:S z Y",
             "a b dH:M:S Y")


geo_parse <- function(doc){
  d <- doc
  doc <- xml2::xml_contents(doc) %>% xml2::as_list()

  # meta attributes:
  link <- attributes(doc[[1]]$link)[1] %>% unlist()
  names(link) <- NULL
  meta <- dplyr::tibble(
    temp = "geo",
    feed_title = purrr::map(doc, "title", .default = NA_character_) %>% unlist(),
    feed_author = purrr::map(doc, "author", .default = NA_character_) %>% unlist(),
    feed_description = purrr::map(doc, "description", .default = NA_character_) %>% unlist(),
    feed_last_updated = purrr::map(doc, "pubDate", .default = NA_character_) %>% unlist() %>%
      lubridate::parse_date_time(orders = formats),
    feed_language = purrr::map(doc, "language", .default = NA_character_) %>% unlist()
  )
  if(!is.null(link)) meta$link <- link

  # items:
  items <- d %>% xml2::xml_find_all("channel") %>% xml2::xml_find_all("item") %>%
    xml2::as_list()

  if(length(items) < 1) {
    items <- d %>% xml_contents() %>% as_list()
  }

  item <- dplyr::tibble(
    temp = "geo",
    item_title = purrr::map(items, "title", .default = NA_character_) %>% unlist(),
    item_date_updated = purrr::map(items, "pubDate", .default = NA_character_) %>%
      unlist() %>% lubridate::parse_date_time(orders = formats),
    item_content = purrr::map(items, "description", .default = NA_character_) %>% unlist(),
    item_link = purrr::map(items, "link", .default = NA_character_) %>% unlist(),
    item_long = purrr::map(items, "long", .default = NA_character_) %>%
      unlist() %>% as.numeric(),
    item_lat = purrr::map(items, "lat", .default = NA_character_) %>%
      unlist() %>% as.numeric()
  )

  if(is.na(unique(item$item_date_updated))){
    date_check <- grepl("date", names(items[[1]]))
    if(any(date_check == TRUE)){
      item$item_date_updated <- purrr::map(items, "date", .default = NA_character_) %>%
        unlist() %>% lubridate::parse_date_time(orders = formats)
    }
  }

  if(is.na(unique(item$item_long))){
    geo <- purrr::map(items, "point", .default = NA_character_) %>% unlist()
    long <- stringr::str_extract(geo, "\\s[0-9\\.-]*") %>% trimws() %>% as.numeric()
    lat <- stringr::str_extract(geo, "[0-9\\.-]*\\s") %>% trimws() %>% as.numeric()
    item$item_long <- long
    item$item_lat <- lat

    if(is.na(unique(item$item_long))){
      geo <- purrr::map(items, "georss:point", .default = NA_character_) %>% unlist()
      long <- stringr::str_extract(geo, "\\s[0-9\\.-]*") %>% trimws() %>% as.numeric()
      lat <- stringr::str_extract(geo, "[0-9\\.-]*\\s") %>% trimws() %>% as.numeric()
      item$item_long <- long
      item$item_lat <- lat
    }
  }

  suppressMessages(result <- dplyr::full_join(meta, item))
  result <- result %>% dplyr::select(-temp)

  result <- Filter(function(x) !all(is.na(x)), result)

  return(result)
}
