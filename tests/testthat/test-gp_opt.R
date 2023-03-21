test_that("pow_abs_dist and cov_mat works", {
  # pow_abs_dist
  expect_equal(pow_abs_dist(x1 = 1:3, pow = 2),
               matrix(c(0, 1, 4, 1, 0, 1, 4, 1, 0), nrow = 3))
  expect_equal(pow_abs_dist(x1 = 1:3, x2 = 4:5, pow = 1.95),
               matrix(c(8.51895740376143, 3.86374531569938, 1.00000000000000,
                        14.92852786458892, 8.51895740376143, 3.86374531569938), nrow = 3))
  # cov_mat
  expect_equal(cov_mat(1:3, g = 0.001, pow = 1.95),
               matrix(c(1.0009999999999999, 0.3678794411714423, 0.0209892407938905,
                        0.3678794411714423, 1.0009999999999999, 0.3678794411714423,
                        0.0209892407938905, 0.3678794411714423, 1.0009999999999999), nrow = 3))

  expect_equal(cov_mat(1:3, 1:2, pow = 1, lengthscale = 0.95),
               matrix(c(1.00000000000000, 0.34901807093132, 0.12181361383662,
                        0.34901807093132, 1.00000000000000, 0.34901807093132), nrow = 3))
})

test_that("gp_opt works", {
  x <- c(0.9000000, 1.0000000, 0.9800560, 0.9893797)
  y <- c(0.441, 0.000, 0.092, 0.052)

  # Test with relatively low resolution for speed
  expect_snapshot(gp_opt(x, y, target = 0.05, dir = 0, resolution = 500, scale_x = FALSE))
  expect_equal(gp_opt(x, y, target = 0.05, dir = 0, resolution = 500, narrow = TRUE)$next_x,
               0.99042257515030052151)
  expect_equal(gp_opt(x, y, target = 0.05, dir = -1, resolution = 500, kappa = 0.5, pow = 1.9,
                       lengthscale = c(0.1, 10))$next_x, 0.98977955911823645163)
  expect_equal(gp_opt(x, y, target = 0.025, dir = 1, resolution = 500, noisy = TRUE,
                      lengthscale = c(0.1, 10))$next_x, 0.99378757515030058389)
  expect_equal(gp_opt(x, y, target = 0.1, resolution = 500, noisy = TRUE,
                      lengthscale = 0.95)$next_x, 0.979759519038076120989)
})
