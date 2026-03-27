# Summarise distribution

Used internally, to summarise posterior distributions, but the logic
does apply to any distribution (thus, the name).

## Usage

``` r
summarise_dist(x, robust = TRUE, interval_width = 0.95)
```

## Arguments

- x:

  a numeric vector of posterior draws.

- robust:

  single logical. if `TRUE` (default) the median and median absolute
  deviation (MAD-SD; scaled to be comparable to the standard deviation
  for normal distributions) are used to summarise the distribution; if
  `FALSE`, the mean and standard deviation (SD) are used instead
  (slightly faster, but may be less appropriate for skewed
  distribution).

- interval_width:

  single numeric value (`> 0` and `<1`); the width of the interval;
  default is 0.95, corresponding to 95% percentile-base credible
  intervals for posterior distributions.

## Value

A numeric vector with four named elements: `est` (the median/mean),
`err` (the MAD-SD/SD), `lo` and `hi` (the lower and upper boundaries of
the interval).

## Details

MAD-SDs are scaled to correspond to SDs if distributions are normal,
similarly to the [`stats::mad()`](https://rdrr.io/r/stats/mad.html)
function; see details regarding calculation in that function's
description.
