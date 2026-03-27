# Setup default cluster for use in parallelised adaptr functions

This function setups (or removes) a default cluster for use in all
parallelised functions in `adaptr` using the `parallel` package. The
function also exports objects that should be available on the cluster
and sets the random number generator appropriately. See **Details** for
further info on how `adaptr` handles sequential/parallel computation.

## Usage

``` r
setup_cluster(cores, export = NULL, export_envir = parent.frame())
```

## Arguments

- cores:

  can be either unspecified, `NULL`, or a single integer `> 0`. If
  `NULL` or `1`, an existing default cluster is removed (if any), and
  the default will subsequently be to run functions sequentially in the
  main process if `cores = 1`, and according to `getOption("mc.cores")`
  if `NULL` (unless otherwise specified in individual functions calls).
  The
  [`parallel::detectCores()`](https://rdrr.io/r/parallel/detectCores.html)
  function may be used to see the number of available cores, although
  this comes with some caveats (as described in the function
  documentation), including that the number of cores may not always be
  returned and may not match the number of cores that are available for
  use. In general, using less cores than available may be preferable if
  other processes are run on the machine at the same time.

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

Invisibly returns the default `parallel` cluster or `NULL`, as
appropriate. This may be used with other functions from the `parallel`
package by advanced users, for example to load certain libraries on the
cluster prior to calling
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md).

## Details

**Using sequential or parallel computing in adaptr**

All parallelised `adaptr` functions have a `cores` argument that
defaults to `NULL`. If a non-`NULL` integer `> 0` is provided to the
`cores` argument in any of those (except `setup_cluster()`), the package
will run calculations sequentially in the main process if `cores = 1`,
and otherwise initiate a new cluster of size `cores` that will be
removed once the function completes, regardless of whether or not a
default cluster or the global `"mc.cores"` option have been specified.

If `cores` is `NULL` in any `adaptr` function (except
`setup_cluster()`), the package will use a default cluster if one exists
or run computations sequentially if `setup_cluster()` has last been
called with `cores = 1`. If `setup_cluster()` has not been called or
last called with `cores = NULL`, then the package will check if the
global `"mc.cores"` option has been specified (using
`options(mc.cores = <number of cores>)`). If this option has been set
with a value `> 1`, then a new, temporary cluster of that size is setup,
used, and removed once the function completes. If this option has not
been set or has been set to `1`, then computations will be run
sequentially in the main process.

Generally, we recommend using the `setup_cluster()` function as this
avoids the overhead of re-initiating new clusters with every call to one
of the parallelised `adaptr` functions. This is especially important
when exporting many or large objects to a `parallel` cluster, as this
can then be done only once (with the option to export further objects to
the same cluster when calling
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)).

**Type of clusters used and random number generation**

The `adaptr` package solely uses parallel socket clusters (using
[`parallel::makePSOCKcluster()`](https://rdrr.io/r/parallel/makeCluster.html))
and thus does not use forking (as this is not available on all operating
systems and may cause crashes in some situations). As such, user-defined
objects that should be used by the `adaptr` functions when run in
parallel need to be exported using either `setup_cluster()` or
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md),
if not included in the generated `trial_spec` object.

The `adaptr` package uses the `"L'Ecuyer-CMRG"` kind (see
[`RNGkind()`](https://rdrr.io/r/base/Random.html)) for safe random
number generation for all parallelised functions. This is also the case
when running `adaptr` functions sequentially with a seed provided, to
ensure that the same results are obtained regardless of whether
sequential or parallel computation is used. All functions restore both
the random number generator kind and the global random seed after use if
called with a seed.

## Examples

``` r
# Setup a cluster using 2 cores
setup_cluster(cores = 2)

# Get existing default cluster (printed here as invisibly returned)
print(setup_cluster())
#> socket cluster with 2 nodes on host ‘localhost’

# Remove existing default cluster
setup_cluster(cores = NULL)

# Specify preference for running computations sequentially
setup_cluster(cores = 1)

# Remove default cluster preference
setup_cluster(cores = NULL)

# Set global option to default to using 2 new clusters each time
# (only used if no default cluster preference is specified)
options(mc.cores = 2)
```
