
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/RobertMyles/tidyRSS.svg?branch=master)](https://travis-ci.org/RobertMyles/tidyRSS) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/tidyRSS)](https://cran.r-project.org/package=tidyRSS)

tidyRSS is a package for extracting data from [RSS feeds](https://en.wikipedia.org/wiki/RSS).

It is easy to use as it only has one function, `tidyfeed()`, which takes one argument, the url of the feed. Running this function will return a tidy data frame of the information contained in the feed. If the url is not a feed, it will return an error message.

Included in the package is a simple dataset, a list of feed urls, which you can use to experiment with (they were taken from [here](https://raw.githubusercontent.com/DataWookie/feedeR/master/tests/testthat/test-feeds.txt)). One (<http://newsrss.bbc.co.uk/rss/newsonline_world_edition/front_page/rss.xml>) returns NULL for most fields, although it is a valid field (and so throws an actual error). So bug reports (and suggestions for fixing them) are very welcome.

Installation
------------

It can be installed directly from CRAN with:

``` r

install.packages("tidyRSS")
```

The development version can be installed from GitHub with the devtools package.

``` r

devtools::install_github("robertmyles/tidyrss")
```

Usage
-----

RSS feeds can be parsed with `tidyfeed()`, and some examples are included in the "feeds" dataset. Here is an example of using the package:

``` r
library(tidyRSS)

data("feeds")

# select a feed:
url <- feeds$feeds[[1]]

tidyfeed(url)
#> 
#> This page does not appear to be a suitable feed.
#> Have you checked that you entered the url correctly?
```

More information is contained in the vignette: `vignette("tidyrss", package = "tidyRSS")`. For common feed types, tidyRSS should be fast. For some feeds, there can be a slight delay because `tidyfeed()` is testing different ways of parsing the feed.

Issues
------

RSS feeds can be finicky things, if you find one that doesn't work with `tidyfeed()`, [let me know](https://github.com/robertmyles/tidyrss/issues). Please include the url of the feed that you are trying. Pull requests and general feedback are welcome.

Related
-------

The package is a 'tidy' version of two other related fantastic little packages, [rss](https://github.com/noahhl/r-does-rss) and [feedeR](https://github.com/DataWookie/feedeR), both of which return lists. In comparison to feedeR, tidyRSS returns more information from the RSS feed (if it exists), and develpment on rss seems to have stopped some time ago. Both packages were influences for tidyRSS.
