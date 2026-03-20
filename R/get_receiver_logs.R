#' Retrieve log files/diagnostic information for acoustic receivers.
#'
#' @param deployment_id Integer (number). One and only one deployment identifier.
#' @inheritParams get_acoustic_detections
#' @inheritParams get_acoustic_deployments
#' @inheritParams list_animal_ids
#'
#' @returns A tibble with receiver diagnostics data.
#' @export
#'
#' @examples
#' get_receiver_logs(deployment_id = 6028)
get_receiver_logs <- function(credentials = list(
                                username = Sys.getenv("userid"),
                                password = Sys.getenv("pwd")),
                              deployment_id = NULL,
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
  if(assertthat::validate_that(!missing(deployment_id))){
    # If the deployment ID is present:
    deployment_id <- check_value(
      deployment_id,
      list_deployment_ids(connection),
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
    start_date_query <- glue::glue_sql("det.datetime >= {start_date}", .con = connection)
  }

  # Check end_date
  if (is.null(end_date)) {
    end_date_query <- "True"
  } else {
    end_date <- check_date_time(end_date, "end_date")
    end_date_query <- glue::glue_sql("det.datetime < {end_date}", .con = connection)
  }

  # Check receiver_id
  if (is.null(receiver_id)) {
    receiver_id_query <- "True"
  } else {
    receiver_id <- check_value(
      receiver_id,
      list_receiver_ids(connection),
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

  NULL
}
