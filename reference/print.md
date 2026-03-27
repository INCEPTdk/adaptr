# Print methods for adaptive trial objects

Prints contents of the first input `x` in a human-friendly way, see
**Details** for more information.

## Usage

``` r
# S3 method for class 'trial_spec'
print(x, prob_digits = 3, ...)

# S3 method for class 'trial_result'
print(x, prob_digits = 3, ...)

# S3 method for class 'trial_performance'
print(x, digits = 3, ...)

# S3 method for class 'trial_results'
print(
  x,
  select_strategy = "control if available",
  select_last_arm = FALSE,
  select_preferences = NULL,
  te_comp = NULL,
  raw_ests = FALSE,
  final_ests = NULL,
  restrict = NULL,
  digits = 1,
  cores = NULL,
  ...
)

# S3 method for class 'trial_results_summary'
print(x, digits = 1, ...)

# S3 method for class 'trial_calibration'
print(x, ...)
```

## Arguments

- x:

  object to print, see **Details**.

- prob_digits:

  single integer (default is `3`), the number of digits used when
  printing probabilities, allocation probabilities and softening powers
  (with `2` extra digits added for stopping rule probability thresholds
  in trial specifications and for outcome rates in summarised results
  from multiple simulations).

- ...:

  additional arguments, not used.

- digits:

  single integer, the number of digits used when printing the numeric
  results. Default is `3` for outputs from
  [`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md)
  and `1` for outputs from
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
  and the accompanying
  [`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md)
  method.

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

## Value

Invisibly returns `x`.

## Details

The behaviour depends on the class of `x`:

- `trial_spec`: prints a trial specification setup by
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  or
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md).

&nbsp;

- `trial_result`: prints the results of a single trial simulated by
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md).
  More details are saved in the `trial_result` object and thus printed
  if the `sparse` argument in
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)
  or
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
  is set to `FALSE`; if `TRUE`, fewer details are printed, but the
  omitted details are available by printing the `trial_spec` object
  created by
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  or
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md).

&nbsp;

- `trial_results`: prints the results of multiple simulations generated
  using
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md).
  Further documentation on how multiple trials are summarised before
  printing can be found in the
  [`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md)
  function documentation.

&nbsp;

- `trial_results_summary`: print method for summary of multiple
  simulations of the same trial specification, generated by using the
  [`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md)
  function on an object generated by
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md).

## Methods (by class)

- `print(trial_spec)`: Trial specification

- `print(trial_result)`: Single trial result

- `print(trial_performance)`: Trial performance metrics

- `print(trial_results)`: Multiple trial results

- `print(trial_results_summary)`: Summary of multiple trial results

- `print(trial_calibration)`: Trial calibration
