test_that("convergence plot of multiple binom trials works", {
  res <- read_testdata("binom__results__3_arms__common_control__equivalence__futility__softened")

  p <- plot_convergence(res)
  vdiffr::expect_doppelganger("convergence plot, binomial, size mean", p)

  p <- plot_convergence(res, n_split = 2)
  vdiffr::expect_doppelganger("convergence plot, binomial, 2 splits", p)

  p <- plot_convergence(res, metrics = c("prob_conclusive", "prob_superior", "idp"))
  vdiffr::expect_doppelganger("convergence plot, binomial, prob conclusion, prob superior, idp", p)
})
