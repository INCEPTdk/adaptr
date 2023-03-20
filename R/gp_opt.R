#' Calculates matrix of absolute distances raised to a power
#'
#' Used internally, calculates the absolute distances for values in a matrix
#' with possibly unequal dimensions, and raises these to a power.
#'
#' @param x1 numeric vector, with length corresponding to the number of rows in
#'   the returned matrix.
#' @param x2 numeric vector, with length corresponding to the number of columns
#'   in the returned matrix. If not specified, `x1` will be used for `x2`.
#' @param pow single numeric value, the power that all distances are raised to.
#'   Defaults to `2`, corresponding to pairwise, squared, Euclidean distances.
#'
#' @return Matrix with `length(x1)` rows and `length(x2)` columns including the
#'   calculated absolute pairwise distances raised to `pow`.
#'
#' @keywords internal
#'
pow_abs_dist <- function(x1, x2 = x1, pow = 2) {
  m <- matrix(nrow = length(x1), ncol = length(x2))
  for (i in 1:length(x2)) {
    m[, i] <- abs(x1 - x2[i])^pow
  }
  m
}



#' Estimates covariance matrices used by Gaussian process optimisation
#'
#' Used internally, estimates covariance matrices used by the Gaussian process
#' optimisation function. Calculates pairwise absolute distances raised to a
#' power (which defaults to `2`) using the [pow_abs_dist()] function, divides
#' the result by a` lengthscale` hyperparameter (which defaults to `1`, i.e., no
#' changes due to division), and subsequently returns the inverse exponentiation
#' of the resulting matrix.
#'
#' @inheritParams pow_abs_dist
#' @param g single numerical value; jitter/nugget value added to the diagonal
#'   if not `NULL` (the default); should be supplied if `x1` is the same as
#'   `x2`, to avoid potentially negative values in the matrix diagonal due to
#'   numerical instability.
#' @param lengthscale single numerical value; lengthscale hyperparameter that
#'   the matrix returned from [pow_abs_dist()] is divided by before the inverse
#'   exponentiation is done.
#'
#' @return Covariance matrix with `length(x1)` rows and `length(x2)` columns
#'   used by the Gaussian process optimiser.
#'
#' @keywords internal
#'
cov_mat <- function(x1, x2 = x1, g = NULL, pow = 2, lengthscale = 1) {
  res <- exp(-pow_abs_dist(x1, x2, pow) / lengthscale)
  if (!is.null(g)) {
    res <- res + diag(g, length(x1))
  }
  res
}



#' Gaussian process-based optimisation
#'
#' Used internally, simple Gaussian process-based Bayesian optimisation
#' function, used to find the next value to evaluate (as `x`) in the
#' [calibrate_trial()] function. Uses only a single input dimension, which may
#' be rescaled to the `[0, 1]` range by the function, and a covariance structure
#' based on inverse exponentiated absolute distances between values, raised to a
#' power (`pow`) and subsequently divided by `lengthscale` before the inverse
#' exponentiation of the matrix is used. These hyperparameters control
#' smoothness by controlling the rate of decay between correlations with
#' distance.\cr
#' The optimisation algorithm Uses bi-directional uncertainty bounds in an
#' acquisition function that suggests the next target to evaluate, with wider
#' uncertainty bounds (higher `kappa`) leading to increased exploration' (i.e.,
#' the function is more prone to suggest new target values where the uncertainty
#' is high and often further from the best evaluation so far) and narrower
#' uncertainty bounds leading to increased 'exploitation' (i.e., the function is
#' more prone to suggest new target values relatively close to the mean
#' predictions from the model).\cr
#' The `dir` argument controls whether the suggested value (based on both
#' uncertainty bounds) should be the value closest to `target` in either
#' direction (`dir = 0`), always at or above `target` (`dir > 0`), or always at
#' or below target (`dir < 0`), if any, are preferred.\cr
#' When the function being evaluated is noise-free and monotonically increasing
#' or decreasing, the function can narrow the range of predictions based on
#' the input evaluations (`narrow = TRUE`), leading to a finer grid of potential
#' new targets to suggest compared to when predictions are spaced over the full
#' range.\cr
#' If a new value at which to evaluate the function is suggested which has
#' already been evaluated, random noise will be added to ensure evaluation at
#' new values (if `narrow` is `FALSE`, a new value will be suggested based on
#' a random draw from a normal distribution with the current suggested value as
#' mean and the standard deviation of the `x` values as SD, truncated to the
#' range of `x`-values; if `narrow` is `TRUE`, a new value drawn from a uniform
#' distribution within the current narrowed range will be suggested. For both
#' strategies, the process will be repeated until the suggested value is 'new').
#' \cr The Gaussian process model used is partially based on code from Gramacy
#' 2020 (with permission), see **References**.
#'
#' @param x numeric vector, the previous values where the function being
#'   calibrated was evaluated.
#' @param y numeric vector, the corresponding results of the previous
#'   evaluations at `x` (must be of the same length as `x`).
#' @param target single numeric value, the desired target value for the
#'   calibration process.
#' @param dir single numeric value (default `0`), used when selecting the next
#'   value to evaluate at. See [which_nearest()] for further description.
#' @param resolution single integer (default `5000`), size of the grid at which
#'   the predictions used to select the next value to evaluate at are made.\cr
#'   **Note:** memory use and time will substantially increase with higher
#'   values.
#' @param kappa single numeric value `> 0` (default `1.96`), used for the width
#'   of uncertainty bounds (based on the Gaussian process posterior predictive
#'   distribution), which are used to select the next value to evaluate at.
#' @param pow single numerical value, passed to [cov_mat()] and controls the
#'   smoothness of the Gaussian process. Should be between `1` (no smoothness,
#'   piecewise straight lines between each subsequent `x`/`y`-coordinate if
#'   `lengthscale` described below is `1`) and `2`; defaults to `1.95`, which
#'   leads to slightly faster decay of correlations when `x` values are
#'   internally scaled to the `[0, 1]`-range compared to `2`.
#' @param lengthscale single numerical value (default `1`) or numerical vector
#'   of length `2`; all values must be finite and non-negative. If a single
#'   value is provided, this will be used as the `lengthscale` hyperparameter
#'   and passed directly to [cov_mat()]. If a numerical vector of length 2 is
#'   provided, the second value must be higher than the first and the optimal
#'   `lengthscale` in this range will be found using an optimisation algorithm.
#'   If any value is `0`, a minimum amount of noise will be added as
#'   lengthscales must be `> 0`. Controls smoothness/decay in combination
#'   with `pow`.
#' @param scale_x single logical value; if `TRUE` (the default) the `x`-values
#'   will be scaled to the `[0, 1]` range according to the minimum/maximum
#'   values provided. If `FALSE`, the model will use the original scale. If
#'   distances on the original scale are small, scaling may be preferred. The
#'   returned values will always be on the original scale.
#' @param noisy single logical value. If `FALSE` (the default), a noise-less
#'   process is assumed, and interpolation between values is performed (i.e.,
#'   with no uncertainty at the evaluated `x`-values); if `TRUE`, the `y`-values
#'   are assumed to come from a noisy process, and regression is performed
#'   (i.e., some uncertainty at the evaluated `x`-values will be included in the
#'   predictions, with the amount estimated using an optimisation algorithm).
#' @param narrow single logical value. If `FALSE` (the default), predictions are
#'   evenly spread over the full `x`-range. If `TRUE`, the prediction grid will
#'   be spread evenly over an interval consisting of the two `x`-values with
#'   corresponding `y`-values closest to the target in opposite directions. This
#'   setting should only be used if `noisy` is `FALSE` and only if the function
#'   can safely be assumed to be only monotonically increasing or decreasing, in
#'   which case this will lead to a faster search and a smoother prediction grid
#'   in the relevant region without increasing memory use.
#'
#' @return List containing two elements, `next_x`, a single numerical value, the
#'   suggested next `x` value at which to evaluate the function, and
#'   `predictions`, a `data.frame` with `resolution` rows and the four columns:
#'   `x`, the `x` grid values where predictions are made; `y_hat`, the predicted
#'   means, and `lub` and `uub`, the lower and upper uncertainty bounds of the
#'   predictions according to `kappa`.
#'
#' @importFrom stats optimise optim runif rnorm var
#'
#' @references
#'
#' Gramacy RB (2020). Chapter 5: Gaussian Process Regression. In: Surrogates:
#' Gaussian Process Modeling, Design and Optimization fo the Applied Sciences.
#' Chapman Hall/CRC, Boca Raton, Florida, USA.
#' [Available online](https://bookdown.org/rbg/surrogates/chap5.html).
#'
#' Greenhill S, Rana S, Gupta S, Vellanki P, Venkatesh S (2020). Bayesian
#' Optimization for Adaptive Experimental Design: A Review. IEEE Accesss, 8,
#' 13937-13948. \doi{10.1109/ACCESS.2020.2966228}
#'
#' @keywords internal
#'
gp_opt <- function(x, y, target, dir = 0, resolution = 5000,
                   kappa = 1.96, pow = 1.95, lengthscale = 1,
                   scale_x = TRUE, noisy = FALSE, narrow = FALSE) {

  # Define grid to evaluate over
  x_grid <- if (narrow) { # Only evaluate between nearest values in both directions
    sort(seq(from = x[which_nearest(y, target, 1)], to = x[which_nearest(y, target, -1)], length.out = resolution))
  } else { # Evaluate over the full range
    seq(from = min(x), to = max(x), length.out = resolution)
  }

  # Scale x and grid to 0-1 range if desired
  if (scale_x) {
    x_work <- (x - min(x)) / (max(x) - min(x))
    x_grid_work <- (x_grid - min(x)) / (max(x) - min(x))
  } else {
    x_work <- x
    x_grid_work <- x_grid
  }

  # Set or optimise g (jitter/nugget) and lengthscale
  eps <- .Machine$double.eps^0.5
  lengthscale <- ifelse(lengthscale <= 0, eps, lengthscale)
  if (noisy) { # Do regression (i.e., fit to noisy observations)
    if (length(lengthscale) != 1) { # Optimise both g and lengthscale
      opt <- optim(
        par = c(exp(mean(log(lengthscale))), 0.1 * var(y)),
        fn = function(par, D, y) {
          K <- exp(-D/par[1]) + diag(par[2], length(y))
          log_det_modulus <- determinant(K, logarithm = TRUE)$modulus
          length(y) * log(t(y) %*% solve(K) %*% y) / 2 + log_det_modulus / 2
        },
        gr = function(par, D, y) {
          K <- exp(-D/par[1]) + diag(par[2], length(y))
          Ki <- solve(K)
          dotK <- K * D / par[1]^2
          Kiy <- Ki %*% y
          c(-(length(y) / 2 * t(Kiy) %*% dotK %*% Kiy / (t(y) %*% Kiy) - # lengthscale
                sum(diag(Ki %*% dotK)) / 2),
            -(length(y) / 2 * t(Kiy) %*% Kiy / (t(y) %*% Kiy) - sum(diag(Ki)) / 2) # g
          )
        },
        method = "L-BFGS-B",
        lower = c(lengthscale[1], eps),
        upper = c(lengthscale[2], var(y)),
        D = pow_abs_dist(x_work, pow = pow),
        y = y)
      lengthscale <- opt$par[1]
      g <- opt$par[2]
    } else { # Optimise only g
      g <- optimise(
        f = function(g, D, y) {
          K <- exp(-D/lengthscale) + diag(g, length(y))
          log_det_modulus <- determinant(K, logarithm = TRUE)$modulus
          length(y) * log(t(y) %*% solve(K) %*% y) / 2 + log_det_modulus / 2
        },
        interval = c(.Machine$double.eps^0.5, var(y)),
        D = pow_abs_dist(x_work, pow = pow),
        y = y
      )$minimum
    }
  } else { # Do interpolation (i.e., fit to noise-free observations)
    g <- eps # Minimal jitter always required
    # Optimise lengthscale if a range is provided, otherwise keep unchanged
    if (length(lengthscale) != 1) {
      lengthscale <- optimise(
        f = function(lengthscale, D, y) {
          K <- exp(-D/lengthscale) + diag(eps, length(y))
          log_det_modulus <- determinant(K, logarithm = TRUE)$modulus
          length(y) * log(t(y) %*% solve(K) %*% y) / 2 + log_det_modulus / 2
        },
        interval = lengthscale,
        D = pow_abs_dist(x_work, pow = pow),
        y = y)$minimum
    }
  }

  # Calculate predictions and bounds of acquisition function
  K_inv <- solve(cov_mat(x_work, g = g, pow = pow, lengthscale = lengthscale))
  Kx <- cov_mat(x_grid_work, x_work, pow = pow, lengthscale = lengthscale)
  Kxx <- cov_mat(x_grid_work, g = g, pow = pow, lengthscale = lengthscale)
  y_hat <- Kx %*% K_inv %*% y # Predicted y for grid values
  # Appropriately scaled prediction uncertainty bounds at grid values
  tau_squared <- drop(t(y) %*% K_inv %*% y / length(y))
  sigma <- sqrt(abs(diag(tau_squared * (Kxx - Kx %*% K_inv %*% t(Kx)))))
  lub <- y_hat - kappa * sigma
  uub <- y_hat + kappa * sigma

  # Find next target to evaluate (considering both uncertainty bounds simultaneously)
  next_x <- x_grid[(which_nearest(c(lub, uub), target, dir) - 1) %% resolution + 1]
  while (next_x %in% x) {
    if (narrow) {
      next_x <- runif(1, min = min(x_grid), max = max(x_grid))
    } else {
      next_x <- max(min(next_x + rnorm(1, 0, sd(x)), max(x)), min(x))
    }
  }

  # Return results
  list(next_x = next_x,
       predictions = data.frame(x = x_grid, y_hat = y_hat, lub = lub, uub = uub))
}
