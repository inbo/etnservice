# small script to parse a postman export and store the tests (so they can be
# versioned on github)


# load libraries ----------------------------------------------------------
library(purrr)

# you can export an entire collection as a json file
# read export -------------------------------------------------------------
export <- jsonlite::read_json("tests/postman/etnservice.postman_collection.json")

# helper to get test script out -------------------------------------------

get_script <- function(event) {
  event[[1]] %>%
    pluck("script") %>%
    pluck("exec") %>%
    paste(collapse = "\n")
}

# get names and scripts and write out -------------------------------------

request_names <-
  export %>%
  pluck("item") %>%
  map_chr(~ pluck(.x, "name"))

export %>%
  pluck("item") %>%
  map(~ pluck(.x, "event")) %>%
  map(get_script) %>%
  set_names(request_names) %>%
  walk2(request_names, ~ readr::write_lines(.x, file.path(
    "tests", "postman", paste0("test-", .y, ".js")
  )))
