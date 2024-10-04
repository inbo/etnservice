#' Connect to the ETN database
#'
#' Connect to the ETN database using username and password.
#'
#' @param username Character. Username to use for the connection.
#' @param password Character. Password to use for the connection.
#'
#' @return ODBC connection to ETN database.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Connect to the ETN database using your rstudio.lifewatch.be username and
#' # password, and save as the default connection variable "con"
#' con <- connect_to_etn()
#'
#' # Connect to the ETN database using non-default username and password
#' con <- connect_to_etn(username = "my_username", password = "my_password")
#' }
connect_to_etn <- function(username, password) {
  tryCatch(
    {
      # Attempt to connect to the database with the provided credentials
      connection <- DBI::dbConnect(
        odbc::odbc(),
        "ETN",
        uid = paste("", tolower(username), "", sep = ""),
        pwd = paste("", password, "", sep = "")
      )
      return(connection)
    },
    error = function(e) {
        # When the database connection fails, return the error message and some
        # directions to try again. This is usually due to a wrong password, so
        # let's include that as a clue in the error message.
        stop(glue::glue(e$message,
                        "Failed to connect to the database.",
                        "Did you enter the right username/password?",
                        "Please try again.",
                        .sep = "\n"),
        call. = FALSE)

    }
  )
}
