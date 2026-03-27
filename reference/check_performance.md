# Check performance metrics for trial simulations

Calculates performance metrics for a trial specification based on
simulation results from the
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
function, with bootstrapped uncertainty measures if requested. Uses
[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md),
which may be used directly to extract key trial results without
summarising. This function is also used by
[`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md) to
calculate the performance metrics presented by that function.

## Usage

``` r
check_performance(
  object,
  select_strategy = "control if available",
  select_last_arm = FALSE,
  select_preferences = NULL,
  te_comp = NULL,
  raw_ests = FALSE,
  final_ests = NULL,
  restrict = NULL,
  uncertainty = FALSE,
  n_boot = 5000,
  ci_width = 0.95,
  boot_seed = NULL,
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

- restrict:

  single character string or `NULL`. If `NULL` (default), results are
  summarised for all simulations; if `"superior"`, results are
  summarised for simulations ending with superiority only; if
  `"selected"`, results are summarised for simulations ending with a
  selected arm only (according to the specified arm selection strategy
  for simulations not ending with superiority). Some summary measures
  (e.g., `prob_conclusive`) have substantially different interpretations
  if restricted, but are calculated nonetheless.

- uncertainty:

  single logical; if `FALSE` (default) uncertainty measures are not
  calculated, if `TRUE`, non-parametric bootstrapping is used to
  calculate uncertainty measures.

- n_boot:

  single integer (default `5000`); the number of bootstrap samples to
  use if `uncertainty = TRUE`. Values `< 100` are not allowed and values
  `< 1000` will lead to a warning, as results are likely to be unstable
  in those cases.

- ci_width:

  single numeric `>= 0` and `< 1`, the width of the percentile-based
  bootstrapped confidence intervals. Defaults to `0.95`, corresponding
  to 95% confidence intervals.

- boot_seed:

  single integer, `NULL` (default), or `"base"`. If a value is provided,
  this value will be used to initiate random seeds when bootstrapping
  with the global random seed restored after the function has run. If
  `"base"` is specified, the `base_seed` specified in
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
  is used. Regardless of whether simulations are run sequentially or in
  parallel, bootstrapped results will be identical if a `boot_seed` is
  specified.

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

A tidy `data.frame` with added class `trial_performance` (to control the
number of digits printed, see
[`print()`](https://inceptdk.github.io/adaptr/reference/print.md)), with
the columns `"metric"` (described below), `"est"` (estimate of each
metric), and the following four columns if `uncertainty = TRUE`:
`"err_sd"`(bootstrapped SDs), `"err_mad"` (bootstrapped MAD-SDs, as
described in
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
and [`stats::mad()`](https://rdrr.io/r/stats/mad.html)), `"lo_ci"`, and
`"hi_ci"`, the latter two corresponding to the lower/upper limits of the
percentile-based bootstrapped confidence intervals. Bootstrap estimates
are **not** calculated for the minimum (`_p0`) and maximum values
(`_p100`) of `size`, `sum_ys`, and `ratio_ys`, as non-parametric
bootstrapping for minimum/maximum values is not sensible - bootstrap
estimates for these values will be `NA`.  
The following performance metrics are calculated:

- `n_summarised`: the number of simulations summarised.

- `size_mean`, `size_sd`, `size_median`, `size_p25`, `size_p75`,
  `size_p0`, `size_p100`: the mean, standard deviation, median as well
  as 25-, 75-, 0- (min), and 100- (max) percentiles of the sample sizes
  (number of participants randomised in each simulated trial) of the
  summarised trial simulations.

- `sum_ys_mean`, `sum_ys_sd`, `sum_ys_median`, `sum_ys_p25`,
  `sum_ys_p75`, `sum_ys_p0`, `sum_ys_p100`: the mean, standard
  deviation, median as well as 25-, 75-, 0- (min), and 100- (max)
  percentiles of the total `sum_ys` across all arms in the summarised
  trial simulations (e.g., the total number of events in trials with a
  binary outcome, or the sums of continuous values for all participants
  across all arms in trials with a continuous outcome). Always uses all
  outcomes from all randomised participants regardless of whether or not
  all participants had outcome data available at the time of trial
  stopping (corresponding to `sum_ys_all` in results from
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)).

- `ratio_ys_mean`, `ratio_ys_sd`, `ratio_ys_median`, `ratio_ys_p25`,
  `ratio_ys_p75`, `ratio_ys_p0`, `ratio_ys_p100`: the mean, standard
  deviation, median as well as 25-, 75-, 0- (min), and 100- (max)
  percentiles of the final `ratio_ys` (`sum_ys` as described above
  divided by the total number of participants randomised) across all
  arms in the summarised trial simulations.

- `prob_conclusive`: the proportion (`0` to `1`) of conclusive trial
  simulations, i.e., simulations not stopped at the maximum sample size
  without a superiority, equivalence or futility decision.

- `prob_superior`, `prob_equivalence`, `prob_futility`, `prob_max`: the
  proportion (`0` to `1`) of trial simulations stopped for superiority,
  equivalence, futility or inconclusive at the maximum allowed sample
  size, respectively.  
  **Note:** Some metrics may not make sense if summarised simulation
  results are `restricted`.

- `prob_select_*`: the selection probabilities for each arm and for no
  selection, according to the specified selection strategy. Contains one
  element per `arm`, named `prob_select_arm_<arm name>` and
  `prob_select_none` for the probability of selecting no arm.

- `rmse`, `rmse_te`: the root mean squared errors of the estimates for
  the selected arm and for the treatment effect, as described in
  [`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md).

- `mae`, `mae_te`: the median absolute errors of the estimates for the
  selected arm and for the treatment effect, as described in
  [`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md).

- `idp`: the ideal design percentage (IDP; 0-100%), see **Details**.

## Details

The ideal design percentage (IDP) returned is based on *Viele et al,
2020*
[doi:10.1177/1740774519877836](https://doi.org/10.1177/1740774519877836)
(and also described in *Granholm et al, 2022*
[doi:10.1016/j.jclinepi.2022.11.002](https://doi.org/10.1016/j.jclinepi.2022.11.002)
, which also describes the other performance measures) and has been
adapted to work for trials with both desirable/undesirable outcomes and
non-binary outcomes. Briefly, the expected outcome is calculated as the
sum of the true outcomes in each arm multiplied by the corresponding
selection probabilities (ignoring simulations with no selected arm). The
IDP is then calculated as:

- For desirable outcomes (`highest_is_best` is `TRUE`):  
  `100 * (expected outcome - lowest true outcome) / (highest true outcome - lowest true outcome)`

- For undesirable outcomes (`highest_is_best` is `FALSE`):  
  `100 - IDP calculated for desirable outcomes`

## See also

[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md),
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

# Check performance measures, without assuming that any arm is selected in
# the inconclusive simulations, with bootstrapped uncertainty measures
# (unstable in this example due to the very low number of simulations
# summarised):
check_performance(res, select_strategy = "none", uncertainty = TRUE,
n_boot = 1000, boot_seed = "base")
#>               metric      est  err_sd err_mad    lo_ci    hi_ci
#> 1       n_summarised   10.000   0.000   0.000   10.000   10.000
#> 2          size_mean 1840.000 162.458 237.216 1520.000 2000.000
#> 3            size_sd  505.964 297.470 250.048    0.000  772.873
#> 4        size_median 2000.000  66.847   0.000 2000.000 2000.000
#> 5           size_p25 2000.000 362.022   0.000  800.000 2000.000
#> 6           size_p75 2000.000   0.000   0.000 2000.000 2000.000
#> 7            size_p0  400.000      NA      NA       NA       NA
#> 8          size_p100 2000.000      NA      NA       NA       NA
#> 9        sum_ys_mean  369.900  33.912  36.324  293.050  419.500
#> 10         sum_ys_sd  105.352  46.692  56.287   19.191  162.759
#> 11     sum_ys_median  390.000  16.984   4.448  373.000  418.500
#> 12        sum_ys_p25  376.500  67.721  16.309  152.750  392.000
#> 13        sum_ys_p75  408.500  21.318  25.945  388.500  460.000
#> 14         sum_ys_p0   84.000      NA      NA       NA       NA
#> 15       sum_ys_p100  466.000      NA      NA       NA       NA
#> 16     ratio_ys_mean    0.202   0.005   0.005    0.193    0.212
#> 17       ratio_ys_sd    0.016   0.003   0.003    0.008    0.021
#> 18   ratio_ys_median    0.196   0.006   0.003    0.190    0.210
#> 19      ratio_ys_p25    0.194   0.005   0.003    0.181    0.200
#> 20      ratio_ys_p75    0.209   0.009   0.009    0.195    0.230
#> 21       ratio_ys_p0    0.180      NA      NA       NA       NA
#> 22     ratio_ys_p100    0.233      NA      NA       NA       NA
#> 23   prob_conclusive    0.100   0.102   0.148    0.000    0.300
#> 24     prob_superior    0.100   0.102   0.148    0.000    0.300
#> 25  prob_equivalence    0.000   0.000   0.000    0.000    0.000
#> 26     prob_futility    0.000   0.000   0.000    0.000    0.000
#> 27          prob_max    0.900   0.102   0.148    0.700    1.000
#> 28 prob_select_arm_A    0.000   0.000   0.000    0.000    0.000
#> 29 prob_select_arm_B    0.100   0.102   0.148    0.000    0.300
#> 30 prob_select_arm_C    0.000   0.000   0.000    0.000    0.000
#> 31 prob_select_arm_D    0.000   0.000   0.000    0.000    0.000
#> 32  prob_select_none    0.900   0.102   0.148    0.700    1.000
#> 33              rmse    0.023   0.000   0.000    0.023    0.023
#> 34           rmse_te    0.182   0.000   0.000    0.182    0.182
#> 35               mae    0.023   0.000   0.000    0.023    0.023
#> 36            mae_te    0.182   0.000   0.000    0.182    0.182
#> 37               idp  100.000   0.000   0.000  100.000  100.000
```
