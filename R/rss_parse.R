rss_parse <- function(response, list, clean_tags, parse_dates) {
  # spec here: https://validator.w3.org/feed/docs/rss2.html
  res <- response %>% read_xml()
  geocheck(res)
  channel <- xml_find_first(res, "//*[name()='channel']")
  # meta data. Necessary: title, link, description
  metadata <- tibble(
    feed_title = xml_find_first(channel, "//*[name()='title']") %>% xml_text(),
    feed_link = xml_find_first(channel, "//*[name()='link']") %>% xml_text(),
    feed_description = xml_find_first(channel, "//*[name()='description']") %>%
      xml_text()
  )
  # optional metadata: language, copyright, managingEditor, webMaster, pubDate,
  # lastBuildDate; category, generator, docs, cloud, ttl, image, textInput,
  # skipHours, skipDays
  meta_optional <- tibble(
    feed_language = safe_run(channel, "first", "//*[name()='language']"),
    feed_managing_editor = safe_run(channel,
                                    "first", "//*[name()='managingEditor']"),
    feed_web_master = safe_run(channel, "first", "//*[name()='webMaster']"),
    feed_pub_date = safe_run(channel, "first", "//*[name()='pubDate']"),
    feed_last_build_date = safe_run(channel,
                                    "first", "//*[name()='lastBuildDate']"),
    feed_category = list(category = safe_run(
      channel, "first", "//*[name()='category']"
      )),
    feed_generator = safe_run(channel, "first", "//*[name()='generator']"),
    feed_docs = safe_run(channel, "first", "//*[name()='docs']"),
    feed_ttl = safe_run(channel, "first", "//*[name()='ttl']")
  )
  meta <- bind_cols(metadata, meta_optional)
  # entries
  # necessary: title or description
  res_entry <- xml_find_all(channel, "//*[name()='item']") %>% as_list()
  res_entry_xml <- xml_find_all(channel, "//*[name()='item']")

  entries <- tibble(
    item_title = map(res_entry, "title", .default = def) %>% unlist(),
    item_link = map(res_entry, "link", .default = def) %>% unlist(),
    item_description = map(res_entry, "description", .default = def) %>%
      unlist(),
    item_pub_date = map(res_entry, "pubDate", .default = def) %>% unlist(),
    item_guid = map(res_entry, "guid", .default = def) %>% unlist(),
    item_author = map(res_entry, "author", .default = def),
    item_category = map(res_entry_xml, ~ {
      xml_find_all(.x, "category") %>% map(xml_text)
    }),
    item_comments = map(res_entry, "comments", .default = def) %>% unlist()
  )

  # clean up
  meta <- clean_up(meta, "rss", clean_tags, parse_dates)
  entries <- clean_up(entries, "rss", clean_tags, parse_dates)

  if (isTRUE(list)) {
    out <- list(meta = meta, entries = entries)
    return(out)
  } else {
    entries$feed_title <- meta$feed_title
    out <- suppressMessages(full_join(meta, entries))
  }
}
