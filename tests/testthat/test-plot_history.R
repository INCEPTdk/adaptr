test_that("history of multiple binom trials works", {
  res <- read_testdata("binom__results__3_arms__common_control__equivalence__futility__softened")

  p <- plot_history(res)
  vdiffr::expect_doppelganger("history plot, binomial, multiple, prob", p)

  p <- plot_history(res, y_value = "pct")
  vdiffr::expect_doppelganger("history plot, binomial, multiple, pct", p)
})

test_that("history of single trial works", {
  res <- read_testdata("binom__result__3_arms__common_control__equivalence__futility__softened")

  p <- plot_history(res)
  vdiffr::expect_doppelganger("history plot, binomial, single, prob", p)
})
