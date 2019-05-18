formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
             "Y-m-d H:M:S z", "d b Y H:M:S",
             "d b Y H:M:S z", "a b d H:M:S z Y",
             "a b dH:M:S Y")


geo_parse <- function(doc){
  d <- doc
  d <- xml2::xml_contents(d) %>% xml2::as_list()
  d2 <- doc

  # meta attributes:
  link <- attributes(d[[1]]$link)[1] %>% unlist()
  names(link) <- NULL
  meta <- dplyr::tibble(
    temp = "geo",
    feed_title = purrr::map(d, "title", .default = NA_character_) %>% unlist(),
    feed_author = purrr::map(d, "author", .default = NA_character_) %>% unlist(),
    feed_description = purrr::map(d, "description", .default = NA_character_) %>% unlist(),
    feed_last_updated = purrr::map(d, "pubDate", .default = NA_character_) %>% unlist() %>%
      lubridate::parse_date_time(orders = formats),
    feed_language = purrr::map(d, "language", .default = NA_character_) %>% unlist()
  )

  if(!is.null(link)) meta$link <- link

  # items:
  items <- d2 %>% xml2::xml_find_all("channel") %>% xml2::xml_find_all("item") %>%
    xml2::as_list()

  if(length(items) < 1) {
    items <- d2 %>% xml_contents() %>% as_list()
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

  item_d_updated <- unique(item$item_date_updated)

  if(all(is.na(item_d_updated))){
    date_check <- grepl("date", names(items[[1]]))
    if(any(date_check == TRUE)){
      item$item_date_updated <- purrr::map(items, "date", .default = NA_character_) %>%
        unlist() %>% lubridate::parse_date_time(orders = formats)
    }
  }

  item_1_long <- unique(item$item_long)

  if(all(is.na(item_1_long))){
    geo <- purrr::map(items, "point", .default = NA_character_) %>% unlist()
    long <- stringr::str_extract(geo, "\\s[0-9\\.-]*") %>% trimws() %>% as.numeric()
    lat <- stringr::str_extract(geo, "[0-9\\.-]*\\s") %>% trimws() %>% as.numeric()
    item$item_long <- long
    item$item_lat <- lat

    item_2_long <- unique(item$item_long)

    if(all(is.na(item_2_long))){
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
