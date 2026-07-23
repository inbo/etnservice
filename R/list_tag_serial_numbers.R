#' List all available tag serial numbers
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `tag_serial_numbers` present in
#'   `common.tag_device`.
#'
#' @export
list_tag_serial_numbers <- function(credentials = list(
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

  # Check if we can make a connection
  check_connection(connection)

  query <- glue::glue_sql(
    "SELECT DISTINCT serial_number FROM common.tag_device",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return vector
  stringr::str_sort(data$serial_number, numeric = TRUE)
}
