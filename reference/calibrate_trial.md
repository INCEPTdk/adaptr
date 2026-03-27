# Calibrate trial specification

This function calibrates a trial specification using a Gaussian
process-based Bayesian optimisation algorithm. The function calibrates
an input trial specification object (using repeated calls to
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
while adjusting the trial specification) to a `target` value within a
`search_range` in a single input dimension (`x`) in order to find an
optimal value (`y`).  
The default (and expectedly most common use case) is to calibrate a
trial specification to adjust the `superiority` and `inferiority`
thresholds to obtain a certain probability of superiority; if used with
a trial specification with identical underlying outcomes (no between-arm
differences), this probability is an estimate of the Bayesian analogue
of the total type-1 error rate for the outcome driving the adaptations,
and if between-arm differences are present, this corresponds to an
estimate of the Bayesian analogue of the power.  
The default is to perform the calibration while varying single,
constant, symmetric thresholds for `superiority` / `inferiority`
throughout a trial design, as described in **Details**, and the default
values have been chosen to function well in this case.  
Advanced users may use the function to calibrate trial specifications
according to other metrics - see **Details** for how to specify a custom
function used to modify (or recreate) a trial specification object
during the calibration process.  
The underlying Gaussian process model and its control hyperparameters
are described under **Details**, and the model is partially based on
code from Gramacy 2020 (with permission; see **References**).

## Usage

``` r
calibrate_trial(
  trial_spec,
  n_rep = 1000,
  cores = NULL,
  base_seed = NULL,
  fun = NULL,
  target = 0.05,
  search_range = c(0.9, 1),
  tol = target/10,
  dir = 0,
  init_n = 2,
  iter_max = 25,
  resolution = 5000,
  kappa = 0.5,
  pow = 1.95,
  lengthscale = 1,
  scale_x = TRUE,
  noisy = is.null(base_seed),
  narrow = !noisy & !is.null(base_seed),
  prev_x = NULL,
  prev_y = NULL,
  path = NULL,
  overwrite = FALSE,
  version = NULL,
  compress = TRUE,
  sparse = TRUE,
  progress = NULL,
  export = NULL,
  export_envir = parent.frame(),
  verbose = FALSE,
  plot = FALSE
)
```

## Arguments

- trial_spec:

  `trial_spec` object, generated and validated by the
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  or
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)
  function.

- n_rep:

  single integer, the number of simulations to run at each evaluation.
  Values `< 100` are not permitted; values `< 1000` are permitted but
  recommended against.

- cores:

  `NULL` or single integer. If `NULL`, a default value/cluster set by
  [`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md)
  will be used to control whether simulations are run in parallel on a
  default cluster or sequentially in the main process; if a
  cluster/value has not been specified by
  [`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md),
  `cores` will then be set to the value stored in the global
  `"mc.cores"` option (if previously set by
  `options(mc.cores = <number of cores>`), and `1` if that option has
  not been specified.  
  If the resulting number of `cores = 1`, computations will be run
  sequentially in the primary process, and if `cores > 1`, a new
  parallel cluster will be setup using the `parallel` library and
  removed once the function completes. See
  [`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md)
  for details.

- base_seed:

  single integer or `NULL` (default); the random seed used as the basis
  for all simulation runs (see
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md))
  and random number generation within the rest of the calibration
  process; if used, the global random seed will be restored after the
  function has been run.  
  **Note:** providing a `base_seed` is highly recommended, as this will
  generally lead to faster and more stable calibration.

- fun:

  `NULL` (the default), in which case the trial specification will be
  calibrated using the default process described above and further in
  **Details**; otherwise a user-supplied function used during the
  calibration process, which should have a structure as described in
  **Details**.

- target:

  single finite numeric value (defaults to `0.05`); the target value for
  `y` to calibrate the `trial_spec` object to.

- search_range:

  finite numeric vector of length `2`; the lower and upper boundaries in
  which to search for the best `x`. Defaults to `c(0.9, 1.0)`.

- tol:

  single finite numeric value (defaults to `target / 10`); the accepted
  tolerance (in the direction(s) specified by `dir`) accepted; when a
  `y`-value within the accepted tolerance of the target is obtained, the
  calibration stops.  
  **Note:** `tol` should be specified to be sensible considering
  `n_rep`; e.g., if the probability of superiority is targeted with
  `n_rep == 1000`, a `tol` of `0.01` will correspond to `10` simulated
  trials.  
  A too low `tol` relative to `n_rep` may lead to very slow calibration
  or calibration that cannot succeed regardless of the number of
  iterations.  
  **Important:** even when a large number of simulations are conducted,
  using a very low `tol` may lead to calibration not succeeding as it
  may also be affected by other factors, e.g., the total number of
  simulated participants, the possible maximum differences in simulated
  outcomes, and the number of posterior draws (`n_draws` in the
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
  family of functions), which affects the minimum differences in
  posterior probabilities when simulating trials and thus can affect
  calibration, including when using the default calibration function.
  Increasing the number of posterior draws or the number of repetitions
  should be attempted if the desired tolerance cannot be achieved with
  lower numbers.

- dir:

  single numeric value; specifies the direction(s) of the tolerance
  range. If `0` (the default) the tolerance range will be `target - tol`
  to `target + tol`. If `< 0`, the range will be `target - tol` to
  `target`, and if `> 0`, the range will be `target` to `target + tol`.

- init_n:

  single integer `>= 2`. The number of initial evaluations evenly spread
  over the `search_range`, with one evaluation at each boundary (thus,
  the default value of `2` is the minimum permitted value; if
  calibrating according to a different target than the default, a higher
  value may be sensible).

- iter_max:

  single integer `> 0` (default `25`). The maximum number of new
  evaluations after the initial grid (with size specified by `init_n`)
  has been set up. If calibration is unsuccessful after the maximum
  number of iterations, the `prev_x` and `prev_y` arguments (described
  below) may be used to to start a new calibration process re-using
  previous evaluations.

- resolution:

  single integer (defaults to `5000`), size of the grid at which the
  predictions used to select the next value to evaluate at are made.  
  **Note:** memory use will substantially increase with higher values.
  See also the `narrow` argument below.

- kappa:

  single numeric value `> 0` (default `0.5`); corresponding to the width
  of the uncertainty bounds used to find the next target to evaluate.
  See **Details**.

- pow:

  single numerical value in the `[1, 2]` range (default `1.95`),
  controlling the smoothness of the Gaussian process. See **Details**.

- lengthscale:

  single numerical value (defaults to `1`) or numerical vector of length
  `2`; values must be finite and non-negative. If a single value is
  provided, this will be used as the `lengthscale` hyperparameter; if a
  numerical vector of length `2` is provided, the second value must be
  higher than the first and the optimal `lengthscale` in this range will
  be found using an optimisation algorithm. If any value is `0`, a small
  amount of noise will be added as lengthscales must be `> 0`. Controls
  smoothness in combination with `pow`. See **Details**.

- scale_x:

  single logical value; if `TRUE` (the default) the `x`-values will be
  scaled to the `[0, 1]` range according to the minimum/maximum values
  provided. If `FALSE`, the model will use the original scale. If
  distances on the original scale are small, scaling may be preferred.
  The returned values will always be on the original scale. See
  **Details**.

- noisy:

  single logical value; if `FALSE`, a noiseless process is assumed, and
  interpolation between values is performed (i.e., with no uncertainty
  at the `x`-values assumed). If `TRUE`, the `y`-values are assumed to
  come from a noisy process, and regression is performed (i.e., some
  uncertainty at the evaluated `x`-values will be assumed and included
  in the predictions). Specifying `FALSE` requires a `base_seed`
  supplied, and is generally recommended, as this will usually lead to
  faster and more stable calibration. If a low `n_rep` is used (or if
  trials are calibrated to other metrics other than the default),
  specifying `TRUE` may be necessary even when using a valid
  `base_seed`. Defaults to `TRUE` if a `base_seed` is supplied and
  `FALSE` if not.

- narrow:

  single logical value. If `FALSE`, predictions are evenly spread over
  the full `x`-range. If `TRUE`, the prediction grid will be spread
  evenly over an interval consisting of the two `x`-values with
  corresponding `y`-values closest to the target in opposite directions.
  Can only be `TRUE` when a `base_seed` is provided and `noisy` is
  `FALSE` (the default value is `TRUE` in that case, otherwise it is
  `FALSE`), and only if the function can safely be assumed to be only
  monotonically increasing or decreasing (which is generally reasonable
  if the default is used for `fun`), in which case this will lead to a
  faster search and a smoother prediction grid in the relevant region
  without increasing memory use.

- prev_x, prev_y:

  numeric vectors of equal lengths, corresponding to previous
  evaluations. If provided, these will be used in the calibration
  process (added before the initial grid is setup, with values in the
  grid matching values in `prev_x` leading to those evaluations being
  skipped).

- path:

  single character string or `NULL` (the default); if a valid file path
  is provided, the calibration results will either be saved to this path
  (if the file does not exist or if `overwrite` is `TRUE`, see below) or
  the previous results will be loaded and returned (if the file exists,
  `overwrite` is `FALSE`, and if the input `trial_spec` and central
  control settings are identical to the previous run, otherwise an error
  is produced). Results are saved/loaded using the
  [`saveRDS()`](https://rdrr.io/r/base/readRDS.html) /
  [`readRDS()`](https://rdrr.io/r/base/readRDS.html) functions.

- overwrite:

  single logical, defaults to `FALSE`, in which case previous results
  are loaded if a valid file path is provided in `path` and the object
  in `path` contains the same input `trial_spec` and the previous
  calibration used the same central control settings (otherwise, the
  function errors). If `TRUE` and a valid file path is provided in
  `path`, the complete calibration function will be run with results
  saved using [`saveRDS()`](https://rdrr.io/r/base/readRDS.html),
  regardless of whether or not a previous result was saved in `path`.

- version:

  passed to [`saveRDS()`](https://rdrr.io/r/base/readRDS.html) when
  saving calibration results, defaults to `NULL` (as in
  [`saveRDS()`](https://rdrr.io/r/base/readRDS.html)), which means that
  the current default version is used. Ignored if calibration results
  are not saved.

- compress:

  passed to [`saveRDS()`](https://rdrr.io/r/base/readRDS.html) when
  saving calibration results, defaults to `TRUE` (as in
  [`saveRDS()`](https://rdrr.io/r/base/readRDS.html)), see
  [`saveRDS()`](https://rdrr.io/r/base/readRDS.html) for other options.
  Ignored if calibration results are not saved.

- sparse, progress, export, export_envir:

  passed to
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md),
  see description there.

- verbose:

  single logical, defaults to `FALSE`. If `TRUE`, the function will
  print details on calibration progress.

- plot:

  single logical, defaults to `FALSE`. If `TRUE`, the function will
  print plots of the Gaussian process model predictions and return them
  as part of the final object; requires the `ggplot2` package installed.

## Value

A list of special class `"trial_calibration"`, which contains the
following elements that can be extracted using `$` or `[[`:

- `success`: single logical, `TRUE` if the calibration succeeded with
  the best result being within the tolerance range, `FALSE` if the
  calibration process ended after all allowed iterations without
  obtaining a result within the tolerance range.

- `best_x`: single numerical value, the `x`-value (on the original,
  input scale) at which the best `y`-value was found, regardless of
  `success`.

- `best_y`: single numerical value, the best `y`-value obtained,
  regardless of `success`.

- `best_trial_spec`: the best calibrated version of the original
  `trial_spec` object supplied, regardless of `success` (i.e., the
  returned trial specification object is only adequately calibrated if
  `success` is `TRUE`).

- `best_sims`: the trial simulation results (from
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md))
  leading to the best `y`-value, regardless of `success`. If no new
  simulations have been conducted (e.g., if the best `y`-value is from
  one of the `prev_y`-values), this will be `NULL`.

- `evaluations`: a two-column `data.frame` containing the variables `x`
  and `y`, corresponding to all `x`-values and `y`-values (including
  values supplied through `prev_x`/`prev_y`).

- `input_trial_spec`: the unaltered, uncalibrated, original
  `trial_spec`-object provided to the function.

- `elapsed_time`: the total run time of the calibration process.

- `control`: list of the most central settings provided to the function.

- `fun`: the function used for calibration; if `NULL` was supplied when
  starting the calibration, the default function (described in
  **Details**) is returned after being used in the function.

- `adaptr_version`: the version of the `adaptr` package used to run the
  calibration process.

- `plots`: list containing `ggplot2` plot objects of each Gaussian
  process suggestion step, only included if `plot` is `TRUE`.

## Details

**Default calibration**  
  
If `fun` is `NULL` (as default), the default calibration strategy will
be employed. Here, the target `y` is the probability of superiority (as
described in
[`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md)
and
[`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md)),
and the function will calibrate constant stopping thresholds for
superiority and inferiority (as described in
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
[`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md),
and
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)),
which corresponds to the Bayesian analogues of the type 1 error rate if
there are no differences between arms in the trial specification, which
we expect to be the most common use case, or the power, if there are
differences between arms in the trial specification.  

The stopping calibration process will, in the default case, use the
input `x` as the stopping threshold for superiority and `1 - x` as the
stopping threshold for inferiority, respectively, i.e., stopping
thresholds will be constant and symmetric.  

The underlying default function calibrated is typically essentially
noiseless if a high enough number of simulations are used with an
appropriate random `base_seed`, and generally monotonically decreasing.
The default values for the control hyperparameters have been set to
normally work well in this case (including `init_n`, `kappa`, `pow`,
`lengthscale`, `narrow`, `scale_x`, etc.). Thus, few initial grid
evaluations are used in this case, and if a `base_seed` is provided, a
noiseless process is assumed and narrowing of the search range with each
iteration is performed, and the uncertainty bounds used in the
acquisition function (corresponding to quantiles from the posterior
predictive distribution) are relatively narrow.

**Specifying calibration functions**  
  
A user-specified calibration function should have the following
structure:

    # The function must take the arguments x and trial_spec
    # trial_spec is the original trial_spec object which should be modified
    # (alternatively, it may be re-specified, but the argument should still
    # be included, even if ignored)
    function(x, trial_spec) {
      # Calibrate trial_spec, here as in the default function
      trial_spec$superiority <- x
      trial_spec$inferiority <- 1 - x

      # If relevant, known y values corresponding to specific x values may be
      # returned without running simulations (here done as in the default
      # function). In that case, a code block line the one below can be included,
      # with changed x/y values - of note, the other return values should not be
      # changed
      if (x == 1) {
        return(list(sims = NULL, trial_spec = trial_spec, y = 0))
      }

      # Run simulations - this block should be included unchanged
      sims <- run_trials(trial_spec, n_rep = n_rep, cores = cores,
                         base_seed = base_seed, sparse = sparse,
                         progress = progress, export = export,
                         export_envir = export_envir)

     # Return results - only the y value here should be changed
     # summary() or check_performance() will often be used here
     list(sims = sims, trial_spec = trial_spec,
          y = summary(sims)$prob_superior)
    }

**Note:** changes to the trial specification are **not validated**;
users who define their own calibration function need to ensure that
changes to calibrated trial specifications does not lead to invalid
values; otherwise, the procedure is prone to error when simulations are
run. Especially, users should be aware that changing `true_ys` in a
trial specification generated using the simplified
[`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
and
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)
functions requires changes in multiple places in the object, including
in the functions used to generate random outcomes, and in these cases
(and otherwise if in doubt) re-generating the `trial_spec` instead of
modifying should be preferred as this is safer and leads to proper
validation.

**Note:** if the `y` values corresponding to certain `x` values are
known, then the user may directly return these values without running
simulations (e.g., in the default case an `x` of `1` will require
`>100%` or `<0%` probabilities for stopping rules, which is impossible,
and hence the `y` value in this case is by definition `1`).

**Gaussian process optimisation function and control hyperparameters**  
  
The calibration function uses a relatively simple Gaussian optimisation
function with settings that should work well for the default calibration
function, but can be changed as required, which should be considered if
calibrating according to other targets (effects of using other settings
may be evaluated in greater detail by setting `verbose` and `plot` to
`TRUE`).  
The function may perform both interpolation (i.e., assuming a noiseless,
deterministic process with no uncertainty at the values already
evaluated) or regression (i.e., assuming a noisy, stochastic process),
controlled by the `noisy` argument.  

The covariance matrix (or kernel) is defined as:  

`exp(-||x - x'||^pow / lengthscale)`  

with `||x -x'||` corresponding to a matrix containing the absolute
Euclidean distances of values of `x` (and values on the prediction
grid), scaled to the `[0, 1]` range if `scale_x` is `TRUE` and on their
original scale if `FALSE`. Scaling i generally recommended (as this
leads to more comparable and predictable effects of `pow` and
`lengthscale`, regardless of the true scale), and also recommended if
the range of values is smaller than this range. The absolute distances
are raised to the power `pow`, which must be a value in the `[1, 2]`
range. Together with `lengthscale`, `pow` controls the smoothness of the
Gaussian process model, with `1` corresponding to less smoothing (i.e.,
piecewise straight lines between all evaluations if `lengthscale` is
`1`) and values `> 1` corresponding to more smoothing. After raising the
absolute distances to the chosen power `pow`, the resulting matrix is
divided by `lengthscale`. The default is `1` (no change), and values
`< 1` leads to faster decay in correlations and thus less smoothing
(more wiggly fits), and values `> 1` leads to more smoothing (less
wiggly fits). If a single specific value is supplied for `lengthscale`
this is used; if a range of values is provided, a secondary optimisation
process determines the value to use within that range.  

Some minimal noise ("jitter") is always added to the diagonals of the
matrices where relevant to ensure numerical stability; if `noisy` is
`TRUE`, a "nugget" value will be determined using a secondary
optimisation process  

Predictions will be made over an equally spaced grid of `x` values of
size `resolution`; if `narrow` is `TRUE`, this grid will only be spread
out between the `x` values with corresponding `y` values closest to and
below and closes to and above `target`, respectively, leading to a finer
grid in the range of relevance (as described above, this should only be
used for processes that are assumed to be noiseless and should only be
used if the process can safely be assumed to be monotonically increasing
or decreasing within the `search_range`). To suggest the next `x` value
for evaluations, the function uses an acquisition function based on
bi-directional uncertainty bounds (posterior predictive distributions)
with widths controlled by the `kappa` hyperparameter. Higher
`kappa`/wider uncertainty bounds leads to increased *exploration* (i.e.,
the algorithm is more prone to select values with high uncertainty,
relatively far from existing evaluations), while lower `kappa`/narrower
uncertainty bounds leads to increased *exploitation* (i.e., the
algorithm is more prone to select values with less uncertainty, closer
to the best predicted mean values). The value in the `x` grid leading
with one of the boundaries having the smallest absolute distance to the
`target` is chosen (within the narrowed range, if `narrow` is `TRUE`).
See Greenhill et al, 2020 under **References** for a general description
of acquisition functions.  

**IMPORTANT:** **we recommend that control hyperparameters are
explicitly specified**, even for the default calibration function.
Although the default values should be sensible for the default
calibration function, these may change in the future. Further, we
generally recommend users to perform small-scale comparisons (i.e., with
fewer simulations than in the final calibration) of the calibration
process with different hyperparameters for specific use cases beyond the
default (possibly guided by setting the `verbose` and `plot` options to
`TRUE`) before running a substantial number of calibrations or
simulations, as the exact choices may have important influence on the
speed and likelihood of success of the calibration process.  
It is the responsibility of the user to specify sensible values for the
settings and hyperparameters.

## References

Gramacy RB (2020). Chapter 5: Gaussian Process Regression. In:
Surrogates: Gaussian Process Modeling, Design and Optimization for the
Applied Sciences. Chapman Hall/CRC, Boca Raton, Florida, USA. [Available
online](https://bookdown.org/rbg/surrogates/chap5.html).

Greenhill S, Rana S, Gupta S, Vellanki P, Venkatesh S (2020). Bayesian
Optimization for Adaptive Experimental Design: A Review. IEEE Access, 8,
13937-13948.
[doi:10.1109/ACCESS.2020.2966228](https://doi.org/10.1109/ACCESS.2020.2966228)

## Examples

``` r
if (FALSE) { # \dontrun{
# Setup a trial specification to calibrate
# This trial specification has similar event rates in all arms
# and as the default calibration settings are used, this corresponds to
# assessing the Bayesian type 1 error rate for this design and scenario
binom_trial <- setup_trial_binom(arms = c("A", "B"),
                                 true_ys = c(0.25, 0.25),
                                 data_looks = 1:5 * 200)

# Run calibration using default settings for most parameters
res <- calibrate_trial(binom_trial, n_rep = 1000, base_seed = 23)

# Print calibration summary result
res
} # }
```
