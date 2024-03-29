credentials <- list(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test_that("list_animal_project_codes() returns unique list of values", {
  vector <- list_animal_project_codes(credentials)

  expect_is(vector, "character")
  expect_false(any(duplicated(vector)))
  expect_true(all(!is.na(vector)))

  expect_true("2014_demer" %in% vector)
  # Should not include network or cpod projects
  expect_false("demer" %in% vector)
  expect_false("cpod-lifewatch" %in% vector)
})
