#' Get acoustic receiver data
#'
#' Get data for acoustic receivers, with options to filter results.
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#' @param receiver_id Character (vector). One or more receiver identifiers.
#' @param status Character. One or more statuses, e.g. `available` or `broken`.
#'
#' @return A tibble with acoustic receiver data, sorted by `receiver_id`. See
#'   also
#'   [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'   Values for `owner_organization` will only be visible if you are member of
#'   the group.
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
#' # Get all acoustic receivers
#' get_acoustic_receivers(credentials)
#'
#' # Get lost and broken acoustic receivers
#' get_acoustic_receivers(credentials, status = c("lost", "broken"))
#'
#' # Get a specific acoustic receiver
#' get_acoustic_receivers(credentials, receiver_id = "VR2W-124070")
get_acoustic_receivers <- function(credentials = list(
                                     username = Sys.getenv("userid"),
                                     password = Sys.getenv("pwd")
                                   ),
                                   receiver_id = NULL,
                                   status = NULL) {
  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  # Check connection
  check_connection(connection)

  # Check receiver_id
  if (is.null(receiver_id)) {
    receiver_id_query <- "True"
  } else {
    valid_receiver_ids <- list_receiver_ids(credentials)
    check_value(receiver_id, valid_receiver_ids, "receiver_id")
    receiver_id_query <- glue::glue_sql(
      "receiver.receiver IN ({receiver_id*})",
      .con = connection
    )
  }

  # Check status
  if (is.null(status)) {
    status_query <- "True"
  } else {
    valid_status <- c("active", "available", "broken", "inactive", "lost", "returned")
    check_value(status, valid_status, "status")
    status_query <- glue::glue_sql(
      "receiver.controlled_status IN ({status*})",
      .con = connection
    )
  }

  receiver_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "receiver.sql", package = "etnservice")),
    .con = connection
  )
  acoustic_tag_id_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "acoustic_tag_id.sql", package = "etnservice")),
    .con = connection
  )

  # Build query
  query <- glue::glue_sql("
    SELECT
      receiver.receiver AS receiver_id,
      manufacturer.project AS manufacturer,
      receiver.model_number AS receiver_model,
      receiver.serial_number AS receiver_serial_number,
      receiver.modem_address AS modem_address,
      receiver.controlled_status AS status,
      receiver.expected_battery_life AS battery_estimated_life,
      CASE
        WHEN receiver.owner_group_fk_limited IS NOT NULL THEN owner_organization.name
        ELSE NULL
      END AS owner_organization,
      financing_project.projectcode AS financing_project,
      acoustic_tag_id.acoustic_tag_id AS built_in_acoustic_tag_id,
      receiver.ar_model_number AS ar_model,
      receiver.ar_serial_number AS ar_serial_number,
      receiver.ar_expected_battery_life AS ar_battery_estimated_life,
      receiver.ar_voltage_at_deploy AS ar_voltage_at_deploy,
      receiver.ar_interrogate_code AS ar_interrogate_code,
      receiver.ar_receive_frequency AS ar_receive_frequency,
      receiver.ar_reply_frequency AS ar_reply_frequency,
      receiver.ar_ping_rate AS ar_ping_rate,
      receiver.ar_enable_code_address AS ar_enable_code_address,
      receiver.ar_release_code AS ar_release_code,
      receiver.ar_disable_code AS ar_disable_code,
      receiver.ar_tilt_code AS ar_tilt_code,
      receiver.ar_tilt_after_deploy AS ar_tilt_after_deploy
      -- receiver.id_pk
      -- receiver.external_id
    FROM
      ({receiver_sql}) AS receiver
      LEFT JOIN common.manufacturer AS manufacturer
          ON receiver.manufacturer_fk = manufacturer.id_pk
      LEFT JOIN common.etn_group AS owner_organization
        ON receiver.owner_group_fk_limited = owner_organization.id_pk
      LEFT JOIN common.projects AS financing_project
        ON receiver.financing_project_fk = financing_project.id
      LEFT JOIN ({acoustic_tag_id_sql}) AS acoustic_tag_id
        ON receiver.built_in_tag_device_fk = acoustic_tag_id.tag_device_fk
    WHERE
      receiver.receiver_type = 'acoustic_telemetry'
      AND {receiver_id_query}
      AND {status_query}
    ", .con = connection)
  receivers <- DBI::dbGetQuery(connection, query)

  # Sort data
  receivers <-
    receivers %>%
    dplyr::arrange(.data$receiver_id)

  # Close connection
  DBI::dbDisconnect(connection)

  # Return receivers
  dplyr::as_tibble(receivers)
}
