#' Summary of simulated trial results
#'
#' Summarises simulation results from the [run_trials()] function. Uses
#' [extract_results()], which may be used directly to extract key trial results
#' without summarising.
#'
#' @inheritParams extract_results
#' @param restrict single character string or `NULL`. If `NULL` (default),
#'   results are summarised for all simulations; if `"superior`, results are
#'   summarised for simulations ending with superiority only; if `"selected"`,
#'   results are summarised for simulations ending with a selected arm
#'   (according to the specified arm selection strategy for simulations not
#'   ending with superiority). Some summary measures (e.g., `prob_conclusive`)
#'   can only be calculated across all simulations and several are calculated
#'   regardless of `restrict` settings, but have substantially different
#'   interpretations if restricted.
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
#'     names), `rmse`, `rmse_te`, `idp`: performance metrics as described in
#'     [check_performance()].
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
#' [extract_results()], [check_performance()].
#'
#'
#' @importFrom stats setNames
#'
summary.trial_results <- function(object,
                                  select_strategy = "control if available",
                                  select_last_arm = FALSE,
                                  select_preferences = NULL, te_comp = NULL,
                                  raw_ests = FALSE, final_ests = NULL,
                                  restrict = NULL, ...) {

  # Set final_ests
  if (is.null(final_ests)) {
    final_ests <- !all(object$trial_spec$data_looks == object$trial_spec$randomised_at_looks)
  }

  # Extract results
  extr_res <- extract_results(
    object = object,
    select_strategy = select_strategy,
    select_preferences = select_preferences,
    te_comp = te_comp,
    raw_ests = raw_ests, final_ests = final_ests
  )

  # Restrict and calculate probability of conclusiveness
  prob_conclusive <- mean(extr_res$final_status != "max")
  if (!is.null(restrict)){
    if (isTRUE(restrict == "superior")){
      extr_res <- extr_res[!is.na(extr_res$superior_arm), ]
      prob_conclusive <- NA # Not sensible when restricted
    } else if (isTRUE(restrict == "selected")){
      extr_res <- extr_res[!is.na(extr_res$selected_arm), ]
      prob_conclusive <- NA # Not sensible when restricted
    } else {
      stop0("restrict must be either NULL, 'superior' or 'selected'.")
    }
  }

  # Calculate all additional summaries
  arms <- object$trial_spec$trial_arms$arms
  n_summarised <- nrow(extr_res)
  count_select <- setNames(vapply_int(c(arms, NA), function(a) if (is.na(a)) sum(is.na(extr_res$selected_arm)) else sum(extr_res$selected_arm == a, na.rm = TRUE)), paste0("count_select_", c(arms, "None")))
  prob_select <- setNames(lapply(count_select, function(x) x/n_summarised), paste0("prob_select_", c(paste0("arm_", arms), "none")))
  n_selected <- sum(!is.na(extr_res$selected_arm))
  true_ys <- object$trial_spec$trial_arms$true_ys
  select_ys_not_na <- count_select[1:length(arms)] / n_selected
  expected_ys <- sum(select_ys_not_na * true_ys)
  idp <- 100 * (expected_ys - min(true_ys)) / (max(true_ys) - min(true_ys))
  idp <- ifelse(object$trial_spec$highest_is_best, idp, 100 - idp)
  idp <- ifelse(is.nan(idp) | is.infinite(idp), NA, idp)

  # Prepare and return summary object
  structure(c(list(n_rep = object$n_rep,
                   n_summarised = n_summarised,
                   highest_is_best = object$trial_spec$highest_is_best,
                   elapsed_time = object$elapsed_time,
                   size_mean = mean(extr_res$final_n),
                   size_sd = sd(extr_res$final_n),
                   size_median = median(extr_res$final_n),
                   size_p25 = quantile(extr_res$final_n, 0.25, names = FALSE),
                   size_p75 = quantile(extr_res$final_n, 0.75, names = FALSE),
                   sum_ys_mean = mean(extr_res$sum_ys),
                   sum_ys_sd = sd(extr_res$sum_ys),
                   sum_ys_median = median(extr_res$sum_ys),
                   sum_ys_p25 = quantile(extr_res$sum_ys, 0.25, names = FALSE),
                   sum_ys_p75 = quantile(extr_res$sum_ys, 0.75, names = FALSE),
                   ratio_ys_mean = mean(extr_res$ratio_ys),
                   ratio_ys_sd = sd(extr_res$ratio_ys),
                   ratio_ys_median = median(extr_res$ratio_ys),
                   ratio_ys_p25 = quantile(extr_res$ratio_ys, 0.25, names = FALSE),
                   ratio_ys_p75 = quantile(extr_res$ratio_ys, 0.75, names = FALSE),
                   prob_conclusive = prob_conclusive,
                   prob_superior = mean(extr_res$final_status == "superiority"),
                   prob_equivalence = mean(extr_res$final_status == "equivalence"),
                   prob_futility = mean(extr_res$final_status == "futility"),
                   prob_max = mean(extr_res$final_status == "max")
  ),
  prob_select,
  list(rmse = sqrt(mean(extr_res$sq_err, na.rm = TRUE)),
       rmse_te = sqrt(mean(extr_res$sq_err_te, na.rm = TRUE)),
       idp = idp,
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
       add_info = object$trial_spec$add_info
  )), class = c("trial_results_summary", "list"))
}
