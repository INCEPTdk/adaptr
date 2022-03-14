#' Generate breakpoints and other values for printing progress
#'
#' Used internally. Generates breakpoints, messages, and 'batches' of trial
#' numbers to simulate when using [run_trials] with the `progress` argument in
#' use. Breaks will be multiples of the number of `cores`, and repeated use of
#' the same values for breaks is avoided (if, e.g., the number of breaks times
#' the number of cores is not possible if few new trials are to be run). Inputs
#' are validated by [run_trials].
#'
#' @inheritParams run_trials
#' @param n_rep_new single integers, number of new simulations to run (i.e.,
#'   `n_rep` as supplied to [run_trials] minus the number of previously run
#'   simulations if `grow` is used in [run_trials]).
#'
#' @return List containing `breaks` (the number of patients at each break),
#'   `start_mess` and `prog_mess` (the first and subsequent progress messages'
#'   basis), and `batches` (a list with each entry corresponding to the
#'   simulation numbers in each batch).
#'
#' @keywords internal
#'
prog_breaks <- function(progress, n_rep_new, cores) {
  # Calculate the breakpoints and probabilities; only allow unique breakpoints
  prog_seq <- unique(c(seq(from = 0, to = 1, by = progress), 1))[-1] # Always end at 1, ignore first
  breaks <- rep(NA_real_, length(prog_seq))
  base_breaks <- prog_seq * n_rep_new
  # End at the final number of new simulations, regardless of the above
  breaks[length(breaks)] <- n_rep_new
  # For all other breakpoints, add as multiples of the number of cores
  valid_breaks <- (2:(n_rep_new-1))[(2:(n_rep_new-1)) %% cores == 0]
  for (i in seq_along(breaks)[-length(breaks)]) {
    # Select first valid break value which is a multiple of the number of cores
    tmp_break <- valid_breaks[valid_breaks >= base_breaks[i]][1]
    # Remove already used breaks
    valid_breaks <- valid_breaks[valid_breaks > tmp_break]
    breaks[i] <- tmp_break
  }
  # Match valid breaks and matching percentages
  breaks <- breaks[!is.na(breaks)]
  # Final proportion of breaks
  prog_prop <- rep(NA_real_, length(breaks)-1)
  for (i in seq_along(prog_prop)) {
    prog_prop[i] <- prog_seq[which.min(abs(base_breaks - breaks[i]))]
  }
  # End with 1
  prog_prop <- c(prog_prop, 1)

  # Prepare message bases
  prog_mess <- paste0("run_trials: ", format(paste0(c(0, breaks), "/", n_rep_new), justify = "right"),
                      format(paste0(" (", round(c(0, prog_prop) * 100), "%)"), justify = "right"))

  # Prepare batches
  batches <- list()
  prog_prev_n <- 0
  for (i in seq_along(prog_prop)) {
    batches[[i]] <- (prog_prev_n+1):breaks[i]
    prog_prev_n <- breaks[i]
  }

  # Return
  list(breaks = breaks,
       start_mess = paste(prog_mess[1], "[starting]"),
       prog_mess = prog_mess[-1],
       batches = batches)
}



#' Simulate single trial after setting seed
#'
#' Helper function to dispatch the running of several trials to [lapply] or
#' [parallel::parLapply]. Used internally in calls by the [run_trials]
#' function.
#'
#' @param i single integer, the simulation number.
#' @param trial_spec trial specification as provided by [setup_trial],
#'   [setup_trial_binom] or [setup_trial_norm].
#' @inheritParams run_trials
#'
#' @return Single trial simulation object, as described in [run_trial].
#'
#' @keywords internal
#'
dispatch_trial_runs <- function(X, trial_spec, base_seed, sparse, cores, cl = NULL) {
  common_args <- list(X = X, trial_spec = trial_spec, base_seed = base_seed, sparse = sparse)

  run_trial_seed <- function(i, trial_spec, base_seed, sparse) {
    run_trial(trial_spec, seed = if (is.null(base_seed)) NULL else base_seed + i, sparse = sparse)
  }

  if (cores == 1) {
    do.call(lapply, c(common_args, FUN = run_trial_seed))
  } else {
    do.call(parLapply, c(common_args, fun = run_trial_seed, cl = list(cl)))
  }
}



#' Simulate multiple trials
#'
#' This function conducts multiple simulations using a trial specification as
#' specified by [setup_trial], [setup_trial_binom] or [setup_trial_norm]. This
#' function essentially manages random seeds and runs multiple simulation using
#' [run_trial] - additional details on individual simulations are provided in
#' that function's description. This function allows simulating trials in
#' parallel using multiple cores, automatically saving and re-loading saved
#' objects, and "growing" already saved simulation files (i.e., appending
#' additional simulations to the same file).
#'
#' @inheritParams run_trial
#' @param n_rep single integer; the number of simulations to run.
#' @param path single character; if specified (defaults to `NULL`), files will
#'   be written to and  loaded from this path using the [saveRDS] / [readRDS]
#'   functions.
#' @param overwrite single logical; defaults to `FALSE`, in which case previous
#'   simulations saved in the same `path` will be re-loaded (if the same trial
#'   specification was used). If `TRUE`, the previous file is overwritten. If
#'   `grow` is `TRUE`, this argument must be set to `FALSE`.
#' @param grow single logical; defaults to `FALSE`. If `TRUE` and a valid `path`
#'   to a valid previous file containing less simulations than `n_rep`, the
#'   additional number of simulations will be run (appropriately re-using the
#'   same `base_seed`, if specified) and appended to the same file.
#' @param cores single integer; the number of cores to run the simulations on
#'   using the \pkg{parallel} library. Defaults to `1`; may be increased to run
#'   multiple simulations in parallel. [parallel::detectCores()] may be used to
#'   find the number of available cores.
#' @param base_seed single integer; a random seed used as the basis for
#'   simulations; each simulation will set the random seed to a value based on
#'   this (+ the trial number), without affecting the global random seed after
#'   the function has been run.
#' @param sparse single logical, as described in [run_trial]; defaults to
#'   `TRUE` when running multiple simulations, in which case only the data
#'   necessary to summarise all simulations are saved for each simulation.
#'   If `FALSE`, more detailed data for each simulation is saved, allowing more
#'   detailed printing of individual trial results and plotting using
#'   [plot_history] ([plot_status] does not require non-sparse results).
#' @param progress single numeric `> 0` and `<= 1` or `NULL`. If `NULL`
#'   (default), no progress is printed to the console. Otherwise, progress
#'   messages are printed to the control at intervals proportional to the value
#'   specified by progress.\cr
#'   **Note:** as printing is not possible from within clusters on multiple
#'   cores, the function conducts batches of simulations on multiple cores (if
#'   specified), with intermittent printing of statuses. Thus, all cores have to
#'   finish running their current assigned batches before the other cores may
#'   proceed with the next batch. If there is substantial differences in the
#'   simulation speeds across cores, using `progress` may thus increase total
#'   simulation times.
#' @param version passed to [saveRDS] when saving simulations, defaults to
#'   `NULL` (as in [saveRDS]), which means that the current default version is
#'   used. Ignored if simulations are not saved.
#' @param compress passed to [saveRDS] when saving simulations, defaults to
#'   `TRUE` (as in [saveRDS]), see [saveRDS] for other options. Ignored if
#'   simulations are not saved.
#'
#' @return A list of a special class `"trial_results"`, which contains the
#'   `trial_results` (results from all simulations), `trial_spec` (the trial
#'   specification), `n_rep`, `base_seed`, `elapsed_time` (the total simulation
#'   run time) and `sparse` (as described above). These results may be extracted
#'   using the [extract_results] function and summarised using the [summary] or
#'   print ([print.trial_results]) functions; see function documentation for
#'   details on additional arguments used to select arms in simulations not
#'   ending in superiority and other summary choices.
#'
#' @export
#'
#' @import parallel
#'
#' @examples
#' # Setup a trial specification
#' binom_trial <- setup_trial_binom(arms = c("A", "B", "C", "D"),
#'                                  true_ys = c(0.20, 0.18, 0.22, 0.24),
#'                                  data_looks = 1:20 * 100)
#'
#' # Run 10 simulations with a specified random base seed
#' res <- run_trials(binom_trial, n_rep = 10, base_seed = 12345)
#'
#' # See ?summary and ?print for details on summarising and printing
#'
run_trials <- function(trial_spec, n_rep, path = NULL, overwrite = FALSE,
                       grow = FALSE, cores = 1, base_seed = NULL,
                       sparse = TRUE, progress = NULL,
                       version = NULL, compress = TRUE) {

  # Log starting time and validate inputs
  tic <- Sys.time()
  if (is.null(sparse) | length(sparse) != 1 | any(is.na(sparse)) | !is.logical(sparse)) {
    stop("sparse must be a single TRUE or FALSE.", call. = FALSE)
  }
  if ((is.null(path) | overwrite) & !inherits(trial_spec, "trial_spec")) {
    stop("If a path to a file is not provided or if overwrite = TRUE, ",
         "a valid trial specifcation must be provided.", call. = FALSE)
  }
  if (!verify_int(n_rep, min_value = 1) | !verify_int(cores, min_value = 1)) {
    stop("n_rep and cores must be single whole numbers larger than 0.", call. = FALSE)
  }
  if (ifelse(!is.null(path), file.exists(path), FALSE)) { # File exists
    prev <- readRDS(path)
    # To avoid complicated errors with previous functions related to byte-compiling
    # and environments and not easily solved by using identical(), create two
    # copies of the trial specs and set the function arguments to NULL
    # These are then compared using all.equal, followed by comparison of the
    # deparsed functions (= only the function definitions)
    prev_spec_nofun <- prev$trial_spec
    spec_nofun <- trial_spec
    prev_spec_nofun$fun_y_gen <- prev_spec_nofun$fun_draws <- prev_spec_nofun$fun_raw_est <-
      spec_nofun$fun_y_gen <- spec_nofun$fun_draws <- spec_nofun$fun_raw_est <- NULL
    if (!isTRUE(all.equal(prev_spec_nofun, spec_nofun)) |
        !equivalent_funs(prev$trial_spec$fun_y_gen, trial_spec$fun_y_gen) |
        !equivalent_funs(prev$trial_spec$fun_draws, trial_spec$fun_draws) |
        !equivalent_funs(prev$trial_spec$fun_raw_est, trial_spec$fun_raw_est)) {
      stop("The trial specification contained in the object in path is not ",
           "the same as the one provided; thus the previous result was not loaded.", call. = FALSE)
    }
    if (grow & overwrite) {
      stop("Both grow and overwrite are TRUE. At least one of them must be ",
           "FALSE; if grow = TRUE, the object is automatically overwritten.", call. = FALSE)
    }
    prev_n_rep <- prev$n_rep
    if (prev_n_rep != n_rep) {
      if (!grow | n_rep <= prev_n_rep) {
        stop(paste0("n_rep is provided in the call and in the loaded object, ",
                    "but they are not the same (n_rep = ", n_rep, ", previous ",
                    "n_rep = ", prev_n_rep, ").\n",
                    "This is only permitted if the provided n_rep is larger ",
                    "than the n_rep in the loaded object and grow = TRUE."), call. = FALSE)
      }
    } else if (grow & prev_n_rep == n_rep) {
      warning(paste0("grow = TRUE, but the provided n_rep is equal to the ",
                     "n_rep in the loaded object (both = ", n_rep, ").\n",
                     "When grow = TRUE, the provided n_rep must be larger ",
                     "than the n_rep in the loaded object.\n",
                     "Ignoring grow and returning previous object."), call. = FALSE)
      grow <- FALSE
    }
    prev_base_seed <- prev$base_seed
    if (!is.null(prev_base_seed) & !is.null(base_seed)) {
      if (prev_base_seed != base_seed) {
        stop(paste0("A base_seed is provided in the call and in the loaded ",
                    "object, but they are not the same (base_seed = ",
                    base_seed, ", previous base_seed = ", prev_base_seed, ")."), call. = FALSE)
      }
    }
    if (prev$sparse != sparse) {
      stop(paste0("Identical values must be provided for the sparse argument ",
                  "in the call and the previous object (sparse = ", sparse,
                  ", previous sparse = ", prev$sparse, ")."), call. = FALSE)
    }
  } else if (grow) {
    stop("grow = TRUE, but a previous object does not exist.", call. = FALSE)
  }
  if (!is.null(base_seed)) {
    if (!verify_int(base_seed)) {
      stop("base_seed must be either NULL or a single whole number.", call. = FALSE)
    }
  }
  if (!is.null(progress)) {
    if (!isTRUE(length(progress) == 1 & is.numeric(progress) & !(is.na(progress)) && progress >= 0.01 && progress <= 1)) {
      stop("progress must be either NULL or a single numeric value >= 0.01 and <= 1.", call. = FALSE)
    }
  }

  # Run simulations, load object and run additional trials, or just load object
  action <- 3 # 1 = new, 2 = grow, 3 = previous
  if (is.null(path) | overwrite | ifelse(!is.null(path), !file.exists(path), FALSE)) { # Run trials - no growing
    action <- 1
    prev_n_rep <- 0 # Start from the beginning
    prev_res <- NULL # Don't reuse
    elapsed_time <- 0
  } else if (grow) {
    action <- 2
    prev_res <- prev$trial_results
    elapsed_time <- prev$elapsed_time
  }

  if (action < 3) { # Grow or add new
    new_base_seed <- if (is.null(base_seed)) NULL else base_seed + prev_n_rep
    n_rep_new <- n_rep - prev_n_rep

    # Setup cluster if using multiple cores
    if (cores > 1) {
      cl <- makeCluster(cores)
      on.exit(stopCluster(cl), add = TRUE, after = FALSE)
    }

    # Run simulations
    if (is.null(progress)) { # No progress printed
      trials <- dispatch_trial_runs(X = 1:n_rep_new, trial_spec = trial_spec,
                                    base_seed = new_base_seed, sparse = sparse, cores = cores,
                                    cl = if (cores > 1) cl else NULL)
    } else { # Print progress
      # Prepare
      prog_vals <- prog_breaks(progress = progress, n_rep_new = n_rep_new, cores = cores)
      trials <- list()
      prog_prev_n <- 0
      if (prev_n_rep > 0) cat0("run_trials: loaded ", prev_n_rep, " previous simulations, running ", n_rep_new, " new\n")
      cat0(prog_vals$start_mess, "\n")
      # Loop
      for (i in seq_along(prog_vals$breaks)) {
        # Run simulations
        trials[[i]] <- dispatch_trial_runs(X = prog_vals$batches[[i]], trial_spec = trial_spec,
                                           base_seed = new_base_seed, sparse = sparse, cores = cores,
                                           cl = if (cores > 1) cl else NULL)
        # Print status including timestamp
        tmdf <- Sys.time() - tic
        cat0(prog_vals$prog_mess[i], " [", fmt_dig(as.numeric(tmdf), dig = 2), " ", attr(tmdf, "units"), "]", "\n")
      }
      cat("\n")
      # Bind results
      trials <- do.call(c, trials)
    }

    # Prepare result
    res <- structure(list(trial_results = c(prev_res, trials),
                          trial_spec = trial_spec,
                          n_rep = n_rep,
                          base_seed = base_seed,
                          elapsed_time = elapsed_time + Sys.time() - tic,
                          sparse = sparse),
                     class = c("trial_results", "list"))

    if (ifelse(!is.null(path), !file.exists(path) | overwrite | grow, FALSE)) {
      saveRDS(res, file = path, version = version, compress = compress)
    }
  } else { # Don't run new simulations - return previous object
    res <- prev
  }

  # Return
  res
}
