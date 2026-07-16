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
  number_of_ids_to_test <- 3
  get_archival_data_uuid()$animal_id |>
    sample(size = number_of_ids_to_test) |>
    purrr::walk(
      \(selected_animal_id){
        animal_uuid_df <- get_archival_data_uuid(animal_id = selected_animal_id)
        expect_s3_class(
          animal_uuid_df,
          "data.frame"
        )

        expect_identical(
          unique(animal_uuid_df$animal_id),
          selected_animal_id
        )
      }
    )
})

test_that("get_archival_data_uuid() can query on animal_project_code", {
  selected_animal_project_code <- "2014_Frome"
  project_uuid <-
    get_archival_data_uuid(animal_project_code = selected_animal_project_code)

  expect_s3_class(
    project_uuid,
    "data.frame"
  )

  expect_identical(
    unique(project_uuid$animal_project_code),
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
  tag_uuid <-
    get_archival_data_uuid(tag_serial_number = selected_tag_serial_number)
  expect_s3_class(
    tag_uuid,
    "data.frame"
  )

  expect_identical(
    unique(tag_uuid$tag_serial_number),
    selected_tag_serial_number
  )
})

