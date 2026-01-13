# check mismatch between js test and api response for a given function

# load libraries ----------------------------------------------------------

library(httr2)

# set function to test ----------------------------------------------------

fn_to_test <- "list_acoustic_project_codes"


# get response ------------------------------------------------------------

## build request ----------------------------------------------------------

request <-
  request(
    glue::glue(
      "https://opencpu.lifewatch.be/library/etnservice/R/{fn_to_test}/json"
    )
  ) |>
  req_headers(
    "Content-Type" = "application/json",
    "Cookie" = "vliz_webc=vliz_webc2"
  ) |>
  req_body_json(list(credentials = list(
    username = Sys.getenv("ETN_USER"),
    password = Sys.getenv("ETN_PWD")
  ))) |>
  req_method("POST")

response <- req_perform(request)

# check against expectation -----------------------------------------------

# Make sure we didn't get a HTTP error
assertthat::assert_that(!httr2::resp_is_error(response))


## extract current expectation --------------------------------------------
expectation <- readr::read_lines(
  glue::glue("tests/postman/test-{fn_to_test}.js")
) %>%
  grep("pm.expect(jsonData).to.include.members(",
       .,
       fixed = TRUE,
       value = TRUE) |>
  stringr::str_extract_all('(?<=")[^,]*?(?=\\")') |>
  unlist()


## extract response --------------------------------------------------------

api_response_values <- httr2::resp_body_json(response) |> unlist()

# report mismatch ---------------------------------------------------------

# values from the response that are not expected (test values), this may be
# useful if the intent is to test all values
api_response_values[!expectation %in% api_response_values]

# Values from expectation that are not in the response values
expectation[!expectation %in% api_response_values]

# Values from the api response that are in the values from the expectation
api_response_values[api_response_values %in% expectation]

# check if the response is always the same --------------------------------

# number of requests to check
iterations <- 20
xxhash <- digest::getVDigest("xxhash64")

number_of_unique_responses <-
  httr2::req_perform_sequential(
    rep(list(request), iterations)
  ) |>
  purrr::map(httr2::resp_body_json) |>
  xxhash() |>
  unique() |>
  length()

assertthat::assert_that(number_of_unique_responses == 1)
