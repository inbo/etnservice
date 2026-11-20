# List all available animal ids

List all available animal ids

## Usage

``` r
list_animal_ids(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD"))
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

## Value

A vector of all unique `id_pk` present in `common.animal_release`.
