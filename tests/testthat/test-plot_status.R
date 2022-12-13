results <- read_testdata("binom__results__3_arms__common_control__equivalence__futility__softened")

test_that("Status plot across arms works", {
  p <- plot_status(results)
  vdiffr::expect_doppelganger("status plot across arms, binomial", p)
  res <- read_testdata( "norm__setup__3_arms__common_control__fixed__all_arms_fixed")
  expect_error(plot_status(res))
})

test_that("Status plot for specific arm works", {
  p <- plot_status(results, arm = "C", x_value = "total n")
  vdiffr::expect_doppelganger("status plot for arm C, binom", p)
})

test_that("Status plot for all arms works", {
  p <- plot_status(results, x_value = "followed n", arm = NA)
  vdiffr::expect_doppelganger("status plot for all arms, binomial", p)
})

test_that("Status extraction works", {
  expect_snapshot(extract_statuses(results, x_value = "look"))
  expect_snapshot(extract_statuses(results, x_value = "n"))
  res <- read_testdata( "norm__results__3_arms__common_control__fixed__all_arms_fixed")
  expect_snapshot(extract_statuses(res, x_value = "look"))
})

test_that("Status plot produces errors with invalid input", {
  expect_error(plot_status(results, x_value = "n"))
  expect_error(plot_status(results, arm = c("A", "A", "F")))
})
