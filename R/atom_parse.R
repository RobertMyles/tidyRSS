atom_parse <- function(response, list, clean_tags, parse_dates) {
  # https://tools.ietf.org/html/rfc4287
  # https://validator.w3.org/feed/docs/atom.html
  res <- read_xml(response, options = "HUGE")
  geocheck(res)

  # get default namespace
  ns_entry <- xml_ns(res) %>% attributes() %>% .[[1]] %>% .[[1]]

  # metadata: id, title, updated necessary
  metadata <- tibble(
    feed_title = xml_find_first(res, glue("{ns_entry}:title")) %>% xml_text(),
    feed_url = xml_find_first(res, glue("{ns_entry}:id")) %>% xml_text(),
    feed_last_updated = xml_find_first(res, glue("{ns_entry}:updated")) %>% xml_text()
  )
  # optional: author, link, category, contributor, generator, icon, logo,
  # rights, subtitle
  link <- xml_find_first(res, glue("{ns_entry}:link")) %>% xml_attr("href")
  meta_optional <- tibble(
    feed_author = safe_run(res, "first", glue("{ns_entry}:author")),
    feed_link = ifelse(!is.null(link), link, def),
    feed_category = list(category = safe_run(res, "first", glue("{ns_entry}:category"))),
    feed_generator = safe_run(res, "first", glue("{ns_entry}:generator")),
    feed_icon = safe_run(res, "first", glue("{ns_entry}:icon")),
    feed_rights = safe_run(res, "first", glue("{ns_entry}:rights"))
  )
  meta <- bind_cols(metadata, meta_optional)
  # entries
  # necessary: id, title, updated

  res_entry <- xml_find_all(res, glue("{ns_entry}:entry"))
  e_link <- xml_find_first(res_entry, glue("{ns_entry}:link")) %>%
    xml_attr("href")

  # optional
  entries <- tibble(
    entry_title = safe_run(res_entry, "all", glue("{ns_entry}:title")),
    entry_url = safe_run(res_entry, "all", glue("{ns_entry}:id")),
    entry_last_updated = safe_run(res_entry, "all", glue("{ns_entry}:updated")),
    entry_author = safe_run(res_entry, "all", glue("{ns_entry}:author")),
    entry_content = safe_run(res_entry, "all", glue("{ns_entry}:content")),
    entry_link = ifelse(!is.null(e_link), e_link, def),
    entry_summary = safe_run(res_entry, "all", glue("{ns_entry}:summary")),
    entry_category = list(NA),
    entry_published = safe_run(res_entry, "all", glue("{ns_entry}:published")),
    entry_rights = safe_run(res_entry, "all", glue("{ns_entry}:rights"))
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
    out <- list(meta = meta, entries = entries) # nocov
    return(out) # nocov
  } else {
    if (!has_name(meta, "feed_title")) {
      meta$feed_title <- NA_character_ # nocov
    }
    entries$feed_title <- meta$feed_title
    out <- suppressMessages(safe_join(meta, entries))
    if (is.null(out$error)) {
      out <- out$result
      if (all(is.na(out$feed_title))) out <- out %>% select(-feed_title) # nocov
      return(out)
    } else {
      # nocov start
      meta$tmp <- "temp"
      entries$tmp <- "temp"
      out <- suppressMessages(full_join(meta, entries))
      out <- out %>% select(-tmp)
      return(out)
      # nocov end
    }
  }
}
