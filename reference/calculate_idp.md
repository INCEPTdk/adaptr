# Calculate the ideal design percentage

Used internally by
[`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md),
calculates the ideal design percentage as described in that function's
documentation.

## Usage

``` r
calculate_idp(sels, arms, true_ys, highest_is_best)
```

## Arguments

- sels:

  a character vector specifying the selected arms (according to the
  selection strategies described in
  [`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md)).

- arms:

  character vector with unique names for the trial arms.

- true_ys:

  numeric vector specifying true outcomes (e.g., event probabilities,
  mean values, etc.) for all trial `arms`.

- highest_is_best:

  single logical, specifies whether larger estimates of the outcome are
  favourable or not; defaults to `FALSE`, corresponding to, e.g., an
  undesirable binary outcomes (e.g., mortality) or a continuous outcome
  where lower numbers are preferred (e.g., hospital length of stay).

## Value

A single numeric value between `0` and `100` corresponding to the ideal
design percentage.
