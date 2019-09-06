atom_parse <- function(doc){
  ns <- xml_ns_rename(xml_ns(doc), d1 = "atom")
  entries <- xml_find_all(doc, "atom:entry", ns = ns)

  res <- tibble(
    feed_title = xml_find_all(doc, ns = ns, "atom:title") %>% xml_text(),
    feed_link = xml_find_first(doc, ns = ns, "atom:link") %>%
      xml_attr(attr = "href"),
    feed_author = xml_find_first(doc, ns = ns, "atom:author") %>% xml_text(),
    feed_last_updated = xml_find_first(doc, ns = ns, "atom:updated") %>%
      xml_text(),
    item_title = xml_find_first(entries, ns = ns, "atom:title") %>% xml_text(),
    item_date_updated = xml_find_first(entries, ns = ns,"atom:updated") %>%
      xml_text() %>%
      parse_date_time(orders = formats),
    item_link = xml_find_first(entries, ns = ns, "atom:link") %>%
      xml_attr(attr = "href"),
    item_content = xml_find_first(entries, ns = ns, "atom:content") %>%
      xml_text()
  )

  if(!grepl("http", unique(res$feed_link))){
    res$feed_link <- xml_find_first(entries, ns = ns, "atom:origLink") %>%
      xml_text()
    if(!grepl("http", unique(res$feed_link))){
      res$feed_link <- xml_find_first(entries, ns = ns, "atom:link") %>%
        xml_text()
    }
  }
  return(res)
}
