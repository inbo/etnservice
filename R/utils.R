# HELPER FUNCTIONS

#' Check the validity of the database connection to ETN
#'
#' @param a connection object
#' @family helper functions
#' @noRd
check_connection <- function(con) {
  assertthat::assert_that(
    methods::is(con, "PostgreSQL"),
    msg = "Not a connection object to database."
  )
  assertthat::assert_that(con@info$dbname == "ETN")
}

#' Check input value against valid values
#'
#' @param x Value(s) to test.
#'   `NULL` values will automatically pass.
#' @param y Value(s) to test against.
#' @param name Name of the parameter.
#' @param lowercase If `TRUE`, the case of `x` and `y` values will ignored and
#'   `x` values will be returned lowercase.
#' @return Error or (lowercase) `x` values.
#' @family helper functions
#' @noRd
check_value <- function(x, y, name = "value", lowercase = FALSE) {
  # Remove NA from valid values
  y <- y[!is.na(y)]

  # Ignore case
  if (lowercase) {
    x <- tolower(x)
    y <- tolower(y)
  }

  # Check value(s) against valid values
  assertthat::assert_that(
    all(x %in% y), # Returns TRUE for x = NULL
    msg = glue::glue(
      "Can't find {name} `{x}` in: {y}",
      x = glue::glue_collapse(x, sep = "`, `", last = "` and/or `"),
      y = glue::glue_collapse(y, sep = ", ", width = 300)
    )
  )

  return(x)
}

#' Check if the string input can be converted to a date
#'
#' Returns `FALSE`` or the cleaned character version of the date
#' (acknowledgments to micstr/isdate.R).
#'
#' @param date_time Character. A character representation of a date.
#' @param date_name Character. Informative description to user about type of
#'   date.
#' @return `FALSE` | character
#' @family helper functions
#' @noRd
#' @examples
#' \dontrun{
#' check_date_time("1985-11-21")
#' check_date_time("1985-11")
#' check_date_time("1985")
#' check_date_time("1985-04-31") # invalid date
#' check_date_time("01-03-1973") # invalid format
#' }
check_date_time <- function(date_time, date_name = "start_date") {
  parsed <- tryCatch(
    lubridate::parse_date_time(date_time, orders = c("ymd", "ym", "y")),
    warning = function(warning) {
      if (grepl("No formats found", warning$message)) {
        stop(glue::glue(
          "The given {date_name}, {date_time}, is not in a valid ",
          "date format. Use a yyyy-mm-dd format or shorter, ",
          "e.g. 2012-11-21, 2012-11 or 2012."
        ))
      } else {
        stop(glue::glue(
          "The given {date_name}, {date_time} can not be interpreted ",
          "as a valid date."
        ))
      }
    }
  )
  as.character(parsed)
}

#' Get the credentials from environment variables, or set them manually
#'
#' By default, it's not necessary to set any values in this function as it's
#' used in the background by other functions. However, if you wish to provide
#' your username and password on a per function basis, this function allows you
#' to do so.
#'
#' @param username ETN Data username, by default read from the environment, but
#'   you can set it manually too.
#' @param password ETN Data password, by default read from the environment, but
#'   you can set it manually too.
#'
#' @return A string as it is ingested by other functions that need
#'   authentication
#' @family helper functions
#' @noRd

get_credentials <-
  function(username = Sys.getenv("userid"),
           password = Sys.getenv("pwd")) {
    stringr::str_glue('list(username = "{username}", password = "{password}")')
  }

#' Check if the provided credentials are valid.
#'
#' This function checks if the provided credentials contain a "username" and "password" field,
#' and if both fields are of type character. It also verifies that the credentials object has a length of 2.
#'
#' @param credentials A list or data frame containing the credentials to be checked.
#'
#' @return TRUE if the credentials are valid, an error otherwise
#'
#' @examples
#' \dontrun{
#' credentials <- list(username = "john_doe", password = "password123")
#' check_credentials(credentials)
#' #> [1] TRUE
#' }
check_credentials <- function(credentials) {

  assertthat::assert_that(
    assertthat::has_name(credentials, "username"),
    msg = "The credentials need to contain a 'username' field."
  )

  assertthat::assert_that(
    assertthat::has_name(credentials, "password"),
    msg = "The credentials need to contain a 'password' field."
  )

  assertthat::assert_that(
    length(credentials) == 2,
    msg = "The credentials object should have a length of 2."
  )

  assertthat::assert_that(
    assertthat::is.string(credentials$username)
  )

  assertthat::assert_that(
    assertthat::is.string(credentials$password)
  )

  return(TRUE)
}

#' Extract the OCPU temp key from a response object
#'
#' When posting a request to the opencpu api service without the json flag, a
#' response object is returned containing all the generated objects, with a
#' unique temp key in the path. To retrieve these objects in a subsequent GET
#' request, it is convenient to retrieve this temp key from the original
#' response object
#'
#' @param response The response resulting from a POST request to a opencpu api
#'   service
#'
#' @return the OCPU temp key to be used as part of a GET request to an opencpu
#'   api service
#' @family helper functions
#' @noRd
extract_temp_key <- function(response) {
  response %>%
    httr::content(as = "text") %>%
    stringr::str_extract("(?<=tmp\\/).{15}(?=\\/)")
}

#' Retrieve the result of a function called to the opencpu api
#'
#' Loading the evaluated object into the current environment, to be used
#' internally in functions calling the opencpu api service to convert a response
#' object included in the response from a post request, to the corresponding
#' objects resulting from the original call.
#'
#' @param temp_key the temp key returned from the POST request to the API
#'
#' @return the uncompressed object resulting form a GET request to the API
#' @family helper functions
#' @noRd
#' @examples
#' \dontrun{
#' etn:::extract_temp_key(response) %>% get_val()
#' }
#'
#' # using the opencpu test instance
#' api_url <- "https://cloud.opencpu.org/ocpu/library/stats/R/rnorm"
#' httr::POST(api_url, body = list(n = 10, mean = 5)) %>%
#'   extract_temp_key() %>%
#'   get_val(api_domain = "https://cloud.opencpu.org/ocpu")
get_val <- function(temp_key, api_domain = "https://opencpu.lifewatch.be") {
  httr::GET(
    stringr::str_glue(
      "{api_domain}",
      "tmp/{temp_key}/R/.val/rds",
      .sep = "/"
    )
  ) %>%
    httr::content(as = "raw") %>%
    rawConnection() %>%
    gzcon() %>%
    readRDS()
}

#' Calculate the MD5 checksum of a string
#'
#' This function calculates the MD5 checksum of a given string by writing it to a
#' temporary file and then using the `tools::md5sum` function to compute the checksum.
#'
#' Its results are different than via digest::digest()
#'
#' @param str A character string for which the MD5 checksum is to be calculated.
#'
#' @return A character string representing the MD5 checksum of the input string.
#' @family helper functions
#' @noRd
#' @examples
#' md5sum("Hello, World!")
md5sum <- function(str) {
  # Set path for tempfile
  temp_file <- tempfile()
  # Delete when done
  on.exit(unlink(temp_file))
  # Write string to tempfile
  readr::write_lines(str, temp_file)
  # Checksum
  unname(tools::md5sum(temp_file))
}
