pkgname <- "newscatcheR"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('newscatcheR')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("get_headlines")
### * get_headlines

flush(stderr()); flush(stdout())

### Name: get_headlines
### Title: Get headlines A helper function to get just the headlines of the
###   feed
### Aliases: get_headlines

### ** Examples

#' Sys.sleep(1) # adding a small time delay to avoid simultaneous posts to the API
get_headlines(website = "news.ycombinator.com")



cleanEx()
nameEx("get_news")
### * get_news

flush(stderr()); flush(stdout())

### Name: get_news
### Title: Get news
### Aliases: get_news

### ** Examples

Sys.sleep(1) # adding a small time delay to avoid simultaneous posts to the API
get_news(website = "news.ycombinator.com")



cleanEx()
nameEx("tld_sources")
### * tld_sources

flush(stderr()); flush(stdout())

### Name: tld_sources
### Title: tld_sources A helper function to explore news sources by country
###   (or other TLD)
### Aliases: tld_sources

### ** Examples

tld_sources(tld = "de")



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
