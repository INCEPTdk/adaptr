test_that("formatting works", {
  # Rounding
  expect_identical(fmt_dig(2.2222, 2), "2.22")
  expect_identical(fmt_dig(2.2222, 0), "2")

  # Percentages
  expect_identical(fmt_pct(1, 10), "1/10 (10.0%)")
  expect_identical(fmt_pct(1, 23, 1), "1/23 (4.3%)")
  expect_identical(fmt_pct(1, 23, 2), "1/23 (4.35%)")
})

test_that("rescale works", {
  expect_identical(rescale(c(0.2, 0.4, 0.2, 0.2)), c(0.2, 0.4, 0.2, 0.2))
  expect_identical(rescale(c(1, 4, 3, 2)), c(0.1, 0.4, 0.3, 0.2))
  expect_identical(rescale(c(0.2, 0.7, NA)), rep(NA_real_, 3))
})

test_that("summarise_dist works", {
  vals <- c(0.914806043496355, 0.937075413297862, 0.286139534786344,
            0.830447626067325, 0.641745518893003, 0.519095949130133,
            0.736588314641267, 0.13466659723781, 0.656992290401831,
            0.705064784036949, 0.45774177624844, 0.719112251652405,
            0.934672247152776, 0.255428824340925, 0.462292822543532,
            0.940014522755519, 0.978226428385824, 0.117487361654639,
            0.474997081561014, 0.560332746244967)

  expect_equal(
    tolerance = 10^-7,
    summarise_dist(vals),
    c(est = 0.6493689, err = 0.2807327, lo = 0.1256475, hi = 0.9600758)
  )

  expect_equal(
    tolerance = 10^-7,
    summarise_dist(vals, robust = FALSE),
    c(est = 0.6131464, err = 0.2725564, lo = 0.1256475, hi = 0.9600758)
  )

  expect_equal(
    tolerance = 10^-7,
    summarise_dist(vals, interval_width = 0.5),
    c(est = 0.6493689, err = 0.2807327, lo = 0.4611551, hi = 0.8515372)
  )
})

test_that("verify_int works", {
  expect_true(verify_int(2, 1, 3))
  expect_true(verify_int(2, -1, 3))
  expect_false(verify_int(2, -1, 1))

  # Right boundary
  expect_true(verify_int(2, -1, 2, "no"))
  expect_true(verify_int(2, -1, 2, "left"))
  expect_false(verify_int(2, -1, 2, "yes"))
  expect_false(verify_int(2, -1, 2, "right"))

  # Left boundary
  expect_true(verify_int(-1, -1, 2, "no"))
  expect_false(verify_int(-1, -1, 2, "left"))
  expect_false(verify_int(-1, -1, 2, "yes"))
  expect_true(verify_int(-1, -1, 2, "right"))

  # Invalid input types
  expect_false(verify_int(NULL))
  expect_false(verify_int(-5:5))
  expect_false(verify_int(1.8))
  expect_false(verify_int("Hello"))
})

test_that("NULL-replacement works", {
  x <- NULL
  y <- 1
  z <- 3
  expect_identical(x %||% y, y)
  expect_identical(y %||% x, y)
  expect_identical(y %||% z, y)
})

test_that("vapply helpers work", {
  expect_equal(vapply_num(1:3, function(x) x * 2), c(2.0, 4.0, 6.0))

  expect_equal(vapply_int(1:3, function(x) x * 2L), c(2L, 4L, 6L))
  expect_error(vapply_int(1:3, function(x) x * 2))

  expect_equal(vapply_str(1:3, function(x) paste0("p", x*10)), c("p10", "p20", "p30"))

  expect_equal(vapply_lgl(c(1, 2.0, 3, 4.0), verify_int, min_value = 2), c(FALSE, TRUE, TRUE, TRUE))
  expect_equal(vapply_lgl(c(1, 2.5, 3, 4.0), verify_int, min_value = 2), c(FALSE, FALSE, TRUE, TRUE))
})

test_that("stop0, warning0 and cat0 work", {
  expect_snapshot_error(stop0("error message"))

  expect_snapshot_warning(warning0("warning message"))

  expect_snapshot_output(cat0("this", "is", "a", "test"))
})

test_that("summarise_num works", {
  expect_equal(
    summarise_num(1:100),
    c(mean = 50.5, sd = 29.011492, median = 50.5, p25 = 25.75, p75 = 75.25, p0 = 1, p100 = 100)
  )
  expect_error(summarise_num(c(NA, 1:100)))
})

test_that("assert_pkgs works", {
  expect_true(assert_pkgs(c("base", "stats")))
  expect_error(assert_pkgs("!*?")) # Invalid package name used
})

test_that("which_nearest works", {
  expect_equal(which_nearest(1:10 + 0.01, 5, dir = 0), 5)
  expect_equal(which_nearest(1:10 + 0.01, 5, dir = -1), 4)
  expect_equal(which_nearest(1:10 + 0.01, 5, dir = 1), 5)
  expect_equal(which_nearest(1:10, 12, dir = 1), which_nearest(1:10, 12, dir = -1))
})
