#' List all available scientific names
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `scientific_name` present in
#'   `common.animal_release`.
#'
#' @export
list_scientific_names <- function(con = list(
                                    username = Sys.getenv("userid"),
                                    password = Sys.getenv("pwd")
                                  )) {
  connection <- connect_to_etn(con$username, con$password)
  query <- glue::glue_sql(
    "SELECT DISTINCT scientific_name FROM common.animal_release",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  sort(data$scientific_name)
}
