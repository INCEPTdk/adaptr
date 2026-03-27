# Conditionally rescale probabilities

Used internally. This function conditionally rescales probabilities,
used in
[`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)
based on the information specified in
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
[`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
or
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md).
Used to rescale adaptation rule probability thresholds for superiority
and/or inferiority in trials without a common `control` arm.

## Usage

``` r
cond_rescale_prob(cond, prob, up = FALSE, rescale_factor)
```

## Arguments

- cond:

  single logical, whether to rescale the probability or not. If `FALSE`
  the input probability is returned without rescaling (ignoring all
  other arguments), if `TRUE` the input probability is rescaled.

- prob:

  probability to be rescaled (as a proportion, i.e., in `[0-1]`).

- up:

  single logical, if `FALSE` (default), the probability provided will be
  rescaled downwards (i.e., closer to `0`, as `prob / rescale_factor`),
  if `TRUE`, the probability provided will be rescaled upwards (i.e.,
  closer to `1`, as `1 - (1 - prob) / rescale_factor`).

- rescale_factor:

  single numerical value, the factor to rescale by as described above.
  The
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)
  function defines this as initial number of trial arms divided by
  currently active number of trial arms.

## Value

numerical, `prob` rescaled or not depending on inputs values.
