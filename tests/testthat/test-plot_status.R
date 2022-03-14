results <- read_testdata("binom__results__3_arms__common_control__equivalence__futility__softened")

test_that("Status plot across arms works", {
  p <- plot_status(results)
  vdiffr::expect_doppelganger("status plot across arms, binomial", p)
})

test_that("Status plot for specific arm works", {
  p <- plot_status(results, arm = "C")
  vdiffr::expect_doppelganger("status plot for arm C, binom", p)
})

test_that("Status extraction works", {
  expect_snapshot(extract_statuses(results, x_value = "look"))
  expect_snapshot(extract_statuses(results, x_value = "n"))
})
