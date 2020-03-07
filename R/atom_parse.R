atom_parse <- function(response, list, clean_tags, parse_dates) {
  # https://tools.ietf.org/html/rfc4287
  # https://validator.w3.org/feed/docs/atom.html
  res <- read_xml(response)
  geocheck(res)

  # metadata: id, title, updated necessary
  metadata <- tibble(
    feed_title = xml_find_first(res, "//*[name()='title']") %>% xml_text(),
    feed_url = xml_find_first(res, "//*[name()='id']") %>% xml_text(),
    feed_last_updated = xml_find_first(res, "//*[name()='updated']") %>% xml_text()
  )
  # optional: author, link, category, contributor, generator, icon, logo,
  # rights, subtitle
  link <- xml_find_first(res, "//*[name()='link']") %>% xml_attr("href")
  meta_optional <- tibble(
    feed_author = safe_run(res, "first", "//*[name()='author']"),
    feed_link = ifelse(!is.null(link), link, def),
    feed_category = list(category = safe_run(res, "first", "//*[name()='category']")),
    feed_generator = safe_run(res, "first", "//*[name()='generator']"),
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

  # clean up
  meta <- clean_up(meta, "atom", clean_tags, parse_dates)
  entries <- clean_up(entries, "atom", clean_tags, parse_dates)

  if (isTRUE(list)) {
    out <- list(meta = meta, entries = entries)
    return(out)
  } else {
    entries$feed_title <- meta$feed_title
    out <- suppressMessages(full_join(meta, entries))
  }
}
