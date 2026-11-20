# Get acoustic receiver data

Get data for acoustic receivers, with options to filter results.

## Usage

``` r
get_acoustic_receivers(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD")),
  receiver_id = NULL,
  status = NULL
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

- receiver_id:

  Character (vector). One or more receiver identifiers.

- status:

  Character. One or more statuses, e.g. `available` or `broken`.

## Value

A tibble with acoustic receiver data, sorted by `receiver_id`. See also
[field
definitions](https://inbo.github.io/etn/articles/etn_fields.html).
Values for `owner_organization` will only be visible if you are member
of the group.

## Examples

``` r
# Set credentials
credentials <- list(
   username = Sys.getenv("ETN_USER"),
   password = Sys.getenv("ETN_PWD")
 )

# Get all acoustic receivers
get_acoustic_receivers(credentials)
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get lost and broken acoustic receivers
get_acoustic_receivers(credentials, status = c("lost", "broken"))
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get a specific acoustic receiver
get_acoustic_receivers(credentials, receiver_id = "VR2W-124070")
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.
```
