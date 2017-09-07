#' @importFrom jsonlite fromJSON
#' @importFrom purrr flatten
#' @importFrom dplyr full_join
formats <- c("a d b Y H:M:S z", "a, d b Y H:M z",
             "Y-m-d H:M:S z", "d b Y H:M:S",
             "d b Y H:M:S z", "a b d H:M:S z Y",
             "a b dH:M:S Y")

json_parse <- function(feed){

  res <- jsonlite::fromJSON(feed)

  items <- res$items
  items$author <- unlist(purrr::flatten(items$author))
  items$feed_title = res$title

  results <- tibble::tibble(
    version = res$version,
    feed_title = res$title,
    home_page_url = res$home_page_url,
    feed_url = res$feed_url,
    feed_author = res$author$name,
    icon = res$icon,
    favicon = res$favicon
  )

  results <- suppressMessages(dplyr::full_join(results, items))

  results <- results %>%
    dplyr::mutate(
      date_published = lubridate::parse_date_time(
        date_published, orders = formats),
      date_modified = lubridate::parse_date_time(
        date_modified, orders = formats)
      )

  return(results)
}

