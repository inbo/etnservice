#' List all available animal project codes
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `project_code` of `type = "animal"` in
#'   `project.sql`.
#'
#' @export
list_animal_project_codes <- function(credentials = list(
                                        username = Sys.getenv("userid"),
                                        password = Sys.getenv("pwd")
                                      )) {
  connection <- connect_to_etn(credentials$username, credentials$password)

  project_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "project.sql", package = "etnservice")),
    .con = connection
  )
  query <- glue::glue_sql(
    "SELECT DISTINCT project_code FROM ({project_sql}) AS project WHERE project_type = 'animal'",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  sort(data$project_code)
}
