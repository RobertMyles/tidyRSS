
## Test environments

* local OS X install, R 3.3.2
* ubuntu 12.04 (on travis-ci), R 3.1.2
* win-builder (devel and release)

## R CMD check results
R CMD check results
0 errors | 0 warnings | 1 note
checking top-level files ... NOTE
Non-standard files/directories found at top level:
  ‘cran-comments.md’ ‘pkgname.R’

When I changed the location of 'pkgname.R', the checks gave me errors.

This package is also a first submission.
