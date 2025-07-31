#' Version information about etnservice
#'
#' Users of the etn package might (probably will) have a local version of
#' etnservice. If there are differences between the version deployed on the API
#' and the version installed locally, this might lead to inconsistent results
#' when switching between local database queries and queries over the API. This
#' function returns version information of the installed version of etnservice,
#' when called over the api, it'll return version information on the version of
#' etnservice deployed via opencpu.
#'
#'
#' @return A list with the following elements:
#'  \item{ls}{A character vector of the objects in the environment.}
#'  \item{version}{The version of the etnservice package.}
#' @export
#'
#' @examples
#' get_version()
get_version <- function() {
  # Check if purrr is installed, only used for this function.
  rlang::check_installed("purrr")
  # Get all functions from etnservice and their code
  fn_names <- ls(envir = getNamespace("etnservice"))
  fn_code <- purrr::map(fn_names,
                            ~ get(.x, envir = getNamespace("etnservice"))) %>%
    purrr::map(deparse) %>%
    purrr::set_names(fn_names)
  # Calculate hashes for the functions, report on the installed version of
  # etnservice
  list(
    fn_checksums = purrr::map(fn_code, md5sum),
    version = utils::packageVersion("etnservice")
  )
}
