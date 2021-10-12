#' List all available animal project codes
#'
#' @param connection A connection to the ETN database. Defaults to `con`.
#'
#' @return A vector of all unique `project_code` of `type = "animal"` in
#'   `project.sql`.
#'
#' @export
list_animal_project_codes <- function(con = list(
                                        username = Sys.getenv("userid"),
                                        password = Sys.getenv("pwd")
                                      )) {
  connection <- connect_to_etn(con)

  project_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "project.sql", package = "etn")),
    .con = connection
  )
  query <- glue::glue_sql(
    "SELECT DISTINCT project_code FROM ({project_sql}) AS project WHERE project_type = 'animal'",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  sort(data$project_code)
}