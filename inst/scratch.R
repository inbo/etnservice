# Functions ---
# "get_animals"
# "get_cpoddata"
# "get_deployments"
# "get_detections_animal"
# "get_detections_network"
# "get_functions"
# "get_projects"
# "get_receivers"
# "get_tags"

fn <- DBI::SQL("get_functions")
query <- glue::glue_sql("SELECT * FROM digital_twin.{fn}()", .con = connection)
fns <- DBI::dbGetQuery(connection, query)
fns$description[9]

val <- "SWIMWAY_2021"
query <- glue::glue_sql(
  "SELECT * FROM digital_twin.get_animals(p_animal_project_codes = {val})
  ",
  .con = connection
)
res <- DBI::dbGetQuery(connection, query)


query <-
  glue::glue_sql(
    "
SELECT pg_get_function_arguments(oid) AS
 parameters
FROM
 pg_proc
WHERE proname = 'get_projects';"
  , .con = connection)

params <- DBI::dbGetQuery(connection, query)


query <- glue::glue_sql(
  "SELECT * FROM digital_twin.get_projects(p_moratorium => False)
  ",
  .con = connection
)
DBI::dbGetQuery(connection, query)


# function factory --------------------------------------------------------

fn <- DBI::SQL("get_functions")
query <- glue::glue_sql("SELECT * FROM digital_twin.{fn}()", .con = connection)
fns <- DBI::dbGetQuery(connection, query)

for fn_name in fns$function_name {

  arguments <- dplyr::filter(fns, function_name == fn_name) |>
    dplyr::pull("description") |>
    jsonlite::fromJSON() |>
    purrr::flatten() |>
    purrr::chuck("arguments") |>
    names() |>
    unique()

  assign(fn_name, {
    function(rlang::eval_tidy(arguments)){

    }
  }

  }

# Function factory --------------------------------------------------------


fetch_sql_fn <- function(fn_name, conn) {

  arguments <- dplyr::filter(fns, .data$function_name == fn_name) |>
    dplyr::pull("description") |>
    jsonlite::fromJSON() |>
    purrr::flatten() |>
    purrr::chuck("arguments") |>
    names() |>
    unique()

  rlang::new_function(
    purrr::map(purrr::set_names(arguments), \(){
      NULL
    }),
    body = {
      sql_args <-
        purrr::map(purrr::set_names(arguments), ~NULL) |>
        (\(x){
          paste0(names(x), " => ", x, collapse = ",")
        })() |>
        DBI::SQL()
      query <-
        glue::glue_sql("
        SELECT * FROM digital_twins.{DBI::SQL(fn_name)}({sql_args})
        ", .con = conn)
      DBI::dbGetQuery(conn, query)
    }
  )
}


# get_proj ----------------------------------------------------------------
acoustic_project_code <- c("Winde_Tjeukemeer")
acoustic_project_code <- c("Winde_Tjeukemeer", "lauwersmeer")
acoustic_project_code <- NULL

sql_get_projects(acoustic_project_code)
