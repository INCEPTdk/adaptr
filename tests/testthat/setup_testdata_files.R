# This files serves to document what RData files are created for tests,
# and may be used to recreate them if needed

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

  res <- run_trials(trial, n_rep = 20, base_seed = 12345, sparse = FALSE)
  save_testdata(res, "binom__results__3_arms__no_control__equivalence__softened")


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
}

