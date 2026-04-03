#' Retrieve log files/diagnostic information for acoustic receivers.
#'
#' @param deployment_id Integer (number). One and only one deployment
#'   identifier.
#' @inheritParams get_acoustic_detections
#' @inheritParams get_acoustic_deployments
#' @inheritParams list_animal_ids
#'
#' @returns A tibble with receiver diagnostics data. The data is embedded in a
#'   `log_data` column that is JSON formatted.
#' @export
#'
#' @examples
#' get_receiver_logs(deployment_id = 6028,
#'                   start_date = "2020",
#'                   end_date = "2020-02-01")
get_receiver_logs <- function(credentials = list(
                                username = Sys.getenv("ETN_USER"),
                                password = Sys.getenv("ETN_PWD")),
                              deployment_id,
                              start_date = NULL,
                              end_date = NULL,
                              receiver_id = NULL,
                              limit = FALSE) {
  # Check if credentials object has right shape
  check_credentials(credentials)

  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  # Check connection
  check_connection(connection)

  # Check deployment_id
  if(missing(deployment_id)){
    rlang::abort(
      message = "Please provide at least one `deployment_id`",
      class = "etn_no_dep_id_supplied"
    )
  } else {
    # If the deployment ID is present:
    deployment_id <- check_value(
      deployment_id,
      list_deployment_ids(credentials),
      "deployment_id"
    )
    deployment_id_query <- glue::glue_sql(
      "deployment_fk IN ({deployment_id*})",
      .con = connection
    )
  }

  # Check start_date
  if (is.null(start_date)) {
    start_date_query <- "True"
  } else {
    start_date <- check_date_time(start_date, "start_date")
    start_date_query <- glue::glue_sql("log.datetime >= {start_date}", .con = connection)
  }

  # Check end_date
  if (is.null(end_date)) {
    end_date_query <- "True"
  } else {
    end_date <- check_date_time(end_date, "end_date")
    end_date_query <- glue::glue_sql("log.datetime < {end_date}", .con = connection)
  }

  # Check receiver_id
  if (is.null(receiver_id)) {
    receiver_id_query <- "True"
  } else {
    receiver_id <- check_value(
      receiver_id,
      list_receiver_ids(credentials),
      name = "receiver_id"
    )
    receiver_id_query <- glue::glue_sql(
      "receiver.receiver IN ({receiver_id*})",
      .con = connection
    )
  }

  # Check limit
  assertthat::assert_that(is.logical(limit),
                          msg = "limit must be a logical: TRUE/FALSE.")
  if (limit) {
    limit_query <- glue::glue_sql("LIMIT 100", .con = connection)
  } else {
    limit_query <- glue::glue_sql("LIMIT ALL}", .con = connection)
  }

  # Build query
  query <-
    glue::glue_sql(
    "SELECT DISTINCT
      log.deployment_fk AS deployment_id,
      receiver.receiver AS receiver_id,
      log.datetime AS datetime,
      log.record_type,
      log.log_data
    FROM
      acoustic.receiver_logs_data AS log
      LEFT JOIN acoustic.deployments AS dep
        ON log.deployment_fk = dep.id_pk
      LEFT JOIN acoustic.receivers AS receiver
        ON dep.receiver_fk = receiver.id_pk
    WHERE
      {start_date_query}
      AND {end_date_query}
      AND {deployment_id_query}
      AND {receiver_id_query}
    {limit_query}",
    .con = connection,
    .null = "NULL"
    )

  ## Query database
  receiver_logs <- DBI::dbGetQuery(connection, query)
  # Close connection
  DBI::dbDisconnect(connection)

  # Sort data
  receiver_logs <-
    receiver_logs %>%
    dplyr::arrange(factor(
      .data$deployment_id, levels = list_deployment_ids(credentials)
    ))

  dplyr::as_tibble(receiver_logs)
}
