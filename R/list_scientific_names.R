#' List all available scientific names
#'
#' @param connection A connection to the ETN database. Defaults to `credentials`.
#'
#' @return A vector of all unique `scientific_name` present in
#'   `common.animal_release`.
#'
#' @export
list_scientific_names <- function(credentials = list(
                                    username = Sys.getenv("userid"),
                                    password = Sys.getenv("pwd")
                                  )) {
  connection <- connection <- connect_to_etn(credentials$username, credentials$password)
  query <- glue::glue_sql(
    "SELECT DISTINCT scientific_name FROM common.animal_release",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  sort(data$scientific_name)
}
