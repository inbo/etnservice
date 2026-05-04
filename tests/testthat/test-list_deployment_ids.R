credentials <- list(
  username = Sys.getenv("ETN_USER"),
  password = Sys.getenv("ETN_PWD")
)

test_that("list_deployment_ids() returns unique list of values", {
  vector <- list_deployment_ids(credentials)

  expect_type(vector, "integer")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("1437" %in% vector)
})
