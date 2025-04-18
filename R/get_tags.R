#' Get tag data
#'
#' Get data for tags, with options to filter results. Note that there
#' can be multiple records (`acoustic_tag_id`) per tag device
#' (`tag_serial_number`).
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#' @param tag_serial_number Character (vector). One or more tag serial numbers.
#' @param tag_type Character (vector). `acoustic` or `archival`. Some tags are
#'   both, find those with `acoustic-archival`.
#' @param tag_subtype Character (vector). `animal`, `built-in`, `range` or
#'   `sentinel`.
#' @param acoustic_tag_id Character (vector). One or more acoustic tag
#'   identifiers, i.e. identifiers found in [get_acoustic_detections()].
#'
#' @return A tibble with tags data, sorted by `tag_serial_number`. See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'  Values for `owner_organization` and `owner_pi` will only be visible if you
#'  are member of the group.
#'
#' @export
#'
#' @examples
#' # Set credentials
#' credentials <- list(
#'    username = Sys.getenv("userid"),
#'    password = Sys.getenv("pwd")
#'  )
#'
#' # Get all tags
#' get_tags(credentials)
#'
#' # Get archival tags, including acoustic-archival
#' get_tags(credentials, tag_type = c("archival", "acoustic-archival"))
#'
#' # Get tags of specific subtype
#' get_tags(credentials, tag_subtype = c("built-in", "range"))
#'
#' # Get specific tags (note that these can return multiple records)
#' get_tags(credentials, tag_serial_number = "1187450")
#' get_tags(credentials, acoustic_tag_id = "A69-1601-16130")
#' get_tags(credentials, acoustic_tag_id = c("A69-1601-16129", "A69-1601-16130"))
get_tags <- function(credentials = list(
                       username = Sys.getenv("userid"),
                       password = Sys.getenv("pwd")
                     ),
                     tag_type = NULL,
                     tag_subtype = NULL,
                     tag_serial_number = NULL,
                     acoustic_tag_id = NULL) {

  # Check if credentials object has right shape
  check_credentials(credentials)

  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  # Check connection
  check_connection(connection)

  # Check tag_serial_number
  if (is.null(tag_serial_number)) {
    tag_serial_number_query <- "True"
  } else {
    tag_serial_number <- check_value(
      as.character(tag_serial_number), # Cast to character
      list_tag_serial_numbers(credentials),
      "tag_serial_number"
    )
    tag_serial_number_query <- glue::glue_sql(
      "tag.tag_serial_number IN ({tag_serial_number*})",
      .con = connection
    )
  }

  # Check tag_type
  if (is.null(tag_type)) {
    tag_type_query <- "True"
  } else {
    tag_type <- check_value(
      tag_type,
      c("acoustic", "archival", "acoustic-archival"),
      "tag_type"
    )
    tag_type_query <- glue::glue_sql(
      "tag.tag_type IN ({tag_type*})",
      .con = connection
    )
  }

  # Check tag_subtype
  if (is.null(tag_subtype)) {
    tag_subtype_query <- "True"
  } else {
    tag_subtype <- check_value(
      tag_subtype,
      c("animal", "built-in", "range", "sentinel"),
      "tag_subtype"
    )
    tag_subtype_query <- glue::glue_sql(
      "tag.tag_subtype IN ({tag_subtype*})",
      .con = connection
    )
  }

  # Check acoustic_tag_id
  if (is.null(acoustic_tag_id)) {
    acoustic_tag_id_query <- "True"
  } else {
    check_value(
      acoustic_tag_id,
      list_acoustic_tag_ids(credentials),
      "acoustic_tag_id"
    )
    acoustic_tag_id_query <- glue::glue_sql(
      "tag.acoustic_tag_id IN ({acoustic_tag_id*})",
      .con = connection
    )
  }

  tag_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "tag.sql", package = "etnservice")),
    .con = connection
  )

  # Build query
  query <- glue::glue_sql("
    SELECT
      tag.tag_serial_number AS tag_serial_number,
      tag.tag_type AS tag_type,
      tag.tag_subtype AS tag_subtype,
      tag.sensor_type AS sensor_type,
      tag.acoustic_tag_id AS acoustic_tag_id,
      tag.thelma_converted_code AS acoustic_tag_id_alternative,
      manufacturer.project AS manufacturer,
      tag_device.model AS model,
      tag.frequency AS frequency,
      tag_status.name AS status,
      tag_device.activation_date AS activation_date,
      tag_device.battery_estimated_lifetime AS battery_estimated_life,
      tag_device.battery_estimated_end_date AS battery_estimated_end_date,
      tag_device.archive_length AS length,
      tag_device.archive_diameter AS diameter,
      tag_device.archive_weight AS weight,
      tag_device.archive_floating AS floating,
      tag_device.device_internal_memory AS archive_memory,
      tag.slope AS sensor_slope,
      tag.intercept AS sensor_intercept,
      tag.range AS sensor_range,
      tag.range_min AS sensor_range_min,
      tag.range_max AS sensor_range_max,
      tag.resolution AS sensor_resolution,
      tag.unit AS sensor_unit,
      tag.accurency AS sensor_accuracy,
      tag.sensor_transmit_ratio AS sensor_transmit_ratio,
      tag.accelerometer_algoritm AS accelerometer_algorithm,
      tag.accelerometer_samples_per_second AS accelerometer_samples_per_second,
      CASE
        WHEN tag_device.owner_group_fk_limited IS NOT NULL THEN owner_organization.name
        ELSE NULL
      END AS owner_organization,
      CASE
        WHEN tag_device.owner_group_fk_limited IS NOT NULL THEN tag_device.owner_pi
        ELSE NULL
      END AS owner_pi,
      financing_project.projectcode AS financing_project,
      tag.min_delay AS step1_min_delay,
      tag.max_delay AS step1_max_delay,
      tag.power AS step1_power,
      tag.duration_step1 AS step1_duration,
      tag.acceleration_on_sec_step1 AS step1_acceleration_duration,
      tag.min_delay_step2 AS step2_min_delay,
      tag.max_delay_step2 AS step2_max_delay,
      tag.power_step2 AS step2_power,
      tag.duration_step2 AS step2_duration,
      tag.acceleration_on_sec_step2 AS step2_acceleration_duration,
      tag.min_delay_step3 AS step3_min_delay,
      tag.max_delay_step3 AS step3_max_delay,
      tag.power_step3 AS step3_power,
      tag.duration_step3 AS step3_duration,
      tag.acceleration_on_sec_step3 AS step3_acceleration_duration,
      tag.min_delay_step4 AS step4_min_delay,
      tag.max_delay_step4 AS step4_max_delay,
      tag.power_step4 AS step4_power,
      tag.duration_step4 AS step4_duration,
      tag.acceleration_on_sec_step4 AS step4_acceleration_duration,
      tag.tag_id AS tag_id,
      tag_device.id_pk AS tag_device_id
      -- tag_device.qc_migration
      -- tag_device.order_number
      -- tag_device.external_id
    FROM ({tag_sql}) AS tag
      LEFT JOIN common.tag_device_limited AS tag_device
        ON tag.tag_device_fk = tag_device.id_pk
        LEFT JOIN common.manufacturer AS manufacturer
          ON tag_device.manufacturer_fk = manufacturer.id_pk
        LEFT JOIN common.tag_device_status AS tag_status
          ON tag_device.tag_device_status_fk = tag_status.id_pk
        LEFT JOIN common.etn_group AS owner_organization
          ON tag_device.owner_group_fk_limited = owner_organization.id_pk
        LEFT JOIN common.projects AS financing_project
          ON tag_device.financing_project_fk = financing_project.id
    WHERE
      {tag_serial_number_query}
      AND {tag_type_query}
      AND {tag_subtype_query}
      AND {acoustic_tag_id_query}
    ", .con = connection)
  tags <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Sort data
  tags <-
    tags %>%
    dplyr::arrange(factor(.data$tag_serial_number, levels = list_tag_serial_numbers(credentials)))

  dplyr::as_tibble(tags)
}
