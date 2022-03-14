test_that("print and summary of single trial work", {
  res <- read_testdata("binom__result__3_arms__common_control__equivalence__futility__softened")
  expect_snapshot(print(res))
  expect_snapshot(summary(res))
})

test_that("print and summary of multiple trials work", {
  res <- read_testdata("binom__results__3_arms__common_control__equivalence__futility__softened")
  expect_snapshot(print(res))
  expect_snapshot(summary(res))
})

test_that("print of trial setup works", {
  res <- read_testdata("binom__setup__3_arms__common_control__equivalence__futility__softened")
  expect_snapshot(print(res))
})
