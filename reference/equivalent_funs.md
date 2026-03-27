# Assert equivalent functions

Used internally. Compares the definitions of two functions (ignoring
environments, bytecodes, etc., by only comparing function arguments and
bodies, using [`deparse()`](https://rdrr.io/r/base/deparse.html)).

## Usage

``` r
equivalent_funs(fun1, fun2)
```

## Arguments

- fun1, fun2:

  functions to compare.

## Value

Single logical.
