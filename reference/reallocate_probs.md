# Update allocation probabilities

Used internally. This function calculates new allocation probabilities
for each arm, based on the information specified in
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
[`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
or
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)
and the calculated probabilities of each arm being the best by
[`prob_best()`](https://inceptdk.github.io/adaptr/reference/prob_best.md).

## Usage

``` r
reallocate_probs(
  probs_best,
  fixed_probs,
  min_probs,
  max_probs,
  soften_power = 1,
  match_arm = NULL,
  rescale_fixed = FALSE,
  rescale_limits = FALSE,
  rescale_factor = 1,
  rescale_ignore = NULL
)
```

## Arguments

- probs_best:

  a resulting named vector from the
  [`prob_best()`](https://inceptdk.github.io/adaptr/reference/prob_best.md)
  function.

- fixed_probs:

  numeric vector, fixed allocation probabilities for each arm. Must be
  either a numeric vector with `NA` for arms without fixed probabilities
  and values between `0` and `1` for the other arms or `NULL` (default),
  if adaptive randomisation is used for all arms or if one of the
  special settings (`"sqrt-based"`, `"sqrt-based start"`,
  `"sqrt-based fixed"`, or `"match"`) is specified for
  `control_prob_fixed` (described below).

- min_probs:

  numeric vector, lower threshold for adaptive allocation probabilities;
  lower probabilities will be rounded up to these values. Must be `NA`
  (default for all arms) if no lower threshold is wanted and for arms
  using fixed allocation probabilities.

- max_probs:

  numeric vector, upper threshold for adaptive allocation probabilities;
  higher probabilities will be rounded down to these values. Must be
  `NA` (default for all arms) if no threshold is wanted and for arms
  using fixed allocation probabilities.

- soften_power:

  either a single numeric value or a numeric vector of exactly the same
  length as the maximum number of looks/adaptive analyses. Values must
  be between `0` and `1` (default); if `< 1`, then re-allocated
  non-fixed allocation probabilities are all raised to this power
  (followed by rescaling to sum to `1`) to make adaptive allocation
  probabilities less extreme, in turn used to redistribute remaining
  probability while respecting limits when defined by `min_probs` and/or
  `max_probs`. If `1`, then no *softening* is applied.

- match_arm:

  index of the `control` arm. If not `NULL` (default), the control arm
  allocation probability will be similar to that of the best non-control
  arm. Must be `NULL` in designs without a common control arm.

- rescale_fixed:

  logical indicating whether `fixed_probs` should be rescaled following
  arm dropping.

- rescale_limits:

  logical indicating whether `min/max_probs` should be rescaled
  following arm dropping.

- rescale_factor:

  numerical, rescale factor defined as
  `initial number of arms/number of active arms`.

- rescale_ignore:

  `NULL` or index of an arm that will be ignored by the `rescale_fixed`
  and `rescale_limits` arguments.

## Value

A named (according to the `arms`) numeric vector with updated allocation
probabilities.
