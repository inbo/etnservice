test_that("version() returns the current installed version of etnservice", {
  installed_packages_df <- as.data.frame(installed.packages())
  expect_equal(
    dplyr::filter(installed_packages_df, Package == "etnservice")$Version,
    version()
  )
})
