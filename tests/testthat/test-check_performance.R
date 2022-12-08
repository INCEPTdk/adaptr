test_that("valid parameters work", {
  res <- read_testdata("binom__results__3_arms__no_control__equivalence__softened")

  expect_snapshot(check_performance(res))

  expect_snapshot(check_performance(res, uncertainty = FALSE))
  expect_snapshot(check_performance(res, uncertainty = TRUE, boot_seed = 4131, n_boot = 100))
  expect_snapshot(check_performance(res, uncertainty = TRUE, ci_width = 0.75, boot_seed = 4131, n_boot = 100))

  expect_snapshot(check_performance(res, restrict = "superior"))
  expect_snapshot(check_performance(res, restrict = "selected"))
})

test_that("invalid parameters handled correctly", {
  res <- read_testdata("binom__results__3_arms__no_control__equivalence__softened")

  expect_error(check_performance(res, select_strategy = NULL))
  expect_error(check_performance(res, select_strategy = "inferior"))

  expect_error(check_performance(res, uncertainty = "yes"))
  expect_error(check_performance(res, uncertainty = TRUE, ci_width = 95))
})
