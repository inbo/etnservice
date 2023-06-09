credentials <- list(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test_that("list_deployment_ids() returns unique list of values", {
  vector <- list_deployment_ids(credentials)

  expect_is(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("1437" %in% vector)
})
