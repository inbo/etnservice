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
