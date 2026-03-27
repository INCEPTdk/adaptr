# Extract results from a batch of trials from an object with multiple trials

Used internally by
[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md).
Extracts results from a batch of simulations from a simulation object
with multiple simulation results returned by
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md),
used to facilitate parallelisation.

## Usage

``` r
extract_results_batch(
  trial_results,
  control = control,
  select_strategy = select_strategy,
  select_last_arm = select_last_arm,
  select_preferences = select_preferences,
  te_comp = te_comp,
  which_ests = which_ests,
  te_comp_index = te_comp_index,
  te_comp_true_y = te_comp_true_y
)
```

## Arguments

- trial_results:

  list of trial results to summarise, the current batch.

- control:

  single character string, the common `control` arm from the trial
  specification (`NULL` if none).

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

- which_ests:

  single character string, a combination of the `raw_ests` and
  `final_ests` arguments from
  [`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md).

- te_comp_index:

  single integer, index of the treatment effect comparator arm (`NULL`
  if none).

- te_comp_true_y:

  single numeric value, true `y` value in the treatment effect
  comparator arm (`NULL` if none).

## Value

A `data.frame` containing all columns returned by
[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md)
and described in that function (`sim` will start from `1`, but this is
changed where relevant by
[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md)).
