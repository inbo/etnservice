sql_get_projects <- function(acoustic_project_code = NULL, project_type = NULL, moratorium = NULL, include_otn = NULL) {
  # Get function description: arguments and expected data types
  fns <-
    DBI::dbGetQuery(connection,
                    glue::glue_sql("SELECT * FROM digital_twin.{DBI::SQL('get_functions')}()",
                                   .con = connection
                    ))

  # Build query via sql function
  argument <- "acoustic_project_code"
  value <- acoustic_project_code
  pg_class <-
    fns[fns$function_name == "get_projects", "description"] |>
    jsonlite::fromJSON() |>
    purrr::chuck(1, "arguments") |>
    purrr::chuck(argument, "argument_type")
  pg_array <- glue::glue_sql("ARRAY[{value*}]::{pg_class}",
                             .con = connection
  )

  sql_fn_args <-
    ifelse(
      # The shape of the test determines the length of the output
      is.null(acoustic_project_code),
      yes = "",
      no = glue::glue("p_{argument} => {pg_array}")
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
