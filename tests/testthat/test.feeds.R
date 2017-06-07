

test_that("tidyfeed returns an error when it should", {
 expect_error(tidyfeed("hello"))
})



test_that("tidyfeed returns a data_frame", {
  data("feeds")

  for(i in 1:nrow(feeds)){
    feed <- feeds$feeds[[i]]
    expect_is(tidyfeed(feed), "tbl_df", info = paste(i, feed))
  }
})

