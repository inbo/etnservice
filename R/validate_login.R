#' Check ETN Database Credentials
#'
#' @description
#' Validates user credentials for the ETN database by attempting to establish
#' a connection. Returns TRUE if the credentials are valid and FALSE otherwise.
#'
#' @param username character string containing the ETN database username
#' @param password character string containing the ETN database password
#'
#' @return logical; TRUE if credentials are valid and connection successful,
#'         FALSE if authentication fails
#'
#' @examples
#' \dontrun{
#' # Check if credentials are valid
#' is_valid <- check_credentials("my_username", "my_password")
#' }
#' @export
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
