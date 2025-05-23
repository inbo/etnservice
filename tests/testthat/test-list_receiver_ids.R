credentials <- list(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test_that("list_receiver_ids() returns unique list of values", {
  if (!exists("receiver_ids")) {
    receiver_ids <- list_receiver_ids(credentials)
  }
  expect_false(any(duplicated(receiver_ids)))
})

test_that("list_receiver_ids() returns a character vector", {
  if (!exists("receiver_ids")) {
    receiver_ids <- list_receiver_ids(credentials)
  }
  expect_type(receiver_ids, "character")
})

test_that("list_receiver_ids() does not return NA values", {
  if (!exists("receiver_ids")) {
    receiver_ids <- list_receiver_ids(credentials)
  }
  expect_true(all(!is.na(receiver_ids)))
})

test_that("list_receiver_ids() returns known value", {
  if (!exists("receiver_ids")) {
    receiver_ids <- list_receiver_ids(credentials)
  }
  expect_true("VR2W-124070" %in% receiver_ids)
})
