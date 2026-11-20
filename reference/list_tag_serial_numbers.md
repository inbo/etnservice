# List all available tag serial numbers

List all available tag serial numbers

## Usage

``` r
list_tag_serial_numbers(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD"))
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

## Value

A vector of all unique `tag_serial_numbers` present in
`common.tag_device`.
