test_that("get_headlines works", {
  # adding a small time delay to avoid simultaneous posts to the api
  Sys.sleep(1)

  # Get the news
  output_headlines <- get_headlines("news.ycombinator.com")

  # What's returned
  expect_is(output_headlines, "data.frame")
  expect_equal(ncol(output_headlines), 1)

})
