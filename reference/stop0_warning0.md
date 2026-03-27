# stop() and warning() with call. = FALSE

Used internally. Calls `stop0()` or
[`warning()`](https://rdrr.io/r/base/warning.html) but enforces
`call. = FALSE`, to suppress the call from the error/warning.

## Usage

``` r
stop0(...)

warning0(...)
```

## Arguments

- ...:

  zero or more objects which can be coerced to character (and which are
  pasted together with no separator) or a single condition object.
