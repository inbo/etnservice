#' Getting a single page of a multi page acoustic detections query
#'
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
    WHERE {start_date_query}
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
