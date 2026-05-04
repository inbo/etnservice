test_that("get_archival_data_uuid() returns a tibble", {
  df <- get_archival_data_uuid()

  expect_s3_class(df, "data.frame")
  expect_s3_class(df, "tbl")
})

test_that("get_archival_data_uuid() returns expected columns", {
  expect_named(
    get_archival_data_uuid(),
    c(
      "animal_project_code",
      "animal_id",
      "converted_archival_file_uuid",
      "tag_serial_number"
    )
  )
})

test_that("get_archival_data_uuid() can query on animal_id", {
  expect_s3_class(
    get_archival_data_uuid(animal_id = 59241),
    "data.frame"
  )
})

test_that("get_archival_data_uuid() can query on animal_project_code", {
  expect_s3_class(
    get_archival_data_uuid(animal_project_code = "2014_Frome"),
    "data.frame"
  )
})

test_that("get_archival_data_uuid() can query on tag_serial_number", {
  expect_s3_class(
    get_archival_data_uuid(tag_serial_number = "1249189"),
    "data.frame"
  )
})

