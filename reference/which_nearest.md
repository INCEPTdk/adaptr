# Find the index of value nearest to a target value

Used internally, to find the index of the value in a vector nearest to a
target value, possibly in a specific preferred direction.

## Usage

``` r
which_nearest(values, target, dir)
```

## Arguments

- values:

  numeric vector, the values considered.

- target:

  single numeric value, the target to find the value closest to.

- dir:

  single numeric value. If `0` (the default), finds the index of the
  value closest to the target, regardless of the direction. If `< 0` or
  `> 0`, finds the index of the value closest to the target, but only
  considers values at or below/above target, respectfully, if any
  (otherwise returns the closest value regardless of direction).

## Value

Single integer, the index of the value closest to `target` according to
`dir`.
