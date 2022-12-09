# This file serves to document what RData files are created for tests,
# and may be used to recreate them if needed. The contents of the if-statement
# block are intended to be run manually after calling devtools::load_all() when
# working in the development version

if (FALSE) {
  save_testdata <- function(object, filename) {
    saveRDS(object, file.path("inst", "testdata", paste0(filename, ".RData")))
  }

  # Binomial trial with no common control, equivalence testing
  trial <- setup_trial_binom(
    arms = c("A", "B", "C"),
    true_ys = c(0.25, 0.20, 0.30),
    min_probs = rep(0.15, 3),
    data_looks = seq(from = 300, to = 2000, by = 100),
    equivalence_prob = 0.9,
    equivalence_diff = 0.05,
    equivalence_only_first = NULL,
    soften_power = 0.5
  )
  save_testdata(trial, "binom__setup__3_arms__no_control__equivalence__softened")

  res <- run_trial(trial, seed = 12345, sparse = FALSE)
  save_testdata(res, "binom__result__3_arms__no_control__equivalence__softened")

  res <- run_trial(trial, seed = 12345, sparse = TRUE)
  save_testdata(res, "binom__result__3_arms__no_control__equivalence__softened__sparse")

  res <- run_trials(trial, n_rep = 20, base_seed = 12345, sparse = FALSE)
  save_testdata(res, "binom__results__3_arms__no_control__equivalence__softened")

  res <- run_trials(trial, n_rep = 20, base_seed = 12345)
  save_testdata(res, "binom__results__3_arms__no_control__equivalence__softened__sparse")


  # Binomial trial with common control, equivalence and futility testing
  trial <- setup_trial_binom(
    arms = c("A", "B", "C"),
    control = "B",
    true_ys = c(0.25, 0.20, 0.30),
    min_probs = rep(0.15, 3),
    data_looks = seq(from = 300, to = 2000, by = 100),
    equivalence_prob = 0.9,
    equivalence_diff = 0.05,
    equivalence_only_first = FALSE,
    futility_prob = 0.95,
    futility_diff = 0.05,
    futility_only_first = FALSE,
    soften_power = 0.5,
    highest_is_best = TRUE,
  )
  save_testdata(trial, "binom__setup__3_arms__common_control__equivalence__futility__softened")

  res <- run_trial(trial, seed = 12345, sparse = FALSE)
  save_testdata(res, "binom__result__3_arms__common_control__equivalence__futility__softened")

  res <- run_trials(trial, n_rep = 20, base_seed = 12345, sparse = FALSE)
  save_testdata(res, "binom__results__3_arms__common_control__equivalence__futility__softened")

  # Normally distributed outcome trial with common control, "matched" control
  # group allocation, multiple best arms, varying probability thresholds, and
  # additional info (by default)
  trial <- setup_trial_norm(
    arms = c("A", "B", "C"),
    control = "B",
    control_prob_fixed = "match",
    true_ys = c(0.25, 0.25, 0.30),
    sds = rep(1, 3),
    data_looks = seq(from = 200, to = 1000, by = 200),
    superiority = c(0.99, 0.98, 0.97, 0.96, 0.95),
    inferiority = c(0.01, 0.02, 0.03, 0.04, 0.05),
    equivalence_prob = c(0.99, 0.98, 0.97, 0.96, 0.95),
    equivalence_diff = 0.05,
    equivalence_only_first = TRUE,
    futility_prob = c(0.99, 0.98, 0.97, 0.96, 0.95),
    futility_diff = 0.05,
    futility_only_first = TRUE
  )
  save_testdata(trial, "norm__setup__3_arms__common_control__matched__varying_probs")

  # Normally distributed outcome trial with common control, fixed control
  # group allocation, and fixed allocation ratios in all other arms
  trial <- setup_trial_norm(
    arms = c("A", "B", "C"),
    control = "B",
    control_prob_fixed = 1/3,
    fixed_probs = rep(1/3, 3),
    true_ys = c(0.25, 0.25, 0.30),
    sds = rep(1, 3),
    data_looks = seq(from = 200, to = 1000, by = 200)
  )
  save_testdata(trial, "norm__setup__3_arms__common_control__fixed__all_arms_fixed")

  res <- run_trial(trial, seed = 12345)
  save_testdata(res, "norm__result__3_arms__common_control__fixed__all_arms_fixed")

  res <- run_trials(trial, n_rep = 20, base_seed = 12345)
  save_testdata(res, "norm__results__3_arms__common_control__fixed__all_arms_fixed")
}

