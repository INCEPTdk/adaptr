# Generate normally distributed continuous outcomes

Used internally. Function factory used to generate a function that
generates outcomes from normal distributions.

## Usage

``` r
get_ys_norm(arms, means, sds)
```

## Arguments

- arms:

  character vector, `arms` as specified in
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md).

- means:

  numeric vector, true `means` in all `arms` as specified in
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md).

- sds:

  numeric vector, true standard deviations (`sds`) in all `arms` as
  specified in
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md).

## Value

A function which takes the argument `allocs` (a character vector with
the allocations) and returns a numeric vector of the same length with
the corresponding, randomly generated outcomes (from normal
distributions).
