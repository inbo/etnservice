# List all available station names

List all available station names

## Usage

``` r
list_station_names(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD"))
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

## Value

A vector of all unique `station_name` present in `acoustic.deployments`.
