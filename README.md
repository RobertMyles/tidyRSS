
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/tidyRSS)](https://cran.r-project.org/package=tidyRSS)
[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS)
[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/grand-total/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS)

tidyRSS is a package for extracting data from [RSS
feeds](https://en.wikipedia.org/wiki/RSS), including Atom feeds, JSON
feeds and georss feeds.

**Note: some users may experience problems with v1.2.10 – use the
development version (1.2.11)**.

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
#library(tidyRSS)
devtools::load_all()
data("feeds")

# select a feed:
rss <- sample(feeds$feeds, 1)

tidyfeed(rss)
#> # A tibble: 20 x 12
#>    feed_title feed_link feed_description feed_last_updated   feed_language
#>    <chr>      <chr>     <chr>            <dttm>              <chr>        
#>  1 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#>  2 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#>  3 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#>  4 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#>  5 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#>  6 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#>  7 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#>  8 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#>  9 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#> 10 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#> 11 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#> 12 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#> 13 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#> 14 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#> 15 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#> 16 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#> 17 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#> 18 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#> 19 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#> 20 FiveThirt… https://… Nate Silver’s F… 2019-05-15 23:22:44 en-US        
#> # … with 7 more variables: feed_update_period <chr>, item_title <chr>,
#> #   item_creator <chr>, item_date_published <dttm>,
#> #   item_description <chr>, item_link <chr>, item_categories <list>
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
