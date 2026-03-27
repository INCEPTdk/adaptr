# Find beta distribution parameters from thresholds

Helper function to find a beta distribution with parameters
corresponding to the fewest possible participants with events/non-events
and a specified event proportion. Used in the **Advanced example**
vignette
([`vignette("Advanced-example", "adaptr")`](https://inceptdk.github.io/adaptr/articles/Advanced-example.md))
to derive `beta` prior distributions for use in *beta-binomial conjugate
models*, based on a belief that the true event probability lies within a
specified percentile-based interval (defaults to `95%`). May similarly
be used by users to derive other `beta` priors.

## Usage

``` r
find_beta_params(
  theta = NULL,
  boundary_target = NULL,
  boundary = "lower",
  interval_width = 0.95,
  n_dec = 0,
  max_n = 10000
)
```

## Arguments

- theta:

  single numeric `> 0` and `< 1`, expected true event probability.

- boundary_target:

  single numeric `> 0` and `< 1`, target lower or upper boundary of the
  interval.

- boundary:

  single character string, either `"lower"` (default) or `"upper"`, used
  to select which boundary to use when finding appropriate parameters
  for the `beta` distribution.

- interval_width:

  width of the credible interval whose lower/upper boundary should be
  used (see `boundary_target`); must be `> 0` and `< 1`; defaults to
  `0.95`.

- n_dec:

  single non-negative integer; the returned parameters are rounded to
  this number of decimals. Defaults to `0`, in which case the parameters
  will correspond to whole number of participants.

- max_n:

  single integer `> 0` (default `10000`), the maximum total sum of the
  parameters, corresponding to the maximum total number of participants
  that will be considered by the function when finding the optimal
  parameter values. Corresponds to the maximum number of participants
  contributing information to a beta prior; more than the default number
  of participants are unlikely to be used in a beta prior.

## Value

A single-row `data.frame` with five columns: the two shape parameters of
the beta distribution (`alpha`, `beta`), rounded according to `n_dec`,
and the actual lower and upper boundaries of the interval and the median
(with appropriate names, e.g. `p2.5`, `p50`, and `p97.5` for a `95%`
interval), when using those rounded values.
