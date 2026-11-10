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

  # Check if the provided value for arguments is valid, and convert if neccesairy.
  args <-
    purrr::imap(args, \(value, argument){
      # For arguments ending on code, id or name, check the value against the
      # respective list_ function, and convert to lowercase to match against the
      # database (this is not built into the sql functions).
      if (
        any(
          stringr::str_ends(argument, stringr::fixed("code")),
          stringr::str_ends(argument, stringr::fixed("name")),
          stringr::str_ends(argument, stringr::fixed("id"))
        )
      ) {
        check_value(
          x = value,
          y = do.call(
            # Call the argument listing function by guessing the function name
            glue::glue("list_", argument, "s"),
            # No arguments needed for list functions
            args = list()
          ),
          lowercase = TRUE
        )
        # For all other arguments, don't use check_value()
      } else {
        value
      }
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
      pg_array <- glue::glue_sql("ARRAY[{value*}]",
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
      glue::glue("p_{argument} => {pg_value}::{DBI::SQL(pg_class)}",
                 pg_value = ifelse(
                   test = pg_class == "boolean",
                   # Convert R logical to SQL boolean
                   yes = as.integer(value),
                   no = pg_array
                 ))
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
db_function_args <- function() {
  fns <-
    DBI::dbGetQuery(connection,
                    glue::glue_sql("SELECT * FROM digital_twin.{DBI::SQL('get_functions')}()",
                                   .con = connection
                    ))

  tibble::tibble(
    fn_name = fns$function_name,
    fn_desc = fns[fns$function_name == fn_name, "description"]
  ) |>
    dplyr::mutate(fn_desc = purrr::map(fn_desc, ~jsonlite::fromJSON(.x) |>
                                        purrr::chuck(1, "arguments"))) |>
    tidyr::unnest_longer(fn_desc, indices_to = "argument", values_to = "arg_values") |>
    tidyr::unnest_wider(arg_values) |>
    dplyr::distinct()

}
