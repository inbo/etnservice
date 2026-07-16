#' List all available animal ids
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `id_pk` present in `common.animal_release`.
#'
#' @export
list_animal_ids <- function(credentials = list(
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
  query <- glue::glue_sql(
    "SELECT DISTINCT id_pk FROM common.animal_release",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  sort(data$id_pk)
}
