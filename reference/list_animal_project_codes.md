# List all available animal project codes

List all available animal project codes

## Usage

``` r
list_animal_project_codes(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD"))
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

## Value

A vector of all unique `project_code` of `type = "animal"` in
`project.sql`.
