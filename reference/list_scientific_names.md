# List all available scientific names

List all available scientific names

## Usage

``` r
list_scientific_names(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD"))
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

## Value

A vector of all unique `scientific_name` present in
`common.animal_release`.
