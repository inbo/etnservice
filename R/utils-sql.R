sql_get_projects <- function(acoustic_project_code = NULL, project_type = NULL, moratorium = NULL, include_otn = NULL) {
  # Get function description: arguments and expected data types
  fns <-
    DBI::dbGetQuery(connection,
                    glue::glue_sql("SELECT * FROM digital_twin.{DBI::SQL('get_functions')}()",
                                   .con = connection
                    ))

  # Capture the function arguments to translate into SQL
  args <-
    as.list(
    rlang::call_match(call = sys.call(),
                      fn = sys.function(),
                      defaults = TRUE)
  )
  # Build query via sql function
    sql_fn_args <-
    purrr::imap(
      # Drop function name
    args[-1],
    \(value, argument) {
      pg_class <-
        fns[fns$function_name == "get_projects", "description"] |>
        jsonlite::fromJSON() |>
        purrr::chuck(1, "arguments") |>
        purrr::chuck(argument, "argument_type")
      pg_array <- glue::glue_sql("ARRAY[{value*}]::{pg_class}",
                                 value = value,
                                 # Look up the postgress class via the result of digital_twin.get_functions()
                                 pg_class = fns[fns$function_name == "get_projects", "description"] |>
                                   jsonlite::fromJSON() |>
                                   purrr::chuck(1, "arguments") |>
                                   purrr::chuck(argument, "argument_type"),
                                 .con = connection
      )
      ifelse(
        # The shape of the test determines the length of the output
        is.null(value),
        yes = rlang::missing_arg,
        no = glue::glue("p_{argument} => {pg_array}")
      )
    }
  )

  # Place query via sql function
  query <-
    glue::glue_sql("SELECT * FROM digital_twin.get_projects({DBI::SQL(sql_fn_args)})",
                   .con = connection)
  projects <-
    DBI::dbGetQuery(conn = connection, statement = query)
  # Return projects data.frame
  projects
}
