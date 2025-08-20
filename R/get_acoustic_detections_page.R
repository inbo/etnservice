#' Getting a single page of a multi page acoustic detections query
#'
#' A view was implemented that returns the next primary key id, this allows for
#' optimized page wise detections querying to the database as no offset needs to
#' be included.
#'
#' @param credentials A list with the username and password to connect to the
#'   ETN database.
#' @param next_id_pk The next primary key to fetch. All detections have a
#'   sequential id, this key allows us to read the view top to bottom, but
#'   filter out any records before the one we've already fetched. By default,
#'   start reading at the first detection. Returned records have a detection_id
#'   higher than next_id_pk.
#' @param page_size The number of records to retrieve.
#' @param start_date Character. Start date (inclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param end_date Character. End date (exclusive) in ISO 8601 format (
#'   `yyyy-mm-dd`, `yyyy-mm` or `yyyy`).
#' @param detection_id Integer (vector). One or more detection ids.
#' @param acoustic_tag_id Character (vector). One or more acoustic tag ids.
#' @param animal_project_code Character (vector). One or more animal project
#'   codes. Case-insensitive.
#' @param scientific_name Character (vector). One or more scientific names.
#' @param acoustic_project_code Character (vector). One or more acoustic project
#'   codes. Case-insensitive.
#' @param receiver_id Character (vector). One or more receiver identifiers.
#' @param station_name Character (vector). One or more deployment station names.
#' @param count Logical. If set to `TRUE` a data.frame is returned with a single
#'   column: the count of the number of records returned by the query.
#'   `page_size` is ignored.
#'
#' @return A tibble with acoustic detections data, with length `page_size` or
#'   smaller. Including a column with the primary key of the next detection.
#'
#' @export
get_acoustic_detections_page <- function(credentials = list(
                                          username = Sys.getenv("userid"),
                                          password = Sys.getenv("pwd")
                                         ),
                                         next_id_pk = 0,
                                         page_size = 100000,
                                         start_date = NULL,
                                         end_date = NULL,
                                         detection_id = NULL,
                                         acoustic_tag_id = NULL,
                                         animal_project_code = NULL,
                                         scientific_name = NULL,
                                         acoustic_project_code = NULL,
                                         receiver_id = NULL,
                                         station_name = NULL,
                                         count = FALSE) {
  # Check if credentials object has right shape
  check_credentials(credentials)

  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  # Check if we can make a connection
  check_connection(connection)

  # Argument checks and conversion to query elements -----
  # Check start_date
  if (is.null(start_date)) {
    start_date_query <- "True"
  } else {
    start_date <- check_date_time(start_date, "start_date")
    start_date_query <- glue::glue_sql("det.datetime >= {start_date}",
                                       .con = connection)
  }

  # Check end_date
  if (is.null(end_date)) {
    end_date_query <- "True"
  } else {
    end_date <- check_date_time(end_date, "end_date")
    end_date_query <- glue::glue_sql("det.datetime < {end_date}",
                                     .con = connection)
  }

  # Check detection_id
  if (is.null(detection_id)) {
    detection_id_query <- "True"
  } else {
    assertthat::assert_that(is.integer(detection_id))

    detection_id_query <- glue::glue_sql(
      "detection_id_pk IN ({detection_id*})",
      .con = connection
    )
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

  # Check limit: page_sie
  assertthat::assert_that(assertthat::is.count(page_size))
  assertthat::assert_that(assertthat::is.flag(count))
  if (count) {
    limit_query <- glue::glue_sql("LIMIT ALL", .con = connection)
  } else {
    limit_query <- glue::glue_sql("LIMIT ",
                                  format(page_size, scientific = FALSE),
                                  .con = connection)
  }

  # Query creation and execution -----
  # Build the query to fetch the next page

  ## Select view to query from -----

  # If we have animal information, use acoustic.detections_animal view,
  # otherwise use the acoustic.detections_network view.

  if(!is.null(animal_project_code) || !is.null(scientific_name)) {
    # If either animal_project_code or scientific_name are provided, use the
    # animal view
    view_to_query <- "acoustic.detections_animal"
  } else {
    view_to_query <- "acoustic.detections_network"
  }

  ## Build query -----
  query <- glue::glue_sql(
    "SELECT",
    ifelse(count, " COUNT(*)", " *"),
    " FROM ", view_to_query, " AS det",
    "
    WHERE
      {start_date_query}
      AND {end_date_query}
      AND {detection_id_query}
      AND {acoustic_tag_id_query}
      AND {animal_project_code_query}
      AND {scientific_name_query}
      AND {acoustic_project_code_query}
      AND {receiver_id_query}
      AND {station_name_query}
      AND det.detection_id_pk > {next_id_pk}
    {limit_query}
    ",
    .con = connection,
    page_size_query = ifelse(count, "ALL", page_size)
  )

  # Execute query -----
  returned_page <- DBI::dbGetQuery(connection, query)

  # Close connection -----
  DBI::dbDisconnect(connection)

  # Apply mapping -----
  if (!count) {
    # No need to apply mapping if we're only returng the number of records
  returned_page <- returned_page %>%
    dplyr::transmute(
    detection_id = .data$detection_id_pk,
    date_time = .data$datetime,
    .data$tag_serial_number,
    acoustic_tag_id = .data$transmitter,
    .data$animal_project_code,
    animal_id = .data$animal_id_pk,
    scientific_name = .data$animal_scientific_name,
    acoustic_project_code = .data$network_project_code,
    receiver_id = .data$receiver,
    station_name = .data$deployment_station_name,
    deploy_latitude = .data$deployment_latitude,
    deploy_longitude = .data$deployment_longitude,
    .data$sensor_value,
    .data$sensor_unit,
    .data$sensor2_value,
    .data$sensor2_unit,
    .data$signal_to_noise_ratio,
    source_file = .data$file,
    .data$qc_flag,
    deployment_id = .data$deployment_fk
  )}

  # Return query result (mapped or not)
  return(dplyr::as_tibble(returned_page))

}
