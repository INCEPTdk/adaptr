#' Summary of simulated trial results
#'
#' Summarises simulation results from the [run_trials()] function. Uses
#' [extract_results()] and [check_performance()], which may be used directly to
#' extract key trial results without summarising or to calculate performance
#' metrics (with uncertainty measures if desired) and return them in a tidy
#' `data.frame`.
#'
#' @inheritParams extract_results
#' @inheritParams check_performance
#' @param ... additional arguments, not used.
#'
#' @return A `"trial_results_summary"` object containing the following values:
#' \itemize{
#'   \item `n_rep`: the number of simulations.
#'   \item `n_summarised`: as described in [check_performance()].
#'   \item `highest_is_best`: as specified in [setup_trial()].
#'   \item `elapsed_time`: the total simulation time.
#'   \item `size_mean`, `size_sd`, `size_median`, `size_p25`, `size_p75`,
#'     `sum_ys_mean`, `sum_ys_sd`, `sum_ys_median`, `sum_ys_p25`, `sum_ys_p75`,
#'     `ratio_ys_mean`, `ratio_ys_sd`, `ratio_ys_median`, `ratio_ys_p25`,
#'     `ratio_ys_p75`, `prob_conclusive`, `prob_superior`, `prob_equivalence`,
#'     `prob_futility`, `prob_max`, `prob_select_*` (with `*` being all `arm`
#'     names), `rmse`, `rmse_te`, and `idp`: performance metrics as described in
#'     [check_performance()]. Note that all `sum_ys_` and `ratio_ys_` measures
#'     uses the total events across all randomised patients, regardless of
#'     whether they had outcome data available at the last analysis or not, as
#'     described in [extract_results()].
#'   \item `select_strategy`, `select_last_arm`, `select_preferences`,
#'     `te_comp`, `raw_ests`, `final_ests`, `restrict`: as specified above.
#'   \item `control`: the control arm specified by [setup_trial()],
#'     [setup_trial_binom()] or [setup_trial_norm()]; `NULL` if no control.
#'   \item `equivalence_assessed`, `futility_assessed`: single logicals,
#'     specifies whether the trial design specification includes assessments of
#'     equivalence and/or futility.
#'   \item `base_seed`: as specified in [run_trials()].
#'   \item `cri_width`, `n_draws`, `robust`, `description`, `add_info`: as
#'     specified in [setup_trial()], [setup_trial_binom()] or
#'     [setup_trial_norm()].
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
#' # Summarise simulations - select the control arm if available in trials not
#' # ending with a superiority decision
#' res_sum <- summary(res, select_strategy = "control")
#'
#' # Print summary
#' print(res_sum, digits = 1)
#'
#' @name summary
#' @export
#'
#' @seealso
#' [extract_results()], [check_performance()], [plot_convergence()].
#'
summary.trial_results <- function(object,
                                  select_strategy = "control if available",
                                  select_last_arm = FALSE,
                                  select_preferences = NULL,
                                  te_comp = NULL,
                                  raw_ests = FALSE,
                                  final_ests = NULL,
                                  restrict = NULL,
                                  cores = getOption("mc.cores", 1), ...) {

  # Set final_ests
  if (is.null(final_ests)) {
    final_ests <- !all(object$trial_spec$data_looks == object$trial_spec$randomised_at_looks)
  }

  # Calculate performance metrics
  performance <- check_performance(object = object,
                                   select_strategy = select_strategy,
                                   select_preferences = select_preferences,
                                   te_comp = te_comp,
                                   raw_ests = raw_ests, final_ests = final_ests,
                                   restrict = restrict,
                                   cores = cores)

  # Prepare and return summary object
  performance_vec <- as.list(performance$est)
  names(performance_vec) <- performance$metric
  spec_vec <- list(n_rep = object$n_rep,
                    highest_is_best = object$trial_spec$highest_is_best,
                    elapsed_time = object$elapsed_time,
                    select_strategy = select_strategy,
                    select_last_arm = select_last_arm,
                    select_preferences = select_preferences,
                    te_comp = te_comp,
                    raw_ests = raw_ests, final_ests = final_ests,
                    restrict = restrict,
                    control = object$trial_spec$control,
                    equivalence_assessed = !is.null(object$trial_spec$equivalence_prob),
                    futility_assessed = !is.null(object$trial_spec$futility_prob),
                    base_seed = object$base_seed,
                    cri_width = object$trial_spec$cri_width,
                    n_draws = object$trial_spec$n_draws,
                    robust = object$trial_spec$robust,
                    description = object$trial_spec$description,
                    add_info = object$trial_spec$add_info)
  res_list <- c(performance_vec, spec_vec)
  res_list <- res_list[unique(c(c("n_rep", "n_summarised", "highest_is_best",
                                "elapsed_time"), performance$metric,
                              names(spec_vec)))]
  # Return
  structure(res_list, class = c("trial_results_summary", "list"))
}
