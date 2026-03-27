# Replace NULL with other value (NULL-OR-operator)

Used internally, primarily when working with list arguments, because,
e.g., `list_name$element_name` yields `NULL` when unspecified.

## Usage

``` r
a %||% b
```

## Arguments

- a, b:

  atomic values of any type.

## Value

If `a` is `NULL`, `b` is returned. Otherwise `a` is returned.
