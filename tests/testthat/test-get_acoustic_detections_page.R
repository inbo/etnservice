test_that("get_acoustic_detections_page() returns error for incorrect connection", {
  expect_error(
    get_acoustic_detections_page(credentials = "not_a_connection"),
    "The credentials need to contain a 'username' field."
  )
  expect_error(
    get_acoustic_detections_page(credentials = list(username = "username")),
    "The credentials need to contain a 'password' field."
  )
  expect_error(
    get_acoustic_detections_page(credentials = list(unexpected_field = 4,
                                               username = "username",
                                               password = "not a password")),
    "The credentials object should have a length of 2."
  )
  expect_error(
    get_acoustic_detections_page(credentials = list(username = "not a username",
                                               password = "the wrong pwd")),
    "Failed to connect to the database."
  )
})

test_that("get_acoustic_detections_page() returns a tibble", {
  df <- get_acoustic_detections_page(page_size = 50)
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_acoustic_detections_page() can return a count", {
  df <-
    get_acoustic_detections_page(animal_project_code = "2021_Gudena", count = TRUE)
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
  expect_named(df, "count")
  expect_identical(
    as.integer(df$count),
    nrow(get_acoustic_detections_page(animal_project_code = "2021_Gudena"))
  )
})

test_that("get_acoustic_detections_page() starts query at next_id_pk", {
  last_detection_id <-
    max(
      get_acoustic_detections_page(acoustic_project_code = "demer",
                                   page_size = 5)$detection_id
      )
  # next_id_pk determines where the query should start, returned detection_id's
  # should always be greater.
  expect_gt(
    min(get_acoustic_detections_page(acoustic_project_code = "demer",
                                 page_size = 5,
                                 next_id_pk = last_detection_id)$detection_id),
    last_detection_id
  )
})

test_that("get_acoustic_detections_page() allows setting of page_size", {
  # Length of returned df should correspond with page size
  expect_identical(nrow(get_acoustic_detections_page(page_size = 5)), 5L)
  # page_size should be a positive integer
  expect_error(
    get_acoustic_detections_page(page_size = NULL),
    regexp = "page_size is not a count (a single positive integer)",
    fixed = TRUE
  )
  # page_size can be bigger than the returned object
  n_detections_from_single_day <-
    get_acoustic_detections_page(
      animal_project_code = "2011_rivierprik",
      start_date = "2012-01-10",
      end_date = "2012-01-11"
    ) %>%
    nrow()
  expect_identical(
    nrow(
      get_acoustic_detections_page(
        animal_project_code = "2011_rivierprik",
        start_date = "2012-01-10",
        end_date = "2012-01-11",
        page_size = n_detections_from_single_day + 1000
      )
    ),
    n_detections_from_single_day
  )
})

test_that("get_acoustic_detections_page() returns the expected columns", {
  df <- get_acoustic_detections_page(page_size = 50)
  expected_col_names <- c(
    "detection_id",
    "date_time",
    "tag_serial_number",
    "acoustic_tag_id",
    "animal_project_code",
    "animal_id",
    "scientific_name",
    "acoustic_project_code",
    "receiver_id",
    "station_name",
    "deploy_latitude",
    "deploy_longitude",
    "sensor_value",
    "sensor_unit",
    "sensor2_value",
    "sensor2_unit",
    "signal_to_noise_ratio",
    "source_file",
    "qc_flag",
    "deployment_id"
  )
  expect_length(names(df), length(expected_col_names))
  expect_equal(names(df), expected_col_names)
  expect_named(df, expected_col_names)
})

test_that("get_acoustic_detections_page() returns only count column on count", {
  expect_named(
    get_acoustic_detections_page(acoustic_project_code = "2024_bovenschelde",
                                 count = TRUE),
    "count")
})

test_that("pagination via next_id_pk returns non-overlapping pages", {
  first_page <- get_acoustic_detections_page(page_size = 300)
  expect_true(nrow(first_page) > 0)
  max_id_first_page <- max(first_page$detection_id)

  second_page <- get_acoustic_detections_page(
    page_size = 300,
    next_id_pk = max_id_first_page
  )

  expect_true(all(second_page$detection_id > max_id_first_page))
  expect_length(intersect(first_page$detection_id, second_page$detection_id), 0)
})
