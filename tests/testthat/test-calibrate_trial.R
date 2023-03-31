test_that("calibrate_trial works", {
  # Store seed - check that the entire process
  # from trial spec to running to calibration does not change it
  set.seed(12345)
  oldseed <- get(".Random.seed", envir = globalenv())

  spec <- setup_trial_binom(arms = 1:2, true_ys = rep(0.35, 2), data_looks = 500 * 1:5)

  # Run and save
  tmp_file <- tempfile()
  on.exit(try(file.remove(tmp_file)), add = TRUE, after = FALSE)
  res <- suppressMessages(calibrate_trial(spec, n_rep = 100, cores = 1, base_seed = 24,
                                          # Save plots and run verbose to check those and facilitate
                                          # checking plots later
                                          plot = TRUE, verbose = TRUE,
                                          # starting with prev x and prev y just to check
                                          prev_x = 1, prev_y = 0,
                                          path = tmp_file))
  res$elapsed_time <- NULL
  expect_snapshot(res)

  # Check plots
  vdiffr::expect_doppelganger("Gaussian process-based calibration plot", res$plots[[1]])

  # Check that a new calibration immediately succeeds when using previous x/y
  res2 <- suppressMessages(calibrate_trial(spec, n_rep = 100, cores = 2, base_seed = 24,
                                           prev_x = res$evaluations$x, prev_y = res$evaluations$y))
  expect_equal(res$evaluations, res2$evaluations)

  # Check that reloading works
  res_load <- suppressMessages(calibrate_trial(spec, n_rep = 100, cores = 2, base_seed = 24,
                                               # Save plots and run verbose to check those and facilitate
                                               # checking plots later
                                               plot = TRUE, verbose = TRUE,
                                               # starting with prev x and prev y just to check
                                               prev_x = 1, prev_y = 0,
                                               path = tmp_file))
  expect_equal(res$evaluations, res_load$evaluations)

  # Check that seed is unchanged
  expect_identical(oldseed, get(".Random.seed", envir = globalenv()))
})

test_that("calibrate_trial errors/warns/messages correctly", {
  spec <- setup_trial_binom(arms = 1:2, true_ys = rep(0.35, 2), data_looks = 500 * 1:5)

  err_spec <- spec
  class(err_spec) <- "fake trial"
  expect_error(calibrate_trial(err_spec))
  expect_error(calibrate_trial(spec, n_rep = 50))
  expect_error(calibrate_trial(spec, narrow = c(TRUE, FALSE)))
  expect_error(calibrate_trial(spec, narrow = TRUE, noisy = TRUE))
  expect_error(calibrate_trial(spec, noisy = FALSE, base_seed = NULL))
  expect_error(calibrate_trial(spec, noisy = 27))
  expect_error(calibrate_trial(spec, base_seed = "Hello"))
  expect_error(calibrate_trial(spec, base_seed = 1, target = Inf))
  expect_error(calibrate_trial(spec, base_seed = 1, target = c(0.05, 0.1) ))
  expect_error(calibrate_trial(spec, base_seed = 1, search_range = 1))
  expect_error(calibrate_trial(spec, base_seed = 1, search_range = c(1, Inf)))
  expect_error(calibrate_trial(spec, base_seed = 1, search_range = c(1, 1)))
  expect_error(calibrate_trial(spec, base_seed = 1, tol = -1))
  expect_error(calibrate_trial(spec, base_seed = 1, tol = 1:2))
  expect_error(calibrate_trial(spec, base_seed = 1, tol = NULL))
  expect_error(calibrate_trial(spec, base_seed = 1, tol = NA))
  expect_error(calibrate_trial(spec, base_seed = 1, init_n = 1))
  expect_error(calibrate_trial(spec, base_seed = 1, iter_max = 24.3))
  expect_error(calibrate_trial(spec, base_seed = 1, resolution = 99))
  expect_error(calibrate_trial(spec, base_seed = 1, kappa = NA))
  expect_error(calibrate_trial(spec, base_seed = 1, pow = 3))
  expect_error(calibrate_trial(spec, base_seed = 1, lengthscale = - 99))
  expect_error(calibrate_trial(spec, base_seed = 1, lengthscale = c(10, 0.1)))
  expect_error(calibrate_trial(spec, base_seed = 1, scale_x = NULL))
  expect_error(calibrate_trial(spec, base_seed = 1, prev_x = "x"))
  expect_error(calibrate_trial(spec, base_seed = 1, prev_x = 1:3, prev_y = 4:5))
  expect_error(calibrate_trial(spec, base_seed = 1, overwrite = NULL))
  expect_error(calibrate_trial(spec, base_seed = 1, verbose = "Yes, please."))
  expect_error(calibrate_trial(spec, base_seed = 1, plot = NULL))
  expect_error(calibrate_trial(spec, base_seed = 1, fun = "mean"))

  # Check that reloading errors correctly
  # Run and save
  tmp_file <- tempfile()
  on.exit(try(file.remove(tmp_file)), add = TRUE, after = FALSE)
  res <- suppressMessages(calibrate_trial(spec, n_rep = 100, cores = 2, base_seed = 24,
                                          # Save plots and run verbose to check those and facilitate
                                          # checking plots later
                                          plot = TRUE, verbose = TRUE,
                                          # starting with prev x and prev y just to check
                                          prev_x = 1, prev_y = 0,
                                          path = tmp_file))
  # Modify spec and error
  err_spec <- spec
  err_spec$description <- "this will now cause an error"
  expect_error(suppressMessages(
    calibrate_trial(err_spec, n_rep = 100, cores = 2, base_seed = 24,
                    # Save plots and run verbose to check those and facilitate
                    # checking plots later
                    plot = TRUE, verbose = TRUE,
                    # starting with prev x and prev y just to check
                    prev_x = 1, prev_y = 0,
                    path = tmp_file)))
  # Error with invalid controls
  expect_error(suppressMessages(
    calibrate_trial(spec, n_rep = 100, cores = 2, base_seed = 25,
                    # Save plots and run verbose to check those and facilitate
                    # checking plots later
                    plot = TRUE, verbose = TRUE,
                    # starting with prev x and prev y just to check
                    prev_x = 1, prev_y = 0,
                    path = tmp_file)))
  # Error with different functions
  err_res <- res
  err_res$fun <- mean
  saveRDS(err_res, tmp_file)
  expect_error(suppressMessages(
    calibrate_trial(spec, n_rep = 100, cores = 2, base_seed = 24,
                    # Save plots and run verbose to check those and facilitate
                    # checking plots later
                    plot = TRUE, verbose = TRUE,
                    # starting with prev x and prev y just to check
                    prev_x = 1, prev_y = 0,
                    path = tmp_file)))
  # Error with previous version
  err_res <- res
  err_res$adaptr_version <- -99
  saveRDS(err_res, tmp_file)
  expect_error(suppressMessages(
    calibrate_trial(spec, n_rep = 100, cores = 2, base_seed = 25,
                    # Save plots and run verbose to check those and facilitate
                    # checking plots later
                    plot = TRUE, verbose = TRUE,
                    # starting with prev x and prev y just to check
                    prev_x = 1, prev_y = 0,
                    path = tmp_file)))
})
