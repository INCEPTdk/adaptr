# Calculate the probability that all arms are practically equivalent

Used internally. This function takes a `matrix` as calculated by the
[`get_draws_binom()`](https://inceptdk.github.io/adaptr/reference/get_draws_binom.md),
[`get_draws_norm()`](https://inceptdk.github.io/adaptr/reference/get_draws_norm.md)
or a corresponding custom function (specified using the `fun_draws`
argument in
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md);
see
[`get_draws_generic()`](https://inceptdk.github.io/adaptr/reference/get_draws_generic.md)),
and an equivalence difference, and calculates the probability of all
arms being equivalent (absolute differences between highest and lowest
value in the same set of posterior draws being less than the difference
considered practically equivalent).

## Usage

``` r
prob_all_equi(m, equivalence_diff = NULL)
```

## Arguments

- m:

  a matrix with one column per trial arm (named as the `arms`) and one
  row for each draw from the posterior distributions.

- equivalence_diff:

  single numeric value (`> 0`) or `NULL` (default, corresponding to no
  equivalence assessment). If a numeric value is specified, estimated
  absolute differences smaller than this threshold will be considered
  equivalent. For designs with a common `control` arm, the differences
  between each non-control arm and the `control` arm is used, and for
  trials without a common `control` arm, the difference between the
  highest and lowest estimated outcome rates are used and the trial is
  only stopped for equivalence if all remaining arms are equivalent.

## Value

A single numeric value corresponding to the probability of all arms
being practically equivalent.
