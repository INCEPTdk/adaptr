# Calculate the probabilities of each arm being the best

Used internally. This function takes a `matrix` as calculated by the
[`get_draws_binom()`](https://inceptdk.github.io/adaptr/reference/get_draws_binom.md),
[`get_draws_norm()`](https://inceptdk.github.io/adaptr/reference/get_draws_norm.md)
or a corresponding custom function (as specified using the `fun_draws`
argument in
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md);
see
[`get_draws_generic()`](https://inceptdk.github.io/adaptr/reference/get_draws_generic.md))
and calculates the probabilities of each arm being the best (defined as
either the highest or the lowest value, as specified by the
`highest_is_best` argument in
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
[`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
or
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)).

## Usage

``` r
prob_best(m, highest_is_best = FALSE)
```

## Arguments

- m:

  a matrix with one column per trial arm (named as the `arms`) and one
  row for each draw from the posterior distributions.

- highest_is_best:

  single logical, specifies whether larger estimates of the outcome are
  favourable or not; defaults to `FALSE`, corresponding to, e.g., an
  undesirable binary outcomes (e.g., mortality) or a continuous outcome
  where lower numbers are preferred (e.g., hospital length of stay).

## Value

A named numeric vector of probabilities (names corresponding to `arms`).
