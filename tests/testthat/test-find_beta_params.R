test_that("lower boundary works", {
  expect_equal(
    tolerance = 10^-6,
    find_beta_params(theta = 0.25, boundary_target = 0.15, boundary = "lower", interval_width = 0.95),
    data.frame(alpha = 15, beta = 45, p2.5 = 0.1498208, p50.0 = 0.2472077, p97.5 = 0.3659499)
  )
})

test_that("upper boundary works", {
  expect_equal(
    tolerance = 10^-6,
    find_beta_params(theta = 0.25, boundary_target = 0.35, boundary = "upper", interval_width = 0.95),
    data.frame(alpha = 20, beta = 60, p2.5 = 0.1620059, p50.0 = 0.2479085, p97.5 = 0.3498257)
  )
})

test_that("interval_width works", {
  expect_equal(
    tolerance = 10^-6,
    find_beta_params(theta = 0.25, boundary_target = 0.15, boundary = "lower", interval_width = 0.5),
    data.frame(alpha = 2, beta = 7, p25.0 = 0.1206287, p50.0 = 0.2011312, p75.0 = 0.3026997)
  )
})
