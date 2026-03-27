# Make x-axis scale for history/status plots

Used internally. Prepares the x-axis scale for history/status plots.
Requires the `ggplot2` package installed.

## Usage

``` r
make_x_scale(x_value)
```

## Arguments

- x_value:

  single character string, determining whether the number of adaptive
  analysis looks (`"look"`, default), the total cumulated number of
  participants randomised (`"total n"`) or the total cumulated number of
  participants with outcome data available at each adaptive analysis
  (`"followed n"`) are plotted on the x-axis.

## Value

An appropriate scale for the `ggplot2` plot x-axis according to the
value specified in `x_value`.
