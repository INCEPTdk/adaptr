#' Plot trial metric history
#'
#' Plots the history of relevant metrics over the progress of single or multiple
#' simulations. Simulated trials **only** contribute until the time they are
#' stopped, i.e., if some trials are stopped earlier than others, they will not
#' contribute to the summary statistics at later adaptive looks. Data from
#' individual arms in a trial contribute until the complete trial is stopped.\cr
#' These history plots require non-sparse results (`sparse` set to
#' `FALSE`; see [run_trial] and [run_trials]) and the `ggplot2` package
#' installed.
#'
#' @inheritParams extract_results
#' @param x_value single character string, determining whether the number of
#'  adaptive analysis looks (`"look"`, default) or the total cumulated number of
#'  patients allocated (`"total n"`) are plotted on the x-axis.
#' @param y_value single character string, determining which values are plotted
#'   on the y-axis. The following options are available: allocation
#'   probabilities (`"prob"`, default), the total number of patients allocated
#'   to each arm (`"n"`), the percentage of patients allocated to each arm of
#'   the total number of patients randomised (`"pct"`), the sum of all outcomes
#'   in each arm (`"sum ys"`), the ratio of outcomes (`"ratio ys"`, the sum of
#'   outcomes in each arm divided by the number of patients allocated to that
#'   arm).
#' @param line list styling the lines as per \pkg{ggplot2} conventions (e.g.,
#'   `linetype`, `size`).
#' @param ... additional arguments, not used.
#'
#' @return A `ggplot2` plot object.
#'
#' @export
#'
#' @examples
#' #### Only run examples if ggplot2 is installed ####
#' if (requireNamespace("ggplot2", quietly = TRUE)){
#'
#'   # Setup a trial specification
#'   binom_trial <- setup_trial_binom(arms = c("A", "B", "C", "D"),
#'                                    control = "A",
#'                                    true_ys = c(0.20, 0.18, 0.22, 0.24),
#'                                    data_looks = 1:20 * 100)
#'
#'
#'
#'   # Run a single simulation with a fixed random seed
#'   res <- run_trial(binom_trial, seed = 12345)
#'
#'   # Plot total allocations to each arm according to overall total allocations
#'   plot_history(res, x_value = "total n", y_value = "n")
#'
#'
#'
#'   # Run multiple simulation with a fixed random base seed
#'   # Notice that sparse = FALSE is required
#'   res_mult <- run_trials(binom_trial, n_rep = 15, base_seed = 12345, sparse = FALSE)
#'
#'   # Plot allocation probabilities at each look
#'   plot_history(res_mult, x_value = "look", y_value = "prob")
#'
#'   # Other y_value options are available but not shown in these examples
#'
#'   # Do not return/print last plot in documentation
#'   invisible(NULL)
#' }
#'
#' @seealso
#' [plot_status].
#'
#'
plot_history <- function(object, x_value = "look", y_value = "prob", line = NULL, ...) {
  UseMethod("plot_history")
}



#' Plot history for a single trial simulation
#'
#' @rdname plot_history
#' @export
#'
plot_history.trial_result <- function(object,
                                      x_value = "look", y_value = "prob",
                                      line = NULL, ...) {
  assert_pkgs("ggplot2")

  if (!isTRUE(x_value %in% c("look", "total n") & length(x_value) == 1)) {
    stop("x_value must be either 'look' or 'total n'.", call. = FALSE)
  }
  if (!isTRUE(y_value %in% c("prob", "n", "pct", "sum ys", "ratio ys") & length(y_value) == 1)) {
    stop("y_value must be either 'prob', 'n', 'pct', 'sum ys', or 'ratio ys'.", call. = FALSE)
  }
  if (isTRUE(object$sparse)) {
    stop("Plotting the history for single trials requires non-sparse results. ",
         "Please call run_trial() again with sparse = FALSE.", call. = FALSE)
  }


  dta <- extract_history(object, metric = y_value)
  dta$x <- if (x_value == "look") dta$look else dta$look_ns

  ggplot2::ggplot(dta, ggplot2::aes(x = x, y = value, colour = arm)) +
    do.call(ggplot2::geom_line, line %||% list(NULL)) +
    make_x_scale(x_value) +
    make_y_scale(y_value) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.title = ggplot2::element_blank())
}



#' Plot history for multiple trial simulations
#'
#' @param ribbon list, as `line` but only appropriate for `trial_results`
#'   objects (i.e., when multiple simulations are run). Also allows to specify
#'   the `width` of the interval: must be between 0 and 1, with `0.5` (default)
#'   showing the inter-quartile ranges.
#'
#' @rdname plot_history
#'
#' @export
#'
plot_history.trial_results <- function(object,
                                       x_value = "look", y_value = "prob",
                                       line = NULL,
                                       ribbon = list(width = 0.5, alpha = 0.2),
                                       ...) {
  assert_pkgs("ggplot2")

  if (!isTRUE(x_value %in% c("look", "total n") & length(x_value) == 1)) {
    stop("x_value must be either 'look' or 'total n'.", call. = FALSE)
  }
  if (!isTRUE(y_value %in% c("prob", "n", "pct", "sum ys", "ratio ys") & length(y_value) == 1)) {
    stop("y_value must be either 'prob', 'n', 'pct', 'sum ys', 'ratio ys'.", call. = FALSE)
  }
  if (isTRUE(object$sparse)) {
    stop("Plotting the history for multiple trials requires non-sparse results.",
         "Please call run_trials() again with sparse = FALSE.", call. = FALSE)
  }

  # Enforce defaults if ill-defined input
  ribbon <- ribbon %||% formals()$ribbon
  ribbon$width <- ribbon$width %||% 0.5
  ribbon$alpha <- ribbon$alpha %||% 0.2

  # Data extraction and aggregation
  dta <- do.call(rbind, lapply(object$trial_results, extract_history, metric = y_value))
  summarise_alloc_dta <- function(dta) {
    qs <- setNames(quantile(dta$value, 0.5 + (-1:1) * ribbon$width/2), c("lo", "mid", "hi"))
    cbind(dta[1, c("look", "look_ns", "arm")], as.list(qs))
  }

  dta_agg <- do.call(rbind, by(dta, dta[, c("look", "look_ns", "arm")], summarise_alloc_dta))
  dta_agg$x <- if (x_value == "look") dta_agg$look else dta_agg$look_ns

  ribbon$width <- NULL # remove invalid geom_ribbon argument
  ribbon_args <- c(list(ggplot2::aes(ymin = lo, ymax = hi, fill = arm)), ribbon)

  line_args <- c(list(ggplot2::aes(y = mid, colour = arm)), line)

  ggplot2::ggplot(dta_agg, ggplot2::aes(x = x)) +
    do.call(ggplot2::geom_ribbon, ribbon_args) +
    do.call(ggplot2::geom_line, line_args) +
    make_x_scale(x_value) +
    make_y_scale(y_value) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.title = ggplot2::element_blank())
}



#' Extract history
#'
#' Used internally. Extracts relevant parameters at each conducted adaptive
#' analysis from a single trial.
#'
#' @param object single `trial_result` from [run_trial], only works if run
#'   with argument `sparse = FALSE`.
#' @param metric either `"prob"` (default), in which case allocation
#'   probabilities at each adaptive analysis are returned; `"n"`, in which
#'   case the total number of patients allocated to each `arm` after each
#'   adaptive analysis are returned; `"pct"` in which case the proportions
#'   of patients allocated to each arm of the total number of patients
#'   randomised are returned; `"sum ys"`, in which case the total summed
#'   outcomes in each arm after each analysis are returned; or `"ratio ys"`, in
#'   which case the total summed outcomes in each arm divided by the total
#'   number of patients randomised to that arm after each analysis are returned.
#'
#' @return A tidy `data.frame` (one row per arm per look) containing the following
#'   columns:
#'   \itemize{
#'     \item `look`: consecutive numbers (integers) of each interim look.
#'     \item `look_ns`: total number of patients (integers) allocated at current
#'     adaptive analysis look to all arms in the trial.
#'     \item `arm`: the current `arm` in the trial.
#'     \item `value`: as described under `metric`.
#'   }
#'
#' @keywords internal
#'
extract_history <- function(object, metric = "prob") {
  metric_name <- switch(
    metric,
    "prob" = "old_alloc",
    "n" = "ns",
    "pct" = "ns",
    "sum ys" = "sum_ys",
    "ratio ys" = "sum_ys"
  )

  history <- lapply(
    seq_along(object$all_looks),
    function(i) {
      with(
        object$all_looks[[i]],
        data.frame(look = i, look_ns = object$looks[i], arm = arms,
                   old_alloc = old_alloc, ns = ns, sum_ys = sum_ys)
      )
    }
  )

  # Format and return
  res <- do.call(rbind, history)
  res$value <- res[[metric_name]]
  switch(
    metric,
    "prob" = transform(res, value = ifelse(is.na(value), 0, value)), # NA = no allocation
    "pct" = transform(res, value = value / look_ns),
    "ratio ys" = transform(res, value = value / ns),
    res # no transformation of value column
  )
}
