# List all available cpod project codes

List all available cpod project codes

## Usage

``` r
list_cpod_project_codes(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD"))
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

## Value

A vector of all unique `project_code` of `type = "cpod"` in
`project.sql`.
