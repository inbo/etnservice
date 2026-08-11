# Test on a known deployment that has log_data.
test_deployment_id <- 53790

test_that("get_acoustic_deployment_logs() returns a tibble", {
  expect_s3_class(
    get_acoustic_deployment_logs(deployment_id = test_deployment_id, limit = TRUE),
    "tbl_df"
  )
})

test_that("get_acoustic_deployment_logs() returns the expected columns", {
  expected_column_names <- c(
    "deployment_id",
    "receiver_id",
    "station_name",
    "datetime",
    "record_type",
    "log_data"
  )

  expect_named(get_acoustic_deployment_logs(deployment_id = test_deployment_id,
                                 limit = TRUE),
               expected_column_names
  )

})

test_that("get_acoustic_deployment_logs() returns the expected column classes", {
  expected_column_classes <- list(
    "deployment_id" = "integer",
    "receiver_id" = "character",
    "station_name" = "character",
    "datetime" = c("POSIXct", "POSIXt"),
    "record_type" = "character",
    "log_data" = "character"
  )

  expect_identical(
    purrr::map(get_acoustic_deployment_logs(deployment_id = test_deployment_id,
                            limit = TRUE),
           class),
    expected_column_classes
  )
})

test_that("get_acoustic_deployment_logs() returns no duplicate rows", {
  log_df <- get_acoustic_deployment_logs(deployment_id = test_deployment_id)
  expect_identical(
    log_df,
    dplyr::distinct(log_df)
  )
})

test_that("get_acoustic_deployment_logs() returns a 0-row tibble if no receiver logs found", {
  # 1758 is a deployment_id with no receiver_logs
  expect_length(
    dplyr::pull(get_acoustic_deployment_logs(deployment_id = 1758), "log_data"),
    0L
  )
})

test_that("get_acoustic_deployment_logs() returns error on missing deployment_id", {
  # Fetching data for all deployments will return too big an object and crash
  # either the query or the client.
  expect_error(
    get_acoustic_deployment_logs(),
    class = "etn_no_dep_id_supplied"
  )
})

test_that("get_acoustic_deployment_logs() can filter on deployment_id", {
  expect_setequal(
    dplyr::pull(
      get_acoustic_deployment_logs(deployment_id = test_deployment_id),
      "deployment_id"
    ) |>
      unique(),
    test_deployment_id
  )

  expect_setequal(
    dplyr::pull(get_acoustic_deployment_logs(
      deployment_id = c(test_deployment_id, 74535)
    ), "deployment_id") |>
      unique(),
    c(test_deployment_id, 74535)
  )
})

test_that("get_acoustic_deployment_logs() can return a limited subset", {
  # This test assumes that there are more than 100 logs for the test deployment
  expect_length(
    dplyr::pull(
      get_acoustic_deployment_logs(deployment_id = test_deployment_id, limit = TRUE),
      1 # first column
    ),
    100L
  )
})
