test_that("print and summary of single trial work", {
  res <- read_testdata("binom__result__3_arms__common_control__equivalence__futility__softened")
  expect_snapshot(print(res))

  res <- read_testdata("binom__result__3_arms__no_control__equivalence__softened__sparse")
  expect_snapshot(print(res))
})

test_that("print and summary of multiple trials work", {
  res <- read_testdata("binom__results__3_arms__common_control__equivalence__futility__softened")
  expect_snapshot(print(res))
  expect_snapshot(summary(res))

  res <- read_testdata("binom__result__3_arms__no_control__equivalence__softened__sparse")
  expect_snapshot(print(res))
  expect_snapshot(summary(res))
})

test_that("print of trial setup works", {
  res <- read_testdata("binom__setup__3_arms__common_control__equivalence__futility__softened")
  expect_snapshot(print(res))

  res <- read_testdata("norm__setup__3_arms__common_control__matched__varying_probs")
  expect_snapshot(print(res))

  res <- read_testdata("norm__setup__3_arms__common_control__fixed__all_arms_fixed")
  expect_snapshot(print(res))
})


test_that("print and summary handles invalid parameters correctly", {
  res <- read_testdata("binom__setup__3_arms__no_control__equivalence__softened")
  expect_error(print(res, prob_digits = 2.5))

  res <- read_testdata("binom__result__3_arms__common_control__equivalence__futility__softened")
  expect_error(print(res, prob_digits = -0.1))
})
