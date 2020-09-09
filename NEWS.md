tidyRSS v2.0.3 (Release date: 06/09/2020)
============
Changes:
- Removed occurrence of warning message related to tidyselect's `where()`.
- Updated list of contributors in DESCRIPTION.


tidyRSS v2.0.2 (Release date: 01/06/2020)
============
Changes:
- Updated package to work with dplyr 1.0.0.

tidyRSS v2.0.1 (Release date: 07/03/2020)
============
Changes:
- More complete testing
- Better checking of 'geo' RSS feeds
- new `parse_dates` argument that allows users to skip parsing of dates.
- bugfix for missing import of dplyr's case_when

tidyRSS v2.0.0 (Release date: 24/02/2020)
============
Changes:
Removed simple features parsing functionality to a sister package, tidygeoRSS. 
More robust testing strategy, streamlined code and less dependencies.
Removed dataset of rss feeds as I thought it unnecessary.

tidyRSS v1.2.12 (Release date: 01/09/2019)
============
Changes:
Pass default user-agent to httr::GET. This solves 403 errors from certain RSS feeds.

tidyRSS v1.2.11 (Release date: 22/05/2019)
============
Changes:
Bug (typo) introduced in v1.2.10, which produced 'Error in eval(lhs, parent, parent) : object 'rss' not found'.
Now fixed. Feeds that are no longer available have been removed from the dataset included. Better handling of list-columns for rss category columns.


tidyRSS v1.2.10 (Release date: 14/05/2019)
============
Changes:
Small bugfix for category columns.

tidyRSS v1.2.9 (Release date: 08/05/2019)
============
Changes:
Added functionality to process dc:date tags in v1 RSS feeds and better handling of item category columns, see https://github.com/luke-a/tidyRSS/commit/c677022996fa971b49ef1a858ae21ca720b56c8e .

tidyRSS v1.2.8 (Release date: 05/03/2019)
============
Changes:
Fix to add proper href links in Atom feeds.

tidyRSS v1.2.7 (Release date: 03/11/2018)
============
Changes:
Small fix to add item descriptions for RSS feeds.

tidyRSS v1.2.6 (Release date: 29/08/2018)
============
Changes:
Fixed an error with feeds parsing as geoRSS when they didn't have the necessary lat/lon columns.

tidyRSS v1.2.5 (Release date: 05/08/2018)
============
Changes:
Removed tests. The tests were based on checking a bunch of RSS feed URLs. Since feeds undergo maintenance, or are taken down etc., the tests were failing randomly.  

tidyRSS v1.2.4 (Release date: 01/06/2018)
============

Changes: 
Added support for geo RSS feeds.

tidyRSS v1.2.3 (Release date: 28/01/2018)
============

Changes: 
Changed tests to avoid failures due to problems outside the package (faulty connections, site maintenance, feeds being taken down).

tidyRSS v1.2.2 (Release date: 7/9/2017)
============

Changes: 
Added preliminary support for jsonfeeds; minor changes to parsing other feeds; minor change to data included with the package. 

tidyRSS v1.2.1 (Release date: 16/6/2017)
============

Changes:
Minor changes to parsing Atom feeds.


tidyRSS v1.2.0 (Release date: 6/6/2017)
============

Changes:

* Re-wrote package: less dependencies, streamlined code, more robust. 

tidyRSS v1.0.1 (Release date: 28/2/2017)
==============

Changes: 

* Fixed certain feeds not parsing (Issue #1)


tidyRSS v1.0.0 (Release date: 24/2/2017)
==============


