test_that("single trial simulation works", {
  setup <- read_testdata("binom__setup__3_arms__no_control__equivalence__softened")
  res <- read_testdata("binom__result__3_arms__no_control__equivalence__softened")
  expect_equal(run_trial(setup, seed = 12345, sparse = FALSE), res)

  setup <- read_testdata("binom__setup__3_arms__common_control__equivalence__futility__softened")
  res <- read_testdata("binom__result__3_arms__common_control__equivalence__futility__softened")
  expect_equal(run_trial(setup, seed = 12345, sparse = FALSE), res)

  setup_equi_futil_only_first <- setup_trial_binom(
    arms = c("A", "B", "C"),
    control = "B",
    control_prob_fixed = 1/3,
    fixed_probs = c(NA, 1/3, NA),
    true_ys = c(0.2, 0.21, 0.7),
    data_looks = seq(from = 500, to = 2000, by = 500),
    equivalence_prob = 0.9,
    equivalence_diff = 0.25,
    equivalence_only_first = TRUE,
    futility_prob = 0.95,
    futility_diff = 0.05,
    futility_only_first = TRUE
  )
  expect_snapshot(run_trial(setup_equi_futil_only_first, seed = 12345))

  setup_equi_futil_only_first2 <- setup_trial_binom(
    arms = c("A", "B", "C"),
    control = "B",
    control_prob_fixed = c(1/3, 1/2),
    fixed_probs = c(NA, 1/3, NA),
    true_ys = c(0.2, 0.21, 0.7),
    data_looks = seq(from = 500, to = 2000, by = 500),
    equivalence_prob = 0.9,
    equivalence_diff = 0.25,
    equivalence_only_first = TRUE,
    futility_prob = 0.95,
    futility_diff = 0.05,
    futility_only_first = TRUE
  )
  expect_snapshot(run_trial(setup_equi_futil_only_first, seed = 12345))
})

test_that("Single trial simulation errors on invalid inputs", {
  setup <- read_testdata("binom__setup__3_arms__no_control__equivalence__softened")
  setup_wrong <- setup
  class(setup_wrong) <- "list"
  expect_error(run_trial(setup_wrong, seed = 4131))
  expect_error(run_trial(setup, seed = "invalid"))
  expect_error(run_trial(setup, sparse = NA))
})

test_that("dispatch_trial_runs works", {
     setup <- read_testdata("binom__setup__3_arms__common_control__equivalence__futility__softened")

     # Manage random seeds
     #oldseed <- get(".Random.seed", envir = globalenv())
     #on.exit(assign(".Random.seed", value = oldseed, envir = globalenv()), add = TRUE, after = FALSE)
     old_rngkind <- RNGkind("L'Ecuyer-CMRG", "default", "default")
     #on.exit(RNGkind(kind = old_rngkind[1], normal.kind = old_rngkind[2], sample.kind = old_rngkind[3]), add = TRUE, after = FALSE)
     set.seed(12345)
     seeds <- list(get(".Random.seed", envir = globalenv()))
     for (i in 2:5) {
       seeds[[i]] <- nextRNGStream(seeds[[i - 1]])
     }

     # Serial run
     expect_snapshot(
       dispatch_trial_runs(1:5, setup, seeds = seeds, sparse = FALSE, cores = 1)
     )

     # Parallel run
     # Test only run conditionally, see check_cluster_version() function for
     # explanation.
     cl <- parallel::makeCluster(2)
     on.exit(parallel::stopCluster(cl))
     parallel::clusterEvalQ(cl, RNGkind("L'Ecuyer-CMRG", "default", "default"))
     if (check_cluster_version(cl)) {
       expect_snapshot(
         dispatch_trial_runs(1:5, setup, seeds = seeds, sparse = TRUE, cores = 2, cl = cl)
       )
     }

     RNGkind(kind = old_rngkind[1], normal.kind = old_rngkind[2], sample.kind = old_rngkind[3])
})

test_that("Multiple trials simulation works", {
  setup <- read_testdata("binom__setup__3_arms__no_control__equivalence__softened")
  res <- run_trials(setup, n_rep = 20, base_seed = 12345, sparse = FALSE)

  sink_file <- tempfile() # diverts progress bar to not distort test output
  on.exit(try(file.remove(sink_file)), add = TRUE, after = FALSE)
  sink(sink_file)
  res_with_progress <- run_trials(setup, n_rep = 20, base_seed = 12345, sparse = FALSE, progress = 0.1)
  sink()

  loaded_res <- read_testdata("binom__results__3_arms__no_control__equivalence__softened")

  # Harmonise items known to be problematic (run-time and functions)
  for (x in c("res", "loaded_res", "res_with_progress")) {
    temp_x <- get(x)
    temp_x$elapsed_time <- as.difftime(0, units = "secs")
    for (f in c("fun_y_gen", "fun_draws", "fun_raw_est"))
      temp_x$trial_spec[[f]] <- deparse(temp_x$trial_spec[[f]])
    assign(x, temp_x)
  }

  expect_equal(res, loaded_res)
  expect_equal(res, res_with_progress)
})

test_that("prog_breaks", {
  expect_snapshot(prog_breaks(0.1, prev_n_rep = 10, n_rep_new = 20, cores = 1))
  expect_snapshot(prog_breaks(0.1, prev_n_rep = 0, n_rep_new = 10, cores = 2))
})

# This test also uses extract_results, to avoid the issue mentioned at the top
test_that("Multiple trials simulation works on multiple cores", {
  setup <- read_testdata("binom__setup__3_arms__no_control__equivalence__softened")
  res <- run_trials(setup, n_rep = 20, base_seed = 12345, sparse = FALSE)
  expect_snapshot(extract_results(res)) # Avoid empty test

  # Tests only run conditionally, see check_cluster_version() function for
  # explanation. This cluster is only used to check version of adaptr on the cluster
  cl <- parallel::makeCluster(2)
  on.exit(parallel::stopCluster(cl))

  if (check_cluster_version(cl, "1.0.0")) { # Any released version of adaptr installed
    # Run trials on multiple cores
    res_mc <- run_trials(setup, n_rep = 20, base_seed = 12345, sparse = FALSE, cores = 2)

    # Always test using extract_results to avoid issues mentioned in check_cluster_version()
    expect_equal(extract_results(res),
                 extract_results(res_mc))


    # Only test íf most updated version installed
    if (check_cluster_version(cl)) {
      # Harmonise items know to be problematic (run-time and functions)
      for (x in c("res", "res_mc")) {
        temp_x <- get(x)
        temp_x$elapsed_time <- as.difftime(0, units = "secs")
        for (f in c("fun_y_gen", "fun_draws", "fun_raw_est"))
          temp_x$trial_spec[[f]] <- deparse(temp_x$trial_spec[[f]])
        assign(x, temp_x)
      }
      expect_equal(res, res_mc)
    }
  }
})

test_that("run_trials errors on invalid input", {
  setup <- read_testdata("binom__setup__3_arms__no_control__equivalence__softened")
  expect_error(run_trials(setup, n_rep = 10, sparse = NA))
  expect_error(run_trials(list(), n_rep = 10))
  expect_error(run_trials(setup, n_rep = 1:10, cores = 0.5))

  res <- run_trials(setup, n_rep = 10, base_seed = 4131)
  temp_res_file <- tempfile()
  on.exit(try(rm(temp_res_file), silent = TRUE), add = TRUE, after = FALSE)

  # Error growing object from pseudo-previous version
  res_err <- res
  res_err$adaptr_version <- NULL
  saveRDS(object = res_err, file = temp_res_file)
  expect_error(run_trials(setup, n_rep = 10, path = temp_res_file, base_seed = 4131))

  # Error with trial spec
  res_err <- res
  res_err$trial_spec$control <- "A"
  saveRDS(object = res_err, file = temp_res_file)
  expect_error(run_trials(setup, n_rep = 10, path = temp_res_file, base_seed = 4131))

  # Error with both grow and overwrite being TRUE
  expect_error(run_trials(setup, n_rep = 10, path = temp_res_file, grow = TRUE, overwrite = TRUE))

  # Error with n_rep being smaller than previous and warning with equal and grow == TRUE
  saveRDS(object = res, file = temp_res_file)
  expect_error(run_trials(setup, n_rep = 8, path = temp_res_file, base_seed = 4131))
  expect_warning(run_trials(setup, n_rep = 10, path = temp_res_file, grow = TRUE, base_seed = 4131))

  # Error with sparse being different
  expect_error(run_trials(setup, n_rep = 10, path = temp_res_file, base_seed = 4131, sparse = FALSE))

  # Error with base_seed from previous version
  res_err <- res
  res_err$base_seed <- 1234
  saveRDS(object = res_err, file = temp_res_file)
  expect_error(run_trials(setup, n_rep = 10, path = temp_res_file, base_seed = 4131))

  # grow == TRUE and invalid file path
  expect_error(run_trials(setup, n_rep = 10, path = paste0(temp_res_file, ".error"), grow = TRUE))

  # Other other values
  expect_error(run_trials(setup, n_rep = 10, base_seed = 0.3))
  expect_error(run_trials(setup, n_rep = 10, base_seed = 1, progress = 10))
  expect_error(run_trials(setup, n_rep = 10, base_seed = 1, cores = 0:1))

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
  # Grow with progress bar to test
  sink_file <- tempfile() # diverts progress bar to not distort test output
  on.exit(try(file.remove(sink_file)), add = TRUE, after = FALSE)
  sink(sink_file)
  res2 <- run_trials(setup, n_rep = 20, base_seed = 12345, path = temp_res_file, grow = TRUE, progress = 0.05)
  sink()

  # Reload without growing
  res3 <- run_trials(setup, n_rep = 20, base_seed = 12345, temp_res_file)

  for (s in c("res1", "res2", "res3")) {
    temp_s <- get(s)
    temp_s$elapsed_time <- as.difftime(0, units = "secs")
    for (f in c("fun_y_gen", "fun_draws", "fun_raw_est"))
      temp_s[[f]] <- deparse(temp_s[[f]])
    assign(s, temp_s)
  }

  expect_equal(res1, res2)
  expect_equal(res1, res3)
})

