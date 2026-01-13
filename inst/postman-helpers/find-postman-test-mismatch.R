# check mismatch between js test and api response for list_acoustic_project_codes


# load libraries ----------------------------------------------------------

library(httr2)



# set function to test ----------------------------------------------------

fn_to_test <- "list_scientific_names"


# get reponse -------------------------------------------------------------


## build request ----------------------------------------------------------

request <-
  request(
    glue::glue(
      "https://opencpu.lifewatch.be/library/etnservice/R/{fn_to_test}/json"
    )
  )

response <-
  request %>%
  req_headers(
    "Content-Type" = "application/json",
    "Cookie" = "vliz_webc=vliz_webc2"
  ) %>%
  req_body_json(list(credentials = list(
    username = Sys.getenv("ETN_USER"),
    password = Sys.getenv("ETN_PWD")
  ))) %>%
  req_method("POST") %>%
  req_perform()

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
       value = TRUE) %>%
  stringr::str_extract_all('(?<=")[^,]*?(?=\\")') %>%
  unlist()


## extract response --------------------------------------------------------

api_response_values <- httr2::resp_body_json(response) %>% unlist()

# report mismatch ---------------------------------------------------------

# values that are in the response, but not in the expected (test values):
api_response_values[
  !expectation %in% api_response_values]

# Values from expectation that are not in the values the api responded
expectation[!expectation %in% api_response_values]

# Values from the api response that are in the values from the expectation
api_response_values[api_response_values %in% expectation]

# check if the response is always the same --------------------------------
# library(furrr)
# plan("multisession", workers = 10)
# furrr::future_map(rep(list(request), 100), ~resp_body_json(req_perform(.x))) %>%
#   purrr::map(digest::digest) %>%
#   unlist %>%
#   unique %>%
#   length(.) == 1
