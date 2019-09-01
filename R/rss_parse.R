formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
             "Y-m-d H:M:S z", "d b Y H:M:S",
             "d b Y H:M:S z", "a b d H:M:S z Y",
             "a b dH:M:S Y")

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
      xx <- xml_text(xml_find_all(item, "rss:category", ns = ns))
      if(length(xx) < 1){
        return(FALSE)
      } else {
        return(TRUE)
      }
    }

    res <- suppressWarnings({tibble(
      feed_title = xml_text(
        safe_run(safe_xml_find_all(channel, "rss:title", ns = ns))
        ),
      feed_link = xml_text(
        safe_run(safe_xml_find_all(channel, "rss:link", ns = ns))
        ),
      feed_description = xml_text(
        safe_run(safe_xml_find_first(channel, "rss:description", ns = ns))
        ),
      feed_last_updated = xml_text(
        safe_run(safe_xml_find_first(channel, "rss:lastBuildDate", ns = ns))
        ) %>%
        parse_date_time(orders = formats),
      feed_language = xml_text(
        safe_run(safe_xml_find_first(channel, "rss:language", ns = ns))
        ),
      feed_update_period = xml_text(
        safe_run(safe_xml_find_first(channel, "rss:updatePeriod", ns = ns))
        ),
      item_title = xml_text(
        safe_run(safe_xml_find_all(site, "rss:title", ns = ns))
        ),
      item_creator = xml_text(
        safe_run(safe_xml_find_first(site, "rss:creator", ns = ns))
        ),
      item_date_published = xml_text(
        safe_run(safe_xml_find_first(site, "rss:pubDate", ns = ns))
        ) %>%
        parse_date_time(orders = formats),
      item_date = xml_text(
        safe_run(safe_xml_find_first(site, "rss:date", ns = ns))
        ) %>%
        parse_date_time(orders = formats),
      item_subject = xml_text(
        safe_run(safe_xml_find_first(site, ns = ns, "rss:subject"))
        ),
      item_link = xml_text(
        safe_run(safe_xml_find_all(site, "rss:link", ns = ns))
        ),
      item_description = xml_text(
        safe_run(safe_xml_find_first(site, "rss:description", ns = ns))
        )
    )})

    if(categories(site) == TRUE) {
      res$item_categories <- safe_run(
        safe_xml_find_all(site, "rss:category/..", ns = ns)
      )
    }

    res <- Filter(function(x) !all(is.na(x)), res)

  } else{

    site <- xml_find_all(channel, "item")

    res <- suppressWarnings({tibble(
      feed_title = xml_text(
        safe_run(safe_xml_find_first(channel, "id"))
        ),
      feed_link = xml_text(
        safe_run(safe_xml_find_first(channel, "link"))
        ),
      feed_description = xml_text(
        safe_run(safe_xml_find_first(channel, "description"))
        ),
      feed_last_updated = xml_text(
        safe_run(safe_xml_find_first(channel, "lastBuildDate"))
        ) %>%
        parse_date_time(orders = formats),
      feed_language = xml_text(
        safe_run(safe_xml_find_first(channel, "language"))
        ),
      feed_update_period = xml_text(
        safe_run(safe_xml_find_first(channel, "updatePeriod"))
        ),
      item_title = xml_text(
        safe_run(safe_xml_find_first(site, "title"))
        ),
      item_creator = xml_text(
        safe_run(safe_xml_find_first(site, "dc:creator"))
        ),
      item_date_published = xml_text(
        safe_run(safe_xml_find_first(site, "pubDate"))
        ) %>%
        parse_date_time(orders = formats),
      item_description = xml_text(
        safe_run(safe_xml_find_first(site, "description"))
        ),
      item_link = xml_text(
        safe_run(safe_xml_find_first(site, "link"))
      )
    )})

    if(length(xml_find_all(site, "category")) > 0){
      res <- res %>%
        mutate(item_categories = map(site, xml_find_all, "category") %>%
                        map(xml_text))
    }

      suppressWarnings(
        res$feed_update_period[is.na(res$feed_update_period)] <- xml_text(
          safe_run(safe_xml_find_first(channel, "sy:updatePeriod")))
      )
      suppressWarnings(
        res$feed_title[is.na(res$feed_title)] <- xml_text(
          safe_run(safe_xml_find_first(channel, "title"))
          )
      )
      
      res <- Filter(function(x) !all(is.na(x)), res)

      return(res)
    }
}
