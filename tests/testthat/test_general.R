test_that("Checks on feeds work correctly", {
  fee <- "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson"
  expect_error(
    tidyfeed(c("one feed", "another feed")),
    "Please supply only one feed at a time."
    )
  expect_error(
    tidyfeed("a feed", config = 1),
    "`config` should be a list only."
  )
  expect_error(
    tidyfeed("a feed", list = "hello"),
    "`list` may be FALSE or TRUE only."
  )
  expect_error(
    tidyfeed("a feed", clean_tags = "hello"),
    "`clean_tags` may be FALSE or TRUE only."
  )
  expect_error(
    tidyfeed("hello"),
    "Error in curl::curl_fetch_memory"
  )
  expect_error(
    tidyfeed("feed", parse_dates = "hey there!"),
    "`parse_dates` may be FALSE or TRUE only."
  )
})
# parsing
test_that("Atom responses are parsed", {
  result <- atom_parse("atomresponse.txt", list = FALSE, clean_tags = TRUE,
                       parse_dates = TRUE)
  expect_s3_class(result, "tbl_df")
})
test_that("RSS responses are parsed", {
  result <- rss_parse("rssresponse.txt", list = FALSE, clean_tags = TRUE,
                      parse_dates = TRUE)
  expect_s3_class(result, "tbl_df")
})
# JSON doesn't work the same way
with_mock_api({
  test_that("JSON responses are parsed", {
    result <- json_parse(
      GET("https://daringfireball.net/feeds/json"),
      list = FALSE, clean_tags = TRUE,
      parse_dates = TRUE
    )
    expect_s3_class(result, "tbl_df")
  })
})
# date parser
test_that("data_parser works correctly", {
  df <- tibble(
    column_date = c("2012-01-01 12:00:00", "2012-02-01 11:00:00"),
    column_no_date = c("hello", "there")
  )
  datecheck <- date_parser(df, column_date) %>%
    pull(column_date) %>% class() %>% .[[1]]
  no_date <- date_parser(df, column_no_date) %>%
    select(column_no_date) %>% pull() %>%
    unique() %>%
    is.na()

  expect_equal(datecheck, "POSIXct")
  expect_equal(no_date, TRUE)
})
# type check
with_mock_api({
  expect_equal(
    type_check(GET("http://xkcd.com/rss.xml")),
    "rss"
  )
})

test_that("df is cleaned properly", {
  df <- tibble(
    one = c("a", "b", "c"),
    two = list(a = "a", b = "b", c = "c"),
    three = NA,
    four = "",
    five = list(c("", "", "")),
    six = c(NA, "hey", NA)
  )
  df_cleaned <- df %>% select(one, two, five, six)
  expect_equal(
    names(df_cleaned),
    names(clean_up(df, "rss", clean_tags = TRUE, parse_dates = TRUE))
    )
  ## check dplyr warning message no longer printed
  expect_silent(clean_up(df, "rss", clean_tags = TRUE, parse_dates = TRUE))
})

test_that("dates are only parsed when they should be", {
  df <- tibble(
    feed_pub_date = "2020-01-01",
    item_date_published = "2020-01-01",
    entry_published = "2020-01-01",
    b = "hello"
  )
  df_dates <- clean_up(df, "rss", clean_tags = FALSE, parse_dates = TRUE)
  df_dates_a <- clean_up(df, "atom", clean_tags = FALSE, parse_dates = TRUE)
  df_dates_j <- clean_up(df, "json", clean_tags = FALSE, parse_dates = TRUE)
  df_no_dates <- clean_up(df, "rss", clean_tags = FALSE, parse_dates = FALSE)
  expect_equal(class(df_dates$feed_pub_date)[[1]], "POSIXct")
  expect_equal(class(df_dates_a$entry_published)[[1]], "POSIXct")
  expect_equal(class(df_dates_j$item_date_published)[[1]], "POSIXct")
  expect_equal(class(df_no_dates$feed_pub_date), "character")
  expect_equal(class(df_no_dates$entry_published), "character")
  expect_equal(class(df_no_dates$item_date_published), "character")
})

# type check
with_mock_api({
  test_that("type check only allows response objects", {
    expect_equal(
      type_check(GET("http://journal.r-project.org/rss.atom")),
      "atom")
    expect_error(type_check("hello"),
                   "`type_check` cannot evaluate this response.")
  })
})
# HTTP GET return status
with_mock_api({
  test_that("safe_get checks for status", {
    expect_error(
      safe_get("https://www.robertmylesmcdonnell.com/hello"),
      'Attempt to get feed was unsuccessful (non-200 response). Feed may not be available.',
      fixed = TRUE
    )
    expect_message(
      safe_get("http://journal.r-project.org/rss.atom"),
      "GET request successful. Parsing...\n"
    )
  })
})
# geo check
with_mock_api({
  test_that("Geo checks work correctly", {
    x <- GET("https://rweekly.org/atom.xml") %>% read_xml()
    y <- GET("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.atom") %>%
      read_xml()
    expect_message(geocheck(x), NA)
    expect_message(geocheck(y),
                   "Parsing feeds with geographic information (geoRSS, geoJSON etc.) is
deprecated in tidyRSS as of version 2.0.0. The geo-fields in this feed will be ignored.
If you would like to fetch this information, try the tidygeoRSS package:
https://github.com/RobertMyles/tidygeoRSS",
                   fixed = TRUE)
  })
})
# cleaning empty list-columns
test_that("delist works as it should", {
  # extract a column of '1' from y
  expect_equal(
    tibble(
      x = 1:5, y = list(1)
    ) %>%
    delist("y"),
    tibble(y = rep(1, times = 5))
  )
  # extract a column of 'NA' from y
  expect_equal(
    tibble(
      x = 1:5, y = list(NA)
    ) %>%
      delist("y"),
    tibble(y = rep(NA, 5))
  )
  # leave y alone
  expect_equal(
    tibble(
      x = 1:5, y = list(c(1, 2, 3))
      ) %>%
      delist("y"),
    tibble(y = rep(list(c(1, 2, 3)), 5))
  )
  # leave y alone pt. 2
  expect_equal(
    tibble(
      x = 1:5, y = list(c(1, "hello", TRUE))
    ) %>%
      delist("y"),
    tibble(y = rep(list(c(1, "hello", TRUE)), 5))
  )
})
