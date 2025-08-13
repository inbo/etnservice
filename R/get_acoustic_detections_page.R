#' Getting a single page of a multi page acoustic detections query
#'
#' A view was implemented that returns the next primary key id, this allows for
#' optimized page wise detections querying to the database as no offset needs to
#' be included.
#'
#' @param next_id_pk The next primary key to fetch.
#' @param page_size The number of records to retrieve.
#' @param start_date_query A query to filter by start date, defaults to "True".
#' @param end_date_query A query to filter by end date, defaults to "True".
#' @param acoustic_tag_id_query A query to filter by acoustic tag ID, defaults
#'   to "True".
#' @param animal_project_code_query A query to filter by animal project code,
#'   defaults to "True".
#' @param scientific_name_query A query to filter by scientific name, defaults
#'   to "True".
#' @param acoustic_project_code_query A query to filter by acoustic project
#'   code, defaults to "True".
#' @param receiver_id_query A query to filter by receiver ID, defaults to
#'   "True".
#' @param station_name_query A query to filter by station name, defaults to
#'   "True".
get_acoustic_detections_page <- function(next_id_pk = 0,
                                         page_size = 1000000,
                                         start_date_query = "True",
                                         end_date_query = "True",
                                         acoustic_tag_id_query = "True",
                                         animal_project_code_query = "True",
                                         scientific_name_query = "True",
                                         acoustic_project_code_query = "True",
                                         receiver_id_query = "True",
                                         station_name_query = "True") {
  # Check if credentials object has right shape
  check_credentials(credentials)

  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  # Check if we can make a connection
  check_connection(connection)

  # Build the query to fetch the next page
  query <- glue::glue_sql("
    SELECT
      det.detection_id_pk FROM acoustic.detections_animal AS det
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
}
