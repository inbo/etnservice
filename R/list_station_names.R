#' List all available station names
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `station_name` present in
#'   `acoustic.deployments`.
#'
#' @export
list_station_names <- function(credentials = list(
                                 username = Sys.getenv("userid"),
                                 password = Sys.getenv("pwd")
                               )) {
  connection <- connect_to_etn(credentials$username, credentials$password)

  query <- glue::glue_sql(
    "SELECT DISTINCT station_name FROM acoustic.deployments WHERE station_name IS NOT NULL",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  stringr::str_sort(data$station_name, numeric = TRUE)
}
