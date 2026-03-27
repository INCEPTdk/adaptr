# Calculates matrix of absolute distances raised to a power

Used internally, calculates the absolute distances for values in a
matrix with possibly unequal dimensions, and raises these to a power.

## Usage

``` r
pow_abs_dist(x1, x2 = x1, pow = 2)
```

## Arguments

- x1:

  numeric vector, with length corresponding to the number of rows in the
  returned matrix.

- x2:

  numeric vector, with length corresponding to the number of columns in
  the returned matrix. If not specified, `x1` will be used for `x2`.

- pow:

  single numeric value, the power that all distances are raised to.
  Defaults to `2`, corresponding to pairwise, squared, Euclidean
  distances.

## Value

Matrix with `length(x1)` rows and `length(x2)` columns including the
calculated absolute pairwise distances raised to `pow`.
