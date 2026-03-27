# Check availability of required packages

Used internally, helper function to check if SUGGESTED packages are
available. Will halt execution if any of the queried packages are not
available and provide installation instructions.

## Usage

``` r
assert_pkgs(pkgs = NULL)
```

## Arguments

- pkgs, :

  character vector with name(s) of package(s) to check.

## Value

`TRUE` if all packages available, otherwise execution is halted with an
error.
