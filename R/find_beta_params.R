#' Find beta distribution parameters from thresholds
#'
#' Helper function to find a beta distribution with parameters corresponding
#' to the fewest possible patients with events/non-events and a specified event
#' proportion. Used in the **Advanced example** vignette
#' (`vignette("Advanced-example", "adaptr")`) to derive `beta` prior
#' distributions for use in *beta-binomial conjugate models*, based on a belief
#' that the true event probability lies within a specified percentile-based
#' interval (defaults to `95%`). May similarly be used by users to derive other
#' `beta` priors.
#'
#' @param theta single numeric `> 0` and `< 1`, expected true event probability.
#' @param boundary_target single numeric `> 0` and `< 1`, target lower or upper
#'   boundary of the interval.
#' @param boundary single character string, either `"lower"` (default) or
#'   `"upper"`, used to select which boundary to use when finding appropriate
#'   parameters for the `beta` distribution.
#' @param interval_width width of the credible interval whose lower/upper
#'   boundary should be used (see `boundary_target`); must be `> 0` and `< 1`;
#'   defaults to `0.95`.
#' @param n_dec single non-negative integer; the returned parameters are rounded
#'   to this number of decimals. Defaults to `0`, in which case the parameters
#'   will correspond to whole number of patients.
#' @param max_n single integer `> 0` (default `10000`), the maximum total sum of
#'   the parameters, corresponding to the maximum total number of patients that
#'   will be considered by the function when finding the optimal parameter
#'   values. Corresponds to the maximum number of patients contributing
#'   information to a beta prior; more than the default number of patients are
#'   unlikely to be used in a beta prior.
#'
#' @return A single-row `data.frame` with five columns: the two shape parameters
#'   of the beta distribution (`alpha`, `beta`), rounded according to `n_dec`,
#'   and the actual lower and upper boundaries of the interval and the median
#'   (with appropriate names, e.g. `p2.5`, `p50`, and `p97.5` for a `95%`
#'   interval), when using those rounded values.
#'
#' @importFrom stats qbeta optimise
#'
#' @export
#'
find_beta_params <- function(theta = NULL, boundary_target = NULL,
                             boundary = "lower", interval_width = 0.95,
                             n_dec = 0, max_n = 10000) {

  if (!verify_int(n_dec, min_value = 0)) {
    stop("n_dec must be a single non-negative integer.", .call = FALSE)
  }
  if (!verify_int(max_n, min_value = 1)) {
    stop("max_n must be a single integer > 0.", .call = FALSE)
  }
  if (!isFALSE(is.null(theta) | is.na(theta) | is.null(boundary_target) | is.na(boundary_target) |
             is.null(interval_width) | is.na(interval_width) |
             length(theta) != 1 | length(boundary_target) != 1 | length(interval_width) != 1 |
             !is.numeric(theta) | !is.numeric(boundary_target) | !is.numeric(interval_width) |
             is.na(theta) | is.na(boundary_target) | is.na(interval_width) |
             theta <= 0 | theta >= 1 | boundary_target <= 0 | boundary_target >= 1 | interval_width <= 0 | interval_width >= 1)) {
    stop("theta, boundary_target, and interval_width must all be single numeric values > 0 and < 1", call. = FALSE)
  }
  if (isTRUE(is.null(boundary) || is.na(boundary) || !(boundary %in% c("lower", "upper")) || length(boundary) != 1)) {
    stop("boundary must be either 'lower' or 'upper'.", call. = FALSE)
  } else if (boundary == "lower") {
    stopifnot(theta >= boundary_target)
  } else if (boundary == "upper") {
    stopifnot(theta <= boundary_target)
  }

  n_tot <- optimise(function(n) {abs(boundary_target -
      qbeta(p = if (boundary == "lower") (1-interval_width)/2 else 1 - (1-interval_width)/2,
            shape1 = n * theta, shape2 = n - n * theta))},
      interval = c(0, max_n))$minimum

  probs <- c((1-interval_width)/2, 0.5, 1- (1-interval_width)/2)
  res_qs <- qbeta(probs, round(n_tot * theta, n_dec), round(n_tot - n_tot * theta, n_dec))
  res <- data.frame(alpha = round(n_tot * theta, n_dec), beta = round(n_tot - n_tot * theta, n_dec),
                    res_qs[1], res_qs[2], res_qs[3])

  names(res)[3:5] <- paste0("p", format(round(probs*100, digits = 1), nsmall = 1, trim = TRUE))
  res
}
