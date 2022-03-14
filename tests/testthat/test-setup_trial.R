test_that("Trial with normally distributed outcome is set up correctly", {
  norm_trial <- setup_trial_norm(
    arms = c("Control", "New A", "New B", "New C"),
    true_ys = c(15, 20, 14, 13),
    sds = c(2, 2.5, 1.9, 1.8),
    max_n = 500,
    look_after_every = 50,
    control = "Control",
    control_prob_fixed = "sqrt-based fixed",
    highest_is_best = TRUE,
    soften_power = 0.5
  )

  expect_snapshot(norm_trial)
})


test_that("Trial with binomially distributed outcome is set up correctly", {
  setup <- setup_trial_binom(
    arms = c("Arm A", "Arm B", "Arm C"),
    true_ys = c(0.25, 0.20, 0.30),
    min_probs = rep(0.15, 3),
    data_looks = seq(from = 300, to = 2000, by = 100),
    equivalence_prob = 0.9,
    equivalence_diff = 0.05,
    soften_power = 0.5
  )
  expect_snapshot(setup)

  setup <- setup_trial_binom(
    arms = c("Arm A", "Arm B", "Arm C"),
    true_ys = c(0.25, 0.20, 0.30),
    fixed_probs = c(0.2, NA, NA),
    start_probs = c(0.2, 0.4, 0.4),
    min_probs = c(NA, 0.2, 0.2),
    data_looks = seq(from = 300, to = 2000, by = 100),
    equivalence_prob = 0.9,
    equivalence_diff = 0.05,
    soften_power = 0.5
  )
  expect_snapshot(setup)

  expect_error(
    setup_trial_binom(
      arms = c("Arm A", "Arm B", "Arm C"),
      true_ys = c(0.25, 0.20, 0.30),
      fixed_probs = c(0.15, NA, NA),
      min_probs = rep(0.15, 3),
      data_looks = seq(from = 300, to = 2000, by = 100),
      equivalence_prob = 0.9,
      equivalence_diff = 0.05,
      soften_power = 0.5
    )
  )
})

test_that("Custom trial with log-normally distributed outcome is set up correctly", {
  get_ys_lognorm <- function(allocs) {
    y <- numeric(length(allocs))
    means <- c("Control" = 2.2, "Experimental A" = 2.1, "Experimental B" = 2.3)
    for (arm in names(means)) {
      ii <- which(allocs == arm)
      y[ii] <- rlnorm(length(ii), means[arm], 1.5)
    }
    y
  }

  get_draws_lognorm <- function(arms, allocs, ys, control, n_draws) {
    draws <- list()
    logys <- log(ys)
    for (arm in arms){
      ii <- which(allocs == arm)
      n <- length(ii)
      if (n > 1) {
        draws[[arm]] <- exp(rnorm(n_draws, mean = mean(logys[ii]), sd = sd(logys[ii])/sqrt(n - 1)))
      } else {
        draws[[arm]] <- exp(rnorm(n_draws, mean = mean(logys), sd = 1000 * (max(logys) - min(logys))))
      }
    }
    do.call(cbind, draws)
  }

  lognorm_trial <- setup_trial(
    arms = c("Control", "Experimental A", "Experimental B"),
    true_ys = exp(c(2.2, 2.1, 2.3)),
    fun_y_gen = get_ys_lognorm,
    fun_draws = get_draws_lognorm,
    max_n = 5000,
    look_after_every = 200,
    control = "Control",
    control_prob_fixed = "sqrt-based",
    equivalence_prob = 0.9,
    equivalence_diff = 0.5,
    equivalence_only_first = TRUE,
    highest_is_best = FALSE,
    fun_raw_est = function(x) exp(mean(log(x))) ,
    robust = TRUE,
    description = "continuous, log-normally distributed outcome",
    add_info = "SD on the log scale for all arms: 1.5"
  )

  expect_snapshot(lognorm_trial)
})

test_that("validate setup trial specifications", {
  via_validate <- validate_trial(
    arms = c("A", "B", "C"),
    control = "B",
    true_ys = c(0.25, 0.20, 0.30),
    fun_y_gen = adaptr:::get_ys_binom(c("A", "B", "C"), c(0.25, 0.20, 0.30)),
    fun_draws = adaptr:::get_draws_binom,
    fun_raw_est = mean,
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
    description = "test",
    robust = TRUE
  )

  via_setup <- setup_trial_binom(
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
    description = "test",
    robust = TRUE
  )

  # Process functions for comparison (ignoring environment, bytecode, etc.)
  for (s in c("via_validate", "via_setup")) {
    temp_s <- get(s)
    for (f in c("fun_y_gen", "fun_draws", "fun_raw_est"))
      temp_s[[f]] <- deparse(temp_s[[f]])
    assign(s, temp_s)
  }

  expect_equal(via_validate, via_setup)
})

test_that("Growing trial objects works", {
  setup <- setup_trial_binom(
    arms = c("Arm A", "Arm B", "Arm C"),
    true_ys = c(0.25, 0.20, 0.30),
    min_probs = rep(0.15, 3),
    data_looks = seq(from = 300, to = 2000, by = 100),
    equivalence_prob = 0.9,
    equivalence_diff = 0.05,
    soften_power = 0.5
  )

  # Everything run in one go
  res1 <- run_trials(setup, n_rep = 20, base_seed = 12345)

  # Run in two "batches", saving results in a file
  temp_res_file <- tempfile()
  on.exit(try(rm(temp_res_file), silent = TRUE), add = TRUE, after = FALSE)
  res2 <- run_trials(setup, n_rep = 10, base_seed = 12345, path = temp_res_file)
  res2 <- run_trials(setup, n_rep = 20, base_seed = 12345, path = temp_res_file, grow = TRUE)

  for (s in c("res1", "res2")) {
    temp_s <- get(s)
    temp_s$elapsed_time <- as.difftime(0, units = "secs")
    for (f in c("fun_y_gen", "fun_draws", "fun_raw_est"))
      temp_s[[f]] <- deparse(temp_s[[f]])
    assign(s, temp_s)
  }

  expect_equal(res1, res2)
})
