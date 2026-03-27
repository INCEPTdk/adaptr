# Calculate probabilities of comparisons of arms against with common control

Used internally. This function takes a `matrix` as calculated by the
[`get_draws_binom()`](https://inceptdk.github.io/adaptr/reference/get_draws_binom.md),
[`get_draws_norm()`](https://inceptdk.github.io/adaptr/reference/get_draws_norm.md)
or a corresponding custom function (as specified using the `fun_draws`
argument in
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md);
see
[`get_draws_generic()`](https://inceptdk.github.io/adaptr/reference/get_draws_generic.md))
and a single character specifying the `control` arm, and calculates the
probabilities of each arm being better than a common `control` (defined
as either higher or lower than the `control`, as specified by the
`highest_is_best` argument in
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
[`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
or
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)).
This function also calculates equivalence and futility probabilities
compared to the common `control` arm, as specified in
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
[`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
or
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md),
unless `equivalence_diff` or `futility_diff`, respectively, are set to
`NULL` (the default).

## Usage

``` r
prob_better(
  m,
  control = NULL,
  highest_is_best = FALSE,
  equivalence_diff = NULL,
  futility_diff = NULL
)
```

## Arguments

- m:

  a matrix with one column per trial arm (named as the `arms`) and one
  row for each draw from the posterior distributions.

- control:

  a single character string specifying the common `control` arm.

- highest_is_best:

  single logical, specifies whether larger estimates of the outcome are
  favourable or not; defaults to `FALSE`, corresponding to, e.g., an
  undesirable binary outcomes (e.g., mortality) or a continuous outcome
  where lower numbers are preferred (e.g., hospital length of stay).

- equivalence_diff:

  single numeric value (`> 0`) or `NULL` (default, corresponding to no
  equivalence assessment). If a numeric value is specified, estimated
  absolute differences smaller than this threshold will be considered
  equivalent. For designs with a common `control` arm, the differences
  between each non-control arm and the `control` arm is used, and for
  trials without a common `control` arm, the difference between the
  highest and lowest estimated outcome rates are used and the trial is
  only stopped for equivalence if all remaining arms are equivalent.

- futility_diff:

  single numeric value (`> 0`) or `NULL` (default, corresponding to no
  futility assessment). If a numeric value is specified, estimated
  differences below this threshold in the *beneficial* direction (as
  specified in `highest_is_best`) will be considered futile when
  assessing futility in designs with a common `control` arm. If only 1
  arm remains after dropping arms for futility, the trial will be
  stopped without declaring the last arm superior.

## Value

A named (row names corresponding to the trial `arms`) `matrix`
containing 1-3 columns: `probs_better`, `probs_equivalence` (if
`equivalence_diff` is specified), and `probs_futile` (if `futility_diff`
is specified). All columns will contain `NA` for the control arm.
