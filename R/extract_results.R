#' Extract results from a batch of trials from an object with multiple trials
#'
#' Used internally by [extract_results()]. Extracts results from a batch of
#' simulations from a simulation object with multiple simulation results
#' returned by [run_trials()], used to facilitate easy parallelisation.
#'
#' @inheritParams extract_results
#' @param trial_results list of trial results to summarise, the current batch.
#' @param control single character string, the common `control` arm from the
#'   trial (`NULL` if none).
#' @param which_ests single character string, a combination of the `raw_ests`
#'   and `final_ests` arguments from [extract_results()].
#' @param te_comp_index single integer, index of the treatment effect comparator
#'   arm (`NULL` if none).
#' @param te_comp_true_y single numeric value, true `y` value in the treatment
#'   effect comparator arm (`NULL` if none).
#'
#' @return A `data.frame` containing all columns returned by [extract_results()]
#'   and described in that function (`sim` will start from `1`, but this is
#'   changed where relevant by [extract_results()]).
#'
#' @keywords internal
#'
extract_results_batch <- function(trial_results,
                                  control = control,
                                  select_strategy = select_strategy,
                                  select_last_arm = select_last_arm,
                                  select_preferences = select_preferences,
                                  te_comp = te_comp,
                                  which_ests = which_ests,
                                  te_comp_index = te_comp_index,
                                  te_comp_true_y = te_comp_true_y) {
  # Start data extraction
  n_rep <- length(trial_results)
  df <- data.frame(sim = 1:n_rep,
                   final_n = vapply_num(1:n_rep, function(x) trial_results[[x]]$final_n),
                   sum_ys = vapply_num(1:n_rep, function(x) sum(trial_results[[x]]$trial_res$sum_ys_all)),
                   ratio_ys = vapply_num(1:n_rep, function(x) sum(trial_results[[x]]$trial_res$sum_ys_all)/trial_results[[x]]$final_n),
                   final_status = vapply_str(1:n_rep, function(x) trial_results[[x]]$final_status),
                   superior_arm = NA,
                   selected_arm = NA,
                   sq_err = NA,
                   sq_err_te = NA,
                   stringsAsFactors = FALSE)

  # Loop: selection and error estimation
  for (i in 1:n_rep) {
    tmp_res <- trial_results[[i]]$trial_res
    cur_status <- df$final_status[i]
    cur_select <- NA
    # Superiority
    if (cur_status == "superiority") {
      tmp_arm <- tmp_res$arms[tmp_res$final_status == "superior"]
      df$superior_arm[i] <- tmp_arm
      cur_select <- tmp_arm
    } else { # Stopped for equivalence, futility or at max
      tmp_sel <- tmp_res[tmp_res$final_status != "inferior", ] # Remove inferior arms
      tmp_sel <- tmp_sel[tmp_sel$final_status != "futile", ] # Remove futile arms
      # Do not consider arms dropped for equivalence before final stop
      if (cur_status == "equivalence") { # Stopped for equivalence
        # Only consider equivalent arms declared equivalent at final look
        tmp_sel <- tmp_sel[tmp_sel$final_status %in% c("equivalence", "control") & tmp_sel$status_look == df$final_n[[i]], ]
      } else {
        # Only consider arms not stopped for equivalence
        tmp_sel <- tmp_sel[tmp_sel$final_status != "equivalence", ]
      }

      # Select arm in trials not ending in superiority

      # Select last remaining arm, even if not superior, if specified (designs with common control only)
      if (select_last_arm & sum(tmp_sel$final_status %in% c("control", "active")) == 1) {
        cur_select <- tmp_sel$arms[tmp_sel$final_status == "control"]

        # Otherwise select according to selection strategy
      } else if (isTRUE(select_strategy == "none")) {
        cur_select <- NA
      } else if (isTRUE(select_strategy == "control")) {
        cur_select <- ifelse(control %in% tmp_sel$arms, control, NA)
      } else if (isTRUE(select_strategy == "final control")) {
        cur_select <- tmp_sel$arms[tmp_sel$final_status == "control"]
      } else if (isTRUE(select_strategy == "control or best")) {
        best <- tmp_sel$arms[which.max(tmp_sel$probs_best_last)]
        cur_select <- ifelse(control %in% tmp_sel$arms, control, best)
      } else if (isTRUE(select_strategy == "best")) {
        best <- tmp_sel$arms[which.max(tmp_sel$probs_best_last)]
        cur_select <- best
      } else if (isTRUE(select_strategy %in% c("list", "list or best"))) {
        tmp_in <- select_preferences %in% tmp_sel$arms
        cur_select <- ifelse(any(tmp_in), select_preferences[which(tmp_in)[1]], NA)
        if (is.na(cur_select) & select_strategy == "list or best") {
          # None on the list found, choose best remaining
          best <- tmp_sel$arms[which.max(tmp_sel$probs_best_last)]
          cur_select <- best
        }
      }
    }
    df$selected_arm[i] <- cur_select  # End arm selection

    # Calculate errors
    if (!is.na(cur_select)){ # An arm has been selected
      selected_index <- which(tmp_res$arms == cur_select)
      selected_est_y <- tmp_res[[which_ests]][selected_index]
      selected_true_y <- tmp_res$true_ys[selected_index]
      df$sq_err[i] <- (selected_est_y - selected_true_y)^2
      if (!is.null(te_comp)){
        if (cur_select != te_comp){
          te_comp_est_y <- tmp_res[[which_ests]][te_comp_index]
          df$sq_err_te[i] <- ( (selected_est_y - te_comp_est_y) - (selected_true_y - te_comp_true_y) )^2
        }
      }
    }
  }

  # Return
  df
}



#' Extract simulation results
#'
#' This function extracts relevant information from multiple simulations of the
#' same trial specification in a tidy `data.frame` (1 simulation per row).
#' See also the [check_performance()] and [summary()] functions, that uses the
#' output from this function to further summarise simulation results..
#'
#' @param object `trial_results` object, output from the [run_trials()]
#'   function.
#' @param select_strategy single character string. For trials not stopped
#'   due to superiority (or with only 1 arm remaining, if `select_last_arm` is
#'   set to `TRUE` in trial designs with a common `control` arm; see below),
#'   this parameter specifies which arm will be considered selected when
#'   calculating trial design performance metrics (described below;
#'   this corresponds to the consequence of an inconclusive trial, i.e., which
#'   arm would then be used in practice).\cr
#'   The following options are available and must be written exactly as below
#'   (case sensitive, cannot be abbreviated):
#'   \itemize{
#'      \item `"control if available"` (default): selects the **first**
#'         `control` arm for trials with a common control arm ***if*** this arm
#'         is active at end-of-trial, otherwise no arm will be selected. For
#'         trial designs without a common `control`, no arm will be selected.
#'       \item `"none"`: selects no arm in trials not ending with superiority.
#'       \item `"control"`: similar to `"control if available"`, but will throw
#'         an error for trial designs without a common `control` arm.
#'       \item `"final control"`: selects the **final** `control` arm regardless
#'         of whether the trial was stopped for practical equivalence, futility,
#'         or at the maximum sample size; this strategy can only be specified
#'         for trial designs with a common `control` arm.
#'       \item `"control or best"`: selects the **first** `control` arm if still
#'         active at end-of-trial, otherwise selects the best remaining arm
#'         (defined as the remaining arm with the highest probability of being
#'         the best in the final analysis). Only works for trial designs with a
#'         common `control` arm.
#'     \item `"best"`: selects the best remaining arm (as described under
#'       `"control or best"`).
#'     \item `"list or best"`: selects the first remaining arm from a specified
#'       list (specified using `select_preferences`, technically a character
#'       vector). If none of these arms are are active at end-of-trial, the best
#'       remaining arm will be selected (as described above).
#'     \item `"list"`: as specified above, but if no arms on the provided list
#'       remain active at end-of-trial, no arm is selected.
#'    }
#' @param select_last_arm single logical, defaults to `FALSE`. If `TRUE`, the
#'   only remaining active arm (the last `control`) will be selected in trials
#'   with a common `control` arm ending with `equivalence` or `futility`, before
#'   considering the options specified in `select_strategy`. Must be `FALSE` for
#'   trial designs without a common `control` arm.
#' @param select_preferences character vector specifying a number of arms used
#'   for selection if one of the `"list or best"` or `"list"` options are
#'   specified for `select_strategy`. Can only contain valid `arms`
#'   available in the trial.
#' @param te_comp character string, treatment-effect comparator. Can be either
#'   `NULL` (the default) in which case the **first** `control` arm is used for
#'   trial designs with a common control arm, or a string naming a single trial
#'   `arm`. Will be used when calculating `sq_err_te` (the squared error of the
#'   treatment effect comparing the selected arm to the comparator arm, as
#'   described below).
#' @param raw_ests single logical. If `FALSE` (default), the
#'   posterior estimates (`post_ests` or `post_ests_all`, see [setup_trial()]
#'   and [run_trial()]) will be used to calculate `sq_err` (the squared error of
#'   the estimated compared to the specified effect in the selected arm) and
#'   `sq_err_te` (the squared error of the treatment effect comparing the
#'   selected arm to the comparator arm, as described for `te_comp` and below).
#'   If `TRUE`, the raw estimates (`raw_ests` or `raw_ests_all`, see
#'   [setup_trial()] and [run_trial()]) will be used instead of the posterior
#'   estimates.
#' @param final_ests single logical. If `TRUE` (recommended) the final estimates
#'   calculated using outcome data from all patients randomised when trials are
#'   stopped is used (`post_ests_all` or `raw_ests_all`, see [setup_trial()] and
#'   [run_trial()]); if `FALSE`, the estimates calculated for each arm when an
#'   arm is stopped (or at the last adaptive analysis if not before) using data
#'   from patients having reach followed up at this time point and not all
#'   patients randomised (`post_ests` or `raw_ests`, see [setup_trial()] and
#'   [run_trial()]). If `NULL` (the default), this argument will be set to
#'   `FALSE` if outcome data are available immediate after randomisation for all
#'   patients (for backwards compatibility, as final posterior estimates may
#'   vary slightly in this situation, even if using the same data); otherwise it
#'   will be said to `TRUE`. See [setup_trial()] for more details on how these
#'   estimates are calculated.
#' @param cores single integer; the number of cores used to extract simulation
#'   results using the `parallel` library. Defaults to use the `"mc.cores"`
#'   global option if set (`options(mc.cores = <number>)`) and `1` otherwise;
#'   more cores may be used to extract large simulation results quicker. Use
#'   `parallel::detectCores()` to find the number of available cores.
#'
#' @return A `data.frame` containing the following columns:
#'   \itemize{
#'     \item `sim`: the simulation number (from 1 to the number of simulations).
#'     \item `final_n`: the final sample size in each simulation.
#'     \item `sum_ys`: the sum of the total counts in all arms, e.g., the total
#'       number of events in trials with a binary outcome
#'       ([setup_trial_binom()]) or the sum of the arm totals in trials with a
#'       continuous outcome ([setup_trial_norm()]). Always uses all outcomes
#'       from all randomised patients regardless of whether or not all patients
#'       had outcome data available at the time of trial stopping (corresponding
#'       to `sum_ys_all` in results from [run_trial()]).
#'     \item `ratio_ys`: calculated as `sum_ys/final_n` (as described above).
#'     \item `final_status`: the final trial status for each simulation, either
#'       `"superiority"`, `"equivalence"`, `"futility"`, or `"max"`, as
#'       described in [run_trial()].
#'     \item `superior_arm`: the final superior arm in simulations stopped for
#'       superiority, will be `NA` in simulations not stopped for superiority.
#'     \item `selected_arm`: the final selected arm (as described above), will
#'       correspond to the `superior_arm` in simulations stopped for superiority
#'       and be `NA` if no arm is selected. See `select_strategy` above.
#'     \item `sq_err:` the squared error of the estimate in the selected arm,
#'       calculated as `(estimated effect - true effect)^2` for the selected
#'       arms.
#'     \item `sq_err_te`: the squared error of the treatment effect comparing
#'       the selected arm to the comparator arm (as specified in `te_comp`).
#'       Calculated as:\cr
#'       `((estimated effect in the selected arm - estimated effect in the comparator arm) -`
#'       `(true effect in the selected arm - true effect in the comparator arm))^2` \cr
#'       Will be `NA` for simulations without a selected arm or with no
#'       comparator specified (see `te_comp` above).
#'   }
#'
#' @examples
#' # Setup a trial specification
#' binom_trial <- setup_trial_binom(arms = c("A", "B", "C", "D"),
#'                                  control = "A",
#'                                  true_ys = c(0.20, 0.18, 0.22, 0.24),
#'                                  data_looks = 1:20 * 100)
#'
#' # Run 10 simulations with a specified random base seed
#' res <- run_trials(binom_trial, n_rep = 10, base_seed = 12345)
#'
#' # Extract results and Select the control arm if available
#' # in simulations not ending with superiority
#' extract_results(res, select_strategy = "control")
#'
#' @export
#'
#' @import parallel
#'
#' @seealso
#' [check_performance()], [summary()], [plot_convergence()],
#' [plot_metrics_ecdf()].
#'
extract_results <- function(object,
                            select_strategy = "control if available",
                            select_last_arm = FALSE,
                            select_preferences = NULL,
                            te_comp = NULL,
                            raw_ests = FALSE,
                            final_ests = NULL,
                            cores = getOption("mc.cores", 1)) {

  # Validate input (only checks class)
  if (!inherits(object, "trial_results")){
    stop0("object must be an output from the run_trials function.")
  }

  # Set final_ests
  if (is.null(final_ests)) {
    final_ests <- !all(object$trial_spec$data_looks == object$trial_spec$randomised_at_looks)
  }

  # Extract values necessary for summarising results
  n_rep <- object$n_rep
  best_arm <- object$trial_spec$best_arm
  highest_is_best <- object$trial_spec$highest_is_best
  control <- object$trial_spec$control

  # Validate selection strategy
  if (is.null(select_strategy) || length(select_strategy ) != 1){
    stop0("select_strategy  must be either 'control if available', 'none', ",
          "control', 'final control', 'control or best', 'best', 'list or best', ",
          "or 'list'.")
  } else if (isTRUE(select_strategy %in% c("control", "final control", "control or best"))){
    if (is.null(control)){
      stop0("select_strategy is set to 'control', 'final control', or 'control or best', ",
            "but the trial specification includes no common control.")
    }
  } else if (isTRUE(select_strategy %in% c("list", "list or best"))){
    arms <- object$trial_spec$trial_arms$arms
    if (is.null(select_preferences) || !isTRUE(all(select_preferences %in% arms)) ||
        any(table(select_preferences) > 1) || length(select_preferences) > length(arms)) {
      stop0("When select_strategy is set to 'list' or 'list or best', ",
            "select_preferences must be provided as a vector of valid treatment ",
            "arms with no arms appearing more than once.")
    }
  } else if (isTRUE(select_strategy == "control if available")){
    select_strategy  <- if (is.null(control)) "none" else "control"
  } else if (!(select_strategy %in% c("best", "none")) ) {
    stop0("select_strategy must be either 'control if available', 'none', ",
          "control', 'final control', 'control or best', 'best', 'list or best', ",
          "or 'list'.")
  }
  if (!isTRUE(select_last_arm %in% c(FALSE, TRUE) && length(select_last_arm) == 1)) {
    stop0("select_last_arm must be either TRUE or FALSE.")
  } else if (is.null(control) & select_last_arm) {
    stop0("select_last_arm must be FALSE for trial specifications ",
          "without a common control arm.")
  }

  # Validate/set treatment effect comparator
  if (is.null(te_comp)) {
    if (!is.null(control)) {
      te_comp <- control
    }
  } else {
    if (length(te_comp) > 1 | !(te_comp %in% object$trial_spec$trial_arms$arms)) {
      stop0("te_comp must be either NULL (in which case the control arm is ",
            "used if specified) or a single valid arm included in the trial.")
    }
  }
  te_comp_index <- if (is.null(te_comp)) NULL else which(te_comp == object$trial_spec$trial_arms$arms)
  te_comp_true_y <- if (is.null(te_comp)) NULL else object$trial_spec$trial_arms$true_ys[te_comp_index]

  # Validate cores
  if (!verify_int(cores, min_value = 1)) {
    stop0("cores must be single whole number larger than 0.")
  }

  # Define which estimates to use
  which_ests <- paste0(ifelse(raw_ests, "raw", "post"), "_ests", ifelse(final_ests, "_all", ""))

  # Extract data using multiple cores if requested
  if (cores == 1) { # Single core
    res <- extract_results_batch(trial_results = object$trial_results,
                                 control = control, select_strategy = select_strategy,
                                 select_last_arm = select_last_arm,
                                 select_preferences = select_preferences,
                                 te_comp = te_comp, which_ests = which_ests,
                                 te_comp_index = te_comp_index,
                                 te_comp_true_y = te_comp_true_y)
  } else { # Multiple cores
    # Setup cores
    cl <- makeCluster(cores)
    on.exit(stopCluster(cl), add = TRUE, after = FALSE)
    # Derive chunks
    chunks <- lapply(1:cores, function(x) {
      size <- ceiling(n_rep / cores)
      start <- (size * (x-1) + 1)
      object$trial_results[start:min(start - 1 + size, n_rep)]
    })
    # Extract
    res <- do.call(rbind,
                   clusterApply(cl = cl, x = chunks, fun = extract_results_batch,
                                control = control, select_strategy = select_strategy,
                                select_last_arm = select_last_arm,
                                select_preferences = select_preferences,
                                te_comp = te_comp, which_ests = which_ests,
                                te_comp_index = te_comp_index,
                                te_comp_true_y = te_comp_true_y))
    res$sim <- 1:n_rep # Overwrite simulation numbers
  }
  res
}
