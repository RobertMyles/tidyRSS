json_parse <- function(response, list, clean_tags, parse_dates) {
  # spec here: https://jsonfeed.org/version/1.1/
  res <- parse_json(response)
  items <- res$items

  meta <- tibble(
    feed_title = res$title,
    home_page_url = return_exists(res$home_page_url),
    feed_url = return_exists(res$feed_url),
    description = return_exists(res$description),
    feed_author = return_exists(res$author$name),
    feed_author_url = return_exists(res$author$url),
    next_url = return_exists(res$next_url),
    language = return_exists(res$language),
    expired = return_exists(res$expired),
    icon = return_exists(res$icon),
    favicon = return_exists(res$favicon)
  )

  entries <- tibble(
    item_id = map_chr(items, "id", .default = def),
    item_title = map_chr(items, "title", .default = def),
    item_date_published = map_chr(items, "date_published", .default = def),
    item_date_modified = map_chr(items, "date_modified", .default = def),
    item_url = map_chr(items, "url", .default = def),
    item_external_url = map_chr(items, "external_url", .default = def),
    item_author = map(items, "author", .default = def),
    item_authors = map(items, "authors", .default = def),
    item_content_html = map_chr(items, "content_html", .default = def),
    item_content_text = map_chr(items, "content_text", .default = def),
    item_summary = map_chr(items, "summary", .default = def),
    item_image = map_chr(items, "image", .default = def),
    item_banner_image = map_chr(items, "banner_image", .default = def),
    item_tags = map_chr(items, "tags", .default = def),
    item_language = map_chr(items, "language", .default = def),
  )

  for (i in seq_len(nrow(entries))) {
    if (!is.null(entries$item_author[i])) {
      entries$item_author_name <- map_chr(
        entries$item_author, "name",
        .default = def
      )
      entries$item_author_url <- map_chr(
        entries$item_author, "url",
        .default = def
      )
      entries$item_author_avatar <- map_chr(
        entries$item_author, "avatar",
        .default = def
      )
    }
  }
  entries$item_author <- NA

  # clean up
  meta <- clean_up(meta, "json", clean_tags, parse_dates)
  entries <- clean_up(entries, "json", clean_tags, parse_dates)

  if (isTRUE(list)) {
    out <- list(meta = meta, entries = entries) # nocov
    return(out) # nocov
  } else {
    entries$feed_title <- meta$feed_title
    out <- suppressMessages(full_join(meta, entries))
    return(out)
  }
}
