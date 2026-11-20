# Changelog

## etnservice (development version)

- etnservice now has a pkgdown website:
  [inbo.github.io/etnservice/](https://inbo.github.io/etnservice/)
  ([\#138](https://github.com/inbo/etnservice/issues/138)).
- `write_dwc()` has been removed from etnservice. It was an API function
  that produced a Darwin Core occurrence table from the database. It
  should only be run through the etn R package, which generates the
  output from a Data Package via get_package(). The etnservice version
  had fallen out of sync with etn, and it likely no longer worked as
  expected. Keeping both implementations risked drift between the two
  packages, so the function is retired here. Use `etn::write_dwc()`
  instead ([\#190](https://github.com/inbo/etnservice/issues/190)).
- The internal helpers `get_val()` and `extract_temp_key()` were removed
  from `etnservice`, both were unused in this package and have since
  migrated to become internal helpers in the `etn` package. After this
  housekeeping, the `httr` package is no longer a dependency of
  `etnservice` ([\#198](https://github.com/inbo/etnservice/issues/198)).

## etnservice 0.7.2

- etnservice now relies on R \>= 4.2.0 due to the dependency on `odbc`
  and `arrow` ([\#179](https://github.com/inbo/etnservice/issues/179)).

## etnservice 0.7.1

- Fixed a bug in
  [`get_acoustic_detections_page()`](../reference/get_acoustic_detections_page.md)
  where the `tag_serial_number` argument was not cast to character
  causing database errors.
  ([\#174](https://github.com/inbo/etnservice/issues/174))

## etnservice 0.7.0

- Added
  [`get_archival_data_uuid()`](../reference/get_archival_data_uuid.md)
  which fetches a table with UUID references to archival data files.
  These UUIDs can be used to construct paths to download the archival
  data CSV files hosted on lifewatch.com
  ([\#126](https://github.com/inbo/etnservice/issues/126)).
- The function `write_dwc()` has been updated in the `etn` package and
  is no longer needed in `etnservice`.
  ([\#141](https://github.com/inbo/etnservice/issues/141))
- The `jsonlite` package is no longer a direct dependency, it is only
  used by a maintenance script.
  ([\#144](https://github.com/inbo/etnservice/issues/144))
- etnservice now relies on R \>= 4.1.0 and uses base pipes (`|>` rather
  than `%>%`) ([\#151](https://github.com/inbo/etnservice/issues/151)).
- The function `get_receiver_logs()` has been renamed to
  [`get_acoustic_deployment_logs()`](../reference/get_acoustic_deployment_logs.md)
  during the review process of the respective etn client function.
  [`get_acoustic_deployment_logs()`](../reference/get_acoustic_deployment_logs.md)
  also supports less arguments but has a greatly simplified user
  interface. ([\#160](https://github.com/inbo/etnservice/issues/160)) \#
  etnservice 0.6.0
- Added `get_receiver_logs()` to fetch receiver logs from the database.
  The data is returned as a tibble with a column with logs in JSON
  format. ([\#117](https://github.com/inbo/etnservice/issues/117))

## etnservice 0.5.1

- Made sure
  [`list_acoustic_project_codes()`](../reference/list_acoustic_project_codes.md),
  [`list_animal_project_codes()`](../reference/list_animal_project_codes.md),
  [`list_cpod_project_codes()`](../reference/list_cpod_project_codes.md)
  and [`list_scientific_names()`](../reference/list_scientific_names.md)
  always return values in the same order, regardless of the locale of
  the computer R is running on.
  ([\#116](https://github.com/inbo/etnservice/issues/116))

## etnservice 0.5.0

- Added `tag_serial_number` to
  [`get_acoustic_detections_page()`](../reference/get_acoustic_detections_page.md).
  This argument is a better option as `acoustic_tag_id`. Thank you
  [@lottepohl](https://github.com/lottepohl) for the suggestion.
  ([\#112](https://github.com/inbo/etnservice/issues/112), inbo/etn#386,
  [\#102](https://github.com/inbo/etnservice/issues/102))

## etnservice 0.4.3

- [`get_version()`](../reference/get_version.md) now returns the package
  version as a `package_version`, `numeric_version` object instead of as
  a character string. This allows for easy comparison by the `etn`
  package. ([\#109](https://github.com/inbo/etnservice/issues/109))

## etnservice 0.4.2

- Minor change to
  [`get_acoustic_detections_page()`](../reference/get_acoustic_detections_page.md)
  to now support ellipsis `...` to be passed (unused). This is useful
  when the function is being called via
  [`do.call()`](https://rdrr.io/r/base/do.call.html) and extra arguments
  are passed.

## etnservice 0.4.1

- Fix spelling mistake

## etnservice 0.4.0

- Added [`get_version()`](../reference/get_version.md) which allows
  users to easily compare their locally installed version of
  `etnservice` with the one deployed on the OpenCPU API.
  ([\#81](https://github.com/inbo/etnservice/issues/81))
- Added
  [`get_acoustic_detections_page()`](../reference/get_acoustic_detections_page.md)
  which fetches a single page from the new detections view. This
  function allows paginated access and is to be called by the etn
  package function
  [`get_acoustic_detections()`](../reference/get_acoustic_detections.md)
  to make fetching large numbers of detections more efficient.
  ([\#85](https://github.com/inbo/etnservice/issues/85))
- The `depth_in_meters` field is not returned as part of
  [`get_acoustic_detections_page()`](../reference/get_acoustic_detections_page.md),
  this was a calculated field that has proved unreliable. It was also
  causing performance issues in the database. As an alternative depth
  can (sometimes) be retrieved via `sensor_value` and `sensor_unit`,
  which will be more dependable than a calculation based on slope.

## etnservice 0.3.0

- Added `depth_in_meters` field to
  [`get_acoustic_detections()`](../reference/get_acoustic_detections.md)
  to achieve feature parity with the etn package
  ([\#72](https://github.com/inbo/etnservice/issues/72),
  [inbo/etn#274](https://github.com/inbo/etn/pull/274)).

## etnservice 0.2.0

- Add new function [`validate_login()`](../reference/validate_login.md)
  to check if the provided credentials grant access to ETN
  ([\#59](https://github.com/inbo/etnservice/issues/59)).
- Fixed bug in `write_dwc()` where providing no value for
  `rights_holder` would result in the function failing to output a
  data.frame ([\#69](https://github.com/inbo/etnservice/issues/69)).
- etnservice will now no longer return duplicate receiver_ids in
  [`list_receiver_ids()`](../reference/list_receiver_ids.md)
  ([inbo/etn#333](https://github.com/inbo/etn/issues/333).

## etnservice 0.1.2

- Updated integration tests (JavaScript) for postman monitor
  ([\#62](https://github.com/inbo/etnservice/issues/62)).
- Fixed broken example in README and updated it to use `httr2`
  ([\#64](https://github.com/inbo/etnservice/issues/64)).

## etnservice 0.1.1

- Added badges to the README.
- Improvements to CI, note that tests and examples are not checked on
  github. These still need to be checked on a machine that has access to
  the ETN database.

## etnservice v0.1.0

- This is the first version of etnservice used in the beta of etn
  v2.3.0.
- This version is still lagging behind its contemporary version of etn
  v2.2.1, which means that database queries made via etnservice, or via
  the OpenCPU API are not guaranteed to be identical as the results of
  the same queries made via the etn R package.
