get_archival_data_uuid <- function(credentials = list(
                                    username = Sys.getenv("ETN_USER"),
                                    password = Sys.getenv("ETN_PWD")),
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
      "animal_project_code"
    )
    animal_project_code_query <- glue::glue_sql(
      "af.animal_project_code IN ({animal_project_code*})",
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


       ", .con = connection
  )
  sensor_reading <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Sort data
  sensor_reading <- sensor_reading |>
    dplyr::arrange(factor(.data$tag_serial_number,
      levels = list_tag_serial_numbers(credentials)
   ))

  # req <- httr2::request("https://www.lifewatch.be") |>
  #   httr2::req_url_path_append("etn","archival-data",
  #                              "file",
  #                              "588B1CFE-7ED4-4F74-8841-E1A567532370")
  #
  # req |>
  #   httr2::req_perform() |>
  #   httr2::resp_body_raw() |>
  #   readr::read_csv()
  #
  # req |>
  #   httr2::req_get_url() |>
  #   readr::read_csv()

  sensor_reading
}
