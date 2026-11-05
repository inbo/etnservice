#' List all available receiver ids
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `receiver` present in `acoustic.receivers`.
#'
#' @export
list_receiver_ids <- function(credentials = list(
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
    "SELECT DISTINCT receiver FROM acoustic.receivers",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return receiver_ids and drop NA (issue on database side #333)
  receiver_ids <- stringr::str_sort(data$receiver, numeric = TRUE)

  return(receiver_ids[!is.na(receiver_ids)])
}
