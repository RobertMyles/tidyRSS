# takes a dataframe and feed type (JSON, Atom, RSS) as input and
# returns a dataframe that has been 'cleaned' in the following way:
# - columns that only have NA values are removed;
# - columns that are character vectors of length 0 are removed;
# - dates are parsed into datetime columns
# - HTML tags are removed
# - list-columns of length 1 are unlisted
clean_up <- function(df, type) {
  # unlist list-cols of length 1
  df <- df %>% mutate_if(is.list, delist)
  # remove empty and NA cols
  df <- df %>%
    select_if(no_na) %>%
    select_if(no_empty_char)
  # parse dates & clean HTML
  if (type == "json") {
    df <- date_parser(df, item_date_published)
    df <- date_parser(df, item_date_modified)
    if (has_name(df, "item_content_html")) {
      df <- df %>%
        mutate(item_content_html = cleanFun(item_content_html))
    }
  } else if (type == "rss") {
    df <- date_parser(df, feed_pub_date)
    df <- date_parser(df, feed_last_build_date)
    df <- date_parser(df, item_pub_date)
    if (has_name(df, "item_description")) {
      df$item_description <- cleanFun(df$item_description)
    }
  } else if (type == "atom") {
    df <- date_parser(df, feed_last_updated)
    df <- date_parser(df, entry_published)
  }
  df
}
