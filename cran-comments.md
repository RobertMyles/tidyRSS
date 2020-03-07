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
