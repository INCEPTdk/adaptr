# Simulate multiple trials

This function conducts multiple simulations using a trial specification
as specified by
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
[`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
or
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md).
This function essentially manages random seeds and runs multiple
simulation using
[`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md) -
additional details on individual simulations are provided in that
function's description. This function allows simulating trials in
parallel using multiple cores, automatically saving and re-loading saved
objects, and "growing" already saved simulation files (i.e., appending
additional simulations to the same file).

## Usage

``` r
run_trials(
  trial_spec,
  n_rep,
  path = NULL,
  overwrite = FALSE,
  grow = FALSE,
  cores = NULL,
  base_seed = NULL,
  sparse = TRUE,
  progress = NULL,
  version = NULL,
  compress = TRUE,
  export = NULL,
  export_envir = parent.frame()
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

  single integer; the number of simulations to run.

- path:

  single character string; if specified (defaults to `NULL`), files will
  be written to and loaded from this path using the
  [`saveRDS()`](https://rdrr.io/r/base/readRDS.html) /
  [`readRDS()`](https://rdrr.io/r/base/readRDS.html) functions.

- overwrite:

  single logical; defaults to `FALSE`, in which case previous
  simulations saved in the same `path` will be re-loaded (if the same
  trial specification was used). If `TRUE`, the previous file is
  overwritten (even if the the same trial specification was not used).
  If `grow` is `TRUE`, this argument must be set to `FALSE`.

- grow:

  single logical; defaults to `FALSE`. If `TRUE` and a valid `path` to a
  valid previous file containing less simulations than `n_rep`, the
  additional number of simulations will be run (appropriately re-using
  the same `base_seed`, if specified) and appended to the same file.

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

  single integer or `NULL` (default); a random seed used as the basis
  for simulations. Regardless of whether simulations are run
  sequentially or in parallel, random number streams will be identical
  and appropriate (see
  [`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md)
  for details).

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

- progress:

  single numeric `> 0` and `<= 1` or `NULL`. If `NULL` (default), no
  progress is printed to the console. Otherwise, progress messages are
  printed to the control at intervals proportional to the value
  specified by progress.  
  **Note:** as printing is not possible from within clusters on multiple
  cores, the function conducts batches of simulations on multiple cores
  (if specified), with intermittent printing of statuses. Thus, all
  cores have to finish running their current assigned batches before the
  other cores may proceed with the next batch. If there are substantial
  differences in the simulation speeds across cores, using `progress`
  may thus increase total run time (especially with small values).

- version:

  passed to [`saveRDS()`](https://rdrr.io/r/base/readRDS.html) when
  saving simulations, defaults to `NULL` (as in
  [`saveRDS()`](https://rdrr.io/r/base/readRDS.html)), which means that
  the current default version is used. Ignored if simulations are not
  saved.

- compress:

  passed to [`saveRDS()`](https://rdrr.io/r/base/readRDS.html) when
  saving simulations, defaults to `TRUE` (as in
  [`saveRDS()`](https://rdrr.io/r/base/readRDS.html)), see
  [`saveRDS()`](https://rdrr.io/r/base/readRDS.html) for other options.
  Ignored if simulations are not saved.

- export:

  character vector of names of objects to export to each parallel core
  when running in parallel; passed as the `varlist` argument to
  [`parallel::clusterExport()`](https://rdrr.io/r/parallel/clusterApply.html).
  Defaults to `NULL` (no objects exported), ignored if `cores == 1`. See
  **Details** below.

- export_envir:

  `environment` where to look for the objects defined in `export` when
  running in parallel and `export` is not `NULL`. Defaults to the
  environment from where the function is called.

## Value

A list of a special class `"trial_results"`, which contains the
`trial_results` (results from all simulations; note that `seed` will be
`NULL` in the individual simulations), `trial_spec` (the trial
specification), `n_rep`, `base_seed`, `elapsed_time` (the total
simulation run time), `sparse` (as described above) and `adaptr_version`
(the version of the `adaptr` package used to run the simulations). These
results may be extracted, summarised, and plotted using the
[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md),
[`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md),
[`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md),
[`print.trial_results()`](https://inceptdk.github.io/adaptr/reference/print.md),
[`plot_convergence()`](https://inceptdk.github.io/adaptr/reference/plot_convergence.md),
[`check_remaining_arms()`](https://inceptdk.github.io/adaptr/reference/check_remaining_arms.md),
[`plot_status()`](https://inceptdk.github.io/adaptr/reference/plot_status.md),
and
[`plot_history()`](https://inceptdk.github.io/adaptr/reference/plot_history.md)
functions. See the definitions of these functions for additional details
and details on additional arguments used to select arms in simulations
not ending in superiority and other summary choices.

## Details

**Exporting objects when using multiple cores**

If
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
is used to define a trial specification with custom functions (in the
`fun_y_gen`, `fun_draws`, and `fun_raw_est` arguments of
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md))
and `run_trials()` is run with `cores > 1`, it is necessary to export
additional functions or objects used by these functions and defined by
the user outside the function definitions provided. Similarly, functions
from external packages loaded using
[`library()`](https://rdrr.io/r/base/library.html) or
[`require()`](https://rdrr.io/r/base/library.html) must be exported or
called prefixed with the namespace, i.e., `package::function`. The
`export` and `export_envir` arguments are used to export objects calling
the
[`parallel::clusterExport()`](https://rdrr.io/r/parallel/clusterApply.html)-function.
See also
[`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md),
which may be used to setup a cluster and export required objects only
once per session.

## Examples

``` r
# Setup a trial specification
binom_trial <- setup_trial_binom(arms = c("A", "B", "C", "D"),
                                 true_ys = c(0.20, 0.18, 0.22, 0.24),
                                 data_looks = 1:20 * 100)

# Run 10 simulations with a specified random base seed
res <- run_trials(binom_trial, n_rep = 10, base_seed = 12345)

# See ?extract_results, ?check_performance, ?summary and ?print for details
# on extracting resutls, summarising and printing
```
