#' List all available acoustic project codes
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `project_code` of `type = "acoustic"` in
#'   `project.sql`.
#'
#' @export
list_acoustic_project_codes <- function(credentials = list(
                                          username = Sys.getenv("userid"),
                                          password = Sys.getenv("pwd")
                                        )) {
  connection <- connect_to_etn(credentials$username, credentials$password)

  project_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "project.sql", package = "etnservice")),
    .con = connection
  )
  query <- glue::glue_sql(
    "SELECT DISTINCT project_code FROM ({project_sql}) AS project WHERE project_type = 'acoustic'",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return acoustic_project_codes
  stringr::str_sort(data$project_code)
}
