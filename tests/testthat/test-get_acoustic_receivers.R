credentials <- list(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test_that("get_acoustic_receivers() returns error for incorrect credentials", {
  expect_error(
    get_acoustic_receivers(credentials = "not_a_credentials"),
    "Failed to connect to the database."
  )
  expect_error(
    get_acoustic_receivers(credentials = list(username = "not a username",
                                               password = "the wrong pwd")),
    "Failed to connect to the database."
  )
})

test_that("get_acoustic_receivers() returns a tibble", {
  df <- get_acoustic_receivers(credentials)
  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

# TODO: re-enable after https://github.com/inbo/etn/issues/251
# test_that("get_acoustic_receivers() returns unique receiver_id", {
#   df <- get_acoustic_receivers(credentials)
#   expect_equal(nrow(df), nrow(df %>% distinct(receiver_id)))
# })

test_that("get_acoustic_receivers() returns the expected columns", {
  df <- get_acoustic_receivers(credentials)
  expected_col_names <- c(
    "receiver_id",
    "manufacturer",
    "receiver_model",
    "receiver_serial_number",
    "modem_address",
    "status",
    "battery_estimated_life",
    "owner_organization",
    "financing_project",
    "built_in_acoustic_tag_id",
    "ar_model",
    "ar_serial_number",
    "ar_battery_estimated_life",
    "ar_voltage_at_deploy",
    "ar_interrogate_code",
    "ar_receive_frequency",
    "ar_reply_frequency",
    "ar_ping_rate",
    "ar_enable_code_address",
    "ar_release_code",
    "ar_disable_code",
    "ar_tilt_code",
    "ar_tilt_after_deploy"
  )
  expect_equal(names(df), expected_col_names)
})

test_that("get_acoustic_receivers() allows selecting on receiver_id", {
  # Errors
  expect_error(get_acoustic_receivers(credentials, receiver_id = "not_a_receiver_id"))
  expect_error(get_acoustic_receivers(credentials, receiver_id = c("VR2W-124070", "not_a_receiver_id")))

  # Select single value
  single_select <- "VR2W-124070" # From demer
  single_select_df <- get_acoustic_receivers(credentials, receiver_id = single_select)
  expect_equal(
    single_select_df %>% distinct(receiver_id) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("VR2W-124070", "VR2W-124078")
  multi_select_df <- get_acoustic_receivers(credentials, receiver_id = multi_select)
  expect_equal(
    multi_select_df %>% distinct(receiver_id) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})



test_that("get_acoustic_receivers() allows selecting on status", {
  # Errors
  expect_error(get_acoustic_receivers(credentials, status = "not_a_status"))
  expect_error(get_acoustic_receivers(credentials, status = c("broken", "not_a_status")))

  # Select single value
  single_select <- "broken"
  single_select_df <- get_acoustic_receivers(credentials, status = single_select)
  expect_equal(
    single_select_df %>% distinct(status) %>% pull(),
    c(single_select)
  )
  expect_gt(nrow(single_select_df), 0)

  # Select multiple values
  multi_select <- c("broken", "lost")
  multi_select_df <- get_acoustic_receivers(credentials, status = multi_select)
  expect_equal(
    multi_select_df %>% distinct(status) %>% pull() %>% sort(),
    c(multi_select)
  )
  expect_gt(nrow(multi_select_df), nrow(single_select_df))
})

test_that("get_acoustic_receivers() does not return cpod receivers", {
  # POD-3610 is a cpod receiver
  df <- get_acoustic_receivers(credentials, receiver_id = "POD-3610")
  expect_equal(nrow(df), 0)
})
