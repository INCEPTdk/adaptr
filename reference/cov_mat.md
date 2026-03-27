# Estimates covariance matrices used by Gaussian process optimisation

Used internally, estimates covariance matrices used by the Gaussian
process optimisation function. Calculates pairwise absolute distances
raised to a power (which defaults to `2`) using the
[`pow_abs_dist()`](https://inceptdk.github.io/adaptr/reference/pow_abs_dist.md)
function, divides the result by a` lengthscale` hyperparameter (which
defaults to `1`, i.e., no changes due to division), and subsequently
returns the inverse exponentiation of the resulting matrix.

## Usage

``` r
cov_mat(x1, x2 = x1, g = NULL, pow = 2, lengthscale = 1)
```

## Arguments

- x1:

  numeric vector, with length corresponding to the number of rows in the
  returned matrix.

- x2:

  numeric vector, with length corresponding to the number of columns in
  the returned matrix. If not specified, `x1` will be used for `x2`.

- g:

  single numerical value; jitter/nugget value added to the diagonal if
  not `NULL` (the default); should be supplied if `x1` is the same as
  `x2`, to avoid potentially negative values in the matrix diagonal due
  to numerical instability.

- pow:

  single numeric value, the power that all distances are raised to.
  Defaults to `2`, corresponding to pairwise, squared, Euclidean
  distances.

- lengthscale:

  single numerical value; lengthscale hyperparameter that the matrix
  returned from
  [`pow_abs_dist()`](https://inceptdk.github.io/adaptr/reference/pow_abs_dist.md)
  is divided by before the inverse exponentiation is done.

## Value

Covariance matrix with `length(x1)` rows and `length(x2)` columns used
by the Gaussian process optimiser.
