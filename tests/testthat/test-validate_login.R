test_that("validate_login() returns error on missing arguments", {
  # password missing
  expect_error(
    validate_login(username = "a username"),
    regexp = "No password provided.",
    fixed = TRUE
  )
  # username missing
  expect_error(
    validate_login(password = "a password",
                   regexp = "No username provided.",
                   fixed = TRUE)
  )
  # both missing
  expect_error(
    validate_login()
  )
})

test_that("validate_login() returns FALSE on a unsuccesful login attempt", {
  expect_false(
    validate_login("username",
                   "the wrong password")
  )
})

test_that("validate_login() returns TRUE on a succesful login attempt", {
  expect_true(
    validate_login(Sys.getenv("userid"),
                   Sys.getenv("pwd"))
  )
})
