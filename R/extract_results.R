#' Extract simulation results
#'
#' This function extracts relevant information from multiple simulations of the
#' same trial specification in a tidy `data.frame` (1 simulation per row).
#' See also the [summary()] function.
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
#'   trial designs with a common control arm, or a single trial `arm`. Will be
#'   used when calculating `sq_err_te` (the squared error of the treatment
#'   effect comparing the selected arm to the comparator arm, as described
#'   below).
#' @param raw_ests single logical. If `FALSE` (default), the
#'   posterior estimates (`post_ests`, see [setup_trial()] and
#'   [run_trial()]) will be used to calculate `sq_err` (the squared error of the
#'   estimated compared to the specified effect in the selected arm) and
#'   `sq_err_te` (the squared error of the treatment effect comparing the
#'   selected arm to the comparator arm, as described for `te_comp` and below).
#'   If `TRUE`, the raw estimates (`raw_ests`, see [setup_trial()] and
#'   [run_trial()]) will be used instead of the posterior estimates.
#'
#' @return A `data.frame` containing the following columns:
#'   \itemize{
#'     \item `sim`: the simulation number (from 1 to the number of simulations).
#'     \item `final_n`: the final sample size in each simulation.
#'     \item `sum_ys`: the sum of the total counts in all arms, e.g., the total
#'       number of events in trials with a binary outcome
#'       ([setup_trial_binom()]) or the sum of the arm totals in trials with a
#'       continuous outcome ([setup_trial_norm()]).
#'     \item `ratio_ys`: calculated as `sum_ys/final_n`.
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

extract_results <- function(object,
                            select_strategy = "control if available",
                            select_last_arm = FALSE,
                            select_preferences = NULL,
                            te_comp = NULL,
                            raw_ests = FALSE) {

  # Validate input (only checks class)
  if (!inherits(object, "trial_results")){
    stop("object must be an output from the run_trials function.", call. = FALSE)
  }

  # Extract values necessary for summarising results
  n_rep <- object$n_rep
  best_arm <- object$trial_spec$best_arm
  highest_is_best <- object$trial_spec$highest_is_best
  control <- object$trial_spec$control

  # Validate selection strategy
  if (is.null(select_strategy) || length(select_strategy ) != 1){
    stop("select_strategy  must be either 'control if available', 'none', ",
         "control', 'final control', 'control or best', 'best', 'list or best', ",
         "or 'list'.", call. = FALSE)
  } else if (isTRUE(select_strategy %in% c("control", "final control", "control or best"))){
    if (is.null(control)){
      stop("select_strategy is set to 'control', 'final control', or 'control or best', ",
           "but the trial specification includes no common control.", call. = FALSE)
    }
  } else if (isTRUE(select_strategy %in% c("list", "list or best"))){
    arms <- object$trial_spec$trial_arms$arms
    if (is.null(select_preferences) || !isTRUE(all(select_preferences %in% arms)) ||
        any(table(select_preferences) > 1) || length(select_preferences) > length(arms)) {
      stop("When select_strategy is set to 'list' or 'list or best', ",
           "select_preferences must be provided as a vector of valid treatment ",
           "arms with no arms appearing more than once.", call. = FALSE)
    }
  } else if (isTRUE(select_strategy == "control if available")){
    select_strategy  <- if (is.null(control)) "none" else "control"
  } else if (!(select_strategy %in% c("best", "none")) ) {
    stop("select_strateg must be either 'control if available', 'none', ",
         "control', 'final control', 'control or best', 'best', 'list or best', ",
         "or 'list'.", call. = FALSE)
  }
  if (!isTRUE(select_last_arm %in% c(FALSE, TRUE) && length(select_last_arm) == 1)) {
    stop("select_last_arm must be either TRUE or FALSE.", call. = FALSE)
  } else if (is.null(control) & select_last_arm) {
    stop("select_last_arm must be FALSE for trial specifications ",
         "without a common control arm.", call. = FALSE)
  }

  # Validate/set treatment effect comparator
  if (is.null(te_comp)) {
    if (!is.null(control)) {
      te_comp <- control
    }
  } else {
    if (length(te_comp) > 1 | !(te_comp %in% object$trial_spec$trial_arms$arms)) {
      stop("te_comp must be either NULL (in which case the control arm is ",
           "used if specified) or a single valid arm included in the trial.", call. = FALSE)
    }
  }
  te_comp_index <- if (is.null(te_comp)) NULL else which(te_comp == object$trial_spec$trial_arms$arms)
  te_comp_true_y <- if (is.null(te_comp)) NULL else object$trial_spec$trial_arms$true_ys[te_comp_index]

  # Start data extraction
  df <- data.frame(sim = 1:n_rep,
                   final_n = vapply(1:n_rep, function(x) object$trial_results[[x]]$final_n, FUN.VALUE = numeric(1)),
                   sum_ys = vapply(1:n_rep, function(x) sum(object$trial_results[[x]]$trial_res$sum_ys), FUN.VALUE = numeric(1)),
                   ratio_ys = vapply(1:n_rep, function(x) sum(object$trial_results[[x]]$trial_res$sum_ys)/object$trial_results[[x]]$final_n, FUN.VALUE = numeric(1)),
                   final_status = vapply(1:n_rep, function(x) object$trial_results[[x]]$final_status, FUN.VALUE = character(1)),
                   superior_arm = NA,
                   selected_arm = NA,
                   sq_err = NA,
                   sq_err_te = NA,
                   stringsAsFactors = FALSE)

  # Loop: selection and error estimation
  for (i in 1:n_rep) {
    tmp_res <- object$trial_results[[i]]$trial_res
    cur_status <- df$final_status[i]
    cur_select <- NA
    # Superiority
    if (cur_status == "superiority"){
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
      selected_est_y <- ifelse(raw_ests, tmp_res$raw_ests[selected_index], tmp_res$post_ests[selected_index])
      selected_true_y <- tmp_res$true_ys[selected_index]
      df$sq_err[i] <- (selected_est_y - selected_true_y)^2
      if (!is.null(te_comp)){
        if (cur_select != te_comp){
          te_comp_est_y <- ifelse(raw_ests, tmp_res$raw_ests[te_comp_index], tmp_res$post_ests[te_comp_index])
          df$sq_err_te[i] <- ( (selected_est_y - te_comp_est_y) - (selected_true_y - te_comp_true_y) )^2
        }
      }
    }
  }

  # Return
  df
}
