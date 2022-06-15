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
  is_int <- length(x) == 1 & all(!is.na(x)) & all(is.numeric(x)) & all(floor(x) == x)
  is_above_min <- if (open %in% c("left", "yes")) min_value < x else min_value <= x
  is_below_max <- if (open %in% c("right", "yes")) x < max_value else x <= max_value
  all(is_int) & all(is_above_min) & all(is_below_max)
}



#' Helper function for replacing NULL with other value
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



#' Check availability of required packages
#'
#' Used internally, helper to check if SUGGESTED packages are available. Will
#' halt execution if any of the queried packages are not available.
#'
#' @param pkgs, character vector with name(s) of package(s) to check.
#'
#' @return `TRUE` if all packages available, otherwise execution is halted with
#' an error.
#'
#' @keywords internal
#'
assert_pkgs <- function(pkgs = NULL) {
  checks <- sapply(pkgs, function(p) isFALSE(requireNamespace(p, quietly = TRUE)))
  unavailable_pkgs <- names(checks[checks])

  if (any(checks)) {
    stop(
      "The following required packages were unavailable: ",
      paste(unavailable_pkgs, collapse = ", "),
      ". \nConsider installing them with the following command: ",
      sprintf("install.packages(%s)", paste0(ifelse(length(unavailable_pkgs) > 1, "c(", ""),
                                             paste(sprintf("\"%s\"", unavailable_pkgs), collapse = ", "),
                                             ifelse(length(unavailable_pkgs) > 1, ")", ""))),
      call. = FALSE
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



#' Assert equivalent functions
#'
#' Used internally. Compares the definitions of two functions (ignoring
#' environments, bytecodes, etc., by only comparing function bodies).
#'
#' @param fun1,fun2 names of functions (unquoted)
#'
#' @return single logical.
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
