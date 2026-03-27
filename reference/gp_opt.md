# Gaussian process-based optimisation

Used internally. Simple Gaussian process-based Bayesian optimisation
function, used to find the next value to evaluate (as `x`) in the
[`calibrate_trial()`](https://inceptdk.github.io/adaptr/reference/calibrate_trial.md)
function. Uses only a single input dimension, which may be rescaled to
the `[0, 1]` range by the function, and a covariance structure based on
absolute distances between values, raised to a power (`pow`) and
subsequently divided by `lengthscale` before the inverse exponentiation
of the resulting matrix is used. The `pow` and `lengthscale`
hyperparameters consequently control the smoothness by controlling the
rate of decay between correlations with distance.  
The optimisation algorithm uses bi-directional uncertainty bounds in an
acquisition function that suggests the next target to evaluate, with
wider uncertainty bounds (higher `kappa`) leading to increased
'exploration' (i.e., the function is more prone to suggest new target
values where the uncertainty is high and often further from the best
evaluation so far) and narrower uncertainty bounds leading to increased
'exploitation' (i.e., the function is more prone to suggest new target
values relatively close to the mean predictions from the model).  
The `dir` argument controls whether the suggested value (based on both
uncertainty bounds) should be the value closest to `target` in either
direction (`dir = 0`), at or above `target` (`dir > 0`), or at or below
target (`dir < 0`), if any, are preferred.  
When the function being evaluated is noise-free and monotonically
increasing or decreasing, the optimisation function can narrow the range
of predictions based on the input evaluations (`narrow = TRUE`), leading
to a finer grid of potential new targets to suggest compared to when
predictions are spaced over the full range.  
If the new value at which to evaluate the function suggested has already
been evaluated, random noise will be added to ensure evaluation at a new
value (if `narrow` is `FALSE`, noise will be based on a random draw from
a normal distribution with the current suggested value as mean and the
standard deviation of the `x` values as SD, truncated to the range of
`x`-values; if `narrow` is `TRUE`, a new value drawn from a uniform
distribution within the current narrowed range will be suggested. For
both strategies, the process will be repeated until the suggested value
is 'new').  
The Gaussian process model used is partially based on code from Gramacy
2020 (with permission), see **References**.

## Usage

``` r
gp_opt(
  x,
  y,
  target,
  dir = 0,
  resolution = 5000,
  kappa = 1.96,
  pow = 1.95,
  lengthscale = 1,
  scale_x = TRUE,
  noisy = FALSE,
  narrow = FALSE
)
```

## Arguments

- x:

  numeric vector, the previous values where the function being
  calibrated was evaluated.

- y:

  numeric vector, the corresponding results of the previous evaluations
  at the `x` values (must be of the same length as `x`).

- target:

  single numeric value, the desired target value for the calibration
  process.

- dir:

  single numeric value (default `0`), used when selecting the next value
  to evaluate at. See
  [`which_nearest()`](https://inceptdk.github.io/adaptr/reference/which_nearest.md)
  for further description.

- resolution:

  single integer (default `5000`), size of the grid at which the
  predictions used to select the next value to evaluate at are made.  
  **Note:** memory use and time will substantially increase with higher
  values.

- kappa:

  single numeric value `> 0` (default `1.96`), used for the width of
  uncertainty bounds (based on the Gaussian process posterior predictive
  distribution), which are used to select the next value to evaluate at.

- pow:

  single numerical value, passed to
  [`cov_mat()`](https://inceptdk.github.io/adaptr/reference/cov_mat.md)
  and controls the smoothness of the Gaussian process. Should be between
  `1` (no smoothness, piecewise straight lines between each subsequent
  `x`/`y`-coordinate if `lengthscale` described below is `1`) and `2`;
  defaults to `1.95`, which leads to slightly faster decay of
  correlations when `x` values are internally scaled to the
  `[0, 1]`-range compared to `2`.

- lengthscale:

  single numerical value (default `1`) or numerical vector of length
  `2`; all values must be finite and non-negative. If a single value is
  provided, this will be used as the `lengthscale` hyperparameter and
  passed directly to
  [`cov_mat()`](https://inceptdk.github.io/adaptr/reference/cov_mat.md).
  If a numerical vector of length `2` is provided, the second value must
  be higher than the first and the optimal `lengthscale` in this range
  will be found using an optimisation algorithm. If any value is `0`, a
  minimum amount of noise will be added as lengthscales must be `> 0`.
  Controls smoothness/decay in combination with `pow`.

- scale_x:

  single logical value; if `TRUE` (the default) the `x`-values will be
  scaled to the `[0, 1]` range according to the minimum/maximum values
  provided. If `FALSE`, the model will use the original scale. If
  distances on the original scale are small, scaling may be preferred.
  The returned values will always be on the original scale.

- noisy:

  single logical value. If `FALSE` (the default), a noiseless process is
  assumed, and interpolation between values is performed (i.e., with no
  uncertainty at the evaluated `x`-values); if `TRUE`, the `y`-values
  are assumed to come from a noisy process, and regression is performed
  (i.e., some uncertainty at the evaluated `x`-values will be included
  in the predictions, with the amount estimated using an optimisation
  algorithm).

- narrow:

  single logical value. If `FALSE` (the default), predictions are evenly
  spread over the full `x`-range. If `TRUE`, the prediction grid will be
  spread evenly over an interval consisting of the two `x`-values with
  corresponding `y`-values closest to the target in opposite directions.
  This setting should only be used if `noisy` is `FALSE` and only if the
  function can safely be assumed to be only monotonically increasing or
  decreasing, in which case this will lead to a faster search and a
  smoother prediction grid in the relevant region without increasing
  memory use.

## Value

List containing two elements, `next_x`, a single numerical value, the
suggested next `x` value at which to evaluate the function, and
`predictions`, a `data.frame` with `resolution` rows and the four
columns: `x`, the `x` grid values where predictions are made; `y_hat`,
the predicted means, and `lub` and `uub`, the lower and upper
uncertainty bounds of the predictions according to `kappa`.

## References

Gramacy RB (2020). Chapter 5: Gaussian Process Regression. In:
Surrogates: Gaussian Process Modeling, Design and Optimization for the
Applied Sciences. Chapman Hall/CRC, Boca Raton, Florida, USA. [Available
online](https://bookdown.org/rbg/surrogates/chap5.html).

Greenhill S, Rana S, Gupta S, Vellanki P, Venkatesh S (2020). Bayesian
Optimization for Adaptive Experimental Design: A Review. IEEE Access, 8,
13937-13948.
[doi:10.1109/ACCESS.2020.2966228](https://doi.org/10.1109/ACCESS.2020.2966228)
