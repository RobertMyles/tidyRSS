
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/tidyRSS)](https://cran.r-project.org/package=tidyRSS)
[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS)
[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/grand-total/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS)

tidyRSS is a package for extracting data from [RSS
feeds](https://en.wikipedia.org/wiki/RSS), including Atom feeds, JSON
feeds and georss feeds.

It is easy to use as it only has one function, `tidyfeed()`, which takes
two arguments, the url of the feed and a logical flag for whether you
want a geoRSS feed returned as a simple features dataframe or not.
Running this function will return a tidy data frame of the information
contained in the feed. If the url is not an rss or atom feed, it will
return an error message.

Included in the package is a simple dataset, a list of feed urls, which
you can use to experiment with. You can access this with
`data("feeds")`.

## Installation

It can be installed directly from CRAN with:

``` r

install.packages("tidyRSS")
```

The development version can be installed from GitHub with the devtools
package.

``` r

devtools::install_github("robertmyles/tidyrss")
```

## Usage

RSS feeds can be parsed with `tidyfeed()`, and some examples are
included in the “feeds” dataset. Here is an example of using the
package:

``` r
library(tidyRSS)

data("feeds")

# select a feed:
rss <- sample(feeds$feeds, 1)

tidyfeed(rss)
#> # A tibble: 50 x 5
#>    feed_title  feed_link   item_title    item_date_published item_link    
#>    <chr>       <chr>       <chr>         <dttm>              <chr>        
#>  1 Instructab… http://www… All  You Nee… 2018-07-04 10:03:03 http://www.i…
#>  2 Instructab… http://www… Automatic Ra… 2018-07-04 09:35:14 http://www.i…
#>  3 Instructab… http://www… DIY survival… 2018-07-04 09:27:17 http://www.i…
#>  4 Instructab… http://www… Recycled and… 2018-07-04 08:29:32 http://www.i…
#>  5 Instructab… http://www… ESP8266 Temp… 2018-07-04 08:23:55 http://www.i…
#>  6 Instructab… http://www… How to Cool … 2018-07-04 06:58:42 http://www.i…
#>  7 Instructab… http://www… DIY Laundry … 2018-07-04 06:38:56 http://www.i…
#>  8 Instructab… http://www… DIY Li-ion C… 2018-07-04 05:54:44 http://www.i…
#>  9 Instructab… http://www… Aluminum Cas… 2018-07-04 04:55:02 http://www.i…
#> 10 Instructab… http://www… Receipt hold… 2018-07-04 04:44:50 http://www.i…
#> # ... with 40 more rows
```

More information is contained in the vignette: `vignette("tidyrss",
package = "tidyRSS")`.

## Issues

RSS & Atom XML feeds can be finicky things, if you find one that doesn’t
work with `tidyfeed()`, [let me
know](https://github.com/robertmyles/tidyrss/issues). Please include the
url of the feed that you are trying. Pull requests and general feedback
are welcome. Many feeds are malformed. What this means is that, for a
well-formed feed, you’ll get back a tidy data frame with information on
the feed and the individual items (like blog posts, for example),
including content. For malformed feeds, it will be less than this, as
`tidyfeed()` deletes `NA` columns, where the information wasn’t in the
feed in the first place.

## Related

The package is a ‘tidy’ version of two other related packages,
[rss](https://github.com/noahhl/r-does-rss) and
[feedeR](https://github.com/DataWookie/feedeR), both of which return
lists. In comparison to feedeR, tidyRSS returns more information from
the RSS feed (if it exists), and development on rss seems to have
stopped some time ago.

# Other

For an example Shiny app that uses geoRSS, see
[here](https://github.com/RobertMyles/shinyGeoRSS).
