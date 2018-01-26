context("simple tests")

test_that("tidyfeed returns an error when it should", {
 expect_error(tidyfeed("hello"))
})


test_that("tidyfeed returns a data_frame", {
  data("feeds")
  rss <- "http://fivethirtyeight.com/all/feed"
  expect_is(tidyfeed(rss), "tbl_df")
})

