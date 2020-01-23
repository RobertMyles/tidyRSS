json_parse <- function(feed){

  res <- fromJSON(feed)

  # return_exists() used for optional items
  # spec here: https://jsonfeed.org/version/1
  results <- tibble(
    version = res$version,
    feed_title = res$title,
    home_page_url = return_exists(res$home_page_url),
    feed_url = return_exists(res$feed_url),
    description = return_exists(res$description),
    feed_author = return_exists(res$author$name),
    feed_author_url = return_exists(res$author$url),
    expired = return_exists(res$expired),
    icon = return_exists(res$icon),
    favicon = return_exists(res$favicon),
    item_title = return_exists(items$title),
    item_summary = return_exists(items$summary),
    item_content = return_exists(items$content_html),
    item_image = return_exists(items$image),
    item_date_published = return_exists(items$date_published),
    item_date_modified = return_exists(items$date_modified),
    item_author = return_exists(items$author),
    item_tags = return_exists(items$tags)
  )
  if (is.na(results$item_content)) {
    results <- mutate(results, item_content = return_exists(items$content_text))
  }

  results <- results %>%
    mutate(
      item_date_published = parse_date_time(item_date_published, orders = formats),
      item_date_modified = parse_date_time(item_date_modified, orders = formats)
      )

  return(results)
}

