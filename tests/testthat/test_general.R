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
})
# parsing
test_that("Atom responses are parsed", {
  result <- atom_parse("atomresponse.txt", list = FALSE)
  expect_s3_class(result, "tbl_df")
})
test_that("RSS responses are parsed", {
  result <- rss_parse("rssresponse.txt", list = FALSE)
  expect_s3_class(result, "tbl_df")
})
# JSON doesn't work the same way
with_mock_api({
  test_that("JSON responses are parsed", {
    result <- json_parse(
      GET("https://daringfireball.net/feeds/json"),
      list = FALSE
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
