# Setup a generic trial specification

Specifies the design of an adaptive trial with any type of outcome and
validates all inputs. Use
[`calibrate_trial()`](https://inceptdk.github.io/adaptr/reference/calibrate_trial.md)
to calibrate the trial specification to obtain a specific value for a
certain performance metric (e.g., the Bayesian type 1 error rate). Use
[`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)
or
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
to conduct single/multiple simulations of the specified trial,
respectively.  
See
[`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
and
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)
for simplified setup of trial designs for common outcome types. For
additional trial specification examples, see the the **Basic examples**
vignette
([`vignette("Basic-examples", package = "adaptr")`](https://inceptdk.github.io/adaptr/articles/Basic-examples.md))
and the **Advanced example** vignette
([`vignette("Advanced-example", package = "adaptr")`](https://inceptdk.github.io/adaptr/articles/Advanced-example.md)).

## Usage

``` r
setup_trial(
  arms,
  true_ys,
  fun_y_gen = NULL,
  fun_draws = NULL,
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
  highest_is_best = FALSE,
  rescale_adapt_probs = NULL,
  soften_power = 1,
  fun_raw_est = mean,
  cri_width = 0.95,
  n_draws = 5000,
  robust = TRUE,
  description = NULL,
  add_info = NULL
)
```

## Arguments

- arms:

  character vector with unique names for the trial arms.

- true_ys:

  numeric vector specifying true outcomes (e.g., event probabilities,
  mean values, etc.) for all trial `arms`.

- fun_y_gen:

  function, generates outcomes. See `setup_trial()` **Details** for
  information on how to specify this function.  
  **Note:** this function is called once during setup to validate its
  output (with the global random seed restored afterwards).

- fun_draws:

  function, generates posterior draws. See `setup_trial()` **Details**
  for information on how to specify this function.  
  **Note:** this function is called up to three times during setup to
  validate its output (with the global random seed restored afterwards).

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
  those comparisons. See `setup_trial()` **Details** for information on
  behaviour with respect to these comparisons.

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
  See `setup_trial()` **Details** for details on how this affects trial
  behaviour.

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

- highest_is_best:

  single logical, specifies whether larger estimates of the outcome are
  favourable or not; defaults to `FALSE`, corresponding to, e.g., an
  undesirable binary outcomes (e.g., mortality) or a continuous outcome
  where lower numbers are preferred (e.g., hospital length of stay).

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

- soften_power:

  either a single numeric value or a numeric vector of exactly the same
  length as the maximum number of looks/adaptive analyses. Values must
  be between `0` and `1` (default); if `< 1`, then re-allocated
  non-fixed allocation probabilities are all raised to this power
  (followed by rescaling to sum to `1`) to make adaptive allocation
  probabilities less extreme, in turn used to redistribute remaining
  probability while respecting limits when defined by `min_probs` and/or
  `max_probs`. If `1`, then no *softening* is applied.

- fun_raw_est:

  function that takes a numeric vector and returns a single numeric
  value, used to calculate a raw summary estimate of the outcomes in
  each `arm`. Defaults to [`mean()`](https://rdrr.io/r/base/mean.html),
  which is always used in the
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  and
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)
  functions.  
  **Note:** the function is called one time per arm during setup to
  validate the output structure.

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

  optional single character string describing the trial design, will
  only be used in print functions if not `NULL` (the default).

- add_info:

  optional single string containing additional information regarding the
  trial design or specifications, will only be used in print functions
  if not `NULL` (the default).

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

## Details

**How to specify the `fun_y_gen` function**

The function must take the following arguments:

- `allocs`: character vector, the trial `arms` that new participants
  allocated since the last adaptive analysis are randomised to.

The function must return a single numeric vector, corresponding to the
outcomes for all participants allocated since the last adaptive
analysis, in the same order as `allocs`.  
See the **Advanced example** vignette
([`vignette("Advanced-example", package = "adaptr")`](https://inceptdk.github.io/adaptr/articles/Advanced-example.md))
for an example with further details.

**How to specify the `fun_draws` function**

The function must take the following arguments:

- `arms`: character vector, the unique trial `arms`, in the same order
  as above, but only the **currently active** arms are included when the
  function is called.

- `allocs`: a vector of allocations for all participants, corresponding
  to the trial `arms`, including participants allocated to both
  **currently active AND inactive** `arms` when called.

- `ys`: a vector of outcomes for all participants in the same order as
  `allocs`, including outcomes for participants allocated to both
  **currently active AND inactive** `arms` when called.

- `control`: single character, the current `control` arm, will be `NULL`
  for designs without a common control arm, but required regardless as
  the argument is supplied by
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)/[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md).

- `n_draws`: single integer, the number of posterior draws for each arm.

The function must return a `matrix` (containing numeric values) with
`arms` named columns and `n_draws` rows. The `matrix` must have columns
**only for currently active arms** (when called). Each row should
contain a single posterior draw for each arm on the original outcome
scale: if they are estimated as, e.g., the *log(odds)*, these estimates
must be transformed to probabilities and similarly for other measures.  
Important: the `matrix` cannot contain `NA`s, even if no participants
have been randomised to an arm yet. See the provided example for one way
to alleviate this.  
See the **Advanced examples** vignette
([`vignette("Advanced-example", package = "adaptr")`](https://inceptdk.github.io/adaptr/articles/Advanced-example.md))
for an example with further details.

*Notes*

- Different estimation methods and prior distributions may be used;
  complex functions will lead to slower simulations compared to simpler
  methods for obtaining posterior draws, including those specified using
  the
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  and
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)
  functions.

- Technically, using log relative effect measures — e.g. log(odds
  ratios) or log(risk ratios) - or differences compared to a reference
  arm (e.g., mean differences or absolute risk differences) instead of
  absolute values in each arm will work to some extent (**be
  cautious!**):

- Stopping for superiority/inferiority/max sample sizes will work.

- Stopping for equivalence/futility may be used with relative effect
  measures on the log scale, but thresholds have to be adjusted
  accordingly.

- Several summary statistics from
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)
  (`sum_ys` and posterior estimates) may be nonsensical if relative
  effect measures are used (depending on calculation method; see the
  `raw_ests` argument in the relevant functions).

- In the same vein,
  [`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md)
  (`sum_ys`, `sq_err`, and `sq_err_te`), and
  [`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md)
  (`sum_ys_mean/sd/median/q25/q75/q0/q100`, `rmse`, and `rmse_te`) may
  be equally nonsensical when calculated on the relative scale (see the
  `raw_ests` argument in the relevant functions.

**Using additional custom or functions from loaded packages in the
custom functions**

If the `fun_y_gen`, `fun_draws`, or `fun_raw_est` functions calls other
user-specified functions (or uses objects defined by the user outside
these functions or the `setup_trial()`-call) or functions from external
packages and simulations are conducted on multiple cores, these objects
or functions must be prefixed with their namespaces (i.e.,
`package::function()`) or exported, as described in
[`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md)
and
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md).

**More information on arguments**

- `control`: if one or more treatment arms are superior to the control
  arm (i.e., passes the superiority threshold as defined above), this
  arm will become the new control (if multiple arms are superior, the
  one with the highest probability of being the overall best will become
  the new control), the previous control will be dropped for
  inferiority, and all remaining arms will be immediately compared to
  the new control in the same adaptive analysis and dropped if inferior
  (or possibly equivalent/futile, see below) compared to this new
  control arm. Only applies in trials with a common `control`.

- `control_prob_fixed`: If the length is 1, then this allocation
  probability will be used for the `control` group (including if a new
  arm becomes the control and the original control is dropped). If
  multiple values are specified the first value will be used when all
  arms are active, the second when one arm has been dropped, and so
  forth. If 1 or more values are specified, previously set
  `fixed_probs`, `min_probs` or `max_probs` for new control arms will be
  ignored. If all allocation probabilities do not sum to 1 (e.g, due to
  multiple limits) they will be rescaled to do so.  
  Can also be set to one of the special arguments `"sqrt-based"`,
  `"sqrt-based start"`, `"sqrt-based fixed"` or `"match"` (written
  exactly as one of those, case sensitive). This requires `start_probs`
  to be `NULL` and relevant `fixed_probs` to be `NULL` (or `NA` for the
  control arm).  
  If one of the `"sqrt-based"/"sqrt-based start"/"sqrt-based fixed"`
  options are used, the function will set
  *square-root-transformation-based* starting allocation probabilities.
  These are as `1` for all non-control arms and
  `sqrt(<number of non-control arms>)` for the common `control` arm,
  scaled to sum to 1. This will generally increase power for comparisons
  against the common `control`, as discussed in, e.g., *Park et al,
  2020*
  [doi:10.1016/j.jclinepi.2020.04.025](https://doi.org/10.1016/j.jclinepi.2020.04.025)
  .  
  If `"sqrt-based"` or `"sqrt-based fixed"`,
  square-root-transformation-based allocation probabilities will be used
  initially and also for new controls when arms are dropped (with
  probabilities always calculated based on the number of active
  non-control arms). If `"sqrt-based"`, response-adaptive randomisation
  will be used for non-control arms, while the non-control arms will use
  fixed, square-root based allocation probabilities at all times (with
  probabilities always calculated based on the number of active
  non-control arms). If `"sqrt-based start"`, the control arm allocation
  probability will be fixed to a square-root based probability at all
  times calculated according to the initial number of arms (with this
  probability also being used for new control(s) when the original
  control is dropped; this may be rescaled using the `rescale`
  argument).  
  If `"match"` is specified, the control group allocation probability
  will always be *matched* to be similar to the highest non-control arm
  allocation probability, followed by scaling to sum allocation
  probabilities to 1.

**Superiority and inferiority**

In trial designs without a common control arm, superiority and
inferiority are assessed by comparing all ***currently active*** groups.
This means that if a "final" analysis of a trial without a common
control and `> 2 arms` is conducted including all arms (as will often be
done in practice) *after* an adaptive trial has stopped, the final
probabilities of the best arm being superior may differ slightly.  
For example, in a trial with three arms and no common `control` arm, one
arm may be dropped early for inferiority defined as `< 1%` probability
of being the overall best `arm`. The trial may then continue with the
two remaining arms, and stopped when one is declared superior to the
other defined as `> 99%` probability of being the overall best `arm`. If
a final analysis is then conducted including all arms, the final
probability of the best arm being overall superior will generally be
slightly lower as the probability of the first dropped arm being the
best will often be `> 0%`, even if very low and below the inferiority
threshold.  
This is less relevant trial designs *with* a common `control`, as
pairwise assessments of superiority/inferiority compared to the common
`control` will not be influenced similarly by previously dropped arms
(and previously dropped arms may be included in the analyses, even if
posterior distributions are not returned for those). Similarly, in
actual clinical trials and when `randomised_at_looks` is specified with
numbers higher than the number of participants with available outcome
data at each analysis, final probabilities may change somewhat when all
participants have completed follow-up and are included in a final
analysis.

**Equivalence**

Equivalence is assessed ***after*** both inferiority and superiority
have been assessed (and in case of superiority, it will be assessed
against the new `control` arm in designs with a common `control`, if
specified - see above).

**Futility**

Futility is assessed ***after*** inferiority, superiority, ***and***
equivalence have been assessed (and in case of superiority, it will be
assessed against the new control arm in designs with a common control,
if specified - see above). Arms will thus be dropped for equivalence
before futility.

**Varying probability thresholds**

Different probability thresholds (for superiority, inferiority,
equivalence, and futility) may be specified for different adaptive
analyses. This may be used, e.g., to apply more strict probability
thresholds at earlier analyses (or make one or more stopping rules not
apply at earlier analyses), similar to the use of monitoring boundaries
with different thresholds used for interim analyses in conventional,
frequentist group sequential trial designs. See the **Basic examples**
vignette
([`vignette("Basic-examples", package = "adaptr")`](https://inceptdk.github.io/adaptr/articles/Basic-examples.md))
for an example.

## Examples

``` r
# Setup a custom trial specification with right-skewed, log-normally
# distributed continuous outcomes (higher values are worse)

# Define the function that will generate the outcomes in each arm
# Notice: contents should match arms/true_ys in the setup_trial() call below
get_ys_lognorm <- function(allocs) {
  y <- numeric(length(allocs))
  # arms (names and order) and values (except for exponentiation) should match
  # those used in setup_trial (below)
  means <- c("Control" = 2.2, "Experimental A" = 2.1, "Experimental B" = 2.3)
  for (arm in names(means)) {
    ii <- which(allocs == arm)
    y[ii] <- rlnorm(length(ii), means[arm], 1.5)
  }
  y
}

# Define the function that will generate posterior draws
# In this example, the function uses no priors (corresponding to improper
# flat priors) and calculates results on the log-scale, before exponentiating
# back to the natural scale, which is required for assessments of
# equivalence, futility and general interpretation
get_draws_lognorm <- function(arms, allocs, ys, control, n_draws) {
  draws <- list()
  logys <- log(ys)
  for (arm in arms){
    ii <- which(allocs == arm)
    n <- length(ii)
    if (n > 1) {
      # Necessary to avoid errors if too few participants randomised to this arm
      draws[[arm]] <- exp(rnorm(n_draws, mean = mean(logys[ii]), sd = sd(logys[ii])/sqrt(n - 1)))
    } else {
      # Too few participants randomised to this arm - extreme uncertainty
      draws[[arm]] <- exp(rnorm(n_draws, mean = mean(logys), sd = 1000 * (max(logys) - min(logys))))
    }
  }
  do.call(cbind, draws)
}

# The actual trial specification is then defined
lognorm_trial <- setup_trial(
  # arms should match those above
  arms = c("Control", "Experimental A", "Experimental B"),
  # true_ys should match those above
  true_ys = exp(c(2.2, 2.1, 2.3)),
  fun_y_gen = get_ys_lognorm, # as specified above
  fun_draws = get_draws_lognorm, # as specified above
  max_n = 5000,
  look_after_every = 200,
  control = "Control",
  # Square-root-based, fixed control group allocation ratio
  # and response-adaptive randomisation for other arms
  control_prob_fixed = "sqrt-based",
  # Equivalence assessment
  equivalence_prob = 0.9,
  equivalence_diff = 0.5,
  equivalence_only_first = TRUE,
  highest_is_best = FALSE,
  # Summarise raw results by taking the mean on the
  # log scale and back-transforming
  fun_raw_est = function(x) exp(mean(log(x))) ,
  # Summarise posteriors using medians with MAD-SDs,
  # as distributions will not be normal on the actual scale
  robust = TRUE,
  # Description/additional info used when printing
  description = "continuous, log-normally distributed outcome",
  add_info = "SD on the log scale for all arms: 1.5"
)

# Print trial specification with 3 digits for all probabilities
print(lognorm_trial, prob_digits = 3)
#> Trial specification: continuous, log-normally distributed outcome
#> * Undesirable outcome
#> * Common control arm: Control 
#> * Control arm probability fixed at 0.414 (for 3 arms), 0.5 (for 2 arms)
#> * Best arm: Experimental A
#> 
#> Arms, true outcomes, starting allocation probabilities 
#> and allocation probability limits (fixed/min/max_probs not rescaled):
#>            arms true_ys start_probs fixed_probs min_probs max_probs
#>         Control    9.03       0.414       0.414        NA        NA
#>  Experimental A    8.17       0.293          NA        NA        NA
#>  Experimental B    9.97       0.293          NA        NA        NA
#> 
#> Maximum sample size: 5000 
#> Maximum number of data looks: 25
#> Planned looks after every 200
#>  participants have reached follow-up until final look after 5000 participants
#> Number of participants randomised at each look:  200, 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 3600, 3800, 4000, 4200, 4400, 4600, 4800, 5000
#> 
#> Superiority threshold: 0.99 (all analyses)
#> Inferiority threshold: 0.01 (all analyses)
#> Equivalence threshold: 0.9 (all analyses) (only checked for first control)
#> Absolute equivalence difference: 0.5
#> No futility threshold
#> Adaptation rule probability thresholds not rescaled when arms are dropped (not relevant - common control used)
#> Soften power for all analyses: 1 (no softening)
#> 
#> Additional info: SD on the log scale for all arms: 1.5
```
