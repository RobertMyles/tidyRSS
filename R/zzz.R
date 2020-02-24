# nocov start
.onLoad <- function(libname = find.package("tidyRSS"), pkgname = "tidyRSS") {
  # CRAN Note avoidance
  if (getRversion() >= "2.15.1") {
    utils::globalVariables(c(
      ".", "feed_description", "feed_last_updated",
      "feed_link", "feed_title", "item_category1", "item_category2",
      "item_category3", "item_category4", "item_category5", "item_creator",
      "item_date_published", "item_link", "item_title", "feed_update_period",
      "date_modified", "date_published", "temp",
      ":=", "bind_cols", "case_when", "entry_published",
      "feed_last_build_date",
      "feed_pub_date", "item_content_html", "item_date_modified", "item_pub_date",
      "xml_contents"
    ))
  }
  invisible()
}
# nocov end
