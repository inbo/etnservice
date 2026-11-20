# Check if the provided credentials are valid.

This function checks if the provided credentials contain a "username"
and "password" field, and if both fields are of type character. It also
verifies that the credentials object has a length of 2.

## Usage

``` r
check_credentials(credentials)
```

## Arguments

- credentials:

  A list or data frame containing the credentials to be checked.

## Value

TRUE if the credentials are valid, an error otherwise

## Examples

``` r
if (FALSE) { # \dontrun{
credentials <- list(username = "john_doe", password = "password123")
check_credentials(credentials)
#> [1] TRUE
} # }
```
