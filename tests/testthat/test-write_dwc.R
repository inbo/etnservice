credentials <- list(
  username = Sys.getenv("userid"),
  password = Sys.getenv("pwd")
)

test_that("write_dwc() can return data as list of tibbles rather than files", {
  result <- suppressMessages(
    write_dwc(credentials, animal_project_code = "2014_demer")
  )

  expect_identical(names(result), "dwc_occurrence")
  expect_s3_class(result$dwc_occurrence, "tbl")
})

test_that("write_dwc() returns the expected Darwin Core terms as columns", {
  result <- suppressMessages(
    write_dwc(credentials, animal_project_code = "2014_demer")
  )

  expect_identical(
    colnames(result$dwc_occurrence),
    c(
      "type",
      "license",
      "rightsHolder",
      "datasetID",
      "institutionCode",
      "collectionCode",
      "datasetName",
      "basisOfRecord",
      "dataGeneralizations",
      "occurrenceID",
      "sex",
      "lifeStage",
      "occurrenceStatus",
      "organismID",
      "organismName",
      "eventID",
      "parentEventID",
      "eventDate",
      "samplingProtocol",
      "eventRemarks",
      "locationID",
      "locality",
      "decimalLatitude",
      "decimalLongitude",
      "geodeticDatum",
      "coordinateUncertaintyInMeters",
      "scientificNameID",
      "scientificName",
      "kingdom"
    )
  )
})

test_that("write_dwc() allows setting of rights_holder", {
  result <- suppressMessages(
    write_dwc(credentials,
              animal_project_code = "2014_demer",
              rights_holder = "< my rightholder value>")
  )

  expect_identical(
    unique(result$dwc_occurrence$rightsHolder),
    "< my rightholder value>"
  )
})

test_that("write_dwc() returns an empty column for rights holder by default", {
  result <- suppressMessages(
    write_dwc(credentials,
              animal_project_code = "2014_demer")
  )

  expect_identical(
    unique(result$dwc_occurrence$rightsHolder),
    NA_character_
  )
})
