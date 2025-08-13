#' Getting a single page of a multi page acoustic detections query
#'
#' A view was implemented that returns the next primary key id, this allows for
#' optimized page wise detections querying to the database as no offset needs to
#' be included.
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#' @param next_id_pk The next primary key to fetch. All detections have a
#'   sequential id, this key allows us to read the view top to bottom, but
#'   filter out any records before the one we've already fetched. By default,
#'   start reading at the first detection.
#' @param page_size The number of records to retrieve.
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
#'
#' @return A tibble with acoustic detections data, with length `page_size` or smaller.
#'  Including a column with the primary key of the next detection.
#'
#' @export
get_acoustic_detections_page <- function(credentials = list(
                                          username = Sys.getenv("userid"),
                                          password = Sys.getenv("pwd")
                                         ),
                                         next_id_pk = 0,
                                         page_size = 1000000,
                                         start_date = NULL,
                                         end_date = NULL,
                                         acoustic_tag_id = NULL,
                                         animal_project_code = NULL,
                                         scientific_name = NULL,
                                         acoustic_project_code = NULL,
                                         receiver_id = NULL,
                                         station_name = NULL) {
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

  # Query creation and execution -----
  # Build the query to fetch the next page
  query <- glue::glue_sql("
    SELECT
      * FROM acoustic.detections_animal AS det
    WHERE
      {start_date_query}
      AND {end_date_query}
      AND {acoustic_tag_id_query}
      AND {animal_project_code_query}
      AND {scientific_name_query}
      AND {acoustic_project_code_query}
      AND {receiver_id_query}
      AND {station_name_query}
      AND det.detection_id_pk > {next_id_pk}
    LIMIT {page_size}
    ", .con = connection)

  # Execute query
  returned_page <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return returned page
  return(returned_page)

}
