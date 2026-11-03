#' List all available acoustic tag ids
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `acoustic_tag_id` in `acoustic_tag_id.sql`.
#'
#' @export
list_acoustic_tag_ids <- function(credentials = list(
  username = Sys.getenv("ETN_USER"),
  password = Sys.getenv("ETN_PWD")
)) {
  # Check if credentials object has right shape
  check_credentials(credentials)

  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  # Ensure the connection is closed when the function exits, even when it fails.
  withr::defer(
    if (DBI::dbIsValid(connection)) {
      DBI::dbDisconnect(connection)
    }
  )

  check_connection(connection)

  query <- glue::glue_sql("
    SELECT DISTINCT acoustic_tag_id, acoustic_tag_id_alternative
    FROM digital_twin.get_tags()
    WHERE acoustic_tag_id IS NOT NULL OR acoustic_tag_id_alternative IS NOT NULL
  ",
    .con = connection
  )

  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return acoustic_tag_ids
  c(data$acoustic_tag_id, data$acoustic_tag_id_alternative) |>
    unique() |>
    stringr::str_sort(numeric = TRUE)
}
