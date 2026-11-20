# Get animal data

Get data for animals, with options to filter results. Associated tag
information is available in columns starting with `tag` and
`acoustic_tag_id`. If multiple tags are associated with a single animal,
the information is comma-separated.

## Usage

``` r
get_animals(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD")),
  animal_id = NULL,
  tag_serial_number = NULL,
  animal_project_code = NULL,
  scientific_name = NULL
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

- animal_id:

  Integer (vector). One or more animal identifiers.

- tag_serial_number:

  Character (vector). One or more tag serial numbers.

- animal_project_code:

  Character (vector). One or more animal project codes.
  Case-insensitive.

- scientific_name:

  Character (vector). One or more scientific names.

## Value

A tibble with animals data, sorted by `animal_project_code`,
`release_date_time` and `tag_serial_number`. See also [field
definitions](https://inbo.github.io/etn/articles/etn_fields.html).

## Examples

``` r
# Set credentials
credentials <- list(
   username = Sys.getenv("ETN_USER"),
   password = Sys.getenv("ETN_PWD")
 )

# Get all animals
get_animals(credentials)
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get specific animals
get_animals(credentials, animal_id = 305) # Or string value "305"
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.
get_animals(credentials, animal_id = c(304, 305, 2827))
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get animals from specific animal project(s)
get_animals(credentials, animal_project_code = "2014_demer")
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.
get_animals(credentials, animal_project_code = c("2014_demer", "2015_dijle"))
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get animals associated with a specific tag_serial_number
get_animals(credentials, tag_serial_number = "1187450")
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get animals of specific species (across all projects)
get_animals(credentials, scientific_name = c("Rutilus rutilus", "Silurus glanis"))
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get animals of a specific species from a specific project
get_animals(credentials, animal_project_code = "2014_demer", scientific_name = "Rutilus rutilus")
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.
```
