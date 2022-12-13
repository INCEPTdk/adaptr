#' Plot trial metric history
#'
#' Plots the history of relevant metrics over the progress of single or multiple
#' simulations. Simulated trials **only** contribute until the time they are
#' stopped, i.e., if some trials are stopped earlier than others, they will not
#' contribute to the summary statistics at later adaptive looks. Data from
#' individual arms in a trial contribute until the complete trial is stopped.\cr
#' These history plots require non-sparse results (`sparse` set to
#' `FALSE`; see [run_trial()] and [run_trials()]) and the `ggplot2` package
#' installed.
#'
#' @inheritParams extract_results
#' @param x_value single character string, determining whether the number of
#'  adaptive analysis looks (`"look"`, default), the total cumulated number of
#'  patients randomised (`"total n"`) or with outcome data available at each
#'  analysis (`"followed n"`) are plotted on the x-axis.
#' @param y_value single character string, determining which values are plotted
#'   on the y-axis. The following options are available: allocation
#'   probabilities (`"prob"`, default), the total number of patients with
#'   outcome data available (`"n"`) or allocated (`"n all"`) to each arm,
#'   the percentage of patients with outcome data available (`"pct"`) or
#'   allocated (`"pct all"`) to each arm out of the current total, the sum of
#'   all available (`"sum ys"`) outcome data or all outcome data for randomised
#'   patients including outcome data not available at the time of the current
#'   adaptive analysis (`"sum ys all"`), the ratio of outcomes as defined for
#'   `"sum ys"`/`"sum ys all"` divided by the corresponding number of patients
#'   in each arm.
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
#' [plot_status()].
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

  if (!isTRUE(x_value %in% c("look", "total n", "followed n") & length(x_value) == 1)) {
    stop0("x_value must be either 'look', 'total n', or 'followed n'.")
  }
  if (!isTRUE(y_value %in% c("prob", "n", "n all", "pct", "pct all", "sum ys",
                             "sum ys all", "ratio ys", "ratio ys all") & length(y_value) == 1)) {
    stop0("y_value must be either 'prob', 'n', 'n all', 'pct', 'pct all',
         'sum ys', 'sum ys all', 'ratio ys', or 'ratio ys all'.")
  }
  if (isTRUE(object$sparse)) {
    stop0("Plotting the history for single trials requires non-sparse results. ",
          "Please call run_trial() again with sparse = FALSE.")
  }

  dta <- extract_history(object, metric = y_value)
  dta$x <- switch(
    x_value,
    "look" = dta$look,
    "total n" = dta$look_ns_all,
    "followed n" = dta$look_ns
  )

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

  if (!isTRUE(x_value %in% c("look", "total n", "followed n") & length(x_value) == 1)) {
    stop0("x_value must be either 'look', 'total n', or 'followed n'.")
  }
  if (!isTRUE(y_value %in% c("prob", "n", "n all", "pct", "pct all", "sum ys",
                             "sum ys all", "ratio ys", "ratio ys all") & length(y_value) == 1)) {
    stop0("y_value must be either 'prob', 'n', 'n all', 'pct', 'pct all',
         'sum ys', 'sum ys all', 'ratio ys', or 'ratio ys all'.")
  }
  if (isTRUE(object$sparse)) {
    stop0("Plotting the history for multiple trials requires non-sparse results.",
          "Please call run_trials() again with sparse = FALSE.")
  }

  # Enforce defaults if ill-defined input
  ribbon <- ribbon %||% formals()$ribbon
  ribbon$width <- ribbon$width %||% 0.5
  ribbon$alpha <- ribbon$alpha %||% 0.2

  # Data extraction and aggregation
  dta <- do.call(rbind, lapply(object$trial_results, extract_history, metric = y_value))
  summarise_alloc_dta <- function(dta) {
    qs <- setNames(quantile(dta$value, 0.5 + (-1:1) * ribbon$width/2), c("lo", "mid", "hi"))
    cbind(dta[1, c("look", "look_ns", "look_ns_all", "arm")], as.list(qs))
  }

  dta_agg <- do.call(rbind, by(dta, dta[, c("look", "look_ns", "look_ns_all", "arm")], summarise_alloc_dta))
  dta_agg$x <- switch(
    x_value,
    "look" = dta_agg$look,
    "total n" = dta_agg$look_ns_all,
    "followed n" = dta_agg$look_ns
  )

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
#' @param object single `trial_result` from [run_trial()], only works if run
#'   with argument `sparse = FALSE`.
#' @param metric either `"prob"` (default), in which case allocation
#'   probabilities at each adaptive analysis are returned; `"n"`/`"n all"`, in
#'   which case the total number of patients with available follow-up data
#'   (`"n"`) or allocated (`"n all"`) to each `arm` during each adaptive
#'   analysis are returned; `"pct"`/`"pct all"` in which case the proportions of
#'   of patients allocated and having available follow-up data (`"pct"`) or
#'   allocated in total (`"pct all"`) to each arm out of the total number of
#'   patients are returned; `"sum ys"`/`"sum ys all"`, in which case the total
#'   summed available outcome data (`"sum ys"`) or total summed outcome data
#'   including outcomes of patients randomised that have not necessarily reached
#'   follow-up yet (`"sum ys all"`) in each arm after each adaptive analysis are
#'   returned; or `"ratio ys"`/`"ratio ys all"`, in which case the total summed
#'   outcomes as specified for `"sum ys"`/`"sum ys all"` divided by the number
#'   of patients after each analysis adaptive are returned.
#'
#' @return A tidy `data.frame` (one row per arm per look) containing the following
#'   columns:
#'   \itemize{
#'     \item `look`: consecutive numbers (integers) of each interim look.
#'     \item `look_ns`: total number of patients (integers) with outcome data
#'       available at current adaptive analysis look to all arms in the trial.
#'     \item `look_ns_all`: total number of patients (integers) randomised at
#'       current adaptive analysis look to all arms in the trial.
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
    "n all" = "ns_all",
    "pct" = "ns",
    "pct all" = "ns_all",
    "sum ys" = "sum_ys",
    "sum ys all" = "sum_ys_all",
    "ratio ys" = "sum_ys",
    "ratio ys all" = "sum_ys_all"
  )

  history <- lapply(
    seq_along(object$all_looks),
    function(i) {
      with(
        object$all_looks[[i]],
        data.frame(look = i, look_ns = object$looks[i],
                   look_ns_all = object$randomised_at_looks[i], arm = arms,
                   old_alloc = old_alloc, ns = ns, ns_all = ns_all,
                   sum_ys = sum_ys, sum_ys_all = sum_ys_all)
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
    "pct all" = transform(res, value = value / look_ns_all),
    "ratio ys" = transform(res, value = value / ns),
    "ratio ys all" = transform(res, value = value / ns_all),
    res # no transformation of value column
  )
}
