# This test commented out
# Caused an error when a previous version of the adaptr package is installed -
# functions from the package and not the updated functions from the development
# version are loaded on the multiple cores. The export solution only solves this
# when the package is not installed.

# test_that("dispatch_trial_runs works", {
#   setup <- read_testdata("binom__setup__3_arms__common_control__equivalence__futility__softened")
#
#   # Serial run
#   expect_snapshot(
#     dispatch_trial_runs(1:5, setup, base_seed = 12345, sparse = FALSE, cores = 1)
#   )
#
#   # Parallel run
#   cl <- parallel::makeCluster(2)
#   on.exit(parallel::stopCluster(cl))
#   # Necessary to avoid testing error due to versions of functions from previous installed package being loaded on the cluster
#   parallel::clusterExport(cl, ls("package:adaptr"))
#   expect_snapshot(
#     dispatch_trial_runs(1:5, setup, base_seed = 12345, sparse = TRUE, cores = 2, cl = cl)
#   )
# })

test_that("single trial simulation works", {
  setup <- read_testdata("binom__setup__3_arms__no_control__equivalence__softened")
  res <- read_testdata("binom__result__3_arms__no_control__equivalence__softened")
  expect_equal(run_trial(setup, seed = 12345, sparse = FALSE), res)

  setup <- read_testdata("binom__setup__3_arms__common_control__equivalence__futility__softened")
  res <- read_testdata("binom__result__3_arms__common_control__equivalence__futility__softened")
  expect_equal(run_trial(setup, seed = 12345, sparse = FALSE), res)
})

test_that("multiple trials simulation works", {
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
  expect_snapshot(prog_breaks(0.1, n_rep_new = 10, cores = 1))
  expect_snapshot(prog_breaks(0.1, n_rep_new = 10, cores = 2))
})

# This test also uses extract_results, to avoid the issue mentioned at the top
test_that("multiple trials simulation works on multiple cores", {
  setup <- read_testdata("binom__setup__3_arms__no_control__equivalence__softened")
  res_extr <- extract_results(run_trials(setup, n_rep = 20, base_seed = 12345, sparse = FALSE))
  res_mc_extr <- extract_results(run_trials(setup, n_rep = 20, base_seed = 12345, sparse = FALSE, cores = 2))
  expect_equal(res_extr, res_mc_extr)
})
