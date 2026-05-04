#' Fetch a table with UUID references to archival data files
#'
#' Archival data is stored in csv files hosted on lifewatch.com. To fetch these
#' we must first query ETN for uuids that are needed to build the paths to read
#' these csv files.
#'
#' @inheritParams get_animals
#'
#' @returns A tibble with a column `converted_archival_file_uuid` that contains
#'   the UUID pointing to the archival data csv file. Other columns are:
#'   `animal_id`, `tag_serial_number`, and `animal_project_code`.
#' @export
#'
#' @examples
#' get_archival_data_uuid(tag_serial_number = "22035610")
get_archival_data_uuid <- function(credentials = list(
                                     username = Sys.getenv("ETN_USER"),
                                     password = Sys.getenv("ETN_PWD")
                                   ),
                                   tag_serial_number = NULL,
                                   animal_project_code = NULL,
                                   animal_id = NULL) {
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
      "af.tag_serial_number IN ({tag_serial_number*})",
      .con = connection
    )
  }

  # Check animal_project_code
  if (is.null(animal_project_code)) {
    animal_project_code_query <- "True"
  } else {
    animal_project_code <- check_value(
      as.character(animal_project_code), # Cast to character
      list_animal_project_codes(credentials),
      name = "animal_project_code",
      lowercase = TRUE
    )
    animal_project_code_query <- glue::glue_sql(
      "LOWER(af.animal_project_code) IN ({animal_project_code*})",
      .con = connection
    )
  }

  # Check animal_id
  if (is.null(animal_id)) {
    animal_id_query <- "True"
  } else {
    animal_id <- check_value(
      as.character(animal_id), # Cast to character
      list_animal_ids(credentials),
      "animal_id"
    )
    animal_id_query <- glue::glue_sql(
      "af.animal_id IN ({animal_id*})",
      .con = connection
    )
  }

  # Build Query
  query <- glue::glue_sql("
    SELECT *
      FROM digital_twin.archival_files AS af
      WHERE
        {tag_serial_number_query}
        AND {animal_project_code_query}
        AND {animal_id_query}
       ", .con = connection)
  uuid_tbl <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Sort data
  uuid_tbl <- uuid_tbl |>
    dplyr::arrange(factor(.data$tag_serial_number,
      levels = list_tag_serial_numbers(credentials)
    ))

  # Return uuids
  dplyr::as_tibble(uuid_tbl)
}
