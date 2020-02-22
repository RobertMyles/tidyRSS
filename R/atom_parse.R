atom_parse <- function(response) {

  res <- read_xml(response)
  geocheck(doc)

  # metadata: id, title, updated necessary
  metadata <- tibble(
    feed_title = xml_find_first(res, "//*[name()='title']") %>% xml_text(),
    feed_url = xml_find_first(res, "//*[name()='id']") %>% xml_text(),
    last_updated = xml_find_first(res, "//*[name()='updated']") %>% xml_text()
  )
  # optional: author, link, category, contributor, generator, icon, logo,
  # rights, subtitle
  link <- xml_find_first(res, "//*[name()='link']") %>% xml_attr("href")
  meta_optional <- tibble(
    feed_author = safe_run(res, "first", "//*[name()='author']"),
    feed_link = ifelse(!is.null(link), link, def),
    feed_category = list(safe_run(res, "first", "//*[name()='category']")),
    feed_icon = safe_run(res, "first", "//*[name()='icon']"),
    feed_rights = safe_run(res, "first", "//*[name()='rights']")
  )
  meta <- bind_cols(metadata, meta_optional)
  # entries
  # necessary: id, title, updated
  res_entry <- xml_find_all(res, "//*[name()='entry']")
  e_link <- xml_find_first(res_entry, "//*[name()='link']") %>%
    xml_attr("href")

  # optional
  entries <- tibble(
    entry_title = xml_find_first(res_entry, "//*[name()='title']") %>%
      xml_text(),
    entry_url = xml_find_first(res_entry, "//*[name()='id']") %>%
      xml_text(),
    entry_last_updated = xml_find_first(
      res_entry, "//*[name()='updated']"
    ) %>%
      xml_text(),
    entry_author = safe_run(res_entry, "all", "//*[name()='author']"),
    entry_content = safe_run(res_entry, "all", "//*[name()='content']"),
    entry_link = ifelse(!is.null(e_link), e_link, def),
    entry_summary = safe_run(res_entry, "all", "//*[name()='summary']"),
    entry_category = list(NA),
    entry_published = safe_run(res_entry, "all", "//*[name()='published']"),
    entry_rights = safe_run(res_entry, "all", "//*[name()='rights']")
  )

  # categories are stored as attributes of xml nodes:
  for (i in seq_len(length(res_entry))) {
    entries$entry_category[[i]] <- res_entry[[i]] %>%
      xml_contents() %>%
      as_list() %>%
      map(attributes) %>%
      map("term") %>%
      compact()
    names(entries$entry_category[[i]]) <- res_entry[[i]] %>%
      xml_contents() %>%
      as_list() %>%
      map(attributes) %>%
      map("label") %>%
      compact()
  }

  out <- list(meta = meta, entries = entries)
  return(out)
}



#
#   ns <- xml_ns_rename(xml_ns(doc), d1 = "atom")
#   entries <- xml_find_all(doc, "atom:entry", ns = ns)
#
#   res <- tibble(
#     feed_title = xml_find_all(doc, ns = ns, "atom:title") %>% xml_text(),
#     feed_link = xml_find_first(doc, ns = ns, "atom:link") %>%
#       xml_attr(attr = "href"),
#     feed_author = xml_find_first(doc, ns = ns, "atom:author") %>% xml_text(),
#     feed_last_updated = xml_find_first(doc, ns = ns, "atom:updated") %>%
#       xml_text(),
#     item_title = xml_find_first(entries, ns = ns, "atom:title") %>% xml_text(),
#     item_date_updated = xml_find_first(entries, ns = ns,"atom:updated") %>%
#       xml_text() %>%
#       parse_date_time(orders = formats),
#     item_link = xml_find_first(entries, ns = ns, "atom:link") %>%
#       xml_attr(attr = "href"),
#     item_content = xml_find_first(entries, ns = ns, "atom:content") %>%
#       xml_text()
#   )
#
#   if(!grepl("http", unique(res$feed_link))){
#     res$feed_link <- xml_find_first(entries, ns = ns, "atom:origLink") %>%
#       xml_text()
#     if(!grepl("http", unique(res$feed_link))){
#       res$feed_link <- xml_find_first(entries, ns = ns, "atom:link") %>%
#         xml_text()
#     }
#   }
#   return(res)
# }
