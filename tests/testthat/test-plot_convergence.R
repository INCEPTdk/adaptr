test_that("convergence plot of multiple binom trials works", {
  res <- read_testdata("binom__results__3_arms__common_control__equivalence__futility__softened")

  p <- plot_convergence(res)
  vdiffr::expect_doppelganger("convergence plot, binomial, size mean", p)

  p <- plot_convergence(res, n_split = 2)
  vdiffr::expect_doppelganger("convergence plot, binomial, 2 splits", p)

  p <- plot_convergence(res, metrics = c("prob_conclusive", "prob_superior", "idp"), nrow = 3)
  vdiffr::expect_doppelganger("convergence plot, binomial, prob concl, prob sup, idp", p)

  p <- plot_convergence(res, metrics = "prob_select_arm_A")
  vdiffr::expect_doppelganger("convergence plot, binomial, prob select arm A", p)
})

test_that("convergence plot errors on invalid input", {
  res <- read_testdata("binom__results__3_arms__common_control__equivalence__futility__softened")

  expect_error(plot_convergence(res, metrics = "wrong metric"))
  expect_error(plot_convergence(res, metrics = c("size_mean", "size_mean")))
  expect_error(plot_convergence(res, restrict = "inferior"))
  expect_error(plot_convergence(res, n_split = 1000))
  expect_error(plot_convergence(res, resolution = 9.5))
  expect_error(plot_convergence(res, metrics = "wrong metric"))
  expect_error(plot_convergence(res, metrics = NULL))
})
