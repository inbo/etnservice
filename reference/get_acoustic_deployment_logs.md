# Retrieve log files/diagnostic information for deployments of acoustic receivers.

This function retrieves log files and diagnostic information for
deployments of acoustic receivers from the ETN database. The returned
data includes deployment ID, receiver ID, station name, datetime, record
type, and log data in JSON format.

## Usage

``` r
get_acoustic_deployment_logs(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD")),
  deployment_id,
  limit = FALSE
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

- deployment_id:

  Integer (vector). One or more deployment identifiers.

- limit:

  Logical. Limit the number of returned records to 100 (useful for
  testing purposes). Defaults to `FALSE`.

## Value

A tibble with receiver diagnostics data. The data is embedded in a
`log_data` column that is JSON formatted.

## Examples

``` r
get_acoustic_deployment_logs(deployment_id = 6028)
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

get_acoustic_deployment_logs(deployment_id = c(53790, 1758), limit = TRUE)
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.
```
