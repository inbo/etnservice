# Get cpod project data

Get data for cpod projects, with options to filter results.

## Usage

``` r
get_cpod_projects(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD")),
  cpod_project_code = NULL
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

- cpod_project_code:

  Character (vector). One or more cpod project codes. Case-insensitive.

## Value

A tibble with animal project data, sorted by `project_code`. See also
[field
definitions](https://inbo.github.io/etn/articles/etn_fields.html).

## Examples

``` r
# Set credentials
credentials <- list(
   username = Sys.getenv("ETN_USER"),
   password = Sys.getenv("ETN_PWD")
 )

# Get all animal projects
get_cpod_projects(credentials)
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get a specific animal project
get_cpod_projects(credentials, cpod_project_code = "cpod-lifewatch")
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.
```
