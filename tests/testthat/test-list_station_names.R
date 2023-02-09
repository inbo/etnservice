credentials <- list(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test_that("list_station_names() returns unique list of values", {
  vector <- list_station_names(credentials)

  expect_is(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("de-9" %in% vector)
})
