# takes a dataframe and feed type (JSON, Atom, RSS) as input and
# returns a dataframe that has been 'cleaned' in the following way:
# - columns that only have NA values are removed;
# - columns that are character vectors of length 0 are removed;
# - dates are parsed into datetime columns
# - HTML tags are removed
# - list-columns of length 1 are unlisted
clean_up <- function(df, type, clean_tags, parse_dates) {
  # remove lists of length 1
  dflistcols <- df %>% select_if(is.list)
  if (ncol(dflistcols) > 0) {
    for (i in 1:ncol(dflistcols)) {
      kolnm <- colnames(dflistcols)[i]
      df[, kolnm] <- delist(dflistcols, kolnm)
    }
  }

  # remove empty and NA cols
  df <- df %>%
    mutate(
      across(is.character, ~ {
        ifelse(nchar(.x) == 0, NA_character_, .x)
      })
    ) %>%
    keep(~ {
      !all(is.na(.x))
    })
  # parse dates & clean HTML
  if (type == "json") {
    if (isTRUE(parse_dates)) {
      df <- date_parser(df, item_date_published)
      df <- date_parser(df, item_date_modified)
    }
    if (isTRUE(clean_tags)) {
      if (has_name(df, "item_content_html")) {
        df <- df %>%
          mutate(item_content_html = cleanFun(item_content_html))
      }
    }
  } else if (type == "rss") {
    if (isTRUE(parse_dates)) {
      df <- date_parser(df, feed_pub_date)
      df <- date_parser(df, feed_last_build_date)
      df <- date_parser(df, item_pub_date)
    }
    if (isTRUE(clean_tags)) {
      if (has_name(df, "item_description")) {
        df$item_description <- cleanFun(df$item_description)
      }
    }
  } else if (type == "atom") {
    if (isTRUE(parse_dates)) {
      df <- date_parser(df, feed_last_updated)
      df <- date_parser(df, entry_published)
      if (has_name(df, "entry_last_updated")) {
        df <- date_parser(df, entry_last_updated)
      }
    }
    if (isTRUE(clean_tags)) {
      if (has_name(df, "entry_summary")) {
        df$entry_summary <- cleanFun(df$entry_summary) # nocov
      }
      if (has_name(df, "entry_content")) {
        df$entry_content <- cleanFun(df$entry_content)
      }
    }
  }
  df
}
