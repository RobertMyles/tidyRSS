formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
             "Y-m-d H:M:S z", "d b Y H:M:S",
             "d b Y H:M:S z", "a b d H:M:S z Y",
             "a b dH:M:S Y")


geo_parse <- function(doc){
  d <- doc
  d <- xml_contents(d) %>% as_list()
  d2 <- doc

  # meta attributes:
  link <- attributes(d[[1]]$link)[1] %>% unlist()
  names(link) <- NULL
  meta <- tibble(
    temp = "geo",
    feed_title = map(d, "title", .default = NA_character_) %>% unlist(),
    feed_author = map(d, "author", .default = NA_character_) %>% unlist(),
    feed_description = map(d, "description", .default = NA_character_) %>% unlist(),
    feed_last_updated = map(d, "pubDate", .default = NA_character_) %>% unlist() %>%
      lubridate::parse_date_time(orders = formats),
    feed_language = map(d, "language", .default = NA_character_) %>% unlist()
  )

  if(!is.null(link)) meta$link <- link

  # items:
  items <- d2 %>% xml_find_all("channel") %>% xml_find_all("item") %>%
    as_list()

  if(length(items) < 1) {
    items <- d2 %>% xml_contents() %>% as_list()
  }

  item <- tibble(
    temp = "geo",
    item_title = map(items, "title", .default = NA_character_) %>% unlist(),
    item_date_updated = map(items, "pubDate", .default = NA_character_) %>%
      unlist() %>% parse_date_time(orders = formats),
    item_content = map(items, "description", .default = NA_character_) %>% unlist(),
    item_link = map(items, "link", .default = NA_character_) %>% unlist(),
    item_long = map(items, "long", .default = NA_character_) %>%
      unlist() %>% as.numeric(),
    item_lat = map(items, "lat", .default = NA_character_) %>%
      unlist() %>% as.numeric()
  )

  item_d_updated <- unique(item$item_date_updated)

  if(all(is.na(item_d_updated))){
    date_check <- grepl("date", names(items[[1]]))
    if(any(date_check == TRUE)){
      item$item_date_updated <- map(items, "date", .default = NA_character_) %>%
        unlist() %>% parse_date_time(orders = formats)
    }
  }

  item_1_long <- unique(item$item_long)

  if(all(is.na(item_1_long))){
    geo <- map(items, "point", .default = NA_character_) %>% unlist()
    long <- str_extract(geo, "\\s[0-9\\.-]*") %>% trimws() %>% as.numeric()
    lat <- str_extract(geo, "[0-9\\.-]*\\s") %>% trimws() %>% as.numeric()
    item$item_long <- long
    item$item_lat <- lat

    item_2_long <- unique(item$item_long)

    if(all(is.na(item_2_long))){
      geo <- map(items, "georss:point", .default = NA_character_) %>% unlist()
      long <- str_extract(geo, "\\s[0-9\\.-]*") %>% trimws() %>% as.numeric()
      lat <- str_extract(geo, "[0-9\\.-]*\\s") %>% trimws() %>% as.numeric()
      item$item_long <- long
      item$item_lat <- lat
    }
  }

  suppressMessages(result <- full_join(meta, item))
  result <- result %>% select(-temp)
  result <- Filter(function(x) !all(is.na(x)), result)

  return(result)
}
