
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/RobertMyles/tidyrss.svg?branch=master)](https://travis-ci.org/RobertMyles/tidyrss) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/tidyRSS)](http://cran.r-project.org/package=tidyRSS)

tidyRSS is a package for extracting data from [RSS feeds](https://en.wikipedia.org/wiki/RSS).

It is easy to use as it only has one function, `tidyfeed()`, which takes one argument, the url of the feed. Running this function will return a tidy data frame of the information contained in the feed. If the url is not a feed, it will return an error message.

Included in the package is a simple dataset, a list of feed urls, which you can use to experiment with (they were taken from [here](https://raw.githubusercontent.com/DataWookie/feedeR/master/tests/testthat/test-feeds.txt)).

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

RSS feeds can be parsed with `tidyfeed()`, and some examples are included in the "feeds" dataset. Some of these feeds deliberately give an error (they are not actually feeds). Here is an example of using the package:

``` r
library(tidyRSS)

data("feeds")

# select a random feed:
url <- sample(feeds$feeds, 1)

tidyfeed(url)
#> # A tibble: 25 × 6
#>                                             item_title           item_date
#>                                                  <chr>              <dttm>
#> 1    Econometrics: Angrist and Pischke are at it Again 2017-02-23 12:53:56
#> 2                Predictive Loss vs. Predictive Regret 2017-02-15 13:11:59
#> 3                                  Data for the People 2017-02-15 13:08:58
#> 4             Randomization Tests for Regime Switching 2017-02-15 13:08:12
#> 5                           Bayes Stifling Creativity? 2017-02-15 12:58:21
#> 6      Impulse Responses From Smooth Local Projections 2017-02-15 13:04:45
#> 7                         Math Rendering Problem Fixed 2017-01-13 13:26:34
#> 8            All of Machine Learning in One Expression 2017-02-15 13:01:38
#> 9  Torpedoing Econometric Randomized Controlled Trials 2017-02-15 13:00:43
#> 10                                        Holiday Haze 2016-12-18 13:27:34
#> # ... with 15 more rows, and 4 more variables: item_link <chr>,
#> #   head_title <chr>, head_link <chr>, last_update <chr>
```

More information is contained in the vignette: `vignette("tidyrss", package = "tidyRSS")`.

Issues
------

RSS feeds can be finicky things, if you find one that doesn't work with `tidyfeed()`, [let me know](https://github.com/RobertMyles/tidyrss/issues). Please include the url of the feed that you are trying. Pull requests and general feedback are welcome.

Related
-------

The package is a 'tidy' version of two other related fantastic little packages, [rss](https://github.com/noahhl/r-does-rss) and [feedeR](https://github.com/DataWookie/feedeR), both of which return lists. In comparison to feedeR, tidyRSS returns more information from the RSS feed (if it exists), and develpment on rss seems to have stopped some time ago. Both packages were influences for tidyRSS.
