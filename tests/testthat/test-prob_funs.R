# values in m came about like this:
# set.seed(42)
# d <- adaptr:::get_draws_binom(
#   c("A", "B", "C"),
#   allocs = LETTERS[c(1, 2, 3, 3, 3, 2, 3, 2, 1, 2, 2, 1, 2, 3, 1)],
#   ys = c(0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0),
#   n_draws = 10
# )
# cat(sprintf("c(%s)", paste(d, collapse = ", ")))

m <- matrix(
  c(0.371025901693382, 0.583355961495554, 0.644212643867367, 0.592722393491275,
    0.475563345895527, 0.822911850585761, 0.478202163342205, 0.899965681373715,
    0.485556527371732, 0.784976414192089, 0.230615371104084, 0.444423465202403,
    0.473409825138157, 0.626388544136649, 0.443335605562652, 0.0791518852832098,
    0.757020509839027, 0.438879763189338, 0.46571517859663, 0.737691696059855,
    0.339984156834914, 0.374958878818473, 0.116454866208437, 0.528552969259523,
    0.299039550650189, 0.527521986022896, 0.583240916932803, 0.657397676450133,
    0.305009121710516, 0.538521624342219),
  ncol = 3,
  dimnames = list(NULL, c("A", "B", "C"))
)

test_that("prob_better works", {
	expect_identical(
		prob_better(m, control = "A"),
		matrix(c(NA, 0.8, 0.9), ncol = 1, dimnames = list(c("A", "B", "C"), "probs_better"))
	)

	expect_identical(
	  prob_better(m, control = "A", highest_is_best = TRUE),
		matrix(c(NA, 0.2, 0.1), ncol = 1, dimnames = list(c("A", "B", "C"), "probs_better"))
	)

	expect_identical(
	  prob_better(m, control = "A", equivalence_diff = 0.05),
		matrix(c(NA, 0.8, 0.9, NA, 0.4, 0.1), ncol = 2,
			   dimnames = list(c("A", "B", "C"), c("probs_better", "probs_equivalence")))
	)
})

test_that("prob_best works", {
  expect_identical(prob_best(m), c(A = 0.1, B = 0.3, C = 0.6))
  expect_identical(prob_best(m, highest_is_best = TRUE),
                   c(A = 0.8, B = 0.2, C = 0.0))
})

test_that("prob_all_equi works", {
  expect_true(is.na(prob_all_equi(m)))
  expect_equal(prob_all_equi(m, equivalence_diff = 0.5), 0.8)
  expect_equal(prob_all_equi(m, equivalence_diff = 0.25), 0.6)
  expect_equal(prob_all_equi(m, equivalence_diff = 0.1), 0.1)
})

test_that("reallocate_probs works", {
  probs_best <- prob_best(m)

  expect_equal(
    reallocate_probs(probs_best, fixed_probs = rep(NA, 3), min_probs = NA, max_probs = NA),
    c(A = 0.1, B = 0.3, C = 0.6)
  )

  expect_equal(
    tolerance = 10^-6,
    reallocate_probs(probs_best, fixed_probs = c(0.2, NA, NA), min_probs = NA, max_probs = NA),
    c(A = 0.2, B = 0.2666667, C = 0.5333333)
  )

  expect_equal(
    tolerance = 10^-6,
    reallocate_probs(probs_best, fixed_probs = c(0.2, NA, 0.4), min_probs = NA, max_probs = NA),
    c(A = 0.2, B = 0.4, C = 0.4)
  )

  expect_equal(
    tolerance = 10^-6,
    reallocate_probs(probs_best, fixed_probs = rep(NA, 3), min_probs = c(0.15, 0.2, NA), max_probs = NA),
    c(A = 0.1500000, B = 0.2833333, C = 0.5666667)
  )

  expect_equal(
    tolerance = 10^-6,
    reallocate_probs(probs_best, fixed_probs = rep(NA, 3), min_probs = NA, max_probs = NA, match_arm = 3),
    c(A = 0.1428571, B = 0.4285714, C = 0.4285714)
  )

  probs_best0 <- setNames(rep(0, length(probs_best)), names(probs_best))
  expect_equal(
    tolerance = 10^-6,
    reallocate_probs(probs_best0, fixed_probs = rep(NA, 3), min_probs = rep(NA, 3), max_probs = rep(NA, 3),
                     soften_power = 1, match_arm = 1),
    c(A = 1/3, B = 1/3, C = 1/3)
  )

  expect_equal(
    tolerance = 10^-6,
    reallocate_probs(probs_best, fixed_probs = c(0.4, 0.3, 0.3), min_probs = rep(NA, 3), max_probs = rep(NA, 3)),
    c(A = 0.4, B = 0.3, C = 0.3)
  )

  # rescaling of of fixed probabilities/probability limits, various versions

  probs_best_rescale <- setNames(c(0.75, 0.1, 0.15), names(probs_best))
  expect_equal(
    tolerance = 10^-6,
    reallocate_probs(probs_best_rescale, fixed_probs = c(0.40, NA, NA),
                     min_probs = c(NA, 0.15, 0.15), max_probs = c(NA, 0.85, 0.85),
                     rescale_fixed = TRUE, rescale_limits = TRUE, rescale_factor = 4/3),
    c(A = 0.5333333, B = 0.2, C = 0.2666667)
  )

  probs_best_rescale <- setNames(c(0.1, 0.15, 0.75), names(probs_best))
  expect_equal(
    tolerance = 10^-6,
    reallocate_probs(probs_best_rescale, fixed_probs = c(0.40, NA, NA),
                     min_probs = c(NA, 0.15, 0.15), max_probs = c(NA, 0.85, 0.85),
                     rescale_fixed = FALSE, rescale_limits = TRUE,
                     rescale_factor = 4/3),
    c(A = 0.4, B = 0.2, C = 0.4)
  )

  probs_best_rescale <- setNames(c(0.1, 0.15, 0.75), names(probs_best))
  expect_equal(
    tolerance = 10^-6,
    reallocate_probs(probs_best_rescale, fixed_probs = c(0.40, NA, NA),
                     min_probs = c(NA, 0.15, 0.15), max_probs = c(NA, 0.85, 0.85),
                     rescale_fixed = TRUE, rescale_limits = FALSE, rescale_factor = 4/3),
    c(A = 0.5333333, B = 0.15, C = 0.3166667)
  )

  # invalid combinations obtained by rescaling, but this is normalised
  probs_best_rescale <- setNames(c(0.1, 0.9), c("A", "B"))
  expect_equal(
    tolerance = 10^-6,
    reallocate_probs(probs_best_rescale, fixed_probs = c(0.40, NA),
                     min_probs = c(NA, 0.25), max_probs = c(NA, 0.75),
                     rescale_fixed = TRUE, rescale_limits = TRUE, rescale_factor = 4/2),
    c(A = 0.6153846, B = 0.3846154)
  )

  probs_best_rescale <- setNames(c(0.1, 0.15, 0.75), names(probs_best))
  expect_equal(
    tolerance = 10^-6,
    reallocate_probs(probs_best_rescale, fixed_probs = c(0.40, NA, NA),
                     min_probs = c(NA, 0.15, 0.15), max_probs = c(NA, 0.85, 0.85),
                     rescale_fixed = TRUE, rescale_limits = TRUE, rescale_factor = 4/3,
                     rescale_ignore = 1),
    c(A = 0.4, B = 0.2, C = 0.4)
  )
})
