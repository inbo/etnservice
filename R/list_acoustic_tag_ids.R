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

  acoustic_tag_id_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "acoustic_tag_id.sql", package = "etnservice")),
    .con = connection
  )
  query <- glue::glue_sql("
    SELECT DISTINCT acoustic_tag_id
    FROM ({acoustic_tag_id_sql}) AS acoustic_tag_id
    WHERE acoustic_tag_id IS NOT NULL
  ", .con = connection)
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return acoustic_tag_ids
  stringr::str_sort(data$acoustic_tag_id, numeric = TRUE)
}
