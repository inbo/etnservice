# List all available receiver ids

List all available receiver ids

## Usage

``` r
list_receiver_ids(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD"))
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

## Value

A vector of all unique `receiver` present in `acoustic.receivers`.
