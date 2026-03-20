# Test on a known deployment.
test_deployment_id <- 53790

test_that("get_receiver_logs() returns a tibble", {
  expect_s3_class(
    get_receiver_logs(deployment_id = test_deployment_id, limit = TRUE),
    "tbl_df"
  )
})

test_that("get_receiver_logs() returns the expected columns", {
  expected_column_names <- c(
    "deployment_id",
    "receiver_id",
    "datetime",
    "record_type",
    "log_data"
  )

  expect_named(get_receiver_logs(deployment_id = test_deployment_id,
                                 limit = TRUE),
               expected_column_names
  )

})

test_that("get_receiver_logs() returns the expected column classes", {
  expected_column_classes <- list(
    "deployment_id" = "integer",
    "receiver_id" = "character",
    "datetime" = c("POSIXct", "POSIXt"),
    "record_type" = "character",
    "log_data" = "character"
  )

  expect_identical(
    purrr::map(get_receiver_logs(deployment_id = test_deployment_id,
                            limit = TRUE),
           class),
    expected_column_classes
  )
})

test_that("get_receiver_logs() returns no duplicate rows", {
  expect_identical(
    get_receiver_logs(deployment_id = test_deployment_id),
    dplyr::distinct(get_receiver_logs(deployment_id = test_deployment_id))
  )
})

test_that("get_receiver_logs() returns a 0-row tibble if no receiver logs found", {

})

test_that("get_receiver_logs() can filter on deployment_id", {

})

test_that("get_receiver_logs() can filter on receiver_id", {

})

test_that("get_receiver_logs() can filter on start_date", {

})

test_that("get_receiver_logs() can filter on end_date", {

})

test_that("get_receiver_logs() can return a limited subset", {
  # This test assumes that there are more than 100 logs for the test deployment
  expect_length(
    get_receiver_logs(deployment_id = test_deployment_id, limit = TRUE)[1],
    100L
  )
})
