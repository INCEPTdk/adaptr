# Simulate a single trial

This function conducts a single trial simulation using a trial
specification as specified by
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
[`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
or
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md).  
During simulation, the function randomises "participants", randomly
generates outcomes, calculates the probabilities that each `arm` is the
best (and better than the control, if any). This is followed by checking
inferiority, superiority, equivalence and/or futility as desired;
dropping arms, and re-adjusting allocation probabilities according to
the criteria specified in the trial specification. If there is no common
`control` arm, the trial simulation will be stopped at the final
specified adaptive analysis, when 1 arm is superior to the others, or
when all arms are considered equivalent (if equivalence is assessed). If
a common `control` arm is specified, all other arms will be compared to
that, and if 1 of these pairwise comparisons crosses the applicable
superiority threshold at an adaptive analysis, that arm will become the
new control and the old control will be considered inferior and dropped.
If multiple non-control arms cross the applicable superiority threshold
in the same adaptive analysis, the one with the highest probability of
being the overall best will become the new control. Equivalence/futility
will also be checked if specified, and equivalent or futile arms will be
dropped in designs with a common `control` arm and the entire trial will
be stopped if all remaining arms are equivalent in designs without a
common `control` arm. The trial simulation will be stopped when only 1
arm is left, when the final arms are all equivalent, or after the final
specified adaptive analysis.  
After stopping (regardless of reason), a final analysis including
outcome data from all participants randomised to all arms will be
conducted (with the final `control` arm, if any, used as the `control`
in this analysis). Results from this analysis will be saved, but not
used with regards to the adaptive stopping rules. This is particularly
relevant if less participants have available outcome data at the last
adaptive analyses than the total number of participants randomised (as
specified in
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
[`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md),
or
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)),
as the final analysis will then include all participants randomised,
which may be more than in the last adaptive analysis conducted.

## Usage

``` r
run_trial(trial_spec, seed = NULL, sparse = FALSE)
```

## Arguments

- trial_spec:

  `trial_spec` object, generated and validated by the
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  or
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)
  function.

- seed:

  single integer or `NULL` (default). If a value is provided, this value
  will be used as the random seed when running and the global random
  seed will be restored after the function has run, so it is not
  affected.

- sparse:

  single logical; if `FALSE` (default) everything listed below is
  included in the returned object. If `TRUE`, only a limited amount of
  data are included in the returned object. This can be practical when
  running many simulations and saving the results using the
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
  function (which relies on this function), as the output file will thus
  be substantially smaller. However, printing of individual trial
  results will be substantially less detailed for sparse results and
  non-sparse results are required by
  [`plot_history()`](https://inceptdk.github.io/adaptr/reference/plot_history.md).

## Value

A `trial_result` object containing everything listed below if `sparse`
(as described above) is `FALSE`. Otherwise only `final_status`,
`final_n`, `followed_n`, `trial_res`, `seed`, and `sparse` are included.

- `final_status`: either `"superiority"`, `"equivalence"`, `"futility"`,
  or `"max"` (stopped at the last possible adaptive analysis), as
  calculated during the adaptive analyses.

- `final_n`: the total number of participants randomised.

- `followed_n`: the total number of participants with available outcome
  data at the last adaptive analysis conducted.

- `max_n`: the pre-specified maximum number of participants with outcome
  data available at the last possible adaptive analysis.

- `max_randomised`: the pre-specified maximum number of participants
  randomised at the last possible adaptive analysis.

- `looks`: numeric vector, the total number of participants with outcome
  data available at each conducted adaptive analysis.

- `planned_looks`: numeric vector, the cumulated number of participants
  planned to have outcome data available at each adaptive analysis, even
  those not conducted if the simulation is stopped before the final
  possible analysis.

- `randomised_at_looks`: numeric vector, the cumulated number of
  participants randomised at each conducted adaptive analysis (only
  including the relevant numbers for the analyses actually conducted).

- `start_control`: character, initial common `control` arm (if
  specified).

- `final_control`: character, final common `control` arm (if relevant).

- `control_prob_fixed`: fixed common `control` arm probabilities (if
  specified; see
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)).

- `inferiority`, `superiority`, `equivalence_prob`, `equivalence_diff`,
  `equivalence_only_first`, `futility_prob`, `futility_diff`,
  `futility_only_first`, `highest_is_best`, and `soften_power`: as
  specified in
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md).

- `rescale_adapt_probs`: as specified in
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md).

- `best_arm`: the best `arm`(s), as described in
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md).

- `trial_res`: a `data.frame` containing most of the information
  specified for each arm in
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
  including `true_ys` (true outcomes as specified in
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md))
  and for each arm the sum of the outcomes (`sum_ys`/`sum_ys_all`; i.e.,
  the total number of events for binary outcomes or the totals of
  continuous outcomes) and sum of participants (`ns`/`ns_all`), summary
  statistics for the raw outcome data (`raw_ests`/`raw_ests_all`,
  calculated as specified in
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
  defaults to mean values, i.e., event rates for binary outcomes or
  means for continuous outcomes) and posterior estimates
  (`post_ests`/`post_ests_all`, `post_errs`/`post_errs_all`,
  `lo_cri`/`lo_cri_all`, and `hi_cri`/`hi_cri_all`, calculated as
  specified in
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)),
  `final_status` of each arm (`"inferior"`, `"superior"`,
  `"equivalence"`, `"futile"`, `"active"`, or `"control"` (currently
  active control arm, including if the current control when stopped for
  equivalence)), `status_look` (specifying the cumulated number of
  participants with outcome data available when an adaptive analysis
  changed the `final_status` to `"superior"`, `"inferior"`,
  `"equivalence"`, or `"futile"`), `status_probs`, the probability (in
  the last adaptive analysis for each arm) that each arm was the
  best/better than the common control arm (if any)/equivalent to the
  common control arm (if any and stopped for equivalence; `NA` if the
  control arm was stopped due to the last remaining other arm(s) being
  stopped for equivalence)/futile if stopped for futility at the last
  analysis it was included in, `final_alloc`, the final allocation
  probability for each arm the last time participants were randomised to
  it, including for arms stopped at the maximum sample size, and
  `probs_best_last`, the probabilities of each remaining arm being the
  overall best in the last conducted adaptive analysis (`NA` for
  previously dropped arms).  
  **Note:** for the variables in the `data.frame` where a version
  including the `_all`-suffix is included, the versions WITHOUT this
  suffix are calculated using participants with available outcome data
  at the time of analysis, while the versions WITH the `_all`-suffixes
  are calculated using outcome data for all participants randomised at
  the time of analysis, even if they have not reached the time of
  follow-up yet (see
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)).

- `rescale_probs`: as specified in
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md).

- `all_looks`: a list of lists containing one list per conducted trial
  look (adaptive analysis). These lists contain the variables `arms`,
  `old_status` (status before the analysis of the current round was
  conducted), `new_status` (as specified above, status after current
  analysis has been conducted), `sum_ys`/`sum_ys_all` (as described
  above), `ns`/`ns_all` (as described above), `old_alloc` (the
  allocation probability used during this look), `probs_best` (the
  probabilities of each arm being the best in the current adaptive
  analysis), `new_alloc` (the allocation probabilities after updating
  these in the current adaptive analysis; NA for all arms when the trial
  is stopped and no further adaptive analyses will be conducted),
  `probs_better_first` (if a common control is provided, specifying the
  probabilities that each arm was better than the control in the first
  analysis conducted during that look), `probs_better` (as
  `probs_better_first`, but updated if another arm becomes the new
  control), `probs_equivalence_first` and `probs_equivalence` (as for
  `probs_better`/`probs_better_first`, but for equivalence if
  equivalence is assessed). The last variables are `NA` if the arm was
  not active in the applicable adaptive analysis or if they would not be
  included during the next adaptive analysis.

- `allocs`: a character vector containing the allocations of all
  participants in the order of randomization.

- `ys`: a numeric vector containing the outcomes of all participants in
  the order of randomization (`0` or `1` for binary outcomes).

- `seed`: the random seed used, if specified.

- `description`, `add_info`, `cri_width`, `n_draws`, `robust`: as
  specified in
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  or
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md).

- `sparse`: single logical, corresponding to the `sparse` input.

## Examples

``` r
# Setup a trial specification
binom_trial <- setup_trial_binom(arms = c("A", "B", "C", "D"),
                                 true_ys = c(0.20, 0.18, 0.22, 0.24),
                                 data_looks = 1:20 * 100)

# Run trial with a specified random seed
res <- run_trial(binom_trial, seed = 12345)

# Print results with 3 decimals
print(res, digits = 3)
#> Single simulation result: generic binomially distributed outcome trial
#> * Undesirable outcome
#> * No common control arm
#> 
#> Final status: inconclusive, stopped at final allowed adaptive analysis
#> Final/maximum allowed sample sizes: 2000/2000 (100.0%)
#> Available outcome data at last adaptive analysis: 2000/2000 (100.0%)
#> 
#> Trial results overview:
#>  arms true_ys final_status status_look status_probs final_alloc
#>     A    0.20       active          NA           NA      0.0232
#>     B    0.18       active          NA           NA      0.8868
#>     C    0.22       active          NA           NA      0.0900
#>     D    0.24     inferior         300       0.0092      0.1078
#> 
#> Estimates from final analysis (all participants):
#>  arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
#>     A         39    161        0.242         0.244       0.03355      0.184
#>     B        297   1613        0.184         0.184       0.00987      0.165
#>     C         39    180        0.217         0.218       0.03032      0.162
#>     D         16     46        0.348         0.351       0.06806      0.224
#>  hi_cri_all
#>       0.316
#>       0.204
#>       0.279
#>       0.495
#> 
#> Estimates from last adaptive analysis including each arm:
#>  arms sum_ys   ns raw_ests post_ests post_errs lo_cri hi_cri
#>     A     39  161    0.242     0.244   0.03461  0.180  0.315
#>     B    297 1613    0.184     0.184   0.00938  0.166  0.204
#>     C     39  180    0.217     0.219   0.03105  0.164  0.283
#>     D     16   46    0.348     0.353   0.06967  0.226  0.492
#> 
#> Simulation details:
#> * Random seed: 12345
#> * Credible interval width: 95%
#> * Number of posterior draws: 5000
#> * Posterior estimation method: medians with MAD-SDs
```
