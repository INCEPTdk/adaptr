# Generate binary outcomes from binomial distributions

Used internally. Function factory used to generate a function that
generates binary outcomes from binomial distributions.

## Usage

``` r
get_ys_binom(arms, event_probs)
```

## Arguments

- arms:

  character vector of `arms` as specified in
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md).

- event_probs:

  numeric vector of true event probabilities in all `arms` as specified
  in
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md).

## Value

A function which takes the argument `allocs` (a character vector with
the allocations) and returns a numeric vector of similar length with the
corresponding, randomly generated outcomes (0 or 1, from binomial
distribution).
