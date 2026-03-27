# Make y-axis scale for history/status plots

Used internally. Prepares the y-axis scale for history/status plots.
Requires the `ggplot2` package installed.

## Usage

``` r
make_y_scale(y_value)
```

## Arguments

- y_value:

  single character string, determining which values are plotted on the
  y-axis. The following options are available: allocation probabilities
  (`"prob"`, default), the total number of participants with outcome
  data available (`"n"`) or randomised (`"n all"`) to each arm, the
  percentage of participants with outcome data available (`"pct"`) or
  randomised (`"pct all"`) to each arm out of the current total, the sum
  of all available (`"sum ys"`) outcome data or all outcome data for
  randomised participants including outcome data not available at the
  time of the current adaptive analysis (`"sum ys all"`), the ratio of
  outcomes as defined for `"sum ys"`/`"sum ys all"` divided by the
  corresponding number of participants in each arm.

## Value

An appropriate scale for the `ggplot2` plot y-axis according to the
value specified in `y_value`.
