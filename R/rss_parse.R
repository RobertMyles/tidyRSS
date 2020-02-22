rss_parse <- function(response) {
  res <- response %>% read_xml()




}



rss_parse <- function(doc){
  channel <- xml_find_all(doc, "channel")

  if(identical(length(channel), 0L)){
    if(any(names(xml_ns(doc)) == "d1")){
      ns <- xml_ns_rename(xml_ns(doc), d1 = "rss")
    } else{
      ns <- xml_ns(doc)
    }

    channel <- xml_find_all(doc, "rss:channel", ns = ns)
    site <- xml_find_all(doc, "rss:item", ns = ns)

    categories <- function(item){
      xx <- xml_find_all(item, "rss:category", ns = ns) %>% xml_text()
      if(length(xx) < 1){
        return(FALSE)
      } else {
        return(TRUE)
      }
    }

    res <- suppressWarnings({tibble(
      feed_title = safe_xml_find_all(channel, "rss:title", ns = ns) %>%
        safe_run() %>%
        xml_text(),
      feed_link = safe_xml_find_all(channel, "rss:link", ns = ns) %>%
        safe_run() %>%
        xml_text(),
      feed_description = safe_xml_find_first(channel,
                                             "rss:description", ns = ns) %>%
        safe_run() %>%
        xml_text(),
      feed_last_updated = safe_xml_find_first(channel,
                                              "rss:lastBuildDate", ns = ns) %>%
        safe_run() %>%
        xml_text() %>%
        parse_date_time(orders = formats),
      feed_language = safe_xml_find_first(channel, "rss:language", ns = ns) %>%
        safe_run() %>%
        xml_text(),
      feed_update_period = safe_xml_find_first(channel,
                                               "rss:updatePeriod", ns = ns) %>%
        safe_run() %>%
        xml_text(),
      item_title = safe_xml_find_all(site, "rss:title", ns = ns) %>%
        safe_run() %>%
        xml_text(),
      item_creator = safe_xml_find_first(site, "rss:creator", ns = ns) %>%
        safe_run() %>%
        xml_text(),
      item_date_published = safe_xml_find_first(site, "rss:pubDate", ns = ns) %>%
        safe_run() %>%
        xml_text() %>%
        parse_date_time(orders = formats),
      item_date = safe_xml_find_first(site, "rss:date", ns = ns) %>%
        safe_run() %>%
        xml_text() %>%
        parse_date_time(orders = formats),
      item_subject = safe_xml_find_first(site, ns = ns, "rss:subject") %>%
        safe_run() %>%
        xml_text(),
      item_link = safe_xml_find_all(site, "rss:link", ns = ns) %>%
        safe_run() %>%
        xml_text(),
      item_description = safe_xml_find_first(site,
                                             "rss:description", ns = ns) %>%
        safe_run() %>%
        xml_text()
    )})

    if(categories(site) == TRUE) {
      res$item_categories <- safe_xml_find_all(
        site, "rss:category/..",
        ns = ns
        ) %>%
        safe_run()
    }
  } else{

    site <- xml_find_all(channel, "item")

    res <- suppressWarnings({
      tibble(
      feed_title = safe_xml_find_first(channel, "id") %>%
        safe_run() %>%
        xml_text(),
      feed_link = safe_xml_find_first(channel, "link") %>%
        safe_run() %>%
        xml_text(),
      feed_description = safe_xml_find_first(channel, "description") %>%
        safe_run() %>%
        xml_text(),
      feed_last_updated = safe_xml_find_first(channel, "lastBuildDate") %>%
        safe_run() %>%
        xml_text() %>%
        parse_date_time(orders = formats),
      feed_language = safe_xml_find_first(channel, "language") %>%
        safe_run() %>%
        xml_text(),
      feed_update_period = safe_xml_find_first(channel, "updatePeriod") %>%
        safe_run() %>%
        xml_text(),
      item_title = safe_xml_find_first(site, "title") %>%
        safe_run() %>%
        xml_text(),
      item_creator = safe_xml_find_first(site, "dc:creator") %>%
        safe_run() %>%
        xml_text(),
      item_date_published = safe_xml_find_first(site, "pubDate") %>%
        safe_run() %>%
        xml_text() %>%
        parse_date_time(orders = formats),
      item_description = safe_xml_find_first(site, "description") %>%
        safe_run() %>%
        xml_text(),
      item_link = safe_xml_find_first(site, "link") %>%
        safe_run() %>%
        xml_text()
    )})

    if(length(xml_find_all(site, "category")) > 0){
      res <- res %>%
        mutate(
          item_categories = map(site, xml_find_all, "category") %>%
            map(xml_text))
    }

      suppressWarnings(
        res$feed_update_period[is.na(res$feed_update_period)] <- safe_xml_find_first(
          channel, "sy:updatePeriod"
          ) %>%
          safe_run() %>%
          xml_text()
      )
      suppressWarnings(
        res$feed_title[is.na(res$feed_title)] <- safe_xml_find_first(
          channel, "title") %>%
          safe_run() %>%
          xml_text()
      )
      return(res)
    }
}
