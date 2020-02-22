rss_parse <- function(response) {
  # spec here: https://validator.w3.org/feed/docs/rss2.html
  res <- response %>% read_xml()
  geocheck(res)
  channel <- xml_find_first(res, "//*[name()='channel']")
  # meta data. Necessary: title, link, description
  metadata <- tibble(
    feed_title = xml_find_first(channel, "//*[name()='title']") %>% xml_text(),
    feed_link = xml_find_first(channel, "//*[name()='link']") %>% xml_text(),
    last_description = xml_find_first(channel, "//*[name()='description']") %>% xml_text()
  )
  # optional metadata: language, copyright, managingEditor, webMaster, pubDate,
  # lastBuildDate; category, generator, docs, cloud, ttl, image, textInput,
  # skipHours, skipDays
  meta_optional <- tibble(
    feed_language = safe_run(channel, "first", "//*[name()='language']"),
    feed_managing_editor = safe_run(channel, "first", "//*[name()='managingEditor']"),
    feed_web_master = safe_run(channel, "first", "//*[name()='webMaster']"),
    feed_pub_date = safe_run(channel, "first", "//*[name()='pubDate']"),
    feed_last_build_date = safe_run(channel, "first", "//*[name()='lastBuildDate']"),
    feed_category = list(category = safe_run(channel, "first", "//*[name()='category']")), ##TODO need check if empty
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
    item_description = map(res_entry, "description", .default = def) %>% unlist(),
    item_pub_date = map(res_entry, "pubDate", .default = def) %>% unlist(),
    item_guid = map(res_entry, "guid", .default = def) %>% unlist(),
    item_author = map(res_entry, "author", .default = def),
    item_category = map(res_entry_xml, ~{
      xml_find_all(.x, "category") %>% map(xml_text)
      }),
    item_comments = map(res_entry, "comments", .default = def) %>% unlist()
  ) %>%
    mutate(
      item_author = map_chr(item_author, ~{
        ifelse(!is.na(.x), map(.x, "name"), .x)
      })
    )

  if (isTRUE(list)) {
    out <- list(meta = meta, entries = entries)
    return(out)
  } else {
    entries$feed_title <- meta$feed_title
    out <- suppressMessages(full_join(meta, entries))
  }

}



# rss_parse <- function(doc){
#   channel <- xml_find_all(doc, "channel")
#
#   if(identical(length(channel), 0L)){
#     if(any(names(xml_ns(doc)) == "d1")){
#       ns <- xml_ns_rename(xml_ns(doc), d1 = "rss")
#     } else{
#       ns <- xml_ns(doc)
#     }
#
#     channel <- xml_find_all(doc, "rss:channel", ns = ns)
#     site <- xml_find_all(doc, "rss:item", ns = ns)
#
#     categories <- function(item){
#       xx <- xml_find_all(item, "rss:category", ns = ns) %>% xml_text()
#       if(length(xx) < 1){
#         return(FALSE)
#       } else {
#         return(TRUE)
#       }
#     }
#
#     res <- suppressWarnings({tibble(
#       feed_title = safe_xml_find_all(channel, "rss:title", ns = ns) %>%
#         safe_run() %>%
#         xml_text(),
#       feed_link = safe_xml_find_all(channel, "rss:link", ns = ns) %>%
#         safe_run() %>%
#         xml_text(),
#       feed_description = safe_xml_find_first(channel,
#                                              "rss:description", ns = ns) %>%
#         safe_run() %>%
#         xml_text(),
#       feed_last_updated = safe_xml_find_first(channel,
#                                               "rss:lastBuildDate", ns = ns) %>%
#         safe_run() %>%
#         xml_text() %>%
#         parse_date_time(orders = formats),
#       feed_language = safe_xml_find_first(channel, "rss:language", ns = ns) %>%
#         safe_run() %>%
#         xml_text(),
#       feed_update_period = safe_xml_find_first(channel,
#                                                "rss:updatePeriod", ns = ns) %>%
#         safe_run() %>%
#         xml_text(),
#       item_title = safe_xml_find_all(site, "rss:title", ns = ns) %>%
#         safe_run() %>%
#         xml_text(),
#       item_creator = safe_xml_find_first(site, "rss:creator", ns = ns) %>%
#         safe_run() %>%
#         xml_text(),
#       item_date_published = safe_xml_find_first(site, "rss:pubDate", ns = ns) %>%
#         safe_run() %>%
#         xml_text() %>%
#         parse_date_time(orders = formats),
#       item_date = safe_xml_find_first(site, "rss:date", ns = ns) %>%
#         safe_run() %>%
#         xml_text() %>%
#         parse_date_time(orders = formats),
#       item_subject = safe_xml_find_first(site, ns = ns, "rss:subject") %>%
#         safe_run() %>%
#         xml_text(),
#       item_link = safe_xml_find_all(site, "rss:link", ns = ns) %>%
#         safe_run() %>%
#         xml_text(),
#       item_description = safe_xml_find_first(site,
#                                              "rss:description", ns = ns) %>%
#         safe_run() %>%
#         xml_text()
#     )})
#
#     if(categories(site) == TRUE) {
#       res$item_categories <- safe_xml_find_all(
#         site, "rss:category/..",
#         ns = ns
#         ) %>%
#         safe_run()
#     }
#   } else{
#
#     site <- xml_find_all(channel, "item")
#
#     res <- suppressWarnings({
#       tibble(
#       feed_title = safe_xml_find_first(channel, "id") %>%
#         safe_run() %>%
#         xml_text(),
#       feed_link = safe_xml_find_first(channel, "link") %>%
#         safe_run() %>%
#         xml_text(),
#       feed_description = safe_xml_find_first(channel, "description") %>%
#         safe_run() %>%
#         xml_text(),
#       feed_last_updated = safe_xml_find_first(channel, "lastBuildDate") %>%
#         safe_run() %>%
#         xml_text() %>%
#         parse_date_time(orders = formats),
#       feed_language = safe_xml_find_first(channel, "language") %>%
#         safe_run() %>%
#         xml_text(),
#       feed_update_period = safe_xml_find_first(channel, "updatePeriod") %>%
#         safe_run() %>%
#         xml_text(),
#       item_title = safe_xml_find_first(site, "title") %>%
#         safe_run() %>%
#         xml_text(),
#       item_creator = safe_xml_find_first(site, "dc:creator") %>%
#         safe_run() %>%
#         xml_text(),
#       item_date_published = safe_xml_find_first(site, "pubDate") %>%
#         safe_run() %>%
#         xml_text() %>%
#         parse_date_time(orders = formats),
#       item_description = safe_xml_find_first(site, "description") %>%
#         safe_run() %>%
#         xml_text(),
#       item_link = safe_xml_find_first(site, "link") %>%
#         safe_run() %>%
#         xml_text()
#     )})
#
#     if(length(xml_find_all(site, "category")) > 0){
#       res <- res %>%
#         mutate(
#           item_categories = map(site, xml_find_all, "category") %>%
#             map(xml_text))
#     }
#
#       suppressWarnings(
#         res$feed_update_period[is.na(res$feed_update_period)] <- safe_xml_find_first(
#           channel, "sy:updatePeriod"
#           ) %>%
#           safe_run() %>%
#           xml_text()
#       )
#       suppressWarnings(
#         res$feed_title[is.na(res$feed_title)] <- safe_xml_find_first(
#           channel, "title") %>%
#           safe_run() %>%
#           xml_text()
#       )
#       return(res)
#     }
# }
