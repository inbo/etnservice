test_that("connect_to_etn() allows to create a connection with passed credentials", {
  credentials <- list(
    username = Sys.getenv("userid"),
    password = Sys.getenv("pwd")
  )
  connection <- connect_to_etn(credentials$username, credentials$password)
  expect_true(check_connection(connection))
  expect_true(isClass(connection, "PostgreSQL"))
  DBI::dbDisconnect(connection)
})

test_that("connect_to_etn() returns a clear error when connecting to db fails",{
  expect_error(connect_to_etn("only one argument"),
               regexp = "Failed to connect to the database.")
  expect_error(connect_to_etn(password = "missing username"),
               regexp = "Failed to connect to the database.")
  expect_error(connect_to_etn(username = "missing password"),
               regexp = "Failed to connect to the database.")
  expect_error(connect_to_etn(username = "", password = ""),
               regexp = "Failed to connect to the database.")
})
