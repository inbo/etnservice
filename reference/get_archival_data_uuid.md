# Fetch a table with UUID references to archival data files

Archival data is stored in csv files hosted on lifewatch.com. To fetch
these we must first query ETN for uuids that are needed to build the
paths to read these csv files.

## Usage

``` r
get_archival_data_uuid(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD")),
  tag_serial_number = NULL,
  animal_project_code = NULL,
  animal_id = NULL
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

- tag_serial_number:

  Character (vector). One or more tag serial numbers.

- animal_project_code:

  Character (vector). One or more animal project codes.
  Case-insensitive.

- animal_id:

  Integer (vector). One or more animal identifiers.

## Value

A tibble with a column `converted_archival_file_uuid` that contains the
UUID pointing to the archival data csv file. Other columns are:
`animal_id`, `tag_serial_number`, and `animal_project_code`.

## Examples

``` r
get_archival_data_uuid(tag_serial_number = "22035610")
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.
```
