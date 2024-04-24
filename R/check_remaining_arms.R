#' Check remaining arm combinations
#'
#' This function summarises the numbers and proportions of all combinations of
#' remaining arms (i.e., excluding arms dropped for inferiority or futility at
#' any analysis, and arms dropped for equivalence at earlier analyses in trials
#' with a common `control`) across multiple simulated trial results. The
#' function supplements the [extract_results()], [check_performance()], and
#' [summary()] functions, and is especially useful for designs with `> 2` arms,
#' where it provides details that the other functions mentioned do not.
#'
#' @param object `trial_results` object, output from the [run_trials()]
#'   function.
#' @param ci_width single numeric `>= 0` and `< 1`, the width of the approximate
#'   confidence intervals for the proportions of combinations (calculated
#'   analytically). Defaults to `0.95`, corresponding to 95% confidence
#'   intervals.
#'
#' @return a `data.frame` containing the combinations of remaining arms, sorted
#'   in descending order of, with the following columns:
#' \itemize{
#'   \item `arm_*`, one column per arm, each named as `arm_<arm name>`. These
#'     columns will contain an empty character string `""` for dropped arms
#'     (including arms dropped at the final analysis), and otherwise be
#'     `"superior"`, `"control"`, `"equivalence"` (only if equivalent at the
#'     final analysis), or `"active"`, as described in [run_trial()].
#'   \item `n` integer vector, number of trial simulations ending with the
#'     combination of remaining arms as specified by the preceding columns.
#'   \item `prop` numeric vector, the proportion of trial simulations ending
#'     with the combination of remaining arms as specified by the preceding
#'     columns.
#'   \item `se`,`lo_ci`,`hi_ci`: the standard error of `prop` and the confidence
#'     intervals of the width specified by `ci_width`.
#'   }
#' @export
#'
#' @importFrom stats aggregate qnorm
#'
#' @examples
#' # Setup a trial specification
#' binom_trial <- setup_trial_binom(arms = c("A", "B", "C", "D"),
#'                                  control = "A",
#'                                  true_ys = c(0.20, 0.18, 0.22, 0.24),
#'                                  data_looks = 1:20 * 200,
#'                                  equivalence_prob = 0.7,
#'                                  equivalence_diff = 0.03,
#'                                  equivalence_only_first = FALSE)
#'
#' # Run 35 simulations with a specified random base seed
#' res <- run_trials(binom_trial, n_rep = 25, base_seed = 12345)
#'
#' # Check remaining arms (printed with fewer digits)
#' print(check_remaining_arms(res), digits = 3)
#'
#' @seealso
#' [extract_results()], [check_performance()], [summary()],
#' [plot_convergence()], [plot_metrics_ecdf()].
#'
check_remaining_arms <- function(object, ci_width = 0.95) {

  if (!inherits(object, "trial_results")){
    stop0("object must be an output from the run_trials function.")
  }
  if (isTRUE(is.null(ci_width) | is.na(ci_width) | !is.numeric(ci_width) |
             ci_width >= 1 | ci_width < 0) | length(ci_width) != 1) {
    stop0("ci_width must be a single numeric value >= 0 and < 1.")
  }

  derive_final_arm_status <- function(trial) {
    final_status <- with(
      trial$trial_res,
      ifelse(is.na(status_look) | status_look == max(status_look), final_status, "")
    )
    ifelse(final_status %in% c("inferior", "futile"), "", final_status)
  }

  res <- t(do.call(cbind, lapply(object$trial_results, derive_final_arm_status)))
  agg_res <- aggregate(rep(1, nrow(res)), by = as.data.frame(res), FUN = length)
  names(agg_res) <- c(paste0("arm_", object$trial_spec$trial_arms$arms), "n")
  agg_res <- agg_res[order(-agg_res$n), ]
  rownames(agg_res) <- NULL
  agg_res$prop <- agg_res$n / object$n_rep
  agg_res$se <- sqrt((agg_res$prop * (1 - agg_res$prop)) / agg_res$n)
  agg_res$lo_ci <- pmax(agg_res$prop + qnorm((1 - ci_width) / 2) * agg_res$se, 0)
  agg_res$hi_ci <- pmin(agg_res$prop + qnorm(1 - (1 - ci_width) / 2) * agg_res$se, 1)
  agg_res
}
