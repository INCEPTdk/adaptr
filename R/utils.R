#' Format digits before printing
#'
#' Used internally.
#'
#' @param x numeric, the numeric value(s) to format.
#' @param dig single integer, the number of digits.
#'
#' @return Formatted character string.
#'
#' @keywords internal
#'
fmt_dig <- function(x, dig) {
  format(round(x, digits = dig), nsmall = dig)
}



#' Create formatted label with absolute and relative frequencies (percentages)
#'
#' Used internally.
#'
#' @param e integer, the numerator (e.g., the number of events).
#' @param n integer, the denominator (e.g., the total number of patients).
#' @param dec integer, the number of decimals for the percentage.
#'
#' @return Formatted character string.
#'
#' @keywords internal
#'
fmt_pct <- function(e, n, dec = 1) {
  paste0(e, "/", n, " (", format(round(e/n*100, digits = dec), nsmall = dec), "%)")
}



#' Rescale numeric vector to sum to 1
#'
#' Used internally.
#'
#' @param x numeric vector.
#'
#' @return Numeric vector, `x` rescaled to sum to a total of 1.
#'
#' @keywords internal
#'
rescale <- function(x) {
  x / sum(x)
}



#' Summarise distribution
#'
#' Used internally, to summarise posterior distributions, but the logic does
#' apply to any distribution (thus, the name).
#'
#' @param x a numeric vector of posterior draws.
#' @param robust single logical. if `TRUE` (default) the median and median
#'   absolute deviation (MAD-SD; scaled to be comparable to the standard
#'   deviation for normal distributions) are used to summarise the distribution;
#'   if `FALSE`, the mean and standard deviation (SD) are used instead (slightly
#'   faster, but may be less appropriate for skewed distribution).
#' @param interval_width single numeric value (`> 0` and `<1`); the width of the
#'   interval; default is 0.95, corresponding to 95% percentile-base credible
#'   intervals for posterior distributions.
#'
#' @details
#' MAD-SDs are scaled to correspond to SDs if distributions are normal,
#' similarly to the [mad] function; see details regarding calculation in that
#' function's description.
#'
#' @return A numeric vector with four named elements: `est` (the median/mean),
#'   `err` (the MAD-SD/SD), `lo` and `hi` (the lower and upper boundaries of the
#'   interval).
#'
#' @importFrom stats median quantile sd
#'
#' @keywords internal
#'
summarise_dist <- function(x, robust = TRUE, interval_width = 0.95) {
  qs <- quantile(x, c((1 - interval_width)/2, 1 - (1 - interval_width)/2), names = FALSE)
  if (robust) {
    p50 <- median(x)
    c(est = p50, err = median(abs(x - p50)) * 1.4826, lo = qs[1], hi = qs[2])
  } else {
    c(est = mean(x), err = sd(x), lo = qs[1], hi = qs[2])
  }
}


#' Summarise numeric vector
#'
#' Used internally, to summarise numeric vectors.
#'
#' @param x a numeric vector.
#'
#' @return A numeric vector with seven named elements: `mean`, `sd`, `median`,
#'   `p25`, `p75`, `p0`, and `p100` corresponding to the mean, standard
#'   deviation, median, and 25-/75-/0-/100-percentiles.
#'
#' @importFrom stats quantile sd
#'
#' @keywords internal
#'
summarise_num <- function(x) {
  ps <- quantile(x, probs = c(0.5, 0.25, 0.75, 0, 1), names = FALSE)
  c(mean = mean(x),
    sd = sd(x),
    median = ps[1],
    p25 = ps[2],
    p75 = ps[3],
    p0 = ps[4],
    p100 = ps[5])
}



#' cat() with sep = ""
#'
#' Used internally. Passes everything on to [cat()] but enforces `sep = ""`.
#' Relates to [cat()] as [paste0()] relates to [paste()].
#'
#' @param ... strings to be concatenated and printed.
#'
#' @return NULL
#'
#' @keywords internal
#'
cat0 <- function(...) cat(..., sep = "")



#' stop() and warning() with call. = FALSE
#'
#' Used internally. Calls [stop0()] or [warning()] but enforces `call. = FALSE`,
#' to suppress the call from the error/warning.
#'
#' @inheritParams base::stop
#'
#' @return NULL
#'
#' @keywords internal
#'
#' @name stop0_warning0
#'
stop0 <- function(...) stop(..., call. = FALSE)

#' @rdname stop0_warning0
#' @keywords internal
warning0 <- function(...) warning(..., call. = FALSE)



#' Verify input is single integer (potentially within range)
#'
#' Used internally.
#'
#' @param x value to check.
#' @param min_value,max_value single integers (each), lower and upper bounds
#'   between which `x` should lie.
#' @param open single character, determines whether `min_value` and `max_value`
#'   are excluded or not. Valid values: `"no"` (= closed interval; `min_value`
#'   and `max_value` included; default value), `"right"`, `"left"`, `"yes"```
#'   (= open interval, `min_value` and `max_value` excluded).
#'
#' @return Single logical.
#'
#' @keywords internal
#'
verify_int <- function(x, min_value = -Inf, max_value = Inf, open = "no") {
  if (is.null(x)) return(FALSE)
  if (!is.numeric(x)) return(FALSE)
  is_int <- length(x) == 1 & all(!is.na(x)) & all(floor(x) == x)
  is_above_min <- if (open %in% c("left", "yes")) min_value < x else min_value <= x
  is_below_max <- if (open %in% c("right", "yes")) x < max_value else x <= max_value
  all(is_int) & all(is_above_min) & all(is_below_max)
}



#' Replace NULL with other value (NULL-OR-operator)
#'
#' Used internally, primarily when working with list arguments, because, e.g.,
#' `list_name$element_name` yields `NULL` when unspecified.
#'
#' @param a,b atomic values of any type.
#'
#' @return If `a` is `NULL`, `b` is returned. Otherwise `a` is returned.
#'
#' @keywords internal
#'
#' @name replace_null
#'
`%||%` <- function(a, b) if (is.null(a)) b else a



#' Replace non-finite values with other value (finite-OR-operator)
#'
#' Used internally, helper function that replaces non-finite (i.e., `NA`, `NaN`,
#' `Inf`, and `-Inf`) values according to [is.finite()], primarily used to
#' replace `NaN`/`Inf`/`-Inf` with `NA`.
#'
#' @param a atomic vector of any type.
#'
#' @param b single value to replace non-finite values with.
#'
#' @return If values in `a` are non-finite, they are replaced with `b`,
#'   otherwise they are left unchanged.
#'
#' @keywords internal
#'
#' @name replace_nonfinite
#'
`%f|%` <- function(x, y) {
  x[!is.finite(x)] <- y
  x
}



#' Check availability of required packages
#'
#' Used internally, helper function to check if SUGGESTED packages are
#' available. Will halt execution if any of the queried packages are not
#' available and provide installation instructions.
#'
#' @param pkgs, character vector with name(s) of package(s) to check.
#'
#' @return `TRUE` if all packages available, otherwise execution is halted with
#'   an error.
#'
#' @keywords internal
#'
assert_pkgs <- function(pkgs = NULL) {
  checks <- vapply_lgl(pkgs, function(p) isFALSE(requireNamespace(p, quietly = TRUE)))
  unavailable_pkgs <- names(checks[checks])

  if (any(checks)) {
    stop0(
      "The following required package",  ifelse(sum(checks) > 1, "s were", " was"), " unavailable: ",
      paste(unavailable_pkgs, collapse = ", "),
      ". \nConsider installing with the following command: ",
      sprintf("install.packages(%s)", paste0(ifelse(length(unavailable_pkgs) > 1, "c(", ""),
                                             paste(sprintf("\"%s\"", unavailable_pkgs), collapse = ", "),
                                             ifelse(length(unavailable_pkgs) > 1, ")", "")))
    )
  }

  return(TRUE)
}



#' vapply helpers
#'
#' Used internally. Helpers for simplifying code invoking vapply().
#'
#' @inheritParams base::vapply
#'
#' @keywords internal
#'
#' @name vapply_helpers
#'
vapply_num <- function(X, FUN, ...) vapply(X, FUN, FUN.VALUE = numeric(1), ...)

#' @rdname vapply_helpers
#' @keywords internal
vapply_int <- function(X, FUN, ...) vapply(X, FUN, FUN.VALUE = integer(1), ...)

#' @rdname vapply_helpers
#' @keywords internal
vapply_str <- function(X, FUN, ...) vapply(X, FUN, FUN.VALUE = character(1), ...)

#' @rdname vapply_helpers
#' @keywords internal
vapply_lgl <- function(X, FUN, ...) vapply(X, FUN, FUN.VALUE = logical(1), ...)



#' Assert equivalent functions
#'
#' Used internally. Compares the definitions of two functions (ignoring
#' environments, bytecodes, etc., by only comparing function bodies).
#'
#' @param fun1,fun2 names of functions (unquoted)
#'
#' @return Single logical.
#'
#' @keywords internal
#'
equivalent_funs <- function(fun1, fun2) {
  isTRUE(
    all.equal(
      deparse(fun1),
      deparse(fun2)
    )
  )
}



#' Find the index of value nearest to a target value
#'
#' Used internally, to find the index of the value in a vector nearest to a
#' target value, possibly in a specific preferred direction.
#'
#' @param values numeric vector, the values considered.
#' @param target single numeric value, the target to find the value closest to.
#' @param dir single numeric value. If `0` (the default), finds the index of the
#'   value closest to the target, regardless of the direction. If `< 0` or
#'   `> 0`, finds the index of the value closest to the target, but only
#'   considers values at or below/above target, respectfully, if any (otherwise
#'   returns the closest value regardless of direction).
#'
#' @return Single integer, the index of the value closest to `target` according
#'   to `dir`.
#'
#' @keywords internal
#'
which_nearest <- function(values, target, dir) {
  # Nearest to target is the default and used if dir == 0 or as fall-back
  idx <- which.min(abs(target - values))
  if (dir != 0) {
    diffs <- sign(dir) * (target - values)
    if (sum(diffs <= 0) > 0) {
      diffs[diffs > 0] <- -Inf
      idx <- which.max(diffs)
    }
  }
  idx
}
