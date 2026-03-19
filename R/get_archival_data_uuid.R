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

  # Build query
  query <- glue::glue_sql("
    SELECT *
     FROM archive.sensor_reading AS sensor_reading
      INNER JOIN acoustic.detections_files df ON
       sensor_reading.conversion_file_fk = df.id_pk
     ", .con = connection)
  sensor_reading <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Sort data
  sensor_reading <- sensor_reading |>
    dplyr::arrange(factor(.data$tag_serial_number,
      levels = list_tag_serial_numbers(credentials)
   ))

  sensor_reading
}
