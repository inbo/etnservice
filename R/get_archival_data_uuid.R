get_archival_data_uuid <- function(credentials = list(
                                    username = Sys.getenv("ETN_USER"),
                                    password = Sys.getenv("ETN_PWD")),
                                   tag_serial_number = NULL) {
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

  # Build Query
  query <- glue::glue_sql("
    SELECT *
      FROM digital_twin.archival_files
      WHERE
                          {tag_serial_number_query}
                          {animal_project_code_query}
                          {animal_id_query}


       ", .con = connection
  )
  sensor_reading <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Repair names
  sensor_reading <-
    dplyr::as_tibble(sensor_reading, .name_repair = "universal")

  # Add tag serial number
  sensor_reading <-
    sensor_reading |>
    dplyr::mutate(tag_serial_number =
                    stringr::str_extract(reading_value, ".+(?=_)"))

  # Sort data
  sensor_reading <- sensor_reading |>
    dplyr::arrange(factor(.data$tag_serial_number,
      levels = list_tag_serial_numbers(credentials)
   ))

  req <- httr2::request("https://www.lifewatch.be") |>
    httr2::req_url_path_append("etn","archival-data",
                               "file",
                               "588B1CFE-7ED4-4F74-8841-E1A567532370")

  req |>
    httr2::req_perform() |>
    httr2::resp_body_raw() |>
    readr::read_csv()

  req |>
    httr2::req_get_url() |>
    readr::read_csv()

  sensor_reading
}
