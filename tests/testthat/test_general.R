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
  # expect_error(
  #   tidyfeed("hello"),
  #   "Error in curl::curl_fetch_memory"
  # )
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
# test_that("JSON responses are parsed", {
#   result <- json_parse("jsonresponse.json", list = FALSE)
#   expect_s3_class(result, "tbl_df")
# })
