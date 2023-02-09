# test_that("connect_to_etn() allows to create a connection with default parameters", {
#   con <- connect_to_etn()
#   expect_true(check_connection(con))
#   expect_true(isClass(con, "PostgreSQL"))
# })

test_that("connect_to_etn() allows to create a connection with passed credentials", {
  con <- list(
    username = Sys.getenv("userid"),
    password = Sys.getenv("pwd")
  )
  connection <- connect_to_etn(con$username,con$password)
  expect_true(check_connection(connection))
  expect_true(isClass(connection, "PostgreSQL"))
})
