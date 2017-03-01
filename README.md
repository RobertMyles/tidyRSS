
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/RobertMyles/tidyRSS.svg?branch=master)](https://travis-ci.org/RobertMyles/tidyRSS) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/tidyRSS)](https://cran.r-project.org/package=tidyRSS) [![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS) [![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/grand-total/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS)

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
#> # A tibble: 20 × 6
#>                                                               item_title
#>                                                                    <chr>
#> 1  Kevin Durant’s Injury Is Exactly Why The Warriors Needed Kevin Durant
#> 2                                Russell Westbrook Can’t Stop Going Left
#> 3                                                The Earth In A Suitcase
#> 4                                   When Did Sports Become So Political?
#> 5                         Significant Digits For Wednesday, Mar. 1, 2017
#> 6                         Trump’s Speech Was Quiet — And Quietly Radical
#> 7                    What Went Down At Trump’s First Address To Congress
#> 8                        Firing Claudio Ranieri Won’t Fix Leicester City
#> 9                      We’re Looking For A Part-Time Quantitative Editor
#> 10       How Frank Vogel Is Making Terrence Ross Feel At Home In Orlando
#> 11           How A Weakened Mexican Economy Could Threaten U.S. Security
#> 12                         Significant Digits For Tuesday, Feb. 28, 2017
#> 13      How Trump’s Start-Of-Term Strategy Differs From Past Presidents’
#> 14                  Politics Podcast: Where Do The Parties Go From Here?
#> 15                       Why You Shouldn’t Always Trust The Inside Scoop
#> 16                        Will Buyout Season Help The Cavs And Warriors?
#> 17               Kemba Walker Doesn’t Care How Close You’re Guarding Him
#> 18               All We Really Need To Get To Mars Is A Boatload Of Cash
#> 19                       Oscars Night Was Predictable Until The Very End
#> 20                          Significant Digits For Monday, Feb. 27, 2017
#> # ... with 5 more variables: item_date <dttm>, item_link <chr>,
#> #   creator <chr>, head_title <chr>, head_link <chr>
```

More information is contained in the vignette: `vignette("tidyrss", package = "tidyRSS")`. For common feed types, tidyRSS should be fast. For some feeds, there can be a slight delay because `tidyfeed()` is testing different ways of parsing the feed.

Issues
------

RSS feeds can be finicky things, if you find one that doesn't work with `tidyfeed()`, [let me know](https://github.com/robertmyles/tidyrss/issues). Please include the url of the feed that you are trying. Pull requests and general feedback are welcome.

Related
-------

The package is a 'tidy' version of two other related fantastic little packages, [rss](https://github.com/noahhl/r-does-rss) and [feedeR](https://github.com/DataWookie/feedeR), both of which return lists. In comparison to feedeR, tidyRSS returns more information from the RSS feed (if it exists), and development on rss seems to have stopped some time ago. Both packages were influences for tidyRSS.
