#' Calculate the probabilities of each arm being the best
#'
#' Used internally. This function takes a `matrix` as calculated by the
#' [get_draws_binom()], [get_draws_norm()] or a corresponding custom function
#' (as specified using the `fun_draws` argument in [setup_trial()]; see
#' [get_draws_generic()]) and calculates the probabilities of each arm being the
#' best (defined as either the highest or the lowest value, as specified by the
#' `highest_is_best` argument in [setup_trial()], [setup_trial_binom()] or
#' [setup_trial_norm()]).
#'
#' @param m a matrix with one column per trial arm (named as the `arms`) and one
#'   row for each draw from the posterior distributions.
#' @inheritParams setup_trial
#'
#' @return A named numeric vector of probabilities (names corresponding to
#'   `arms`).
#'
#' @importFrom stats setNames
#'
#' @keywords internal
#'
prob_best <- function(m, highest_is_best = FALSE) {
  winners <- max.col(if (highest_is_best) m else -m, ties.method = "first")
  setNames(
    vapply(seq_len(ncol(m)), function(i) mean(winners == i), FUN.VALUE = numeric(1)),
    colnames(m)
  )
}



#' Calculate the probabilities that each arm is better than a common control
#'
#' Used internally. This function takes a `matrix` as calculated by the
#' [get_draws_binom()], [get_draws_norm()] or a corresponding custom function
#' (as specified using the `fun_draws` argument in [setup_trial()]; see
#' [get_draws_generic()]) and a single character specifying the `control` arm,
#' and calculates the probabilities of each arm being better than a common
#' `control` (defined as either higher or lower than the `control`, as specified
#' by the `highest_is_best` argument in [setup_trial()], [setup_trial_binom()]
#' or [setup_trial_norm()]). This function also calculates equivalence and
#' futility probabilities compared to the common `control` arm, as specified in
#' [setup_trial()], [setup_trial_binom()] or [setup_trial_norm()], unless
#' `equivalence_diff` or `futility_diff`, respectively, are set to `NULL`
#' (the default).
#'
#' @inheritParams prob_best
#' @inheritParams setup_trial
#'
#' @param control a single character string specifying the common `control` arm.
#'
#' @return A named (rownames corresponding to the trial `arms`) `matrix`
#' containing 1-3 columns: `probs_better`, `probs_equivalence` (if
#' `equivalence_diff` is specified), and `probs_futile` (if `futility_diff` is
#' specified). All columns will contain `NA` for the control arm.
#'
#' @keywords internal
#'
prob_better <- function(m, control = NULL, highest_is_best = FALSE,
                        equivalence_diff = NULL, futility_diff = NULL) {
  compare_fun <- if (highest_is_best) `>` else `<`
  col_control <- m[, control]
  m[, control] <- NA

  res <- matrix(
    apply(m, 2, function(col) mean(compare_fun(col, col_control))),
    dimnames = list(colnames(m), "probs_better")
  )

  # Bind objects - do not return early if both equivalence and futility are assessed
  if (!is.null(equivalence_diff)) {
    equivalence_fun <- function(col) {
      mean(abs(col - col_control) < equivalence_diff)
    }
    res <- cbind(res, probs_equivalence = apply(m, 2, equivalence_fun))
  }

  if (!is.null(futility_diff)) {
    futility_fun <- function(col) {
      mean(ifelse(highest_is_best, -1, 1) * (col_control - col) < futility_diff)
    }
    res <- cbind(res, probs_futility = apply(m, 2, futility_fun))
  }

  res
}



#' Calculate the probability that all arms are practically equivalent
#'
#' Used internally. This function takes a `matrix` as calculated by the
#' [get_draws_binom()], [get_draws_norm()] or a corresponding custom function
#' (specified using the `fun_draws` argument in [setup_trial()]; see
#' [get_draws_generic()]), and an equivalence difference, and calculates the
#' probability of all arms being equivalent (absolute differences between
#' highest and lowest value in the same set of posterior draws being less than
#' the difference considered equivalent).

#' @inheritParams prob_best
#' @inheritParams setup_trial
#'
#' @return A single numeric value corresponding to the probability of all arms
#'   being practically equivalent.
#'
#' @keywords internal
#'
prob_all_equi <- function(m, equivalence_diff = NULL) {
  l <- lapply(seq_len(ncol(m)), function(i) m[, i])
  mean((do.call(pmax.int, l) - do.call(pmin.int, l)) < equivalence_diff)
}



#' Update allocation probabilities
#'
#' Used internally. This function calculates new allocation probabilities for
#' each arm, based on the information specified in [setup_trial()],
#' [setup_trial_binom()] or [setup_trial_norm()] and the calculated
#' probabilities of each arm being the best by [prob_best()].
#'
#' @param probs_best a resulting named vector from the [prob_best()] function.
#' @param match_arm index of the `control` arm. If not `NULL` (default), the
#'   control arm allocation probability will be similar to that of the best
#'   non-control arm. Must be `NULL` in designs without a common control arm.
#' @inheritParams setup_trial
#'
#' @return A named (according to the `arms`) numeric vector with updated
#'   allocation probabilities.
#'
#' @importFrom stats setNames
#'
#' @keywords internal
#'
reallocate_probs <- function(probs_best, fixed_probs, min_probs, max_probs,
                             soften_power = 1, match_arm = NULL) {

  # Match the control arm allocation ratio to the best arm's ratio if specified
  if (!is.null(match_arm) & length(probs_best) > 1) {
    probs_best[match_arm] <- max(probs_best[-match_arm])

    # Avoid 0 probabilities for all arms when matching
    if (all(probs_best == 0)) probs_best <- rep(1, length(probs_best))

    probs_best <- rescale(probs_best)
  }

  # Return results without looping if no restrictions are provided (after
  # raising to soften_power and rescaling, if needed)
  if (all(is.na(c(fixed_probs, min_probs, max_probs)))) {
    return(setNames(rescale(probs_best^soften_power), names(probs_best)))
  }

  # If all probabilities are fixed, just return those unless some arms are
  # dropped (or it exceeds 1 due to a fixed control arm ratio), then rescale.
  # Does not consider matching if all are fixed.
  if (all(!is.na(fixed_probs))) {
    return(setNames(rescale(fixed_probs), names(probs_best)))
  }

  # Restrictions provided; correct probabilities until all are within limits
  final_probs <- setNames(fixed_probs, names(probs_best)) # Ensure named vector as output
  while (abs(sum(final_probs, na.rm = TRUE) - 1) > .Machine$double.eps^0.5) {
    total_remaining_probs <- 1 - sum(final_probs, na.rm = TRUE)
    remaining_probs_arms <- is.na(final_probs)
    remaining_probs_sum <- sum(probs_best[remaining_probs_arms])

    tmp_factor <- if (remaining_probs_sum > 0) {
      probs_best / remaining_probs_sum
    } else {
      1 / sum(remaining_probs_arms)
    }

    tmp_probs <- ifelse(remaining_probs_arms, total_remaining_probs * tmp_factor, final_probs)

    # If desired, raise non-fixed allocation probabilities to desired power,
    # distribute remaining probability and rescale
    if (soften_power < 1) {
      tmp_probs[remaining_probs_arms] <- total_remaining_probs *
        rescale(tmp_probs[remaining_probs_arms]^soften_power)
    }

    # Check and correct probability limits
    min_idx <- !is.na(min_probs) & remaining_probs_arms & tmp_probs < min_probs
    tmp_probs[min_idx] <- final_probs[min_idx] <- min_probs[min_idx]

    max_idx <- !is.na(max_probs) & remaining_probs_arms & tmp_probs > max_probs
    tmp_probs[max_idx] <- final_probs[max_idx] <- max_probs[max_idx]

    # If all tmp values are good, then set final values to those
    if (abs(sum(tmp_probs) - 1) <= .Machine$double.eps^0.5) {
      final_probs <- tmp_probs
    }

    # If all probabilities are final but do not sum to 1 (due to a fixed control
    # allocation probability, a new control or other restrictions), rescale
    if (!any(is.na(final_probs)) & abs(sum(final_probs) - 1) > .Machine$double.eps^0.5) {
      final_probs <- rescale(final_probs)
    }
  }

  # Return
  final_probs
}
