# Extract history

Used internally. Extracts relevant parameters at each conducted adaptive
analysis from a single trial.

## Usage

``` r
extract_history(object, metric = "prob")
```

## Arguments

- object:

  single `trial_result` from
  [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md),
  only works if run with argument `sparse = FALSE`.

- metric:

  either `"prob"` (default), in which case allocation probabilities at
  each adaptive analysis are returned; `"n"`/`"n all"`, in which case
  the total number of participants with available follow-up data (`"n"`)
  or allocated (`"n all"`) to each `arm` during each adaptive analysis
  are returned; `"pct"`/`"pct all"` in which case the proportions of of
  participants allocated and having available follow-up data (`"pct"`)
  or allocated in total (`"pct all"`) to each arm out of the total
  number of participants are returned; `"sum ys"`/`"sum ys all"`, in
  which case the total summed available outcome data (`"sum ys"`) or
  total summed outcome data including outcomes of participants
  randomised that have not necessarily reached follow-up yet
  (`"sum ys all"`) in each arm after each adaptive analysis are
  returned; or `"ratio ys"`/`"ratio ys all"`, in which case the total
  summed outcomes as specified for `"sum ys"`/`"sum ys all"` divided by
  the number of participants after each analysis adaptive are returned.

## Value

A tidy `data.frame` (one row per arm per look) containing the following
columns:

- `look`: consecutive numbers (integers) of each interim look.

- `look_ns`: total number of participants (integers) with outcome data
  available at current adaptive analysis look to all arms in the trial.

- `look_ns_all`: total number of participants (integers) randomised at
  current adaptive analysis look to all arms in the trial.

- `arm`: the current `arm` in the trial.

- `value`: as described under `metric`.
