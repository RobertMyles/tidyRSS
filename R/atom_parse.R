formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
             "Y-m-d H:M:S z", "d b Y H:M:S",
             "d b Y H:M:S z", "a b d H:M:S z Y",
             "a b dH:M:S Y")


atom_parse <- function(doc){
  ns <- xml2::xml_ns_rename(xml2::xml_ns(doc), d1 = "atom")

  entries <- xml2::xml_find_all(doc, "atom:entry", ns = ns)

  res <- tibble::tibble(
    feed_title = xml2::xml_text(xml2::xml_find_all(doc, ns = ns, "atom:title")),
    feed_link = xml2::xml_attr(xml2::xml_find_first(doc, ns = ns, "atom:link"),
                               attr = "href"),
    feed_author = xml2::xml_text(xml2::xml_find_first(doc, ns = ns, "atom:author")),
    feed_last_updated = xml2::xml_text(xml2::xml_find_first(doc, ns = ns, "atom:updated")),
    item_title = xml2::xml_text(xml2::xml_find_first(entries, ns = ns, "atom:title")),
    item_date_updated = xml2::xml_text(xml2::xml_find_first(entries, ns = ns,
                                                            "atom:updated")) %>%
      lubridate::parse_date_time(orders = formats),
    item_link = xml2::xml_attr(xml2::xml_find_first(entries, ns = ns,
                                                     "atom:link"), attr = "href"),
    item_content = xml2::xml_text(xml2::xml_find_first(entries, ns = ns, "atom:content"))
  )

  if(!grepl("http", unique(res$feed_link))){
    res$feed_link <- xml2::xml_text(xml2::xml_find_first(entries, ns = ns, "atom:origLink"))
    if(!grepl("http", unique(res$feed_link))){
      res$feed_link <- xml2::xml_text(xml2::xml_find_first(entries, ns = ns, "atom:link"))
    }
  }

  res <- Filter(function(x) !all(is.na(x)), res)

  return(res)
}
