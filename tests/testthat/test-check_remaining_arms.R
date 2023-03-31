test_that("check_remaining_arms works and errors correctly", {
  res <- read_testdata("binom__results__3_arms__no_control__equivalence__softened__sparse")
  expect_snapshot(check_remaining_arms(res))

  expect_error(check_remaining_arms(mtcars))
  expect_error(check_remaining_arms(res, ci_width = NA))
})
