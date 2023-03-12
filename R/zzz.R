# Save package version when package is built
.adaptr_version <- as.character(packageVersion("adaptr"))



#' Print package startup message
#'
#' @param libname not used.
#' @param pkgname not used.
#'
#' @return NULL
#'
#' @importFrom utils packageVersion
#'
#' @keywords internal
#' @noRd
#'
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Loading 'adaptr' package v", .adaptr_version, ".\n",
                        "For instructions, type 'help(\"adaptr\")'",
                        "\nor see https://inceptdk.github.io/adaptr/.")
}



#' Handle well-known "problem" of pseudo-global variables
#'
#' Handles "Undefined global functions or variables" after R CMD check (in
#' [plot_convergence()], [plot_status()], and [plot_history()]).
#' See [https://stackoverflow.com/a/12429344].
#'
#' @param libname not used.
#' @param pkgname not used.
#'
#' @importFrom utils globalVariables
#'
#' @keywords internal
#' @noRd
#'
.onLoad <- function(libname, pkgname) {
  if (getRversion() >= "2.15.1") {
    globalVariables(c(
      "arm", "hi", "lo", "x", "mid", "value", "ns", "ns_all", "look_ns",
      "look_ns_all", "p", "status", "metric", "y", "arm_facet"
    ))
  }
}
