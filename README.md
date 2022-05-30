
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyRSS <a href='https://github.com/RobertMyles/tidyrss/'><img src='man/figures/logo.png' align="right" height="139" /></a>

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/tidyRSS)](https://cran.r-project.org/package=tidyRSS)
[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS)
[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/grand-total/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS)
![R-CMD-check](https://github.com/RobertMyles/tidyRSS/workflows/R-CMD-check/badge.svg)
[![Codecov test
coverage](https://codecov.io/gh/RobertMyles/tidyRSS/branch/master/graph/badge.svg)](https://app.codecov.io/gh/RobertMyles/tidyRSS?branch=master)

tidyRSS is a package for extracting data from [RSS
feeds](https://en.wikipedia.org/wiki/RSS), including Atom feeds and JSON
feeds. For geo-type feeds, see the section on changes in version 2
below, or jump directly to
[tidygeoRSS](https://github.com/RobertMyles/tidygeoRSS), which is
designed for that purpose.

It is easy to use as it only has one function, `tidyfeed()`, which takes
five arguments:

-   the url of the feed;
-   a logical flag for whether you want the feed returned as a tibble or
    a list containing two tibbles;
-   a logical flag for whether you want HTML tags removed from columns
    in the dataframe;
-   a config list that is passed off to
    [`httr::GET()`](https://httr.r-lib.org/reference/config.html);
-   and a `parse_dates` argument, a logical flag, which will attempt to
    parse dates if `TRUE` (see below).

If `parse_dates` is `TRUE`, `tidyfeed()` will attempt to parse dates
using the [anytime](https://github.com/eddelbuettel/anytime) package.
Note that this removes some lower-level control that you may wish to
retain over how dates are parsed. See [this
issue](https://github.com/RobertMyles/tidyRSS/issues/37) for an example.

## Installation

It can be installed directly from [CRAN](https://cran.r-project.org/)
with:

    install.packages("tidyRSS")

The development version can be installed from GitHub with the
[remotes](https://github.com/r-lib/remotes) package:

    remotes::install_github("robertmyles/tidyrss")

## Usage

Here is how you can get the contents of the [R
Journal](https://journal.r-project.org/):

    library(tidyRSS)

    tidyfeed("http://journal.r-project.org/rss.atom")

## Changes in version 2.0.0

The biggest change in version 2 is that tidyRSS no longer attempts to
parse geo-type feeds into [sf](https://github.com/r-spatial/sf/)
tibbles. This functionality has been moved to
[tidygeoRSS](https://github.com/RobertMyles/tidygeoRSS).

## Issues

XML feeds can be finicky things, if you find one that doesn’t work with
`tidyfeed()`, feel free to create an
[issue](https://github.com/robertmyles/tidyrss/issues) with the url of
the feed that you are trying. Pull Requests are welcome if you’d like to
try and fix it yourself. For older RSS feeds, some fields will almost
never be ‘clean’, that is, they will contain things like newlines (`\n`)
or extra quote marks. Cleaning these in a generic way is more or less
impossible so I suggest you use
[stringr](https://github.com/tidyverse/stringr),
[strex](https://rorynolan.github.io/strex/) and/or tools from base R
such as gsub to clean these. This will mainly affect the
`item_description` column of a parsed RSS feed, and will not often
affect Atom feeds (and should never be a problem with JSON).

## Related

There are two other related packages that I’m aware of:

-   [rss](https://github.com/noahhl/r-does-rss)
-   [feedeR](https://github.com/DataWookie/feedeR)

In comparison to feedeR, tidyRSS returns more information from the RSS
feed (if it exists), and development on rss seems to have stopped some
time ago.

# Other

For the schemas used to develop the parsers in this package, see:

-   RSS: <https://validator.w3.org/feed/docs/rss2.html>  
-   Atom: <https://validator.w3.org/feed/docs/atom.html>  
-   JSON: <https://jsonfeed.org/version/1>

I’ve implemented most of the items in the schemas above. The following
are not yet implemented:

**Atom meta info:**

-   contributor, generator, logo, subtitle

**Rss meta info:**

-   cloud
-   image
-   textInput
-   skipHours
-   skipDays
