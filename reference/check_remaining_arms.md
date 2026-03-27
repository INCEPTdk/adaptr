# Check remaining arm combinations

This function summarises the numbers and proportions of all combinations
of remaining arms (i.e., excluding arms dropped for inferiority or
futility at any analysis, and arms dropped for equivalence at earlier
analyses in trials with a common `control`) across multiple simulated
trial results. The function supplements the
[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md),
[`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md),
and
[`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md)
functions, and is especially useful for designs with `> 2` arms, where
it provides details that the other functions mentioned do not.

## Usage

``` r
check_remaining_arms(object, ci_width = 0.95)
```

## Arguments

- object:

  `trial_results` object, output from the
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
  function.

- ci_width:

  single numeric `>= 0` and `< 1`, the width of the approximate
  confidence intervals for the proportions of combinations (calculated
  analytically). Defaults to `0.95`, corresponding to 95% confidence
  intervals.

## Value

a `data.frame` containing the combinations of remaining arms, sorted in
descending order of, with the following columns:

- `arm_*`, one column per arm, each named as `arm_<arm name>`. These
  columns will contain an empty character string `""` for dropped arms
  (including arms dropped at the final analysis), and otherwise be
  `"superior"`, `"control"`, `"equivalence"` (only if equivalent at the
  final analysis), or `"active"`, as described in
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md).

- `n` integer vector, number of trial simulations ending with the
  combination of remaining arms as specified by the preceding columns.

- `prop` numeric vector, the proportion of trial simulations ending with
  the combination of remaining arms as specified by the preceding
  columns.

- `se`,`lo_ci`,`hi_ci`: the standard error of `prop` and the confidence
  intervals of the width specified by `ci_width`.

## See also

[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md),
[`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md),
[`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md),
[`plot_convergence()`](https://inceptdk.github.io/adaptr/reference/plot_convergence.md),
[`plot_metrics_ecdf()`](https://inceptdk.github.io/adaptr/reference/plot_metrics_ecdf.md).

## Examples

``` r
# Setup a trial specification
binom_trial <- setup_trial_binom(arms = c("A", "B", "C", "D"),
                                 control = "A",
                                 true_ys = c(0.20, 0.18, 0.22, 0.24),
                                 data_looks = 1:20 * 200,
                                 equivalence_prob = 0.7,
                                 equivalence_diff = 0.03,
                                 equivalence_only_first = FALSE)

# Run 25 simulations with a specified random base seed
res <- run_trials(binom_trial, n_rep = 25, base_seed = 12345)

# Check remaining arms (printed with fewer digits)
print(check_remaining_arms(res), digits = 3)
#>      arm_A    arm_B  arm_C       arm_D n prop    se lo_ci hi_ci
#> 1 superior                             5 0.20 0.179     0 0.551
#> 2          superior                    5 0.20 0.179     0 0.551
#> 3  control   active active      active 5 0.20 0.179     0 0.551
#> 4  control                 equivalence 1 0.04 0.196     0 0.424
```
