# Extract statuses

Used internally. Extracts overall trial statuses or statuses from a
single `arm` from multiple trial simulations. Works with *sparse*
results.

## Usage

``` r
extract_statuses(object, x_value, arm = NULL)
```

## Arguments

- object:

  `trial_results` object from
  [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md).

- x_value:

  single character string, determining whether the number of adaptive
  analysis looks (`"look"`, default), the total cumulated number of
  participants randomised (`"total n"`) or the total cumulated number of
  participants with outcome data available at each adaptive analysis
  (`"followed n"`) are plotted on the x-axis.

- arm:

  character vector containing one or more unique, valid `arm` names,
  `NA`, or `NULL` (default). If `NULL`, the overall trial statuses are
  plotted, otherwise the specified arms or all arms (if `NA` is
  specified) are plotted.

## Value

A tidy `data.frame` (one row possible status per look) containing the
following columns:

- `x`: the look numbers or total number of participants at each look, as
  specified in `x_value`.

- `status`: each possible status (`"Recruiting"`, `"Inferiority"` (only
  relevant for individual arms), `"Futility"`, `"Equivalence"`, and
  `"Superiority"`, as relevant).

- `p`: the proportion (`0-1`) of participants with each `status` at each
  value of `x`.

- `value`: as described under `metric`.
