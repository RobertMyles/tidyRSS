
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/RobertMyles/tidyrss.svg?branch=master)](https://travis-ci.org/RobertMyles/tidyrss)

tidyRSS is a package for extracting data from [RSS feeds](https://en.wikipedia.org/wiki/RSS).

It is easy to use as it only has one function, `tidyfeed()`, which takes one argument, the url of the feed. Running this function will return a tidy data frame of the information contained in the feed. If the url is not a feed, it will return an error message.

Included in the package is a simple dataset, a list of feed urls, which you can use to experiment with (they were taken from [here](https://raw.githubusercontent.com/DataWookie/feedeR/master/tests/testthat/test-feeds.txt)).

Installation
------------

At the moment, the package is only available from GitHub and will be submitted to CRAN shortly. It can be installed using the devtools package.

``` r

devtools::install_github("https://github.com/RobertMyles/tidyrss")
```
