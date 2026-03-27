# Setup a trial specification using a binary, binomially distributed outcome

Specifies the design of an adaptive trial with a binary, binomially
distributed outcome and validates all inputs. Uses *beta-binomial*
conjugate models with `beta(1, 1)` prior distributions, corresponding to
a uniform prior (or the addition of 2 participants, 1 with an event and
1 without, in each `arm`) to the trial. Use
[`calibrate_trial()`](https://inceptdk.github.io/adaptr/reference/calibrate_trial.md)
to calibrate the trial specification to obtain a specific value for a
certain performance metric (e.g., the Bayesian type 1 error rate). Use
[`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)
or
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
to conduct single/multiple simulations of the specified trial,
respectively.  
**Note:** `add_info` as specified in
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
is set to `NULL` for trial specifications setup by this function.  
**Further details:** please see
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md).
See
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)
for simplified setup of trials with a normally distributed continuous
outcome.  
For additional trial specification examples, see the the **Basic
examples** vignette
([`vignette("Basic-examples", package = "adaptr")`](https://inceptdk.github.io/adaptr/articles/Basic-examples.md))
and the **Advanced example** vignette
([`vignette("Advanced-example", package = "adaptr")`](https://inceptdk.github.io/adaptr/articles/Advanced-example.md)).

## Usage

``` r
setup_trial_binom(
  arms,
  true_ys,
  start_probs = NULL,
  fixed_probs = NULL,
  min_probs = rep(NA, length(arms)),
  max_probs = rep(NA, length(arms)),
  rescale_probs = NULL,
  data_looks = NULL,
  max_n = NULL,
  look_after_every = NULL,
  randomised_at_looks = NULL,
  control = NULL,
  control_prob_fixed = NULL,
  inferiority = 0.01,
  superiority = 0.99,
  equivalence_prob = NULL,
  equivalence_diff = NULL,
  equivalence_only_first = NULL,
  futility_prob = NULL,
  futility_diff = NULL,
  futility_only_first = NULL,
  rescale_adapt_probs = NULL,
  highest_is_best = FALSE,
  soften_power = 1,
  cri_width = 0.95,
  n_draws = 5000,
  robust = TRUE,
  description = "generic binomially distributed outcome trial"
)
```

## Arguments

- arms:

  character vector with unique names for the trial arms.

- true_ys:

  numeric vector, true probabilities (between `0` and `1`) of outcomes
  in all trial `arms`.

- start_probs:

  numeric vector, allocation probabilities for each arm at the beginning
  of the trial. The default (`NULL`) automatically generates equal
  randomisation probabilities for each arm.

- fixed_probs:

  numeric vector, fixed allocation probabilities for each arm. Must be
  either a numeric vector with `NA` for arms without fixed probabilities
  and values between `0` and `1` for the other arms or `NULL` (default),
  if adaptive randomisation is used for all arms or if one of the
  special settings (`"sqrt-based"`, `"sqrt-based start"`,
  `"sqrt-based fixed"`, or `"match"`) is specified for
  `control_prob_fixed` (described below).

- min_probs:

  numeric vector, lower threshold for adaptive allocation probabilities;
  lower probabilities will be rounded up to these values. Must be `NA`
  (default for all arms) if no lower threshold is wanted and for arms
  using fixed allocation probabilities.

- max_probs:

  numeric vector, upper threshold for adaptive allocation probabilities;
  higher probabilities will be rounded down to these values. Must be
  `NA` (default for all arms) if no threshold is wanted and for arms
  using fixed allocation probabilities.

- rescale_probs:

  `NULL` (default) or one of either `"fixed"`, `"limits"`, or `"both"`.
  Rescales `fixed_probs` (if `"fixed"` or `"both"`) and
  `min_probs/max_probs` (if `"limits"` or `"both"`) after arm dropping
  in trial specifications with `>2 arms` using a `rescale_factor`
  defined as `initial number of arms/number of active arms`.
  `fixed_probs` and `min_probs` are rescaled as
  `initial value * rescale factor`, except for `fixed_probs` controlled
  by the `control_prob_fixed` argument, which are never rescaled.
  `max_probs` are rescaled as
  `1 - ( (1 - initial value) * rescale_factor)`.  
  Must be `NULL` if there are only `2 arms` or if `control_prob_fixed`
  is `"sqrt-based fixed"`. If not `NULL`, one or more valid non-`NA`
  values must be specified for either `min_probs/max_probs` or
  `fixed_probs` (not counting a fixed value for the original `control`
  if `control_prob_fixed` is
  `"sqrt-based"/"sqrt-based start"/"sqrt-based fixed"`).  
  **Note:** using this argument and specific combinations of values in
  the other arguments may lead to invalid combined (total) allocation
  probabilities after arm dropping, in which case all probabilities will
  ultimately be rescaled to sum to `1`. It is the responsibility of the
  user to ensure that rescaling fixed allocation probabilities and
  minimum/maximum allocation probability limits will not lead to invalid
  or unexpected allocation probabilities after arm dropping.  
  Finally, any initial values that are overwritten by the
  `control_prob_fixed` argument after arm dropping will not be rescaled.

- data_looks:

  vector of increasing integers, specifies when to conduct adaptive
  analyses (= the total number of participants with available outcome
  data at each adaptive analysis). The last number in the vector
  represents the final adaptive analysis, i.e., the final analysis where
  superiority, inferiority, practical equivalence, or futility can be
  claimed. Instead of specifying `data_looks`, the `max_n` and
  `look_after_every` arguments can be used in combination (in which case
  `data_looks` must be `NULL`, the default value).

- max_n:

  single integer, number of participants with available outcome data at
  the last possible adaptive analysis (defaults to `NULL`). Must only be
  specified if `data_looks` is `NULL`. Requires specification of the
  `look_after_every` argument.

- look_after_every:

  single integer, specified together with `max_n`. Adaptive analyses
  will be conducted after every `look_after_every` participants have
  available outcome data, and at the total sample size as specified by
  `max_n` (`max_n` does not need to be a multiple of
  `look_after_every`). If specified, `data_looks` must be `NULL`
  (default).

- randomised_at_looks:

  vector of increasing integers or `NULL`, specifying the number of
  participants randomised at the time of each adaptive analysis, with
  new participants randomised using the current allocation probabilities
  at said analysis. If `NULL` (the default), the number of participants
  randomised at each analysis will match the number of participants with
  available outcome data at said analysis, as specified by `data_looks`
  or `max_n` and `look_after_every`, i.e., outcome data will be
  available immediately after randomisation for all participants.  
  If not `NULL`, the vector must be of the same length as the number of
  adaptive analyses specified by `data_looks` or `max_n` and
  `look_after_every`, and all values must be larger than or equal to the
  number of participants with available outcome data at each analysis.

- control:

  single character string, name of one of the `arms` or `NULL`
  (default). If specified, this arm will serve as a common control arm,
  to which all other arms will be compared and the
  inferiority/superiority/equivalence thresholds (see below) will be for
  those comparisons. See
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
  **Details** for information on behaviour with respect to these
  comparisons.

- control_prob_fixed:

  if a common `control` arm is specified, this can be set `NULL` (the
  default), in which case the control arm allocation probability will
  not be fixed if control arms change (the allocation probability for
  the first control arm may still be fixed using `fixed_probs`, but will
  not be 'reused' for the new control arm).  
  If not `NULL`, a vector of probabilities of either length `1` or
  `number of arms - 1` can be provided, or one of the special arguments
  `"sqrt-based"`, `"sqrt-based start"`, `"sqrt-based fixed"` or
  `"match"`.  
  See
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
  **Details** for details on how this affects trial behaviour.

- inferiority:

  single numeric value or vector of numeric values of the same length as
  the maximum number of possible adaptive analyses, specifying the
  probability threshold(s) for inferiority (default is `0.01`). All
  values must be `>= 0` and `<= 1`, and if multiple values are supplied,
  no values may be lower than the preceding value. If a common
  `control`is not used, all values must be `< 1 / number of arms`. An
  arm will be considered inferior and dropped if the probability that it
  is best (when comparing all arms) or better than the control arm (when
  a common `control` is used) drops below the inferiority threshold at
  an adaptive analysis.

- superiority:

  single numeric value or vector of numeric values of the same length as
  the maximum number of possible adaptive analyses, specifying the
  probability threshold(s) for superiority (default is `0.99`). All
  values must be `>= 0` and `<= 1`, and if multiple values are supplied,
  no values may be higher than the preceding value. If the probability
  that an arm is best (when comparing all arms) or better than the
  control arm (when a common `control` is used) exceeds the superiority
  threshold at an adaptive analysis, said arm will be declared the
  winner and the trial will be stopped (if no common `control` is used
  or if the last comparator is dropped in a design with a common
  control) *or* become the new control and the trial will continue (if a
  common control is specified).

- equivalence_prob:

  single numeric value, vector of numeric values of the same length as
  the maximum number of possible adaptive analyses or `NULL` (default,
  corresponding to no equivalence assessment), specifying the
  probability threshold(s) for equivalence. If not `NULL`, all values
  must be `> 0` and `<= 1`, and if multiple values are supplied, no
  value may be higher than the preceding value. If not `NULL`, arms will
  be dropped for equivalence if the probability of either *(a)*
  equivalence compared to a common `control` or *(b)* equivalence
  between all arms remaining (designs without a common `control`)
  exceeds the equivalence threshold at an adaptive analysis. Requires
  specification of `equivalence_diff` and `equivalence_only_first`.

- equivalence_diff:

  single numeric value (`> 0`) or `NULL` (default, corresponding to no
  equivalence assessment). If a numeric value is specified, estimated
  absolute differences smaller than this threshold will be considered
  equivalent. For designs with a common `control` arm, the differences
  between each non-control arm and the `control` arm is used, and for
  trials without a common `control` arm, the difference between the
  highest and lowest estimated outcome rates are used and the trial is
  only stopped for equivalence if all remaining arms are equivalent.

- equivalence_only_first:

  single logical in trial specifications where `equivalence_prob` and
  `equivalence_diff` are specified and a common `control` arm is
  included, otherwise `NULL` (default). If a common `control` arm is
  used, this specifies whether equivalence will only be assessed for the
  first control (if `TRUE`) or also for subsequent `control` arms (if
  `FALSE`) if one arm is superior to the first control and becomes the
  new control.

- futility_prob:

  single numeric value, vector of numeric values of the same length as
  the maximum number of possible adaptive analyses or `NULL` (default,
  corresponding to no futility assessment), specifying the probability
  threshold(s) for futility. All values must be `> 0` and `<= 1`, and if
  multiple values are supplied, no value may be higher than the
  preceding value. If not `NULL`, arms will be dropped for futility if
  the probability for futility compared to the common `control` exceeds
  the futility threshold at an adaptive analysis. Requires a common
  `control` arm (otherwise this argument must be `NULL`), specification
  of `futility_diff`, and `futility_only_first`.

- futility_diff:

  single numeric value (`> 0`) or `NULL` (default, corresponding to no
  futility assessment). If a numeric value is specified, estimated
  differences below this threshold in the *beneficial* direction (as
  specified in `highest_is_best`) will be considered futile when
  assessing futility in designs with a common `control` arm. If only 1
  arm remains after dropping arms for futility, the trial will be
  stopped without declaring the last arm superior.

- futility_only_first:

  single logical in trial specifications designs where `futility_prob`
  and `futility_diff` are specified, otherwise `NULL` (default and
  required in designs without a common `control` arm). Specifies whether
  futility will only be assessed against the first `control` (if `TRUE`)
  or also for subsequent control arms (if `FALSE`) if one arm is
  superior to the first control and becomes the new control.

- rescale_adapt_probs:

  `NULL` (default), or a single character string, either `"both"`,
  `"superiority"`, or `"inferiority"`. Specifies whether/which
  adaptation rule probability thresholds will be rescaled proportionally
  if arms are dropped before a simulated trial is stopped. `NULL` is no
  rescaling, and `"both"` is rescaling of adaptation probabilities for
  both `"superiority"` and `"inferiority"`. Rescaling of adaptation rule
  probability thresholds can only be applied for trial designs with \>2
  arms *without* a common `control` arm. This is because stopping/arm
  dropping for superiority and inferiority is based on probabilities of
  each arm being best, and these probabilities have to sum to `1` across
  all arms. Thus, thresholds can become 'easier' to cross when fewer
  arms are active.  
  Probabilities are rescaled using a `rescale_factor` defined as
  `initial number of arms/number of active arms`. Probability thresholds
  for `superiority` are rescaled as
  `1 - (1 - initial value) / rescale_factor` (increasing these values),
  while probability thresholds for `inferiority` are rescaled as
  `initial value / rescale_factor` (decreasing these values).

- highest_is_best:

  single logical, specifies whether larger estimates of the outcome are
  favourable or not; defaults to `FALSE`, corresponding to, e.g., an
  undesirable binary outcomes (e.g., mortality) or a continuous outcome
  where lower numbers are preferred (e.g., hospital length of stay).

- soften_power:

  either a single numeric value or a numeric vector of exactly the same
  length as the maximum number of looks/adaptive analyses. Values must
  be between `0` and `1` (default); if `< 1`, then re-allocated
  non-fixed allocation probabilities are all raised to this power
  (followed by rescaling to sum to `1`) to make adaptive allocation
  probabilities less extreme, in turn used to redistribute remaining
  probability while respecting limits when defined by `min_probs` and/or
  `max_probs`. If `1`, then no *softening* is applied.

- cri_width:

  single numeric `>= 0` and `< 1`, the width of the percentile-based
  credible intervals used when summarising individual trial results.
  Defaults to `0.95`, corresponding to 95% credible intervals.

- n_draws:

  single integer, the number of draws from the posterior distributions
  for each arm used when running the trial. Defaults to `5000`; can be
  reduced for a speed gain (at the potential loss of stability of
  results if too low) or increased for increased precision (increasing
  simulation time). Values `< 100` are not allowed and values `< 1000`
  are not recommended and warned against.

- robust:

  single logical, if `TRUE` (default) the medians and median absolute
  deviations (scaled to be comparable to the standard deviation for
  normal distributions; MAD_SDs, see
  [`stats::mad()`](https://rdrr.io/r/stats/mad.html)) are used to
  summarise the posterior distributions; if `FALSE`, the means and
  standard deviations (SDs) are used instead (slightly faster, but may
  be less appropriate for posteriors skewed on the natural scale).

- description:

  character string, default is
  `"generic binomially distributed outcome trial"`. See arguments of
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md).

## Value

A `trial_spec` object used to run simulations by
[`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)
or
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md).
The output is essentially a list containing the input values (some
combined in a `data.frame` called `trial_arms`), but its class signals
that these inputs have been validated and inappropriate combinations and
settings have been ruled out. Also contains `best_arm`, holding the
arm(s) with the best value(s) in `true_ys`. Use
[`str()`](https://rdrr.io/r/utils/str.html) to peruse the actual content
of the returned object.

## Examples

``` r
# Setup a trial specification using a binary, binomially
# distributed, undesirable outcome
binom_trial <- setup_trial_binom(
  arms = c("Arm A", "Arm B", "Arm C"),
  true_ys = c(0.25, 0.20, 0.30),
  # Minimum allocation of 15% in all arms
  min_probs = rep(0.15, 3),
  data_looks = seq(from = 300, to = 2000, by = 100),
  # Stop for equivalence if > 90% probability of
  # absolute differences < 5 percentage points
  equivalence_prob = 0.9,
  equivalence_diff = 0.05,
  soften_power = 0.5 # Limit extreme allocation ratios
)

# Print using 3 digits for probabilities
print(binom_trial, prob_digits = 3)
#> Trial specification: generic binomially distributed outcome trial
#> * Undesirable outcome
#> * No common control arm
#> * Best arm: Arm B
#> 
#> Arms, true outcomes, starting allocation probabilities 
#> and allocation probability limits (fixed/min/max_probs not rescaled):
#>   arms true_ys start_probs fixed_probs min_probs max_probs
#>  Arm A    0.25       0.333          NA      0.15        NA
#>  Arm B    0.20       0.333          NA      0.15        NA
#>  Arm C    0.30       0.333          NA      0.15        NA
#> 
#> Maximum sample size: 2000 
#> Maximum number of data looks: 18
#> Planned data looks after:  300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000 participants have reached follow-up
#> Number of participants randomised at each look:  300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000
#> 
#> Superiority threshold: 0.99 (all analyses)
#> Inferiority threshold: 0.01 (all analyses)
#> Equivalence threshold: 0.9 (all analyses) (no common control)
#> Absolute equivalence difference: 0.05
#> No futility threshold (not relevant - no common control)
#> Adaptation rule probability thresholds not rescaled when arms are dropped
#> Soften power for all analyses: 0.5
```
