test_that("get_version() returns a version object as character", {
  expect_type(get_version()$version,
                  "character")
})

test_that("get_version() returns installed etnservice version", {
  expect_identical(
    get_version()$version,
    installed.packages(noCache = TRUE) %>%
      dplyr::as_tibble() %>%
      dplyr::filter(Package == "etnservice") %>%
      dplyr::pull("Version")
  )
})

test_that("get_version() both the version number and hashes of function code", {
  expect_named(
    get_version(),
    c("fn_checksums", "version")
  )
})
