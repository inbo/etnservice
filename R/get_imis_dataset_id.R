get_imis_dataset_id <- function(credentials = list(
                                  username = Sys.getenv("userid"),
                                  password = Sys.getenv("pwd")
                                ), acoustic_project_code = NULL) {
  credentials <- list(
    username = Sys.getenv("userid"),
    password = Sys.getenv("pwd")
  )

  # Check if credentials object has right shape
  check_credentials(credentials)

  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  # Argument checks and conversion to query elements -----
  if(is.null(acoustic_project_code)){
    acoustic_project_code_query <- "True"
  } else {
    acoustic_project_code_query <-
      glue::glue_sql(
        "project.projectcode IN ({acoustic_project_code*})",
        .con = connection
      )
  }


  # Build query -----
  query <- glue::glue_sql(
    "
  SELECT
  project.id AS project_id,
  project.projectcode AS project_code,
  CASE
    WHEN project.type = 'animal' THEN 'animal'
    WHEN project.type = 'network' AND project.context_type = 'acoustic_telemetry' THEN 'acoustic'
    WHEN project.type = 'network' AND project.context_type = 'cpod' THEN 'cpod'
  END AS project_type,
  project.telemtry_type AS telemetry_type,
  project.name AS project_name,
  -- ADD coordinating_organization
  -- ADD principal_investigator
  -- ADD principal_investigator_email
  project.startdate AS start_date,
  project.enddate AS end_date,
  project.latitude AS latitude,
  project.longitude AS longitude,
  project.moratorium AS moratorium,
  project.imis_dataset_id AS imis_dataset_id
  -- project.mrgid
  -- project.mda_folder_id
  FROM
  common.projects AS project
  WHERE
  {acoustic_project_code_query}
  ",
    .con = connection
  )


  # Execute query -----
  data <- DBI::dbGetQuery(connection, query)

  # Close connection
  DBI::dbDisconnect(connection)

  data$imis_dataset_id
}
