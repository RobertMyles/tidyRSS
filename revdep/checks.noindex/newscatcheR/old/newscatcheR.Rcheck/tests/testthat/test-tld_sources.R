test_that("tld_sources works", {

  # Get the news
  output_tld_sources <- tld_sources()

  # What's returned
  expect_is(output_tld_sources, "data.frame")

  # Get the news
  output_tld_sources <- tld_sources("de")

  # What's returned
  expect_is(output_tld_sources, "data.frame")

  # Get the news
  expect_error(output_tld_sources <- tld_sources("zzz"))

})

