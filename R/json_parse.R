json_parse <- function(feed){

  res <- fromJSON(feed)

  items <- res$items
  items$author <- unlist(flatten(items$author))
  items$feed_title = res$title

  results <- tibble(
    version = res$version,
    feed_title = res$title,
    home_page_url = res$home_page_url,
    feed_url = res$feed_url,
    feed_author = res$author$name,
    icon = res$icon,
    favicon = res$favicon
  )

  results <- suppressMessages(full_join(results, items))

  results <- results %>%
    mutate(
      date_published = parse_date_time(date_published, orders = formats),
      date_modified = parse_date_time(date_modified, orders = formats)
      )

  return(results)
}

