#' Get acoustic project data
#'
#' Get data for acoustic projects, with options to filter results.
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#' @param acoustic_project_code Character (vector). One or more acoustic
#'   project codes. Case-insensitive.
#'
#' @return A tibble with acoustic project data, sorted by `project_code`. See
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
#' # Get all acoustic projects
#' get_acoustic_projects(credentials)
#'
#' # Get a specific acoustic project
#' get_acoustic_projects(credentials, acoustic_project_code = "demer")
get_acoustic_projects <- function(credentials = list(
                                    username = Sys.getenv("userid"),
                                    password = Sys.getenv("pwd")
                                  ),
                                  acoustic_project_code = NULL) {

  # Check if credentials object has right shape
  check_credentials(credentials)

  # create connection object
  connection <-
    connect_to_etn(credentials$username, credentials$password)

  # Check connection
  check_connection(connection)

  # Check acoustic_project_code
  if (is.null(acoustic_project_code)) {
    acoustic_project_code_query <- "True"
  } else {
    acoustic_project_code <- check_value(
      acoustic_project_code,
      list_acoustic_project_codes(credentials),
      "acoustic_project_code",
      lowercase = TRUE
    )
    acoustic_project_code_query <- glue::glue_sql(
      "LOWER(project.project_code) IN ({acoustic_project_code*})",
      .con = connection
    )
  }

  project_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "project.sql", package = "etnservice")),
    .con = connection
  )

  # Build query
  query <- glue::glue_sql("
    SELECT
      project.*
    FROM
      ({project_sql}) AS project
    WHERE
      project_type = 'acoustic'
      AND {acoustic_project_code_query}
    ", .con = connection)
  projects <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Sort data
  projects <-
    projects %>%
    dplyr::arrange(.data$project_code)

  dplyr::as_tibble(projects)
}
