test_that("valid parameters work", {
  res <- read_testdata("binom__results__3_arms__no_control__equivalence__softened")

  # Store seed - check that the entire process does not change it
  set.seed(12345)
  oldseed <- get(".Random.seed", envir = globalenv())

  expect_snapshot(check_performance(res))

  expect_snapshot(check_performance(res, uncertainty = FALSE))
  expect_snapshot(check_performance(res, uncertainty = TRUE, boot_seed = 4131, n_boot = 100))
  expect_snapshot(check_performance(res, uncertainty = TRUE, ci_width = 0.75, boot_seed = 4131, n_boot = 100))

  expect_snapshot(check_performance(res, restrict = "superior"))
  expect_snapshot(check_performance(res, restrict = "selected"))

  expect_snapshot(check_performance(res, restrict = "superior", uncertainty = TRUE, boot_seed = "base", n_boot = 100))
  expect_snapshot(check_performance(res, restrict = "selected", uncertainty = TRUE, boot_seed = "base", n_boot = 100))

  # Same for sequential and parallel computation
  res1 <- suppressWarnings(check_performance(res, uncertainty = TRUE, boot_seed = "base", n_boot = 100))
  res2 <- suppressWarnings(check_performance(res, uncertainty = TRUE, boot_seed = "base", n_boot = 100, cores = 2))
  expect_identical(res1, res2)

  # Check that seed is unchanged
  expect_identical(oldseed, get(".Random.seed", envir = globalenv()))
})

test_that("invalid parameters handled correctly", {
  res <- read_testdata("binom__results__3_arms__no_control__equivalence__softened")

  expect_error(check_performance(res, select_strategy = NULL))
  expect_error(check_performance(res, select_strategy = "inferior"))

  expect_error(check_performance(res, uncertainty = "yes"))
  expect_error(check_performance(res, uncertainty = TRUE, ci_width = 95))

  expect_error(check_performance(res, restrict = "inferior"))

  expect_error(check_performance(res, uncertainty = TRUE, n_boot = 10))
  expect_warning(check_performance(res, uncertainty = TRUE, n_boot = 100))
  expect_error(check_performance(res, uncertainty = TRUE, n_boot = 1000, boot_seed = "wrong"))
  res_no_seed <- res
  res_no_seed$base_seed <- NULL
  expect_error(check_performance(res_no_seed, uncertainty = TRUE, n_boot = 1000, boot_seed = "base"))
  expect_error(check_performance(res, uncertainty = TRUE, n_boot = 1000, boot_seed = 0.5))
})
