test_that("get_news works", {
  # adding a small time delay to avoid simultaneous posts to the api
  Sys.sleep(1)

  # Get the news
  output_news <- get_news("news.ycombinator.com")

  # What's returned
  expect_is(output_news, "data.frame")

  # adding a small time delay to avoid simultaneous posts to the api
  Sys.sleep(1)

  # numbers return an error
  expect_error(output_news <- get_news(123))

  # adding a small time delay to avoid simultaneous posts to the api
  Sys.sleep(1)

  # url not in database returns error
  expect_error(output_news <- get_news("example.com"))

})

