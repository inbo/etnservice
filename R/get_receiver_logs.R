#' Retrieve log files/diagnostic information for acoustic receivers.
#'
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

}
