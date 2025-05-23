#' Get acoustic detections data
#'
#' Get data for acoustic detections, with options to filter results. Use
#' `limit` to limit the number of returned records.
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#' @param start_date Character. Start date (inclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param end_date Character. End date (exclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param acoustic_tag_id Character (vector). One or more acoustic tag ids.
#' @param animal_project_code Character (vector). One or more animal project
#'   codes. Case-insensitive.
#' @param scientific_name Character (vector). One or more scientific names.
#' @param acoustic_project_code Character (vector). One or more acoustic
#'   project codes. Case-insensitive.
#' @param receiver_id Character (vector). One or more receiver identifiers.
#' @param station_name Character (vector). One or more deployment station
#'   names.
#' @param limit Logical. Limit the number of returned records to 100 (useful
#'   for testing purposes). Defaults to `FALSE`.
#'
#' @return A tibble with acoustic detections data, sorted by `acoustic_tag_id`
#'  and `date_time`. See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Set default connection variable
#' con <- connect_to_etn()
#'
#' # Get limited sample of acoustic detections
#' get_acoustic_detections(con, limit = TRUE)
#'
#' # Get all acoustic detections from a specific animal project
#' get_acoustic_detections(con, animal_project_code = "2014_demer")
#'
#' # Get 2015 acoustic detections from that animal project
#' get_acoustic_detections(
#'   con,
#'   animal_project_code = "2014_demer",
#'   start_date = "2015",
#'   end_date = "2016",
#' )
#'
#' # Get April 2015 acoustic detections from that animal project
#' get_acoustic_detections(
#'   con,
#'   animal_project_code = "2014_demer",
#'   start_date = "2015-04",
#'   end_date = "2015-05",
#' )
#'
#' # Get April 24, 2015 acoustic detections from that animal project
#' get_acoustic_detections(
#'   con,
#'   animal_project_code = "2014_demer",
#'   start_date = "2015-04-24",
#'   end_date = "2015-04-25",
#' )
#'
#' # Get acoustic detections for a specific tag at two specific stations
#' get_acoustic_detections(
#'   con,
#'   acoustic_tag_id = "A69-1601-16130",
#'   station_name = c("de-9", "de-10")
#' )
#'
#' # Get acoustic detections for a specific species, receiver and acoustic project
#' get_acoustic_detections(
#'   con,
#'   scientific_name = "Rutilus rutilus",
#'   receiver_id = "VR2W-124070",
#'   acoustic_project_code = "demer"
#' )
#' }
get_acoustic_detections <- function(credentials = list(
                                      username = Sys.getenv("userid"),
                                      password = Sys.getenv("pwd")
                                    ),
                                    start_date = NULL,
                                    end_date = NULL,
                                    acoustic_tag_id = NULL,
                                    animal_project_code = NULL,
                                    scientific_name = NULL,
                                    acoustic_project_code = NULL,
                                    receiver_id = NULL,
                                    station_name = NULL,
                                    limit = FALSE) {

  # Check if credentials object has right shape
  check_credentials(credentials)

  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  # Check if we can make a connection
  check_connection(connection)

  # Check start_date
  if (is.null(start_date)) {
    start_date_query <- "True"
  } else {
    start_date <- check_date_time(start_date, "start_date")
    start_date_query <- glue::glue_sql("det.datetime >= {start_date}", .con = connection)
  }

  # Check end_date
  if (is.null(end_date)) {
    end_date_query <- "True"
  } else {
    end_date <- check_date_time(end_date, "end_date")
    end_date_query <- glue::glue_sql("det.datetime < {end_date}", .con = connection)
  }

  # Check acoustic_tag_id
  if (is.null(acoustic_tag_id)) {
    acoustic_tag_id_query <- "True"
  } else {
    acoustic_tag_id <- check_value(
      acoustic_tag_id,
      list_acoustic_tag_ids(credentials),
      "acoustic_tag_id"
    )
    acoustic_tag_id_query <- glue::glue_sql(
      "det.transmitter IN ({acoustic_tag_id*})",
      .con = connection
    )
    include_ref_tags <- TRUE
  }

  # Check animal_project_code
  if (is.null(animal_project_code)) {
    animal_project_code_query <- "True"
  } else {
    animal_project_code <- check_value(
      animal_project_code,
      list_animal_project_codes(credentials),
      "animal_project_code",
      lowercase = TRUE
    )
    animal_project_code_query <- glue::glue_sql(
      "LOWER(animal_project_code) IN ({animal_project_code*})",
      .con = connection
    )
  }

  # Check scientific_name
  if (is.null(scientific_name)) {
    scientific_name_query <- "True"
  } else {
    scientific_name <- check_value(
      scientific_name,
      list_scientific_names(credentials),
      "scientific_name"
    )
    scientific_name_query <- glue::glue_sql(
      "animal_scientific_name IN ({scientific_name*})",
      .con = connection
    )
  }

  # Check acoustic_project_code
  if (is.null(acoustic_project_code)) {
    acoustic_project_code_query <- "True"
  } else {
    acoustic_project_code <- check_value(
      acoustic_project_code,
      list_acoustic_project_codes(credentials),
      "acoustic_project_code",
      lowercase = TRUE
    )
    acoustic_project_code_query <- glue::glue_sql(
      "LOWER(network_project_code) IN ({acoustic_project_code*})",
      .con = connection
    )
  }

  # Check receiver_id
  if (is.null(receiver_id)) {
    receiver_id_query <- "True"
  } else {
    receiver_id <- check_value(
      receiver_id,
      list_receiver_ids(credentials),
      "receiver_id"
    )
    receiver_id_query <- glue::glue_sql(
      "det.receiver IN ({receiver_id*})",
      .con = connection
    )
  }

  # Check station_name
  if (is.null(station_name)) {
    station_name_query <- "True"
  } else {
    station_name <- check_value(
      station_name,
      list_station_names(credentials),
      "station_name"
    )
    station_name_query <- glue::glue_sql(
      "deployment_station_name IN ({station_name*})",
      .con = connection
    )
  }

  # Check limit
  assertthat::assert_that(is.logical(limit), msg = "limit must be a logical: TRUE/FALSE.")
  if (limit) {
    limit_query <- glue::glue_sql("LIMIT 100", .con = connection)
  } else {
    limit_query <- glue::glue_sql("LIMIT ALL}", .con = connection)
  }

  acoustic_tag_id_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "acoustic_tag_id.sql", package = "etnservice")),
    .con = connection
  )

  # Build query
  query <- glue::glue_sql("
    SELECT
      det.id_pk AS detection_id,
      det.datetime AS date_time,
      tag_serial_number AS tag_serial_number, -- exclusive to detections_limited
      det.transmitter AS acoustic_tag_id,
      animal_project_code AS animal_project_code, -- exclusive to detections_limited
      animal_id_pk AS animal_id, -- exclusive to detections_limited
      animal_scientific_name AS scientific_name, -- exclusive to detections_limited
      network_project_code AS acoustic_project_code, -- exclusive to detections_limited
      det.receiver AS receiver_id,
      deployment_station_name AS station_name, -- exclusive to detections_limited
      deployment_latitude AS deploy_latitude, -- exclusive to detections_limited
      deployment_longitude AS deploy_longitude, -- exclusive to detections_limited
      det.depth_in_meters AS depth_in_meters,
      det.sensor_value AS sensor_value,
      det.sensor_unit AS sensor_unit,
      det.sensor2_value AS sensor2_value,
      det.sensor2_unit AS sensor2_unit,
      det.signal_to_noise_ratio AS signal_to_noise_ratio,
      det.file AS source_file,
      det.qc_flag AS qc_flag,
      det.deployment_fk AS deployment_id
      -- det.transmitter_name
      -- det.transmitter_serial: via tag_device instead
      -- det.station_name: deployment.station_name instead
      -- det.latitude: deployment.deploy_lat instead
      -- det.longitude: deployment.deploy_long instead
      -- det.detection_file_id
      -- det.receiver_serial
      -- det.gain
      -- external_id
    FROM acoustic.detections_limited AS det
    WHERE
      {start_date_query}
      AND {end_date_query}
      AND {acoustic_tag_id_query}
      AND {animal_project_code_query}
      AND {scientific_name_query}
      AND {acoustic_project_code_query}
      AND {receiver_id_query}
      AND {station_name_query}
      {limit_query}
    ", .con = connection)
  detections <- DBI::dbGetQuery(connection, query)

  # Sort data (faster than in SQL)
  detections <-
    detections %>%
    dplyr::arrange(
      factor(.data$acoustic_tag_id, levels = list_acoustic_tag_ids(credentials)),
      .data$date_time
    )
  # Close connection
  DBI::dbDisconnect(connection)

  # Return detections
  dplyr::as_tibble(detections)
}
