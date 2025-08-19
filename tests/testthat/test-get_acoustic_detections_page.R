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


