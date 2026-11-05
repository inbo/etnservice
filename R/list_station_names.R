#' List all available station names
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `station_name` present in
#'   `acoustic.deployments`.
#'
#' @export
list_station_names <- function(credentials = list(
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
  
  query <- glue::glue_sql(
    "SELECT DISTINCT station_name FROM acoustic.deployments WHERE station_name IS NOT NULL",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  stringr::str_sort(data$station_name, numeric = TRUE)
}
