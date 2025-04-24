#' Return the installed version of etnservice
#'
#' This function is useful to check what version of etnservice is deployed to
#' openCPU. This way you can validate that any local version of etnservice is
#' the same as the one you are adressing via the API.
#'
#' If you have multiple versions of etnservice installed, multiple version
#' numbers will be returned.
#'
#' @returns A character vector with the version number of the installed version
#'   of etnservice.
#' @export
#'
#' @examples
#' version()
version <- function() {
  as.character(packageVersion("etnservice"))
}
