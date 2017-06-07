
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/RobertMyles/tidyRSS.svg?branch=master)](https://travis-ci.org/RobertMyles/tidyRSS) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/tidyRSS)](https://cran.r-project.org/package=tidyRSS) [![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS) [![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/grand-total/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS)

tidyRSS is a package for extracting data from [RSS feeds](https://en.wikipedia.org/wiki/RSS).

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
#> # A tibble: 10 x 4
#>                                                                       item_url
#>                                                                          <chr>
#>  1           http://datamining.typepad.com/data_mining/2016/03/ais-not-ai.html
#>  2 http://datamining.typepad.com/data_mining/2015/10/agile-web-mining-at-bing.
#>  3 http://datamining.typepad.com/data_mining/2015/05/the-economist-gets-in-on-
#>  4 http://datamining.typepad.com/data_mining/2015/05/ai-artificial-birds-and-a
#>  5 http://datamining.typepad.com/data_mining/2015/05/how-to-understand-compute
#>  6 http://datamining.typepad.com/data_mining/2015/05/how-the-tech-media-keeps-
#>  7 http://datamining.typepad.com/data_mining/2015/05/how-hollywood-keeps-artif
#>  8 http://datamining.typepad.com/data_mining/2015/05/artificial-intelligence-a
#>  9    http://datamining.typepad.com/data_mining/2015/01/stamp-of-approval.html
#> 10 http://datamining.typepad.com/data_mining/2014/09/the-longform-manifesto.ht
#> # ... with 3 more variables: head_title <chr>, head_link <chr>,
#> #   last_updated <dttm>
```

More information is contained in the vignette: `vignette("tidyrss", package = "tidyRSS")`.

Issues
------

RSS feeds can be finicky things, if you find one that doesn't work with `tidyfeed()`, [let me know](https://github.com/robertmyles/tidyrss/issues). Please include the url of the feed that you are trying. Pull requests and general feedback are welcome. Many feeds are malformed. What this means is that, for a well-formed feed, you'll get back a tidy data frame with information on the feed and the individual items (like blog posts, for example), including content. For malformed feeds, it will be less than this, as `tidyfeed()` deletes `NA` columns, where the information wasn't in the feed in the first place.

Related
-------

The package is a 'tidy' version of two other related fantastic little packages, [rss](https://github.com/noahhl/r-does-rss) and [feedeR](https://github.com/DataWookie/feedeR), both of which return lists. In comparison to feedeR, tidyRSS returns more information from the RSS feed (if it exists), and development on rss seems to have stopped some time ago. Both packages were influences for tidyRSS.

### Version 1.2.0

I've completely re-written the main function in this package, streamlining it by reducing the number of dependencies. The use of lists has been left behind for dealing with xml directly, which I think makes the package quicker and much more robust (not to mention much lighter in terms of code). For this little leap, I have the many question-answerers on Stack Overflow and the estimable [Guilherme Jardim Duarte](https://github.com/duarteguilherme) to thank, not to mention [hrbrmaster](https://github.com/hrbrmstr), who first alerted me to the bloatedness of this little package.
