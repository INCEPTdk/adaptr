test_that("plot_metrics_ecdf works and errors correctly", {
  # Works
  res <- read_testdata("binom__results__3_arms__no_control__equivalence__softened__sparse")
  p <- plot_metrics_ecdf(res)
  vdiffr::expect_doppelganger("no restriction", p)
  p <- plot_metrics_ecdf(res, restrict = "superior")
  vdiffr::expect_doppelganger("superior", p)
  p <- plot_metrics_ecdf(res, restrict = "selected")
  vdiffr::expect_doppelganger("selected", p)
  p <- plot_metrics_ecdf(res, metrics = "size")
  vdiffr::expect_doppelganger("size only", p)

  # Errors
  expect_error(plot_metrics_ecdf(res, metrics = TRUE))
  expect_error(plot_metrics_ecdf(res, metrics = c("sum ys", "prob_conclusive")))
  expect_error(plot_metrics_ecdf(res, metrics = c("sum ys", "sum_ys")))
  expect_error(plot_metrics_ecdf(res, restrict = "positive trials"))
})
