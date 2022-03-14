test_that("Tidy results of simulations from binomial-outcome trial with common control works", {
  res <- read_testdata("binom__results__3_arms__common_control__equivalence__futility__softened")

  expect_snapshot(extract_results(res, select_strategy = "control if available"))
  expect_snapshot(extract_results(res, select_strategy = "none"))
  expect_snapshot(extract_results(res, select_strategy = "control"))
  expect_snapshot(extract_results(res, select_strategy = "final control"))
  expect_snapshot(extract_results(res, select_strategy = "control or best"))
  expect_snapshot(extract_results(res, select_strategy = "best"))

  expect_snapshot(extract_results(res, select_strategy = "list or best", select_preferences = "B"))
  expect_error(extract_results(res, select_strategy = "list or best"))

  expect_snapshot(extract_results(res, select_strategy = "list", select_preferences = "B"))
  expect_error(extract_results(res, select_strategy = "list"))

  expect_snapshot(extract_results(res, te_comp = "C"))
  expect_snapshot(extract_results(res, raw_ests = TRUE))
})

test_that("Tidy results of simulations from binomial-outcome trial without common control works", {
  res <- read_testdata("binom__results__3_arms__no_control__equivalence__softened")

  expect_snapshot(extract_results(res, select_strategy = "control if available"))
  expect_snapshot(extract_results(res, select_strategy = "none"))
  expect_error(extract_results(res, select_strategy = "control"))
  expect_error(extract_results(res, select_strategy = "final control"))
  expect_error(extract_results(res, select_strategy = "control or best"))
  expect_snapshot(extract_results(res, select_strategy = "best"))

  expect_snapshot(extract_results(res, select_strategy = "list or best", select_preferences = "B"))
  expect_error(extract_results(res, select_strategy = "list or best"))

  expect_snapshot(extract_results(res, select_strategy = "list", select_preferences = "B"))
  expect_error(extract_results(res, select_strategy = "list"))

  expect_snapshot(extract_results(res, te_comp = "C"))
  expect_snapshot(extract_results(res, raw_ests = TRUE))
})

test_that("Metric history of specific trial works", {
  res <- read_testdata("binom__result__3_arms__common_control__equivalence__futility__softened")
  expect_snapshot(extract_history(res))
})
