credentials <- list(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test_that("list_cpod_project_codes() returns unique list of values", {
  vector <- list_cpod_project_codes(credentials)

  expect_is(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("cpod-lifewatch" %in% vector)
  # Should not include animal or network projects
  expect_false("2014_demer" %in% vector)
  expect_false("demer" %in% vector)
})
