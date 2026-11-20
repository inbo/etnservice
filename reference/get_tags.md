# Get tag data

Get data for tags, with options to filter results. Note that there can
be multiple records (`acoustic_tag_id`) per tag device
(`tag_serial_number`).

## Usage

``` r
get_tags(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD")),
  tag_type = NULL,
  tag_subtype = NULL,
  tag_serial_number = NULL,
  acoustic_tag_id = NULL
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

- tag_type:

  Character (vector). `acoustic` or `archival`. Some tags are both, find
  those with `acoustic-archival`.

- tag_subtype:

  Character (vector). `animal`, `built-in`, `range` or `sentinel`.

- tag_serial_number:

  Character (vector). One or more tag serial numbers.

- acoustic_tag_id:

  Character (vector). One or more acoustic tag identifiers, i.e.
  identifiers found in
  [`get_acoustic_detections()`](get_acoustic_detections.md).

## Value

A tibble with tags data, sorted by `tag_serial_number`. See also [field
definitions](https://inbo.github.io/etn/articles/etn_fields.html).
Values for `owner_organization` and `owner_pi` will only be visible if
you are member of the group.

## Examples

``` r
# Set credentials
credentials <- list(
   username = Sys.getenv("ETN_USER"),
   password = Sys.getenv("ETN_PWD")
 )

# Get all tags
get_tags(credentials)
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get archival tags, including acoustic-archival
get_tags(credentials, tag_type = c("archival", "acoustic-archival"))
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get tags of specific subtype
get_tags(credentials, tag_subtype = c("built-in", "range"))
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.

# Get specific tags (note that these can return multiple records)
get_tags(credentials, tag_serial_number = "1187450")
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.
get_tags(credentials, acoustic_tag_id = "A69-1601-16130")
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.
get_tags(credentials, acoustic_tag_id = c("A69-1601-16129", "A69-1601-16130"))
#> Error: ODBC failed with error 00000 from              [unixODBC][Driver Manager].
#> Failed to connect to the database.
#> Did you enter the right username/password?
#> Please try again.
```
