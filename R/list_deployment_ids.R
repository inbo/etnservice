#' List all available receiver ids
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `id_pk` present in `acoustic.deployments`.
#'
#' @export
list_deployment_ids <- function(credentials = list(
                                  username = Sys.getenv("ETN_USER"),
                                  password = Sys.getenv("ETN_PWD")
                                )) {
  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  query <- glue::glue_sql(
    "SELECT DISTINCT id_pk FROM acoustic.deployments",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  stringr::str_sort(data$id, numeric = TRUE)
}
