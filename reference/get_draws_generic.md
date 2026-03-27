# Generic documentation for get_draws\_\* functions

Used internally. See the
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
function documentation for additional details on how to specify
functions to generate posterior draws.

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
