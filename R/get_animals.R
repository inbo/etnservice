#' Get animal data
#'
#' Get data for animals, with options to filter results. Associated tag
#' information is available in columns starting with `tag` and
#' `acoustic_tag_id`. If multiple tags are associated with a single animal,
#' the information is comma-separated.
#'
#' @param credentials A list with the username and password to connect to the ETN database.
#' @param animal_id Integer (vector). One or more animal identifiers.
#' @param animal_project_code Character (vector). One or more animal project
#'   codes. Case-insensitive.
#' @param tag_serial_number Character (vector). One or more tag serial numbers.
#' @param scientific_name Character (vector). One or more scientific names.
#'
#' @return A tibble with animals data, sorted by `animal_project_code`,
#' `release_date_time` and `tag_serial_number`. See also
#'  [field definitions](https://inbo.github.io/etn/articles/etn_fields.html).
#'
#' @export
#'
#' @examples
#' # Set credentials
#' credentials <- list(
#'    username = Sys.getenv("userid"),
#'    password = Sys.getenv("pwd")
#'  )
#'
#' # Get all animals
#' get_animals(credentials)
#'
#' # Get specific animals
#' get_animals(credentials, animal_id = 305) # Or string value "305"
#' get_animals(credentials, animal_id = c(304, 305, 2827))
#'
#' # Get animals from specific animal project(s)
#' get_animals(credentials, animal_project_code = "2014_demer")
#' get_animals(credentials, animal_project_code = c("2014_demer", "2015_dijle"))
#'
#' # Get animals associated with a specific tag_serial_number
#' get_animals(credentials, tag_serial_number = "1187450")
#'
#' # Get animals of specific species (across all projects)
#' get_animals(credentials, scientific_name = c("Rutilus rutilus", "Silurus glanis"))
#'
#' # Get animals of a specific species from a specific project
#' get_animals(credentials, animal_project_code = "2014_demer", scientific_name = "Rutilus rutilus")
get_animals <- function(credentials = list(
                          username = Sys.getenv("userid"),
                          password = Sys.getenv("pwd")
                        ),
                        animal_id = NULL,
                        tag_serial_number = NULL,
                        animal_project_code = NULL,
                        scientific_name = NULL) {

  # Check if credentials object has right shape
  check_credentials(credentials)

  # Create connection object
  connection <- connect_to_etn(credentials$username, credentials$password)

  # Check connection
  check_connection(connection)

  # Check animal_id
  if (is.null(animal_id)) {
    animal_id_query <- "True"
  } else {
    animal_id <- check_value(
      animal_id,
      list_animal_ids(credentials),
      "animal_id"
    )
    animal_id_query <- glue::glue_sql(
      "animal.id_pk IN ({animal_id*})",
      .con = connection
    )
    # animal_id_query seems to work correctly with integers or strings: 'animal_id IN (\'304\')'
  }

  # Check animal_project_code
  if (is.null(animal_project_code)) {
    animal_project_code_query <- "True"
  } else {
    animal_project_code <- check_value(
      animal_project_code,
      list_animal_project_codes(credentials),
      "animal_project_code",
      lowercase = TRUE
    )
    animal_project_code_query <- glue::glue_sql(
      "LOWER(animal_project.projectcode) IN ({animal_project_code*})",
      .con = connection
    )
  }

  # Check tag_serial_number
  if (is.null(tag_serial_number)) {
    tag_serial_number_query <- "True"
  } else {
    tag_serial_number <- check_value(
      as.character(tag_serial_number), # Cast to character
      list_tag_serial_numbers(credentials),
      "tag_serial_number"
    )
    tag_serial_number_query <- glue::glue_sql(
      "tag.tag_serial_number IN ({tag_serial_number*})",
      .con = connection
    )
  }

  # Check scientific_name
  if (is.null(scientific_name)) {
    scientific_name_query <- "True"
  } else {
    scientific_name <- check_value(
      scientific_name,
      list_scientific_names(credentials),
      "scientific_name"
    )
    scientific_name_query <- glue::glue_sql(
      "animal.scientific_name IN ({scientific_name*})",
      .con = connection
    )
  }

  tag_sql <- glue::glue_sql(
    readr::read_file(system.file("sql", "tag.sql", package = "etnservice")),
    .con = connection
  )

  # Build query
  query <- glue::glue_sql("
    SELECT
      animal.id_pk AS animal_id,
      animal_project.projectcode AS animal_project_code,
      tag.tag_serial_number AS tag_serial_number,
      tag.tag_type AS tag_type,
      tag.tag_subtype AS tag_subtype,
      tag.acoustic_tag_id AS acoustic_tag_id,
      tag.thelma_converted_code AS acoustic_tag_id_alternative,
      animal.scientific_name AS scientific_name,
      animal.common_name AS common_name,
      animal.aphia_id AS aphia_id,
      animal.animal_id AS animal_label,
      animal.animal_nickname AS animal_nickname,
      animal.tagger AS tagger,
      animal.catched_date_time AS capture_date_time,
      animal.capture_location AS capture_location,
      animal.capture_latitude AS capture_latitude,
      animal.capture_longitude AS capture_longitude,
      animal.capture_method AS capture_method,
      animal.capture_depth AS capture_depth,
      animal.temperature_change AS capture_temperature_change,
      animal.utc_release_date_time AS release_date_time,
      animal.release_location AS release_location,
      animal.release_latitude AS release_latitude,
      animal.release_longitude AS release_longitude,
      animal.recapture_date AS recapture_date_time,
      animal.length_type AS length1_type,
      animal.length AS length1,
      animal.length_units AS length1_unit,
      animal.length2_type AS length2_type,
      animal.length2 AS length2,
      animal.length2_units AS length2_unit,
      animal.length3_type AS length3_type,
      animal.length3 AS length3,
      animal.length3_units AS length3_unit,
      animal.length4_type AS length4_type,
      animal.length4 AS length4,
      animal.length4_units AS length4_unit,
      animal.weight AS weight,
      animal.weight_units AS weight_unit,
      animal.age AS age,
      animal.age_units AS age_unit,
      animal.sex AS sex,
      animal.life_stage AS life_stage,
      animal.wild_or_hatchery AS wild_or_hatchery,
      animal.stock AS stock,
      animal.date_of_surgery AS surgery_date_time,
      animal.surgery_location AS surgery_location,
      animal.surgery_latitude AS surgery_latitude,
      animal.surgery_longitude AS surgery_longitude,
      animal.treatment_type AS treatment_type,
      animal.implant_type AS tagging_type,
      animal.implant_method AS tagging_methodology,
      animal.dna_sample_taken AS dna_sample,
      animal.sedative AS sedative,
      animal.sedative_concentration AS sedative_concentration,
      animal.anaesthetic AS anaesthetic,
      animal.buffer AS buffer,
      animal.anaesthetic_concentration AS anaesthetic_concentration,
      animal.buffer_concentration_in_anaesthetic AS buffer_concentration_in_anaesthetic,
      animal.anesthetic_concentration_in_recirculation AS anaesthetic_concentration_in_recirculation,
      animal.buffer_concentration_in_recirculation AS buffer_concentration_in_recirculation,
      animal.dissolved_oxygen AS dissolved_oxygen,
      animal.preop_holding_period AS pre_surgery_holding_period,
      animal.post_op_holding_period AS post_surgery_holding_period,
      animal.holding_temperature AS holding_temperature,
      animal.comments AS comments
      -- animal.project: animal.project_fk instead
      -- animal.person_id
      -- animal.est_tag_life
      -- animal.date_modified
      -- animal.date_created
      -- animal.end_date_tag
      -- animal.post_op_holding_period_new
      -- animal.external_id
    FROM common.animal_release_limited AS animal
      LEFT JOIN common.animal_release_tag_device AS animal_with_tag
        ON animal.id_pk = animal_with_tag.animal_release_fk
        LEFT JOIN ({tag_sql}) AS tag
          ON animal_with_tag.tag_device_fk = tag.tag_device_fk
      LEFT JOIN common.projects AS animal_project
        ON animal.project_fk = animal_project.id
    WHERE
      {animal_id_query}
      AND {animal_project_code_query}
      AND {tag_serial_number_query}
      AND {scientific_name_query}
    ", .con = connection)
  animals <- DBI::dbGetQuery(connection, query)

  # Collapse tag information, to obtain one row = one animal
  tag_cols <-
    animals %>%
    dplyr::select(dplyr::starts_with("tag"), dplyr::starts_with("acoustic_tag_id")) %>%
    names()
  other_cols <-
    animals %>%
    dplyr::select(-dplyr::starts_with("tag"), -dplyr::starts_with("acoustic_tag_id")) %>%
    names()
  animals <-
    animals %>%
    dplyr::group_by_at(other_cols) %>%
    dplyr::summarize_at(tag_cols, paste, collapse = ",") %>% # Collapse multiple tags by comma
    dplyr::ungroup() %>%
    dplyr::mutate_at(tag_cols, gsub, pattern = "NA", replacement = "") %>% # Use "" instead of "NA"
    dplyr::select(names(animals)) # Use the original column order

  # Sort data
  animals <-
    animals %>%
    dplyr::arrange(
      .data$animal_project_code,
      .data$release_date_time,
      factor(.data$tag_serial_number, levels = list_tag_serial_numbers(credentials))
    )

  # Close connection
  DBI::dbDisconnect(connection)

  # Return animals
  dplyr::as_tibble(animals) # Is already a tibble, but added if code above changes
}
