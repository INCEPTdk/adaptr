# Replace non-finite values with other value (finite-OR-operator)

Used internally, helper function that replaces non-finite (i.e., `NA`,
`NaN`, `Inf`, and `-Inf`) values according to
[`is.finite()`](https://rdrr.io/r/base/is.finite.html), primarily used
to replace `NaN`/`Inf`/`-Inf` with `NA`.

## Usage

``` r
a %f|% b
```

## Arguments

- a:

  atomic vector of any type.

- b:

  single value to replace non-finite values with.

## Value

If values in `a` are non-finite, they are replaced with `b`, otherwise
they are left unchanged.
