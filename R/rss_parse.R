formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
             "Y-m-d H:M:S z", "d b Y H:M:S",
             "d b Y H:M:S z", "a b d H:M:S z Y",
             "a b dH:M:S Y")

rss_parse <- function(doc){

  channel <- xml2::xml_find_all(doc, "channel")

  if(identical(length(channel), 0L)){
    ns <- xml2::xml_ns_rename(xml2::xml_ns(doc), d1 = "rss")
    channel <- xml2::xml_find_all(doc, "rss:channel", ns = ns)
    site <- xml2::xml_find_all(doc, "rss:item", ns = ns)

    res <- suppressWarnings({tibble::tibble(
      feed_title = xml2::xml_text(xml2::xml_find_all(channel, "rss:title", ns = ns)),
      feed_link = xml2::xml_text(xml2::xml_find_all(channel, "rss:link", ns = ns)),
      feed_description = xml2::xml_text(xml2::xml_find_first(channel, "rss:description", ns = ns)),
      feed_last_updated = xml2::xml_text(xml2::xml_find_first(channel,
                                                              "rss:lastBuildDate", ns = ns)) %>%
        lubridate::parse_date_time(orders = formats),
      feed_language = xml2::xml_text(xml2::xml_find_first(channel, "rss:language", ns = ns)),
      feed_update_period = xml2::xml_text(xml2::xml_find_first(channel, "rss:updatePeriod", ns = ns)),
      item_title = xml2::xml_text(xml2::xml_find_all(site, "rss:title", ns = ns)),
      item_creator = xml2::xml_text(xml2::xml_find_first(site, "rss:creator", ns = ns)),
      item_date_published = xml2::xml_text(xml2::xml_find_first(site, "rss:pubDate", ns = ns)) %>%
        lubridate::parse_date_time(orders = formats),
      item_date =  xml2::xml_text(xml2::xml_find_first(site, "rss:date", ns = ns)) %>%
        lubridate::parse_date_time(orders = formats),
      item_subject = xml2::xml_text(xml2::xml_find_first(site, ns = ns, "rss:subject")),
      item_category1 = xml2::xml_text(xml2::xml_find_first(site, "rss:category[1]", ns = ns)),
      item_category2 = xml2::xml_text(xml2::xml_find_first(site, "rss:category[2]", ns = ns)),
      item_category3 = xml2::xml_text(xml2::xml_find_first(site, "rss:category[3]", ns = ns)),
      item_category4 = xml2::xml_text(xml2::xml_find_first(site, "rss:category[4]", ns = ns)),
      item_category5 = xml2::xml_text(xml2::xml_find_first(site, "rss:category[5]", ns = ns)),
      item_link = xml2::xml_text(xml2::xml_find_all(site, "rss:link", ns = ns)),
      item_description = xml2::xml_text(xml2::xml_find_first(site, "rss:description", ns = ns))
    )})

    res <- Filter(function(x) !all(is.na(x)), res)

  } else{

    site <- xml2::xml_find_all(channel, "item")

    res <- suppressWarnings({tibble::tibble(
      feed_title = xml2::xml_text(xml2::xml_find_first(channel, "id")),
      feed_link = xml2::xml_text(xml2::xml_find_first(channel, "link")),
      feed_description = xml2::xml_text(xml2::xml_find_first(channel, "description")),
      feed_last_updated = xml2::xml_text(xml2::xml_find_first(channel,
                                                              "lastBuildDate")) %>%
        lubridate::parse_date_time(orders = formats),
      feed_language = xml2::xml_text(xml2::xml_find_first(channel, "language")),
      feed_update_period = xml2::xml_text(xml2::xml_find_first(channel, "updatePeriod")),
      item_title = xml2::xml_text(xml2::xml_find_first(site, "title")),
      item_creator = xml2::xml_text(xml2::xml_find_first(site, "dc:creator")),
      item_date_published = xml2::xml_text(xml2::xml_find_first(site, "pubDate")) %>%
        lubridate::parse_date_time(orders = formats),
      item_category1 = xml2::xml_text(xml2::xml_find_first(site, "category[1]")),
      item_category2 = xml2::xml_text(xml2::xml_find_first(site, "category[2]")),
      item_category3 = xml2::xml_text(xml2::xml_find_first(site, "category[3]")),
      item_category4 = xml2::xml_text(xml2::xml_find_first(site, "category[4]")),
      item_category5 = xml2::xml_text(xml2::xml_find_first(site, "category[5]")),
      item_link = xml2::xml_text(xml2::xml_find_first(site, "link"))
    )})

      suppressWarnings(
        res$feed_update_period[is.na(res$feed_update_period)] <- xml2::xml_text(
          xml2::xml_find_first(channel, "sy:updatePeriod"))
      )
      suppressWarnings(
        res$feed_title[is.na(res$feed_title)] <- xml2::xml_text(
          xml2::xml_find_first(channel, "title"))
      )

      res <- Filter(function(x) !all(is.na(x)), res)

      return(res)
    }
}
