#' List all available cpod project codes
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `project_code` of `type = "cpod"` in
#'   `project.sql`.
#'
#' @export
list_cpod_project_codes <- function(credentials = list(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)) {

  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  # Check if we can make a connection
  check_connection(connection)

  project_query <- glue::glue_sql(
    readr::read_file(system.file("sql", "project.sql", package = "etnservice")),
    .con = connection
  )
  query <- glue::glue_sql(
    "SELECT DISTINCT project_code FROM ({project_query}) AS project WHERE project_type = 'cpod'",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  sort(data$project_code)
}
