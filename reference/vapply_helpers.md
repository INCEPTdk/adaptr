# vapply helpers

Used internally. Helpers for simplifying code invoking vapply().

## Usage

``` r
vapply_num(X, FUN, ...)

vapply_int(X, FUN, ...)

vapply_str(X, FUN, ...)

vapply_lgl(X, FUN, ...)
```

## Arguments

- X:

  a vector (atomic or list) or an
  [`expression`](https://rdrr.io/r/base/expression.html) object. Other
  objects (including classed objects) will be coerced by
  `base::`[`as.list`](https://rdrr.io/r/base/list.html).

- FUN:

  the function to be applied to each element of `X`: see ‘Details’. In
  the case of functions like `+`, `%*%`, the function name must be
  backquoted or quoted.

- ...:

  optional arguments to `FUN`.
