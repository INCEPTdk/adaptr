# Verify input is single integer (potentially within range)

Used internally.

## Usage

``` r
verify_int(x, min_value = -Inf, max_value = Inf, open = "no")
```

## Arguments

- x:

  value to check.

- min_value, max_value:

  single integers (each), lower and upper bounds between which `x`
  should lie.

- open:

  single character, determines whether `min_value` and `max_value` are
  excluded or not. Valid values: `"no"` (= closed interval; `min_value`
  and `max_value` included; default value), `"right"`, `"left"`, `"yes"`
  (= open interval, `min_value` and `max_value` excluded).

## Value

Single logical.
