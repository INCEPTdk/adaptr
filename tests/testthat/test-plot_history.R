test_that("history of multiple binom trials works", {
  res <- read_testdata("binom__results__3_arms__common_control__equivalence__futility__softened")

  p <- plot_history(res)
  vdiffr::expect_doppelganger("history plot, binomial, multiple, prob", p)

  p <- plot_history(res, y_value = "pct")
  vdiffr::expect_doppelganger("history plot, binomial, multiple, pct", p)

  p <- plot_history(res, y_value = "pct", x_value = "total n")
  vdiffr::expect_doppelganger("history plot, binomial, multiple, pct, total n", p)

  p <- plot_history(res, y_value = "pct", x_value = "followed n")
  vdiffr::expect_doppelganger("history plot, binomial, multiple, pct, followed n", p)

  p <- plot_history(res, y_value = "pct", x_value = "followed n", cores = 2)
  vdiffr::expect_doppelganger("history plot, binomial, multiple, pct, followed n, 2 cores", p)
})

test_that("history of single trial works", {
  res <- read_testdata("binom__result__3_arms__common_control__equivalence__futility__softened")

  p <- plot_history(res)
  vdiffr::expect_doppelganger("history plot, binomial, single, prob", p)

  p <- plot_history(res, x_value = "total n")
  vdiffr::expect_doppelganger("history plot, binomial, single, prob, total n", p)

  p <- plot_history(res, x_value = "followed n")
  vdiffr::expect_doppelganger("history plot, binomial, single, prob, followed n", p)

  p <- plot_history(res, y_value = "pct")
  vdiffr::expect_doppelganger("history plot, binomial, single, pct, look", p)

  p <- plot_history(res, y_value = "pct all")
  vdiffr::expect_doppelganger("history plot, binomial, single, pct all, look", p)

  p <- plot_history(res, y_value = "ratio ys")
  vdiffr::expect_doppelganger("history plot, binomial, single, ratio ys, look", p)

  p <- plot_history(res, y_value = "ratio ys all")
  vdiffr::expect_doppelganger("history plot, binomial, single, ratio ys all, look", p)

  p <- plot_history(res, y_value = "n")
  vdiffr::expect_doppelganger("history plot, binomial, single, n, look", p)
})


test_that("history plot produces errors with invalid input", {
  result <- read_testdata("binom__result__3_arms__common_control__equivalence__futility__softened")
  expect_error(plot_history(result, x_value = "n"))
  expect_error(plot_history(result, y_value = "mean ys"))
  result <- read_testdata("binom__result__3_arms__no_control__equivalence__softened__sparse")
  expect_error(plot_history(result)) # error due to sparse object

  results <- read_testdata("binom__results__3_arms__common_control__equivalence__futility__softened")
  expect_error(plot_history(results, x_value = "n"))
  expect_error(plot_history(results, y_value = "mean ys"))
  results <- read_testdata("binom__results__3_arms__no_control__equivalence__softened__sparse")
  expect_error(plot_history(results)) # error due to sparse object

  expect_error(plot_history(results, cores = 0.27))
})
