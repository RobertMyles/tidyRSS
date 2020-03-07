# takes a dataframe and feed type (JSON, Atom, RSS) as input and
# returns a dataframe that has been 'cleaned' in the following way:
# - columns that only have NA values are removed;
# - columns that are character vectors of length 0 are removed;
# - dates are parsed into datetime columns
# - HTML tags are removed
# - list-columns of length 1 are unlisted
clean_up <- function(df, type, clean_tags, parse_dates) {
  # unlist list-cols of length 1
  df <- df %>% mutate_if(is.list, delist)
  # remove empty and NA cols
  df <- df %>%
    map_df(~ {ifelse(is.character(.x) & nchar(.x) == 0, NA_character_, .x)}) %>%
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
    }
    if (isTRUE(clean_tags)) {
      if (has_name(df, "entry_summary")) {
        df$entry_summary <- cleanFun(df$entry_summary)
      }
      if (has_name(df, "entry_content")) {
        df$entry_content <- cleanFun(df$entry_content)
      }
    }
  }
  df
}
