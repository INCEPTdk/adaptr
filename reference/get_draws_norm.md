# Generate draws from posterior normal distributions

Used internally. This function generates draws from posterior, normal
distributions for continuous outcomes. Technically, these posteriors use
no priors (for simulation speed), corresponding to the use of improper
flat priors. These posteriors correspond (and give similar results) to
using normal-normal models (normally distributed outcome, conjugate
normal prior) for each arm, assuming that a non-informative, flat prior
is used. Thus, the posteriors directly correspond to normal
distributions with each groups' mean as the mean and each groups'
standard error as the standard deviation. As it is necessary to always
return valid draws, in cases where `< 2` participants have been
randomised to an `arm`, posterior draws will come from an extremely wide
normal distribution with mean corresponding to the mean of all included
participants with outcome data and a standard deviation corresponding to
the difference between the highest and lowest recorded outcomes for all
participants with available outcome data multiplied by `1000`.

## Usage

``` r
get_draws_norm(arms, allocs, ys, control, n_draws)
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
