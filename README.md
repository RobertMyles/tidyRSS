
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/RobertMyles/tidyRSS.svg?branch=master)](https://travis-ci.org/RobertMyles/tidyRSS) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/tidyRSS)](https://cran.r-project.org/package=tidyRSS) [![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS) [![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/grand-total/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS)

tidyRSS is a package for extracting data from [RSS feeds](https://en.wikipedia.org/wiki/RSS). As of version 1.2.2, it provides preliminary support for jsonfeeds.

It is easy to use as it only has one function, `tidyfeed()`, which takes one argument, the url of the feed. Running this function will return a tidy data frame of the information contained in the feed. If the url is not an rss or atom feed, it will return an error message.

Included in the package is a simple dataset, a list of feed urls, which you can use to experiment with. You can access this with `data("feeds")`.

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
rss <- sample(feeds$feeds, 1)

tidyfeed(rss)
#> # A tibble: 410 x 11
#>                      feed_title                      feed_link
#>                           <chr>                          <chr>
#>  1 remote jobs - Stack Overflow https://stackoverflow.com/jobs
#>  2 remote jobs - Stack Overflow https://stackoverflow.com/jobs
#>  3 remote jobs - Stack Overflow https://stackoverflow.com/jobs
#>  4 remote jobs - Stack Overflow https://stackoverflow.com/jobs
#>  5 remote jobs - Stack Overflow https://stackoverflow.com/jobs
#>  6 remote jobs - Stack Overflow https://stackoverflow.com/jobs
#>  7 remote jobs - Stack Overflow https://stackoverflow.com/jobs
#>  8 remote jobs - Stack Overflow https://stackoverflow.com/jobs
#>  9 remote jobs - Stack Overflow https://stackoverflow.com/jobs
#> 10 remote jobs - Stack Overflow https://stackoverflow.com/jobs
#> # ... with 400 more rows, and 9 more variables: feed_description <chr>,
#> #   item_title <chr>, item_date_published <dttm>, item_category1 <chr>,
#> #   item_category2 <chr>, item_category3 <chr>, item_category4 <chr>,
#> #   item_category5 <chr>, item_link <chr>
```

More information is contained in the vignette: `vignette("tidyrss", package = "tidyRSS")`.

Issues
------

RSS & Atom XML feeds can be finicky things, if you find one that doesn't work with `tidyfeed()`, [let me know](https://github.com/robertmyles/tidyrss/issues). Please include the url of the feed that you are trying. Pull requests and general feedback are welcome. Many feeds are malformed. What this means is that, for a well-formed feed, you'll get back a tidy data frame with information on the feed and the individual items (like blog posts, for example), including content. For malformed feeds, it will be less than this, as `tidyfeed()` deletes `NA` columns, where the information wasn't in the feed in the first place. If you find problems with jsonfeeds, please let me know, since I'm still experimenting with this format.

Related
-------

The package is a 'tidy' version of two other related fantastic little packages, [rss](https://github.com/noahhl/r-does-rss) and [feedeR](https://github.com/DataWookie/feedeR), both of which return lists. In comparison to feedeR, tidyRSS returns more information from the RSS feed (if it exists), and development on rss seems to have stopped some time ago. Both packages were influences for tidyRSS.
