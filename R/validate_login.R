#' Check ETN Database Credentials
#'
#' Validates user credentials for the ETN database by attempting to establish
#' a connection. Returns `TRUE` if the credentials are valid and `FALSE` otherwise.
#'
#' @param username Character string containing the ETN database username.
#' @param password Character string containing the ETN database password.
#'
#' @return Logical `TRUE` if credentials are valid and the connection is
#'   successful, `FALSE` if authentication fails.
#'
#' @export
#' @examples
#' # Check if credentials are valid
#'  validate_login("invalid_username", "invalid_password")

validate_login <- function(username, password) {
  assertthat::assert_that(!missing(username),
                          msg = "No username provided.")
  assertthat::assert_that(!missing(password),
                          msg = "No password provided.")

  tryCatch(
    {
      connection <- connect_to_etn(username, password)
      DBI::dbDisconnect(connection)
      return(TRUE)
    },
    error = function(e) {
      return(FALSE)
    }
  )
}
