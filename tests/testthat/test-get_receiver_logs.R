# Test on a known deployment that has log_data.
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

test_that("get_receiver_logs() returns error on missing deployment_id", {
  # Fetching data for all deployments will return too big an object and crash
  # either the query or the client.
  expect_error(
    get_receiver_logs(),
    class = "etn_no_dep_id_supplied"
  )
})

test_that("get_receiver_logs() can filter on deployment_id", {

})

test_that("get_receiver_logs() can filter on receiver_id", {

})

test_that("get_receiver_logs() can filter on start_date", {
  expect_error(
    get_receiver_logs(deployment_id = test_deployment_id,
                      start_date = "not_a_date")
  )

  # Start date (inclusive) <= min(date_time)
  start_year_df <- get_receiver_logs(deployment_id = test_deployment_id,
                            start_date = "2021")
  expect_lte(as.POSIXct("2021-01-01", tz = "UTC"), min(start_year_df$datetime))
  start_month_df <- get_receiver_logs(deployment_id = test_deployment_id,
                            start_date = "2020-09")
  expect_lte(as.POSIXct("2020-09-01", tz = "UTC"), min(start_month_df$datetime))
  start_day_df <- get_receiver_logs(deployment_id = test_deployment_id,
                                    start_date = "2020-10-12")
  expect_lte(as.POSIXct("2020-10-12", tz = "UTC"), min(start_day_df$datetime))


})

test_that("get_receiver_logs() can filter on end_date", {
  expect_error(
    get_receiver_logs(deployment_id = test_deployment_id,
                      end_date = "not_a_date")
  )

  # End date (exclusive) > max(date_time)
  end_year_df <- get_receiver_logs(end_date = "2021",
                                   deployment_id = test_deployment_id)
  expect_gt(as.POSIXct("2021-01-01", tz = "UTC"), max(end_year_df$datetime))
  end_month_df <- get_receiver_logs(end_date = "2020-09",
                                    deployment_id = test_deployment_id)
  expect_gt(as.POSIXct("2020-09-01", tz = "UTC"), max(end_month_df$datetime))
  end_day_df <- get_receiver_logs(end_date = "2021-02-10",
                                  deployment_id = test_deployment_id)
  expect_gt(as.POSIXct("2021-02-10", tz = "UTC"), max(end_day_df$datetime))
})

test_that("get_receiver_logs() can filter on both start and end date", {
  # Test querying between two dates.
  between_year_df <- get_receiver_logs(start_date = "2020",
                                       end_date = "2021",
                                       deployment_id = test_deployment_id)
  expect_lte(as.POSIXct("2020-01-01", tz = "UTC"),
             min(between_year_df$datetime))
  expect_gt(as.POSIXct("2021-01-01", tz = "UTC"),
            max(between_year_df$datetime))
  between_month_df <- get_receiver_logs(start_date = "2020-09",
                                        end_date = "2020-11",
                                        deployment_id = test_deployment_id)
  expect_lte(as.POSIXct("2020-09-01", tz = "UTC"),
             min(between_month_df$datetime))
  expect_gt(as.POSIXct("2020-11-01", tz = "UTC"),
            max(between_month_df$datetime))
  between_day_df <- get_receiver_logs(start_date = "2021-04-24",
                                      end_date = "2021-04-25",
                                      deployment_id = test_deployment_id)
  expect_lte(as.POSIXct("2021-04-24", tz = "UTC"),
             min(between_day_df$datetime))
  expect_gt(as.POSIXct("2021-04-25", tz = "UTC"),
            max(between_day_df$datetime))
})

test_that("get_receiver_logs() can return a limited subset", {
  # This test assumes that there are more than 100 logs for the test deployment
  expect_length(
    dplyr::pull(
      get_receiver_logs(deployment_id = test_deployment_id, limit = TRUE),
      1 # first column
    ),
    100L
  )
})
