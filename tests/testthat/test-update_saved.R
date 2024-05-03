test_that("updating outdated trial_results objects works", {
  tmp_file <- tempfile()
  on.exit(try(file.remove(tmp_file)), add = TRUE, after = FALSE)

  expect_error(update_saved_trials("invalid_fpath.adaptr"))
  expect_error(update_saved_trials(tmp_file))

  res <- read_testdata("binom__results__3_arms__no_control__equivalence__softened")

  # Test v1.1.1 or before
  pseudo_old_res <- res
  pseudo_old_res$adaptr_version <- NULL # mimic what happened in adaptr until v1.1.1
  pseudo_old_res$trial_spec$rescale_probs <- NULL

  saveRDS(res, tmp_file)
  expect_warning(update_saved_trials(tmp_file))

  saveRDS(pseudo_old_res, tmp_file)
  expect_invisible(update_saved_trials(tmp_file))
  expect_warning(update_saved_trials(tmp_file))

  pseudo_old_res_sparse <- read_testdata("binom__results__3_arms__no_control__equivalence__softened__sparse")
  pseudo_old_res_sparse$adaptr_version <- NULL # mimic what happened in adaptr until v1.1.1
  saveRDS(pseudo_old_res_sparse, tmp_file)
  expect_invisible(update_saved_trials(tmp_file))

  saveRDS(1:10, tmp_file)
  expect_error(update_saved_trials(tmp_file))

  # Test v1.2.0+
  pseudo_old_res <- res
  pseudo_old_res$trial_spec$rescale_probs <- NULL
  pseudo_old_res$adaptr_version <- as.package_version("1.2.0")

  saveRDS(pseudo_old_res, tmp_file)
  expect_identical(update_saved_trials(tmp_file), res)
})

test_that("updating outdated trial_calibration objects works", {
  tmp_file <- tempfile()
  on.exit(try(file.remove(tmp_file)), add = TRUE, after = FALSE)

  expect_error(update_saved_calibration("invalid_fpath.adaptr"))
  expect_error(update_saved_calibration(tmp_file))

  res <- read_testdata("binom___calibration___setup2_arms__no_difference___rar")

  # Test v1.3.0+
  pseudo_old_res <- res
  pseudo_old_res$adaptr_version <- as.package_version("1.3.0")
  pseudo_old_res$input_trial_spec$rescale_probs <- NULL
  pseudo_old_res$best_trial_spec$rescale_probs <- NULL
  pseudo_old_res$best_sims$adaptr_version <- as.package_version("1.3.0")

  saveRDS(res, tmp_file)
  expect_warning(update_saved_calibration(tmp_file))

  saveRDS(pseudo_old_res, tmp_file)
  expect_invisible(update_saved_calibration(tmp_file))
  expect_warning(update_saved_calibration(tmp_file))

  saveRDS(1:10, tmp_file)
  expect_error(update_saved_calibration(tmp_file))
})
