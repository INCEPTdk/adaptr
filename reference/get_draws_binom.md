# Generate draws from posterior beta-binomial distributions

Used internally. This function generates draws from posterior
distributions using separate beta-binomial models (binomial outcome,
conjugate beta prior) for each arm, with flat (`beta(1, 1)`) priors.

## Usage

``` r
get_draws_binom(arms, allocs, ys, control, n_draws)
```

## Arguments

- arms:

  character vector, **currently active** `arms` as specified in
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
  /
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  /
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md).

- allocs:

  character vector, allocations of all participants (including
  allocations to **currently inactive** `arms`).

- ys:

  numeric vector, outcomes of all participants in the same order as
  `alloc` (including outcomes of participants in **currently inactive**
  `arms`).

- control:

  unused argument in the built-in functions for
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  and
  [setup_trial_norm](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md),
  but required as this argument is supplied by the
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)
  function, and may be used in user-defined functions used to generate
  posterior draws.

- n_draws:

  single integer, number of posterior draws.

## Value

A `matrix` (with numeric values) with `length(arms)` columns and
`n_draws` rows, with `arms` as column names.
