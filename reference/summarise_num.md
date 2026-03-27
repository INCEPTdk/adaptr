# Summarise numeric vector

Used internally, to summarise numeric vectors.

## Usage

``` r
summarise_num(x)
```

## Arguments

- x:

  a numeric vector.

## Value

A numeric vector with seven named elements: `mean`, `sd`, `median`,
`p25`, `p75`, `p0`, and `p100` corresponding to the mean, standard
deviation, median, and 25-/75-/0-/100-percentiles.
