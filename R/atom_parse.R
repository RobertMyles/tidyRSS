formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
             "Y-m-d H:M:S z", "d b Y H:M:S",
             "d b Y H:M:S z", "a b d H:M:S z Y",
             "a b dH:M:S Y")


atom_parse <- function(doc){
  ns <- xml_ns_rename(xml_ns(doc), d1 = "atom")

  entries <- xml_find_all(doc, "atom:entry", ns = ns)

  res <- tibble(
    feed_title = xml_text(xml_find_all(doc, ns = ns, "atom:title")),
    feed_link = xml_attr(xml_find_first(doc, ns = ns, "atom:link"),
                               attr = "href"),
    feed_author = xml_text(xml_find_first(doc, ns = ns, "atom:author")),
    feed_last_updated = xml_text(xml_find_first(doc, ns = ns, "atom:updated")),
    item_title = xml_text(xml_find_first(entries, ns = ns, "atom:title")),
    item_date_updated = xml_text(xml_find_first(entries, ns = ns,
                                                            "atom:updated")) %>%
      parse_date_time(orders = formats),
    item_link = xml_attr(xml_find_first(entries, ns = ns,
                                                     "atom:link"), attr = "href"),
    item_content = xml_text(xml_find_first(entries, ns = ns, "atom:content"))
  )

  if(!grepl("http", unique(res$feed_link))){
    res$feed_link <- xml_text(xml_find_first(entries, ns = ns, "atom:origLink"))
    if(!grepl("http", unique(res$feed_link))){
      res$feed_link <- xml_text(xml_find_first(entries, ns = ns, "atom:link"))
    }
  }
  res <- Filter(function(x) !all(is.na(x)), res)

  return(res)
}
