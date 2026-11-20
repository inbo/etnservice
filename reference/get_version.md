# Version information about etnservice

Users of the etn package might (probably will) have a local version of
etnservice. If there are differences between the version deployed on the
API and the version installed locally, this might lead to inconsistent
results when switching between local database queries and queries over
the API. This function returns version information of the installed
version of etnservice, when called over the api, it'll return version
information on the version of etnservice deployed via opencpu.

## Usage

``` r
get_version()
```

## Value

A list with the following elements:

- ls:

  A character vector of the objects in the environment.

- version:

  The version of the etnservice package.

## Examples

``` r
get_version()
#> Error in purrr::map(fn_names, ~get(.x, envir = getNamespace("etnservice"))) %>%     purrr::map(deparse) %>% purrr::set_names(fn_names): could not find function "%>%"
```
