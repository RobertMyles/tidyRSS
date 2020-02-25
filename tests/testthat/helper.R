library(httptest)
library(httr)
library(xml2)
library(dplyr)

# save responses to disk for parse tests
# GET("http://journal.r-project.org/rss.atom", write_disk("tests/testthat/atomresponse.txt"))
# GET("http://xkcd.com/rss.xml", write_disk("tests/testthat/rssresponse.txt"))
# GET("https://daringfireball.net/feeds/json", write_disk("tests/testthat/jsonresponse.txt"))

# from tests/testthat/
# capture_requests({
#   GET("http://www.geonames.org/recent-changes.xml", simplify = TRUE)
#   GET("http://journal.r-project.org/rss.atom", simplify = TRUE)
#   GET("https://daringfireball.net/feeds/json", simplify = TRUE)
#   GET("http://fivethirtyeight.com/all/feed", simplify = TRUE)
#   GET("https://www.r-statistics.com/feed/", simplify = TRUE)
#   GET("http://flowingdata.com/feed/", simplify = TRUE)
#   GET("http://feeds.feedburner.com/SimplyStatistics?format=xml", simplify = TRUE)
#   GET("https://eagereyes.org/feed", simplify = TRUE)
#   GET("http://xkcd.com/rss.xml", simplify = TRUE)
#   GET("http://planet.ubuntu.com/rss20.xml", simplify = TRUE)
#   GET("https://rweekly.org/atom.xml", simplify = TRUE)
# })
