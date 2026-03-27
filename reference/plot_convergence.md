# Plot convergence of performance metrics

Plots performance metrics according to the number of simulations
conducted for multiple simulated trials. The simulated trial results may
be split into a number of batches to illustrate stability of performance
metrics across different simulations. Calculations are done according to
specified selection and restriction strategies as described in
[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md)
and
[`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md).
Requires the `ggplot2` package installed.

## Usage

``` r
plot_convergence(
  object,
  metrics = "size mean",
  resolution = 100,
  select_strategy = "control if available",
  select_last_arm = FALSE,
  select_preferences = NULL,
  te_comp = NULL,
  raw_ests = FALSE,
  final_ests = NULL,
  restrict = NULL,
  n_split = 1,
  nrow = NULL,
  ncol = NULL,
  cores = NULL
)
```

## Arguments

- object:

  `trial_results` object, output from the
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
  function.

- metrics:

  the performance metrics to plot, as described in
  [`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md).
  Multiple metrics may be plotted at the same time. Valid metrics
  include: `size_mean`, `size_sd`, `size_median`, `size_p25`,
  `size_p75`, `size_p0`, `size_p100`, `sum_ys_mean`, `sum_ys_sd`,
  `sum_ys_median`, `sum_ys_p25`, `sum_ys_p75`, `sum_ys_p0`,
  `sum_ys_p100`, `ratio_ys_mean`, `ratio_ys_sd`, `ratio_ys_median`,
  `ratio_ys_p25`, `ratio_ys_p75`, `ratio_ys_p0`, `ratio_ys_p100`,
  `prob_conclusive`, `prob_superior`, `prob_equivalence`,
  `prob_futility`, `prob_max`, `prob_select_*` (with `*` being either
  "`arm_<name>` for all `arm` names or `none`), `rmse`, `rmse_te`,
  `mae`, `mae_te`, and `idp`. All may be specified as above, case
  sensitive, but with either spaces or underlines. Defaults to
  `"size mean"`.

- resolution:

  single positive integer, the number of points calculated and plotted,
  defaults to `100` and must be `>= 10`. Higher numbers lead to smoother
  plots, but increases computation time. If the value specified is
  higher than the number of simulations (or simulations per split), the
  maximum possible value will be used instead.

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

- restrict:

  single character string or `NULL`. If `NULL` (default), results are
  summarised for all simulations; if `"superior"`, results are
  summarised for simulations ending with superiority only; if
  `"selected"`, results are summarised for simulations ending with a
  selected arm only (according to the specified arm selection strategy
  for simulations not ending with superiority). Some summary measures
  (e.g., `prob_conclusive`) have substantially different interpretations
  if restricted, but are calculated nonetheless.

- n_split:

  single positive integer, the number of consecutive batches the
  simulation results will be split into, which will be plotted
  separately. Default is `1` (no splitting); maximum value is the number
  of simulations summarised (after restrictions) divided by 10.

- nrow, ncol:

  the number of rows and columns when plotting multiple metrics in the
  same plot (using faceting in `ggplot2`). Defaults to `NULL`, in which
  case this will be determined automatically.

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

A `ggplot2` plot object.

## See also

[`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md),
[`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md),
[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md),
[`check_remaining_arms()`](https://inceptdk.github.io/adaptr/reference/check_remaining_arms.md).

## Examples

``` r
#### Only run examples if ggplot2 is installed ####
if (requireNamespace("ggplot2", quietly = TRUE)){

  # Setup a trial specification
  binom_trial <- setup_trial_binom(arms = c("A", "B", "C", "D"),
                                   control = "A",
                                   true_ys = c(0.20, 0.18, 0.22, 0.24),
                                   data_looks = 1:20 * 100)

  # Run multiple simulation with a fixed random base seed
  res_mult <- run_trials(binom_trial, n_rep = 25, base_seed = 678)

  # NOTE: the number of simulations in this example is smaller than
  # recommended - the plots reflect that, and show that performance metrics
  # are not stable and have likely not converged yet

  # Convergence plot of mean sample sizes
  plot_convergence(res_mult, metrics = "size mean")

}


if (requireNamespace("ggplot2", quietly = TRUE)){

  # Convergence plot of mean sample sizes and ideal design percentages,
  # with simulations split in 2 batches
  plot_convergence(res_mult, metrics = c("size mean", "idp"), n_split = 2)

}

```
