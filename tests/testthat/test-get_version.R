test_that("get_version() returns a version object as `package_version`", {
  expect_s3_class(get_version()$version, "package_version")
})

test_that("get_version() returns installed etnservice version", {
  expect_identical(
    as.character(get_version()$version),
    installed.packages(noCache = TRUE) %>%
      dplyr::as_tibble() %>%
      dplyr::filter(Package == "etnservice") %>%
      dplyr::pull("Version")
  )
})

test_that("get_version() returns both the version number and hashes of function code", {
  expect_named(
    get_version(),
    c("fn_checksums", "version")
  )
})
