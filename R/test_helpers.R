#' Read test data
#'
#' Internal helper function only used for unit tests. Simple wrapper around
#' [readRDS()].
#'
#' @param filename Name of the file to load (without `".RData."`-extension and
#'   directory).
#'
#' @return returns the object loaded by [readRDS()].
#'
#' @keywords internal
#' @noRd
#'
read_testdata <- function(filename) {
  readRDS(system.file("testdata", paste0(filename, ".RData"), package = "adaptr"))
}



#' Cluster version check
#'
#' Internal helper function only used for unit tests. Gets the package version
#' on a cluster created by the `parallel` package and compares it to a
#' user-specified package version or the package version obtained when not
#' running in parallel. This is necessary, as in some cases when using parallel
#' computing with [devtools::test()], the workers on the `parallel`-cluster
#' use function versions from the installed version of the package and not those
#' from the development version with loading simulated by the
#' [devtools::load_all()] function. This is not an issue when using
#' [devtools::check()], which builds and (temporarily) installs the development
#' version of the package.
#'
#' @param cl a cluster setup by [parallel::makeCluster()], which is used for the
#'   test.
#' @param minimum_version single character string, defaults to `NULL` in which
#'   case it is tested whether the package version loaded on the cluster is the
#'   exact same as that loaded when not working in parallel. If a version is
#'   provided (in the format returned by [utils::packageVersion]), it is tested
#'   whether the version loaded on the cluster is greater than or equal to this.
#'
#' @return single logical, `TRUE` if the test is passed, `FALSE` if not.
#'
#' @importFrom utils packageVersion
#' @importFrom parallel clusterCall
#'
#' @keywords internal
#' @noRd
#'
check_cluster_version <- function(cl, minimum_version = NULL) {
  cl_version <- clusterCall(cl, function() {
    if (isFALSE(requireNamespace("adaptr", quietly = TRUE))) {
      NA
    } else {
      packageVersion("adaptr")
    }
  })[[1]][1]
  if (is.na(cl_version)) {
    FALSE
  } else if (is.null(minimum_version)) {
    cl_version == .adaptr_version
  } else {
    cl_version >= minimum_version
  }
}
