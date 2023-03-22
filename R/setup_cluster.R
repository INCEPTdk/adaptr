# Setup environment for default cluster
.adaptr_cluster_env <- new.env()



#' Setup default cluster for use in parallelised adaptr functions
#'
#' This function setups (or removes) a default cluster for use in all
#' parallelised functions in `adaptr` using the `parallel`-package. The function
#' also exports objects that should be available on the cluster and sets the
#' random number generator appropriately. See **Details** for further info on
#' how `adaptr` handles sequential/parallel computation.
#'
#' @inheritParams run_trials
#' @param cores can be either unspecified, `NULL`, or a single integer `> 0`. If
#'   `NULL` or `1`, an existing default cluster is removed (if any), and the
#'   default will subsequently be to run functions sequentially in the main
#'   process if `cores = 1`, and according to `getOption("mc.cores")` if `NULL`
#'   (unless otherwise specified in individual functions). The
#'   [parallel::detectCores()] function may be used to see the number of
#'   available cores, although this comes with some caveats (as described in the
#'   function documentation), including that the number of cores may not always
#'   be returned and may not match the number of cores that are available for
#'   use. In general, using less cores than available may be preferable if other
#'   processess are run on the machine at the same time.
#'
#' @details
#'
#' \strong{Using sequential or parallel computing in adaptr}
#'
#' All parallelised `adaptr` functions have a `cores` argument that defaults to
#' `NULL`. If a non-`NULL` integer `> 0` is provided to the `cores` argument in
#' any of the other `adaptr` functions, the package will run calculations
#' sequentially in the main process if `cores = 1`, and otherwise initiate a new
#' cluster of size `cores` that will be removed once the function completes,
#' regardless of whether or not a default cluster or the global `"mc.cores"`
#' option have been specified.
#'
#' If `cores` is `NULL` in any other `adaptr` function, the package will use a
#' default cluster if one exists or run computations sequentially if
#' [setup_cluster()] has last been called with `cores = 1`. If [setup_cluster()]
#' has not been called or last called with `cores = NULL`, then the package will
#' check if the global `"mc.cores"` option has been specified (using
#' `options(mc.cores = <number of cores>)`). If this option has been set with a
#' value `> 1`, then a new, temporary cluster of that size is setup, used, and
#' removed once the function completes. If this option has not been set or has
#' been set to `1`, then computations will be run sequentially in the main
#' process.
#'
#' Generally, we recommend using the [setup_cluster()] function as this avoids
#' the overhead of re-initiating new clusters with every call to one of the
#' parallelised `adaptr` functions. This is especially important when exporting
#' many or large objects to a parallel cluster, as this can then be done only
#' once (with the option to export further objects to the same cluster when
#' calling [run_trials()]).
#'
#' \strong{Type of clusters used and random number generation}
#'
#' The `adaptr` package solely uses parallel socket clusters (using
#' [parallel::makePSOCKcluster()]) and thus does not use forking (as this is not
#' available on all operating systems). As such, user-defined objects that
#' should be used by the `adaptr` functions when run in parallel need to be
#' exported using either  [setup_cluster()] or [run_trials()], if not part of
#' the package or the generated `trial_spec` object.
#'
#' The `adaptr` package uses the `"L'Ecuyer-CMRG"` kind (see [RNGkind()]) for
#' safe random number generation for parallelised functions. This is also used
#' when running `adaptr` functions sequentially with a seed provided, to ensure
#' that the same results are obtained regardless of whether sequential or
#' parallel computation is used. All functions restore both the random number
#' generator kind and the global random seed after use if called with a seed.
#'
#' @return invisible returns the default `parallel` cluster or `NULL`, as
#'   appropriate. This may be used with other functions from the `parallel`
#'   package by advanced users, for example to load certain libraries on the
#'   cluster prior to calling [run_trials()].
#' @export
#'
#' @examples
#'
#' # Setup a cluster using 2 cores
#' setup_cluster(cores = 2)
#'
#' # Get existing default cluster (printed as invisibly returned)
#' print(setup_cluster())
#'
#
#' # Remove existing default cluster
#' setup_cluster(cores = NULL)
#'
#' # Specify preference for running computations sequentially
#' setup_cluster(cores = 1)
#'
#' # Remove default cluster preference
#' setup_cluster(cores = NULL)
#'
#' # Set global option to default to using 2 new clusters each time
#' # (only used if no default cluster preference is specified)
#' options(mc.cores = 2)
#'
setup_cluster <- function(cores, export = NULL, export_envir = parent.frame()) {
  # If cores is provided, change or remove default cluster
  if (!missing(cores)) {
    # Stop cluster if existing and if a valid new 'cores' value is provided
    if (isTRUE(is.null(cores) | verify_int(cores, min_value = 1))) {
      if (!is.null(.adaptr_cluster_env$cl)) {
        stopCluster(.adaptr_cluster_env$cl)
      }
      .adaptr_cluster_env$cl <- NULL
      .adaptr_cluster_env$cores <- cores
    } else { # Error if invalid values
      stop0("If specified, cores must be either NULL or a single integer > 0.")
    }

    # Setup new cluster if cores >= 2
    if (verify_int(cores, min_value = 2)) {
      cl <- makePSOCKcluster(cores)
      .adaptr_cluster_env$cl <- cl
      .adaptr_cluster_env$cores <- cores
      clusterEvalQ(cl, RNGkind("L'Ecuyer-CMRG", "default", "default"))
      if (!is.null(export)) {
        clusterExport(cl = cl, varlist = export, envir = export_envir)
      }
    }
  }

  # Invisibly return cluster (will be NULL if not set)
  invisible(.adaptr_cluster_env$cl)
}
