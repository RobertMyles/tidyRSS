
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/tidyRSS)](https://cran.r-project.org/package=tidyRSS)
[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS)
[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/grand-total/tidyRSS)](https://CRAN.R-project.org/package=tidyRSS)

tidyRSS is a package for extracting data from [RSS
feeds](https://en.wikipedia.org/wiki/RSS), including Atom feeds, JSON
feeds and geo-rss feeds.

It is easy to use as it only has one function, `tidyfeed()`, which takes
three arguments, the url of the feed, a logical flag for whether you
want a geoRSS feed returned as a simple features dataframe or not, and a
config list that is passed off to `httr::GET()`. Running this function
will return a tidy data frame of the information contained in the feed.
If the url is not an rss, json or atom feed, it will return an error
message.

Included in the package is a simple dataset, a list of feed urls, which
you can use to experiment with. You can access this with
`data("feeds")`.

## Installation

It can be installed directly from CRAN with:

``` r
install.packages("tidyRSS")
```

The development version can be installed from GitHub with the remotes
package.

``` r
remotes::install_github("robertmyles/tidyrss")
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
#> # A tibble: 50 x 12
#>    feed_title feed_link feed_description feed_last_updated   feed_language
#>    <chr>      <chr>     <chr>            <dttm>              <chr>        
#>  1 Statistic… https://… ""               2019-09-06 14:23:58 en-US        
#>  2 Statistic… https://… ""               2019-09-06 14:23:58 en-US        
#>  3 Statistic… https://… ""               2019-09-06 14:23:58 en-US        
#>  4 Statistic… https://… ""               2019-09-06 14:23:58 en-US        
#>  5 Statistic… https://… ""               2019-09-06 14:23:58 en-US        
#>  6 Statistic… https://… ""               2019-09-06 14:23:58 en-US        
#>  7 Statistic… https://… ""               2019-09-06 14:23:58 en-US        
#>  8 Statistic… https://… ""               2019-09-06 14:23:58 en-US        
#>  9 Statistic… https://… ""               2019-09-06 14:23:58 en-US        
#> 10 Statistic… https://… ""               2019-09-06 14:23:58 en-US        
#> # … with 40 more rows, and 7 more variables: feed_update_period <chr>,
#> #   item_title <chr>, item_creator <chr>, item_date_published <dttm>,
#> #   item_description <chr>, item_link <chr>, item_categories <list>
```

More information is contained in the vignette: `vignette("tidyrss",
package = "tidyRSS")`.

## Issues

RSS & Atom XML feeds can be finicky things, if you find one that doesn’t
work with `tidyfeed()`, [let me
know](https://github.com/robertmyles/tidyrss/issues). Please include the
url of the feed that you are trying. Pull requests and general feedback
are welcome.  
Many feeds are malformed. What this means is that, for a well-formed
feed, you’ll get back a tidy data frame with information on the feed and
the individual items (like blog posts, for example), including content.
For malformed feeds, it will be less than this, as `tidyfeed()` deletes
`NA` columns, where the information wasn’t in the feed in the first
place. You might often find that most information comes back, but that
some columns are not ‘clean’ – this happens particularly with older
feeds and the ‘description’ or ‘content’ fields. These will require that
you do a bit of further string cleaning after using tidyRSS. Here’s an
example of what I’m talkin
’bout:

``` r
tidyfeed("http://feeds.feedburner.com/SalaryTrendsAndReportsDiscussions-Analyticbridge?format=xml")$item_content[[1]]
#> [1] "\n                            <p>Very interesting data compiled and analyzed by O'Reilly, using statistical models such as Lasso regression to predict salary based on different factors. It reminds me <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/comparing-linear-regression-with-the-jackknife-method\" target=\"_blank\">our own analysis based on simulated (but realistic) data</a>, to assess whether having Python or R (or both) commands a bigger salary, and what is the extra boost provided by these skills, individually. The statistical model used was Jackknife regression, and it was designed for tutorial purposes.</p>\n<p>The O'Reilly survey is much bigger, based on real data, and it includes many factors, as well as factor selection. It uses standard statistical techniques which might be less robust than Jackknife regression. Below is the highlight - a formula to estimate your salary. They tried different models, and use R^2 for model selection. I would recommend <a rel=\"nofollow\" href=\"http://www.analyticbridge.com/profiles/blogs/correlation-and-r-squared-for-big-data\" target=\"_blank\">using an L^1 metric</a> instead of R^2, which is more robust.</p>\n<p>All in all, a great analysis with numerous useful charts. <a rel=\"nofollow\" href=\"https://www.oreilly.com/ideas/2015-data-science-salary-survey\" target=\"_blank\">You can download the survey here</a>.</p>\n<p></p>\n<p><strong>One of O'Reillys statistical (regression-like) models</strong> for salary prediction:</p>\n<p>For instance, start with a $30,572 base salary. Add $13,950 if you are 28 years old (though this variable should be capped, you don't earn more at 58 than you do at 53, I think -- but I could be wrong). Add $13,200 if you are in California. Add $9,747 if you know Spark. And so on. Note that in our simulated data, the boosts provided by each skill were not additive. Beyond 3-4 skills, there was no more boost, indeed I believe the number of skills was a component of the model, capped at 3, if I remember correctly. </p>\n<p><span class=\"font-size-2\">30572 intercept</span><br/><span class=\"font-size-2\">+1395 age (per year of age above 18)</span><br/><span class=\"font-size-2\">+5911 bargaining skills (times 1 for “poor” skills to 5 for “excellent” skills)</span><br/><span class=\"font-size-2\">+382 work_week (times # hours in week)</span><br/><span class=\"font-size-2\">-2007 gender=Female</span><br/><span class=\"font-size-2\">+1759 industry=Software (incl. security, cloud services)</span><br/><span class=\"font-size-2\">-891 industry=Retail / E-Commerce</span><br/><span class=\"font-size-2\">-6336 industry=Education</span><br/><span class=\"font-size-2\">+718 company size: 2500+</span><br/><span class=\"font-size-2\">-448 company size: &lt;500</span><br/><span class=\"font-size-2\">+8606 PhD</span><br/><span class=\"font-size-2\">+851 master’s degree (but no PhD)</span><br/><span class=\"font-size-2\">+13200 California</span><br/><span class=\"font-size-2\">+10097 Northeast US</span><br/><span class=\"font-size-2\">-3695 UK/Ireland</span><br/><span class=\"font-size-2\">-18353 Europe (except UK/I)</span><br/><span class=\"font-size-2\">-23140 Latin America</span><br/><span class=\"font-size-2\">-30139 Asia</span><br/><span class=\"font-size-2\">+7819 Meetings: 1 - 3 hours / day</span><br/><span class=\"font-size-2\">+9036 Meetings: 4+ hours / day</span><br/><span class=\"font-size-2\">+2679 Basic exploratory data analysis: 1 - 4 hours / week</span><br/><span class=\"font-size-2\">-4615 Basic exploratory data analysis: 4+ hours / day</span><br/><span class=\"font-size-2\">+352 Data cleaning::1 - 4 hrs / week</span><br/><span class=\"font-size-2\">+2287 cloud computing amount: Most or all cloud computing</span><br/><span class=\"font-size-2\">-2710 cloud computing amount: Not using cloud computing</span><br/><span class=\"font-size-2\">+9747 Spark</span><br/><span class=\"font-size-2\">+6758 D3</span><br/><span class=\"font-size-2\">+4878 Amazon Elastic MapReduce (EMR)</span><br/><span class=\"font-size-2\">+3371 Scala</span><br/><span class=\"font-size-2\">+2309 C++</span><br/><span class=\"font-size-2\">+1173 Teradata</span><br/><span class=\"font-size-2\">+625 Hive</span><br/><span class=\"font-size-2\">-1931 Visual Basic/VBA</span><br/><span class=\"font-size-2\">+31280 level: Principal</span><br/><span class=\"font-size-2\">+15642 title: Architect</span><br/><span class=\"font-size-2\">+3340 title: Data Scientist</span><br/><span class=\"font-size-2\">+2819 title: Engineer</span><br/><span class=\"font-size-2\">-3272 title: Developer</span><br/><span class=\"font-size-2\">-4566 title: Analyst</span></p>\n<p>It would be nice to create an interactive Excel spreadsheet, or a web form (maybe in JavaScript) to compute expected salary given your particular feature vector. Also, checking whether this data is consistent with other sources such as Indeed.com, Payscale.com or Glassdoor.com (these sources also offer some level of granularity, although limited). Better, blend these data sets together: survey data is not good at catching outliers (people who don't have time filling surveys, and who might be executives with a high salary, or people not speaking English) so we might get a better picture for extreme salaries.</p>\n<p><span>.</span></p>\n<p><strong>Here's one of the numerous charts found in the report</strong>:</p>\n<p><a href=\"http://storage.ning.com/topology/rest/1.0/file/get/2059722023?profile=original\" target=\"_self\"><img src=\"http://storage.ning.com/topology/rest/1.0/file/get/2059722023?profile=original\" width=\"685\" class=\"align-center\"/></a></p>\n<p></p>\n<p><strong>And the table of content</strong>:</p>\n<p>Introduction ....................................................................................2<br/>How You Spend Your Time.............................................................13<br/>Tools versus Tools ..........................................................................21<br/>Tools and Salary: A More Complete Model ......................................30<br/>Integrating Job Titles into Our Final Model .......................................33<br/>Finding a New Position...................................................................38<br/>Wrapping Up.................................................................................39</p>\n<p><a rel=\"nofollow\" href=\"https://www.oreilly.com/ideas/2015-data-science-salary-survey\" target=\"_blank\">Download full report here</a>.</p>\n<p></p>\n<p><strong><span class=\"font-size-4\">DSC Resources</span></strong></p>\n<ul>\n<li>Career: <a rel=\"nofollow\" href=\"http://www.analyticbridge.com/group/analyticscourses/forum\">Training</a> | <a rel=\"nofollow\" href=\"http://www.analyticbridge.com/group/books/forum\">Books</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/data-science-cheat-sheet\">Cheat Sheet</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/group/data-science-apprenticeship/forum/topics/our-data-science-apprenticeship-is-now-live\">Apprenticeship</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/group/data-science-certification\">Certification</a> | <a rel=\"nofollow\" href=\"http://www.analyticbridge.com/group/salary-trends-and-reports/forum\">Salary Surveys</a> | <a rel=\"nofollow\" href=\"http://careers.analytictalent.com/jobs/search/results\">Jobs</a></li>\n<li>Knowledge: <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/group/resources/forum\">Research</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/group/resources/forum/topics/best-kept-secret-about-data-science-competitions\">Competitions</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/video/video/listFeatured\">Webinars</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/my-data-science-book\">Our Book</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/page/member\">Members Only</a> | <a rel=\"nofollow\" href=\"https://www.google.com/cse/publicurl?cx=007889287169707156432:04zouenp6u0\">Search DSC</a></li>\n<li>Buzz: <a rel=\"nofollow\" href=\"http://www.bigdatanews.com/group/bdn-daily-press-releases\">Business News</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/group/announcements/forum\">Announcements</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/events/\">Events</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/page/news-feeds\">RSS Feeds</a></li>\n<li>Misc: <a rel=\"nofollow\" href=\"http://www.analyticbridge.com/page/links\">Top Links</a> | <a rel=\"nofollow\" href=\"http://www.analyticbridge.com/group/codesnippets\">Code Snippets</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/group/resources/forum/topics/comprehensive-list-of-data-science-resources\">External Resources</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/group/resources/forum/topics/the-best-of-our-weekly-digests\">Best Blogs</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/check-out-our-dsc-newsletter\">Subscribe</a> | <a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/group/resources/forum/topics/free-stuff-for-data-science-publishers-authors-bloggers-professor\">For Bloggers</a></li>\n</ul>\n<p><b>Additional Reading</b></p>\n<ul>\n<li><a rel=\"nofollow\" href=\"http://www.hadoop360.com/blog/50-articles-about-hadoop-and-related-topics\">50 Articles about Hadoop and Related Topics</a></li>\n<li><a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/10-modern-statistical-concepts-discovered-by-data-scientists\">10 Modern Statistical Concepts Discovered by Data Scientists</a></li>\n<li><a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/forum/topics/most-popular-data-science-keywords-on-dsc\">Top data science keywords on DSC</a></li>\n<li><a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/4-easy-steps-to-becoming-a-data-scientist\">4 easy steps to becoming a data scientist</a></li>\n<li><a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/13-new-trends-in-big-data-and-data-science\">13 New Trends in Big Data and Data Science</a></li>\n<li><a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/22-tips-for-better-data-science\">22 tips for better data science</a></li>\n<li><a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/17-analytic-disciplines-compared\">Data Science Compared to 16 Analytic Disciplines</a></li>\n<li><a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/tutorial-how-to-detect-spurious-correlations-and-how-to-find-the-\">How to detect spurious correlations, and how to find the real ones</a></li>\n<li><a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/17-short-tutorials-all-data-scientists-should-read-and-practice\">17 short tutorials all data scientists should read (and practice)</a></li>\n<li><a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/six-categories-of-data-scientists\">10 types of data scientists</a></li>\n<li><a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/66-job-interview-questions-for-data-scientists\">66 job interview questions for data scientists</a></li>\n<li><a rel=\"nofollow\" href=\"http://www.datasciencecentral.com/profiles/blogs/high-level-versus-low-level-data-science\">High versus low-level data science</a></li>\n</ul>\n<p><span>Follow us on Twitter: </span><a rel=\"nofollow\" href=\"http://www.twitter.com/datasciencectrl\">@DataScienceCtrl</a><span> | </span><a rel=\"nofollow\" href=\"http://www.twitter.com/analyticbridge\">@AnalyticBridge</a></p>                        "
```

Best of luck cleaning that up.

Including geo-rss feeds in this package has been a bit of ongoing issue
for me, as it brings a whole host of new dependencies into the package
that I know some users didn’t want. I may extract it out into a ‘sfRSS’
package in the future.

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
