# List all available acoustic tag ids

List all available acoustic tag ids

## Usage

``` r
list_acoustic_tag_ids(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD"))
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

## Value

A vector of all unique `acoustic_tag_id` in `acoustic_tag_id.sql`.
