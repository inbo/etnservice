#' List all available scientific names
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `scientific_name` present in
#'   `common.animal_release`.
#'
#' @export
list_scientific_names <- function(credentials = list(
                                    username = Sys.getenv("userid"),
                                    password = Sys.getenv("pwd")
                                  )) {
  connection <- connect_to_etn(credentials$username, credentials$password)
  query <- glue::glue_sql(
    "SELECT DISTINCT scientific_name FROM common.animal_release",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  stringr::str_sort(data$scientific_name)
}
