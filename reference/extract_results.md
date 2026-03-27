# Extract simulation results

This function extracts relevant information from multiple simulations of
the same trial specification in a tidy `data.frame` (1 simulation per
row). See also the
[`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md)
and
[`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md)
functions, that uses the output from this function to further summarise
simulation results.

## Usage

``` r
extract_results(
  object,
  select_strategy = "control if available",
  select_last_arm = FALSE,
  select_preferences = NULL,
  te_comp = NULL,
  raw_ests = FALSE,
  final_ests = NULL,
  cores = NULL
)
```

## Arguments

- object:

  `trial_results` object, output from the
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
  function.

- select_strategy:

  single character string. If a trial was not stopped due to superiority
  (or had only 1 arm remaining, if `select_last_arm` is set to `TRUE` in
  trial designs with a common `control` arm; see below), this parameter
  specifies which arm will be considered selected when calculating trial
  design performance metrics, as described below; this corresponds to
  the consequence of an inconclusive trial, i.e., which arm would then
  be used in practice.  
  The following options are available and must be written exactly as
  below (case sensitive, cannot be abbreviated):

  - `"control if available"` (default): selects the **first** `control`
    arm for trials with a common `control` arm ***if*** this arm is
    active at end-of-trial, otherwise no arm will be selected. For trial
    designs without a common `control`, no arm will be selected.

  - `"none"`: selects no arm in trials not ending with superiority.

  - `"control"`: similar to `"control if available"`, but will throw an
    error if used for trial designs without a common `control` arm.

  - `"final control"`: selects the **final** `control` arm regardless of
    whether the trial was stopped for practical equivalence, futility,
    or at the maximum sample size; this strategy can only be specified
    for trial designs with a common `control` arm.

  - `"control or best"`: selects the **first** `control` arm if still
    active at end-of-trial, otherwise selects the best remaining arm
    (defined as the remaining arm with the highest probability of being
    the best in the last adaptive analysis conducted). Only works for
    trial designs with a common `control` arm.

  - `"best"`: selects the best remaining arm (as described under
    `"control or best"`).

  - `"list or best"`: selects the first remaining arm from a specified
    list (specified using `select_preferences`, technically a character
    vector). If none of these arms are are active at end-of-trial, the
    best remaining arm will be selected (as described above).

  - `"list"`: as specified above, but if no arms on the provided list
    remain active at end-of-trial, no arm is selected.

- select_last_arm:

  single logical, defaults to `FALSE`. If `TRUE`, the only remaining
  active arm (the last `control`) will be selected in trials with a
  common `control` arm ending with `equivalence` or `futility`, before
  considering the options specified in `select_strategy`. Must be
  `FALSE` for trial designs without a common `control` arm.

- select_preferences:

  character vector specifying a number of arms used for selection if one
  of the `"list or best"` or `"list"` options are specified for
  `select_strategy`. Can only contain valid `arms` available in the
  trial.

- te_comp:

  character string, treatment-effect comparator. Can be either `NULL`
  (the default) in which case the **first** `control` arm is used for
  trial designs with a common control arm, or a string naming a single
  trial `arm`. Will be used when calculating `err_te` and `sq_err_te`
  (the error and the squared error of the treatment effect comparing the
  selected arm to the comparator arm, as described below).

- raw_ests:

  single logical. If `FALSE` (default), the posterior estimates
  (`post_ests` or `post_ests_all`, see
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
  and
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md))
  will be used to calculate `err` and `sq_err` (the error and the
  squared error of the estimated compared to the specified effect in the
  selected arm) and `err_te` and `sq_err_te` (the error and the squared
  error of the treatment effect comparing the selected arm to the
  comparator arm, as described for `te_comp` and below). If `TRUE`, the
  raw estimates (`raw_ests` or `raw_ests_all`, see
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
  and
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md))
  will be used instead of the posterior estimates.

- final_ests:

  single logical. If `TRUE` (recommended) the final estimates calculated
  using outcome data from all participants randomised when trials are
  stopped are used (`post_ests_all` or `raw_ests_all`, see
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
  and
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md));
  if `FALSE`, the estimates calculated for each arm when an arm is
  stopped (or at the last adaptive analysis if not before) using data
  from participants having reach followed up at this time point and not
  all participants randomised are used (`post_ests` or `raw_ests`, see
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
  and
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)).
  If `NULL` (the default), this argument will be set to `FALSE` if
  outcome data are available immediate after randomisation for all
  participants (for backwards compatibility, as final posterior
  estimates may vary slightly in this situation, even if using the same
  data); otherwise it will be said to `TRUE`. See
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
  for more details on how these estimates are calculated.

- cores:

  `NULL` or single integer. If `NULL`, a default value set by
  [`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md)
  will be used to control whether extractions of simulation results are
  done in parallel on a default cluster or sequentially in the main
  process; if a value has not been specified by
  [`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md),
  `cores` will then be set to the value stored in the global
  `"mc.cores"` option (if previously set by
  `options(mc.cores = <number of cores>`), and `1` if that option has
  not been specified.  
  If `cores = 1`, computations will be run sequentially in the primary
  process, and if `cores > 1`, a new parallel cluster will be setup
  using the `parallel` library and removed once the function completes.
  See
  [`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md)
  for details.

## Value

A `data.frame` containing the following columns:

- `sim`: the simulation number (from `1` to the total number of
  simulations).

- `final_n`: the final sample size in each simulation.

- `sum_ys`: the sum of the total counts in all arms, e.g., the total
  number of events in trials with a binary outcome
  ([`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md))
  or the sum of the arm totals in trials with a continuous outcome
  ([`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)).
  Always uses all outcome data from all randomised participants
  regardless of whether or not all participants had outcome data
  available at the time of trial stopping (corresponding to `sum_ys_all`
  in results from
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)).

- `ratio_ys`: calculated as `sum_ys/final_n` (as described above).

- `final_status`: the final trial status for each simulation, either
  `"superiority"`, `"equivalence"`, `"futility"`, or `"max"`, as
  described in
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md).

- `superior_arm`: the final superior arm in simulations stopped for
  superiority. Will be `NA` in simulations not stopped for superiority.

- `selected_arm`: the final selected arm (as described above). Will
  correspond to the `superior_arm` in simulations stopped for
  superiority and be `NA` if no arm is selected. See `select_strategy`
  above.

- `err`: the squared error of the estimate in the selected arm,
  calculated as `estimated effect - true effect` for the selected arm.

- `sq_err:` the squared error of the estimate in the selected arm,
  calculated as `err^2` for the selected arm, with `err` defined above.

- `err_te`: the error of the treatment effect comparing the selected arm
  to the comparator arm (as specified in `te_comp`). Calculated as:  
  `(estimated effect in the selected arm - estimated effect in the comparator arm) -`
  `(true effect in the selected arm - true effect in the comparator arm)`  
  Will be `NA` for simulations without a selected arm, with no
  comparator specified (see `te_comp` above), and when the selected arm
  is the comparator arm.

- `sq_err_te`: the squared error of the treatment effect comparing the
  selected arm to the comparator arm (as specified in `te_comp`),
  calculated as `err_te^2`, with `err_te` defined above.

## See also

[`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md),
[`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md),
[`plot_convergence()`](https://inceptdk.github.io/adaptr/reference/plot_convergence.md),
[`plot_metrics_ecdf()`](https://inceptdk.github.io/adaptr/reference/plot_metrics_ecdf.md),
[`check_remaining_arms()`](https://inceptdk.github.io/adaptr/reference/check_remaining_arms.md).

## Examples

``` r
# Setup a trial specification
binom_trial <- setup_trial_binom(arms = c("A", "B", "C", "D"),
                                 control = "A",
                                 true_ys = c(0.20, 0.18, 0.22, 0.24),
                                 data_looks = 1:20 * 100)

# Run 10 simulations with a specified random base seed
res <- run_trials(binom_trial, n_rep = 10, base_seed = 12345)

# Extract results and Select the control arm if available
# in simulations not ending with superiority
extract_results(res, select_strategy = "control")
#>    sim final_n sum_ys ratio_ys final_status superior_arm selected_arm
#> 1    1    2000    387   0.1935          max         <NA>            A
#> 2    2    2000    391   0.1955          max         <NA>            A
#> 3    3    2000    359   0.1795          max         <NA>         <NA>
#> 4    4    2000    389   0.1945          max         <NA>            A
#> 5    5    2000    373   0.1865          max         <NA>            A
#> 6    6     400     84   0.2100  superiority            B            B
#> 7    7    2000    395   0.1975          max         <NA>            A
#> 8    8    2000    442   0.2210          max         <NA>            A
#> 9    9    2000    413   0.2065          max         <NA>            A
#> 10  10    2000    466   0.2330          max         <NA>            A
#>             err       sq_err     err_te sq_err_te
#> 1   0.027072360 7.329127e-04         NA        NA
#> 2   0.027225919 7.412507e-04         NA        NA
#> 3            NA           NA         NA        NA
#> 4   0.028619492 8.190753e-04         NA        NA
#> 5  -0.014477338 2.095933e-04         NA        NA
#> 6  -0.022699865 5.152839e-04 -0.1820624 0.0331467
#> 7   0.009098866 8.278937e-05         NA        NA
#> 8   0.010663973 1.137203e-04         NA        NA
#> 9   0.015544164 2.416210e-04         NA        NA
#> 10  0.019152691 3.668256e-04         NA        NA
```
