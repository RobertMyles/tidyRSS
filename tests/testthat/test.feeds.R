context("simple tests")

test_that("tidyfeed returns an error when it should", {
 expect_error(tidyfeed("hello"))
})



test_that("tidyfeed returns a data_frame", {
  data("feeds")
  rss <- sample(feeds$feeds, 1)
  expect_is(tidyfeed(rss), "tbl_df")
})

