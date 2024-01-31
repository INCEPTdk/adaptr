test_that("updating outdated trials objects works", {
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

  # Test v1.2.0-1.3.2
  pseudo_old_res <- res
  pseudo_old_res$trial_spec$rescale_probs <- NULL
  pseudo_old_res$adaptr_version <- as.package_version("1.2.0")

  saveRDS(pseudo_old_res, tmp_file)
  expect_identical(update_saved_trials(tmp_file), res)
})
