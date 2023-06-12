#' Get cpod project data
#'
#' Get data for cpod projects, with options to filter results.
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#' @param cpod_project_code Character (vector). One or more cpod project
#'   codes. Case-insensitive.
#'
#' @return A tibble with animal project data, sorted by `project_code`. See
#'   also
#'   [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @examples
#' # Set credentials
#' credentials <- list(
#'    username = Sys.getenv("userid"),
#'    password = Sys.getenv("pwd")
#'  )
#'
#' # Get all animal projects
#' get_cpod_projects(credentials)
#'
#' # Get a specific animal project
#' get_cpod_projects(credentials, cpod_project_code = "cpod-lifewatch")
get_cpod_projects <- function(credentials = list(
                                username = Sys.getenv("userid"),
                                password = Sys.getenv("pwd")
                              ),
                              cpod_project_code = NULL) {
  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  # Check connection
  check_connection(connection)

  # Check cpod_project_code
  if (is.null(cpod_project_code)) {
    cpod_project_code_query <- "True"
  } else {
    cpod_project_code <- check_value(
      cpod_project_code,
      list_cpod_project_codes(credentials),
      "cpod_project_code",
      lowercase = TRUE
    )
    cpod_project_code_query <- glue::glue_sql(
      "LOWER(project.project_code) IN ({cpod_project_code*})",
      .con = connection
    )
  }

  project_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "project.sql", package = "etn")),
    .con = connection
  )

  # Build query
  query <- glue::glue_sql("
    SELECT
      project.*
    FROM
      ({project_sql}) AS project
    WHERE
      project_type = 'cpod'
      AND {cpod_project_code_query}
    ", .con = connection)
  projects <- DBI::dbGetQuery(connection, query)

  # Sort data
  projects <-
    projects %>%
    dplyr::arrange(.data$project_code)
  # Close connection
  DBI::dbDisconnect(connection)

  # Return data
  dplyr::as_tibble(projects)
}
