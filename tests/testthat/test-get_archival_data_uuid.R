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
  selected_animal_id <- 59241
  animal_uuid <-
    get_archival_data_uuid(animal_id = selected_animal_id)

  expect_s3_class(
    animal_uuid,
    "data.frame"
  )

  expect_identical(
    unique(animal_uuid$animal_id),
    selected_animal_id
  )
})

test_that("get_archival_data_uuid() can query on animal_project_code", {
  selected_animal_project_code <- "2014_Frome"
  expect_s3_class(
    get_archival_data_uuid(animal_project_code = selected_animal_project_code),
    "data.frame"
  )

  expect_identical(
    unique(animal_uuid$animal_project_code),
    selected_animal_project_code
  )
})

test_that("get_archival_data_uuid() supports case insensitive animal_project_code", {
  selected_animal_project_code <- "2014_Frome"

  expect_identical(
    get_archival_data_uuid(
      animal_project_code =
        toupper(selected_animal_project_code)
    ),
    get_archival_data_uuid(
      animal_project_code =
        selected_animal_project_code
    )
  )
})

test_that("get_archival_data_uuid() can query on tag_serial_number", {
  selected_tag_serial_number <- "1249189"
  expect_s3_class(
    get_archival_data_uuid(tag_serial_number = selected_tag_serial_number),
    "data.frame"
  )

  expect_identical(
    unique(animal_uuid$tag_serial_number),
    selected_tag_serial_number
  )
})

