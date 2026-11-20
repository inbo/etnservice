# Get acoustic deployment data

Get data for deployments of acoustic receivers, with options to filter
results.

## Usage

``` r
get_acoustic_deployments(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD")),
  deployment_id = NULL,
  receiver_id = NULL,
  acoustic_project_code = NULL,
  station_name = NULL,
  open_only = FALSE
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

- deployment_id:

  Integer (vector). One or more deployment identifiers.

- receiver_id:

  Character (vector). One or more receiver identifiers.

- acoustic_project_code:

  Character (vector). One or more acoustic project codes.
  Case-insensitive.

- station_name:

  Character (vector). One or more deployment station names.

- open_only:

  Logical. Restrict deployments to those that are currently open (i.e.
  no end date defined). Defaults to `FALSE`.

## Value

A tibble with acoustic deployment data, sorted by
`acoustic_project_code`, `station_name` and `deploy_date_time`. See also
[field
definitions](https://inbo.github.io/etn/articles/etn_fields.html).

## Examples

``` r
# Set credentials
credentials <- list(
   username = Sys.getenv("ETN_USER"),
   password = Sys.getenv("ETN_PWD")
 )

# Get all acoustic deployments
get_acoustic_deployments(credentials)
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get specific acoustic deployment
get_acoustic_deployments(credentials, deployment_id = 1437)
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get acoustic deployments for a specific receiver
get_acoustic_deployments(credentials, receiver_id = "VR2W-124070")
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get open acoustic deployments for a specific receiver
get_acoustic_deployments(credentials, receiver_id = "VR2W-124070", open_only = TRUE)
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get acoustic deployments for a specific acoustic project
get_acoustic_deployments(credentials, acoustic_project_code = "demer")
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get acoustic deployments for two specific stations
get_acoustic_deployments(credentials, station_name = c("de-9", "de-10"))
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.
```
