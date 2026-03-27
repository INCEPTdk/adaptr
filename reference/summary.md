# Summary of simulated trial results

Summarises simulation results from the
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
function. Uses
[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md)
and
[`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md),
which may be used directly to extract key trial results without
summarising or to calculate performance metrics (with uncertainty
measures if desired) and return them in a tidy `data.frame`.

## Usage

``` r
# S3 method for class 'trial_results'
summary(
  object,
  select_strategy = "control if available",
  select_last_arm = FALSE,
  select_preferences = NULL,
  te_comp = NULL,
  raw_ests = FALSE,
  final_ests = NULL,
  restrict = NULL,
  cores = NULL,
  ...
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

- ...:

  additional arguments, not used.

## Value

A `"trial_results_summary"` object containing the following values:

- `n_rep`: the number of simulations.

- `n_summarised`: as described in
  [`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md).

- `highest_is_best`: as specified in
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md).

- `elapsed_time`: the total simulation time.

- `size_mean`, `size_sd`, `size_median`, `size_p25`, `size_p75`,
  `size_p0`, `size_p100`, `sum_ys_mean`, `sum_ys_sd`, `sum_ys_median`,
  `sum_ys_p25`, `sum_ys_p75`, `sum_ys_p0`, `sum_ys_p100`,
  `ratio_ys_mean`, `ratio_ys_sd`, `ratio_ys_median`, `ratio_ys_p25`,
  `ratio_ys_p75`, `ratio_ys_p0`, `ratio_ys_p100`, `prob_conclusive`,
  `prob_superior`, `prob_equivalence`, `prob_futility`, `prob_max`,
  `prob_select_*` (with `*` being either "`arm_<name>` for all `arm`
  names or `none`), `rmse`, `rmse_te`, `mae`, `mae_te`, and `idp`:
  performance metrics as described in
  [`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md).
  Note that all `sum_ys_` and `ratio_ys_` measures use outcome data from
  all randomised participants, regardless of whether they had outcome
  data available at the last analysis or not, as described in
  [`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md).

- `select_strategy`, `select_last_arm`, `select_preferences`, `te_comp`,
  `raw_ests`, `final_ests`, `restrict`: as specified above.

- `control`: the control arm specified by
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  or
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md);
  `NULL` if no control.

- `equivalence_assessed`, `futility_assessed`: single logicals,
  specifies whether the trial design specification includes assessments
  of equivalence and/or futility.

- `base_seed`: as specified in
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md).

- `cri_width`, `n_draws`, `robust`, `description`, `add_info`: as
  specified in
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  or
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md).

## See also

[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md),
[`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md),
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

# Summarise simulations - select the control arm if available in trials not
# ending with a superiority decision
res_sum <- summary(res, select_strategy = "control")

# Print summary
print(res_sum, digits = 1)
#> Multiple simulation results: generic binomially distributed outcome trial
#> * Undesirable outcome
#> * Number of simulations: 10
#> * Number of simulations summarised: 10 (all trials)
#> * Common control arm: A
#> * Selection strategy: first control if available (otherwise no selection)
#> * Treatment effect compared to: no comparison
#> 
#> Performance metrics (using posterior estimates from last adaptive analysis):
#> * Sample sizes: mean 1840.0 (SD: 506.0) | median 2000.0 (IQR: 2000.0 to 2000.0) [range: 400.0 to 2000.0]
#> * Total summarised outcomes: mean 369.9 (SD: 105.4) | median 390.0 (IQR: 376.5 to 408.5) [range: 84.0 to 466.0]
#> * Total summarised outcome rates: mean 0.202 (SD: 0.016) | median 0.196 (IQR: 0.194 to 0.209) [range: 0.180 to 0.233]
#> * Conclusive: 10.0%
#> * Superiority: 10.0%
#> * Equivalence: 0.0% [not assessed]
#> * Futility: 0.0% [not assessed]
#> * Inconclusive at max sample size: 90.0%
#> * Selection probabilities: A: 80.0% | B: 10.0% | C: 0.0% | D: 0.0% | None: 10.0%
#> * RMSE / MAE: 0.02061 / 0.01915
#> * RMSE / MAE treatment effect: 0.18206 / 0.18206
#> * Ideal design percentage: 70.4%
#> 
#> Simulation details:
#> * Simulation time: 0.705 secs
#> * Base random seed: 12345
#> * Credible interval width: 95%
#> * Number of posterior draws: 5000
#> * Estimation method: posterior medians with MAD-SDs
```
