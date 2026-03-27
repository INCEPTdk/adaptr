# Simulate single trial after setting seed

Helper function to dispatch the running of several trials to
[`lapply()`](https://rdrr.io/r/base/lapply.html) or
[`parallel::parLapply()`](https://rdrr.io/r/parallel/clusterApply.html),
setting seeds correctly if a `base_seed` was used when calling
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md).
Used internally in calls by the
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
function.

## Usage

``` r
dispatch_trial_runs(is, trial_spec, seeds, sparse, cores, cl = NULL)
```

## Arguments

- is:

  vector of integers, the simulation numbers/indices.

- trial_spec:

  trial specification as provided by
  [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
  [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  or
  [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md).

- sparse:

  single logical, as described in
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md);
  defaults to `TRUE` when running multiple simulations, in which case
  only the data necessary to summarise all simulations are saved for
  each simulation. If `FALSE`, more detailed data for each simulation is
  saved, allowing more detailed printing of individual trial results and
  plotting using
  [`plot_history()`](https://inceptdk.github.io/adaptr/reference/plot_history.md)
  ([`plot_status()`](https://inceptdk.github.io/adaptr/reference/plot_status.md)
  does not require non-sparse results).

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

- cl:

  `NULL` (default) for running sequentially, otherwise a `parallel`
  cluster for parallel computation if `cores > 1`.

## Value

Single trial simulation object, as described in
[`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md).
