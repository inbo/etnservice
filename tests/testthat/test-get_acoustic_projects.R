credentials <- list(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test_that("get_acoustic_projects() returns error for incorrect credentialsnection", {
  expect_error(
    get_acoustic_projects(credentials = "not_a_credentialsnection"),
    "Not a credentialsnection object to database."
  )
})

test_that("get_acoustic_projects() returns a tibble", {
  df <- get_acoustic_projects(credentials)
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_acoustic_projects() returns unique project_id", {
  df <- get_acoustic_projects(credentials)
  expect_equal(nrow(df), nrow(df %>% distinct(project_id)))
})

test_that("get_acoustic_projects() returns the expected columns", {
  df <- get_acoustic_projects(credentials)
  expected_col_names <- c(
    "project_id",
    "project_code",
    "project_type",
    "telemetry_type",
    "project_name",
    # "coordinating_organization",
    # "principal_investigator",
    # "principal_investigator_email",
    "start_date",
    "end_date",
    "latitude",
    "longitude",
    "moratorium",
    "imis_dataset_id"
  )
  expect_equal(names(df), expected_col_names)
})

test_that("get_acoustic_projects() allows selecting on acoustic_project_code", {
  # Errors
  expect_error(get_acoustic_projects(credentials, acoustic_project_code = "not_a_project"))
  expect_error(get_acoustic_projects(credentials, acoustic_project_code = c("demer", "not_a_project")))

  # Select single value
  single_select <- "demer"
  single_select_df <- get_acoustic_projects(credentials, acoustic_project_code = single_select)
  expect_equal(
    single_select_df %>% distinct(project_code) %>% pull(),
    c(single_select)
  )
  expect_equal(nrow(single_select_df), 1)

  # Selection is case insensitive
  expect_equal(
    get_acoustic_projects(credentials, acoustic_project_code = "demer"),
    get_acoustic_projects(credentials, acoustic_project_code = "DEMER")
  )

  # Select multiple values
  multi_select <- c("demer", "dijle")
  multi_select_df <- get_acoustic_projects(credentials, acoustic_project_code = multi_select)
  expect_equal(
    multi_select_df %>% distinct(project_code) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_equal(nrow(multi_select_df), 2)
})

test_that("get_acoustic_projects() returns projects of type 'acoustic'", {
  expect_equal(
    get_acoustic_projects(credentials) %>% distinct(project_type) %>% pull(),
    "acoustic"
  )
})
