# newscatcheR

<details>

* Version: 0.0.1
* Source code: https://github.com/cran/newscatcheR
* Date/Publication: 2020-05-29 10:50:02 UTC
* Number of recursive dependencies: 57

Run `revdep_details(,"newscatcheR")` for more info

</details>

## Newly broken

*   checking whether package ‘newscatcheR’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/Users/f64k1s8/Documents/Other/tidyRSS/revdep/checks.noindex/newscatcheR/new/newscatcheR.Rcheck/00install.out’ for details.
    ```

## Newly fixed

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 1 marked UTF-8 string
    ```

## Installation

### Devel

```
* installing *source* package ‘newscatcheR’ ...
** package ‘newscatcheR’ successfully unpacked and MD5 sums checked
** using staged installation
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
Error in loadNamespace(j <- i[[1L]], c(lib.loc, .libPaths()), versionCheck = vI[[j]]) : 
  namespace ‘dplyr’ 0.8.5 is being loaded, but >= 1.0.0 is required
Calls: <Anonymous> ... namespaceImportFrom -> asNamespace -> loadNamespace
Execution halted
ERROR: lazy loading failed for package ‘newscatcheR’
* removing ‘/Users/f64k1s8/Documents/Other/tidyRSS/revdep/checks.noindex/newscatcheR/new/newscatcheR.Rcheck/newscatcheR’

```
### CRAN

```
* installing *source* package ‘newscatcheR’ ...
** package ‘newscatcheR’ successfully unpacked and MD5 sums checked
** using staged installation
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
** building package indices
** installing vignettes
** testing if installed package can be loaded from temporary location
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (newscatcheR)

```
