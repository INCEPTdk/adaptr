# Generate breakpoints and other values for printing progress

Used internally. Generates breakpoints, messages, and 'batches' of trial
numbers to simulate when using
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
with the `progress` argument in use. Breaks will be multiples of the
number of `cores`, and repeated use of the same values for breaks is
avoided (if, e.g., the number of breaks times the number of cores is not
possible if few new trials are to be run). Inputs are validated by
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md).

## Usage

``` r
prog_breaks(progress, prev_n_rep, n_rep_new, cores)
```

## Arguments

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

- prev_n_rep:

  single integer, the previous number of simulations run (to add to the
  indices generated and used).

- n_rep_new:

  single integers, number of new simulations to run (i.e., `n_rep` as
  supplied to
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
  minus the number of previously run simulations if `grow` is used in
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)).

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

## Value

List containing `breaks` (the number of participants at each break),
`start_mess` and `prog_mess` (the basis of the first and subsequent
progress messages), and `batches` (a list with each entry corresponding
to the simulation numbers in each batch).
