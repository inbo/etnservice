credentials <- list(
  username = Sys.getenv("ETN_USER"),
  password = Sys.getenv("ETN_PWD")
)

test_that("list_tag_serial_numbers() returns unique list of values", {
  vector <- list_tag_serial_numbers(credentials)

  expect_type(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("1187450" %in% vector)
})
