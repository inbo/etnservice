# Getting a single page of a multi page acoustic detections query

A view was implemented that returns the next primary key id, this allows
for optimized page wise detections querying to the database as no offset
needs to be included.

## Usage

``` r
get_acoustic_detections_page(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD")),
  next_id_pk = 0,
  page_size = 1e+05,
  start_date = NULL,
  end_date = NULL,
  tag_serial_number = NULL,
  acoustic_tag_id = NULL,
  animal_project_code = NULL,
  scientific_name = NULL,
  acoustic_project_code = NULL,
  deployment_id = NULL,
  receiver_id = NULL,
  station_name = NULL,
  count = FALSE,
  ...
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

- next_id_pk:

  The next primary key to fetch. All detections have a sequential id,
  this key allows us to read the view top to bottom, but filter out any
  records with lower detection_ids the one we've already fetched. By
  default, start reading at the first detection. Returned records have a
  detection_id higher than next_id_pk.

- page_size:

  The number of records to retrieve.

- start_date:

  Character. Start date (inclusive) in ISO 8601 format ( `yyyy-mm-dd`,
  `yyyy-mm` or `yyyy`).

- end_date:

  Character. End date (exclusive) in ISO 8601 format ( `yyyy-mm-dd`,
  `yyyy-mm` or `yyyy`).

- tag_serial_number:

  Character (vector). One or more tag serial numbers.

- acoustic_tag_id:

  Character (vector). One or more acoustic tag ids.

- animal_project_code:

  Character (vector). One or more animal project codes.
  Case-insensitive.

- scientific_name:

  Character (vector). One or more scientific names.

- acoustic_project_code:

  Character (vector). One or more acoustic project codes.
  Case-insensitive.

- deployment_id:

  Character (vector). One or more deployment ids.

- receiver_id:

  Character (vector). One or more receiver identifiers.

- station_name:

  Character (vector). One or more deployment station names.

- count:

  Logical. If set to `TRUE` a data.frame is returned with a single
  column: the count of the number of records returned by the query.
  `page_size` is ignored.

- ...:

  Additional arguments passed to the function. Not used. Handy if extra
  arguments are passed as a side effect of
  [`do.call()`](https://rdrr.io/r/base/do.call.html)

## Value

A tibble with acoustic detections data, with length `page_size` or
smaller. Including a column with the primary key of the next detection.
