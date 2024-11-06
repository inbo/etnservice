#' List all available receiver ids
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `receiver` present in `acoustic.receivers`.
#'
#' @export
list_receiver_ids <- function(credentials = list(
                                username = Sys.getenv("userid"),
                                password = Sys.getenv("pwd")
                              )) {
  connection <- connect_to_etn(credentials$username, credentials$password)
  query <- glue::glue_sql(
    "SELECT DISTINCT receiver FROM acoustic.receivers",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return receiver_ids
  stringr::str_sort(data$receiver, numeric = TRUE)
}
