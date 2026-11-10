#' Get project data from the digital twin SQL function
#'
#'
#' @param acoustic_project_code Character vector of acoustic project codes to
#'   filter on. Defaults to `NULL` (no filter).
#' @param project_type Character vector of project types to filter on. Defaults
#'   to `NULL` (no filter).
#' @param moratorium Logical vector to filter on the moratorium flag. Defaults
#'   to `NULL` (no filter).
#' @param include_otn Logical vector to filter on whether projects are included
#'   in OTN. Defaults to `NULL` (no filter).
#'
#' @returns A tibble with project data, sorted by `project_code`.
#'
#' @examples
#' sql_get_projects(acoustic_project_code = "demer")
#' sql_get_projects(acoustic_project_code = "Winde_Tjeukemeer", moratorium = TRUE)
sql_get_projects <- function(acoustic_project_code = NULL, project_type = NULL, moratorium = NULL, include_otn = NULL) {
  # Get function description: arguments and expected data types
  fns <-
    DBI::dbGetQuery(connection,
                    glue::glue_sql("SELECT * FROM digital_twin.{DBI::SQL('get_functions')}()",
                                   .con = connection
                    ))

  # Capture the function arguments to translate into SQL
  args <-
    mget(names(formals()), envir = environment()) |>
    # Drop arguments set to NULL, we don't need to pass these to the sql function
    purrr::compact()

  # For arguments ending on code, id or name, check if they contain a valid value.
  args |>
    purrr::keep_at(\(arg) {
      stringr::str_ends(arg, stringr::fixed("code")) |
          stringr::str_ends(arg, stringr::fixed("id")) |
          stringr::str_ends(arg, stringr::fixed("name")
      )
          }) |>
    purrr::imap(\(value, argument) {
      check_value(value, do.call(
        # Call the argument listing function by guessing the function name
        glue::glue("list_", argument, "s"),
        # No arguments needed for list functions
        args = list()
      ))
    })

  # Build query via sql function,
    sql_fn_args <-
    purrr::imap(
      # Drop function name
    args,
    \(value, argument) {
      pg_class <-
        fns[fns$function_name == "get_projects", "description"] |>
        jsonlite::fromJSON() |>
        purrr::chuck(1, "arguments") |>
        purrr::chuck(argument, "argument_type")
      pg_array <- glue::glue_sql("ARRAY[{value*}]::{DBI::SQL(pg_class)}",
                                 # Stop DBI from converting logicals into integers
                                 value = as.character(value),
                                 # Avoid the class being wrapped in ticks by glue
                                 # Look up the postgress class via the result of digital_twin.get_functions()
                                 pg_class = fns[fns$function_name == "get_projects", "description"] |>
                                   jsonlite::fromJSON() |>
                                   purrr::chuck(1, "arguments") |>
                                   purrr::chuck(argument, "argument_type"),
                                 .con = connection
      )
      glue::glue("p_{argument} => {pg_array}")
    }
  ) |>
      glue::glue_sql_collapse(sep = ", ")

  # Place query via sql function
  query <-
    glue::glue_sql("SELECT * FROM digital_twin.get_projects({DBI::SQL(sql_fn_args)})",
                   .con = connection)
  projects <-
    DBI::dbGetQuery(conn = connection, statement = query)
  # Return projects data.frame
  projects
}
