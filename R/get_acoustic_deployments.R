#' Get acoustic deployment data
#'
#' Get data for deployments of acoustic receivers, with options to filter
#' results.
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#' @param deployment_id Integer (vector). One or more deployment identifiers.
#' @param receiver_id Character (vector). One or more receiver identifiers.
#' @param acoustic_project_code Character (vector). One or more acoustic
#'   project codes. Case-insensitive.
#' @param station_name Character (vector). One or more deployment station
#'   names.
#' @param open_only Logical. Restrict deployments to those that are currently
#'   open (i.e. no end date defined). Defaults to `FALSE`.
#'
#' @return A tibble with acoustic deployment data, sorted by
#'   `acoustic_project_code`, `station_name` and `deploy_date_time`. See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @examples
#' # Set credentials
#' credentials <- list(
#'    username = Sys.getenv("ETN_USER"),
#'    password = Sys.getenv("ETN_PWD")
#'  )
#'
#' # Get all acoustic deployments
#' get_acoustic_deployments(credentials)
#'
#' # Get specific acoustic deployment
#' get_acoustic_deployments(credentials, deployment_id = 1437)
#'
#' # Get acoustic deployments for a specific receiver
#' get_acoustic_deployments(credentials, receiver_id = "VR2W-124070")
#'
#' # Get open acoustic deployments for a specific receiver
#' get_acoustic_deployments(credentials, receiver_id = "VR2W-124070", open_only = TRUE)
#'
#' # Get acoustic deployments for a specific acoustic project
#' get_acoustic_deployments(credentials, acoustic_project_code = "demer")
#'
#' # Get acoustic deployments for two specific stations
#' get_acoustic_deployments(credentials, station_name = c("de-9", "de-10"))
get_acoustic_deployments <- function(
    credentials = list(username = Sys.getenv("ETN_USER"),
                       password = Sys.getenv("ETN_PWD")),
    deployment_id = NULL,
    receiver_id = NULL,
    acoustic_project_code = NULL,
    station_name = NULL,
    open_only = FALSE) {

  # Check if credentials object has right shape
  check_credentials(credentials)

  # create connection object
  connection <-
    connect_to_etn(credentials$username, credentials$password)

  # Ensure the connection is closed when the function exits, even when it fails.
  withr::defer(
    if (DBI::dbIsValid(connection)) {
      DBI::dbDisconnect(connection)
    }
  )

  # Check if we can make a connection
  check_connection(connection)

  # Check deployment_id
  if (is.null(deployment_id)) {
    # deployment_id_query <- "True"
  } else {
    deployment_id <- check_value(
      deployment_id,
      list_deployment_ids(credentials),
      "receiver_id"
    )
    deployment_id_query <- glue::glue_sql(
      "dep.id_pk IN ({deployment_id*})",
      .con = connection
    )
  }

  # Check receiver_id
  if (is.null(receiver_id)) {
    # receiver_id_query <- "True"
  } else {
    receiver_id <- check_value(
      receiver_id,
      list_receiver_ids(credentials),
      "receiver_id"
    )
    receiver_id_query <- glue::glue_sql(
      "receiver.receiver IN ({receiver_id*})",
      .con = connection
    )
  }

  # Check acoustic_project_code
  if (is.null(acoustic_project_code)) {
    # acoustic_project_code_query <- "True"
  } else {
    acoustic_project_code <- check_value(
      acoustic_project_code,
      list_acoustic_project_codes(credentials),
      "acoustic_project_code",
      lowercase = TRUE
    )
    acoustic_project_code_query <- glue::glue_sql(
      "LOWER(network_project.projectcode) IN ({acoustic_project_code*})",
      .con = connection
    )
  }

  # Check station_name
  if (is.null(station_name)) {
    # station_name_query <- "True"
  } else {
    station_name <- check_value(
      station_name,
      list_station_names(credentials),
      "station_name"
    )
    station_name_query <- glue::glue_sql(
      "dep.station_name IN ({station_name*})",
      .con = connection
    )
  }

  # Build query
  sql_fn_args <- format_sql_args(
    function = "get_deployments",
    deployment_ids = deployment_id,
    receiver_ids = receiver_id,
    acoustic_project_codes = acoustic_project_code,
    station_names = station_name,
    # This function returns acoustic deployments only
    deployment_type = "Acoustic"
  )

  query <- glue::glue_sql("
    SELECT * FROM digital_twin.get_deployments({DBI::SQL(sql_fn_args)})
                          ", .con = connection)
  deployments <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  # Filter on open deployments
  if (open_only) {
    deployments <- filter(deployments, is.na(.data$recover_date_time))
  }

  # Sort data
  deployments <-
    deployments |>
    dplyr::arrange(
      .data$acoustic_project_code,
      factor(.data$station_name, levels = list_station_names(credentials)),
      .data$deploy_date_time
    )

  dplyr::as_tibble(deployments)
}
