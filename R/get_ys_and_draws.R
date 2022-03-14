#' Generic documentation for get_draws_* functions
#'
#' Used internally. See the [setup_trial] function documentation for additional
#' details on how to specify functions to generate posterior draws.
#'
#' @param arms character vector, **currently active** `arms` as specified in
#'   [setup_trial]/[setup_trial_binom]/[setup_trial_norm].
#' @param allocs character vector, allocations of all patients (including
#'   allocations to **currently inactive** `arms`).
#' @param ys numeric vector, outcomes of all patients in the same order
#'   as `alloc` (including outcomes of patients in **currently inactive**
#'   `arms`).
#' @param control unused argument in the built-in functions for
#'   [setup_trial_binom] and [setup_trial_norm], but required as this
#'   argument is supplied by the [run_trial] function, and may be used in
#'   user-defined functions used to generate posterior draws.
#' @param n_draws single integer, number of posterior draws.
#'
#' @return A `matrix` (with numeric values) with `length(arms)` columns and
#'   `n_draws` rows, with `arms` as column names.
#'
#' @name get_draws_generic
#' @keywords internal
#'
NULL



#' Generate binary outcomes from binomial distributions
#'
#' Used internally. Function factory used to generate a function that generates
#' binary outcomes from binomial distributions.
#'
#' @param arms character vector of `arms` as specified in [setup_trial_binom].
#' @param event_probs numeric vector of true event probabilities in all `arms`
#'   as specified in [setup_trial_binom].
#'
#' @return A function which takes the argument `allocs` (a character vector
#'   with the allocations) and returns a numeric vector of similar length with
#'   the corresponding, randomly generated outcomes (0 or 1, from binomial
#'   distribution).
#'
#' @importFrom stats rbinom
#'
#' @keywords internal
#'
get_ys_binom <- function(arms, event_probs) {
  function(allocs) {
    y <- integer(length(allocs))
    for (i in seq_along(arms)) {
      ii <- which(allocs == arms[i])
      y[ii] <- rbinom(length(ii), 1, event_probs[i])
    }
    y
  }
}



#' Generate draws from posterior beta-binomial distributions
#'
#' Used internally. This function generates draws from posterior distributions
#' using separate beta-binomial models (binomial outcome, conjugate beta prior)
#' for each arm, with flat (`beta(1, 1)`) priors.
#'
#' @inheritParams get_draws_generic
#'
#' @inherit get_draws_generic return
#'
#' @importFrom stats rbeta
#'
#' @keywords internal
#'
get_draws_binom <- function(arms, allocs, ys, control, n_draws) {
  draws <- list()
  for (a in arms) {
    ii <- which(allocs == a)
    n_events <- sum(ys[ii])
    draws[[a]] <- rbeta(n_draws, 1 + n_events, 1 + length(ii) - n_events)
  }
  do.call(cbind, draws)
}


#' Generate normally distributed continuous outcomes
#'
#' Used internally. Function factory used to generate a function that generates
#' outcomes from normal distributions.
#'
#' @param arms character vector, `arms` as specified in [setup_trial_norm].
#' @param means numeric vector, true `means` in all `arms` as specified in
#'   [setup_trial_norm].
#' @param sds numeric vector, true standard deviations (`sds`) in all `arms` as
#'   specified in [setup_trial_norm].
#'
#' @return A function which takes the argument `allocs` (a character vector
#'   with the allocations) and returns a numeric vector of the same length with
#'   the corresponding, randomly generated outcomes (from normal distributions).
#'
#' @importFrom stats rnorm
#'
#' @keywords internal
#'
get_ys_norm <- function(arms, means, sds) {
  function(allocs) {
    y <- numeric(length(allocs))
    for (i in seq_along(arms)) {
      ii <- which(allocs == arms[i])
      y[ii] <- rnorm(length(ii), means[i], sds[i])
    }
    y
  }
}



#' Generate draws from posterior normal distributions
#'
#' Used internally. This function generates draws from posterior, normal
#' distributions for continuous outcomes. Technically, these posteriors use no
#' priors (for simulation speed), corresponding to the use of improper flat
#' priors. These posteriors correspond (and give similar results) to using
#' normal-normal models (normally distributed outcome, conjugate normal prior)
#' for each arm, assuming that a non-informative, flat prior is used. Thus, the
#' posteriors directly correspond to normal distributions with each groups' mean
#' as the mean and each groups' standard error as the standard deviation.
#' As it is necessary to always return valid draws, in cases where <2 patients
#' have been randomised to an `arm`, posterior draws will come from an extremely
#' wide normal distribution with mean corresponding to the mean of all included
#' patients with outcome data and a standard deviation corresponding to the
#' difference between the highest and lowest recorded outcomes for all patients
#' with available outcome data multiplied by 1000.
#'
#' @inheritParams get_draws_generic
#'
#' @inherit get_draws_generic return
#'
#' @importFrom stats rnorm
#'
#' @keywords internal
#'
get_draws_norm <- function(arms, allocs, ys, control, n_draws) {
  draws <- list()
  for (a in arms) {
    ii <- which(allocs == a)
    n <- length(ii)
    if (n > 1){ # Necessary to avoid errors if too few patients have been randomised to this arm yet
      draws[[a]] <- rnorm(n_draws, mean = mean(ys[ii]), sd = sd(ys[ii]) / sqrt(n - 1))
    } else { # Too few patients randomised - extreme uncertainty
      draws[[a]] <- rnorm(n_draws, mean = mean(ys), sd = 1000 * (max(ys) - min(ys)))
    }
  }
  do.call(cbind, draws)
}
