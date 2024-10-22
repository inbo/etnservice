credentials <- list(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

vector <- list_receiver_ids(credentials)

test_that("list_receiver_ids() returns unique list of values", {
  expect_false(any(duplicated(vector)))
})

test_that("list_receiver_ids() returns a character vector", {
  expect_is(vector, "character")
})

test_that("list_receiver_ids() does not return NA values", {
  skip("Empty receiver value in acoustic.receivers, ISSUE https://github.com/inbo/etn/issues/333")
  expect_true(all(!is.na(vector)))
})

test_that("list_receiver_ids() returns known value", {
  expect_true("VR2W-124070" %in% vector)
})
