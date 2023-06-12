#' List all available animal ids
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#'
#' @return A vector of all unique `id_pk` present in `common.animal_release`.
#'
#' @export
list_animal_ids <- function(credentials = list(
                              username = Sys.getenv("userid"),
                              password = Sys.getenv("pwd")
                            )) {
  stopifnot(is.list(credentials))
  stopifnot(any(names(credentials) == c("username", "password")))

  connection <- connect_to_etn(credentials$username, credentials$password)

  query <- glue::glue_sql(
    "SELECT DISTINCT id_pk FROM common.animal_release",
    .con = connection
  )
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  sort(data$id_pk)
}
