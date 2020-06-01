# v2.0.2

Updates tidyRSS to be compatible with dplyr 1.0.0, along with some minor bugfixes and improvements.

## Test environments

* local mac OS install, R 4.0.0
* Ubuntu 16.04 (on GitHub Actions), R-devel, R 4.0.0, R 3.6.3, 3.5.3, R 3.4.4, R 3.3.3
* mac OS 10.15.4 (on GitHub Actions) R-devel, R 3.6.0
* Microsoft Windows Server 2019 10.0.17763 (on GitHub Actions) R 4.0.0
* win-builder (R-devel, R-release)
* Fedora Linux (on R-hub) R-devel
* Ubuntu Linux (on R-hub) R-Release

## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

R CMD check succeeded

# v2.0.1

This fixes a bug a missing function import; creates a new input argument that allows users to leave dates unparsed, fixing another bug with NA in date columns. It also improves code coverage and testing.

# v2.0.0

This version is a rewrite of the package, removing the functionality of parsing feeds into tibbles with geographic simple features columns into a sister package. I've adopted a more stringent testing strategy along with much more streamlined code.
- **Resubmit:** reduced package file size. 

## Test environments
* local OS X install, R 3.6.2
* ubuntu 14.04 (on travis-ci), R 3.6.2
* win-builder (devel and release)

## R CMD check results

0 errors ✓ | 0 warnings ✓ | 0 notes ✓
