#' Plot empirical cumulative distribution functions of performance metrics
#'
#' Plots empirical cumulative distribution functions (ECDFs) of numerical
#' performance metrics across multiple simulations from a `"trial_results"`
#' object returned by [run_trials()]. Requires the `ggplot2` package installed.
#'
#' @inheritParams extract_results
#' @inheritParams plot_convergence
#' @inheritParams check_performance
#' @param metrics the performance metrics to plot, as described in
#'   [extract_results()]. Multiple metrics may be plotted at the same time.
#'   Valid metrics include: `size`, `sum_ys`, `ratio_ys_mean`, `sq_err`,
#'   `sq_err_te`, `err`, `err_te`, `abs_err`, `abs_err_te`, (as described in
#'   [extract_results()], with the addition of `abs_err` and `abs_err_te`, which
#'   are the absolute errors, i.e., `abs(err)` and `abs(err_te)`). All
#'   may be specified using either spaces or underlines (case sensitive).
#'   Defaults to plotting `size`, `sum_ys`, and `ratio_ys_mean`.
#' @param nrow,ncol the number of rows and columns when plotting multiple
#'   metrics in the same plot (using faceting in `ggplot2`). Defaults to `NULL`,
#'   in which case this will be determined automatically.
#'
#' @details
#'
#' Note that the arguments related to arm selection and error calculation are
#' only relevant if errors are visualised.
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
#'   # Run multiple simulation with a fixed random base seed
#'   res_mult <- run_trials(binom_trial, n_rep = 25, base_seed = 678)
#'
#'   # NOTE: the number of simulations in this example is smaller than
#'   # recommended - the plots reflect that, and would likely be smoother if
#'   # a larger number of trials had been simulated
#'
#'   # Plot ECDFs of continuous performance metrics
#'   plot_metrics_ecdf(res_mult)
#'
#' }
#'
#' @seealso
#' [check_performance()], [summary()], [extract_results()],
#' [plot_convergence()], [check_remaining_arms()].
#'
plot_metrics_ecdf <- function(object, metrics = c("size", "sum_ys", "ratio_ys"),
                              select_strategy = "control if available",
                              select_last_arm = FALSE, select_preferences = NULL,
                              te_comp = NULL, raw_ests = FALSE, final_ests = NULL,
                              restrict = NULL, nrow = NULL, ncol = NULL,
                              cores = NULL) {

  # Check packages
  assert_pkgs("ggplot2")

  # Validate metrics
  if (!isTRUE(is.character(metrics) & length(metrics) >= 1)) {
    stop0("metrics must be a character vector of length 1 or more specifying valid metric(s) ",
          "to plot, and each metric must be specified only once.")
  } else {
    metrics <- chartr("_", " ", metrics) # Replace underlines with spaces
    if (!all(metrics %in% c("size", "sum ys", "ratio ys", "sq err", "sq err te",
                            "err", "err te", "abs err", "abs err te"))) {
      stop0("Invalid metric(s) specified. Type 'help(plot_metrics_ecdf)' to see a list of the metrics ",
            "that may be specified.")
    }
    if (length(metrics) != length(unique(metrics))) {
      stop0("The same metric(s) may only be specified once.")
    }
  }

  # Check validity of restrict argument
  if (!is.null(restrict)) {
    if (!restrict %in% c("superior", "selected")) {
      stop("restrict must be either NULL, 'superior' or 'selected'.")
    }
  }

  # Extract results and values from trial specification object
  extr_res <- extract_results(object, select_strategy = select_strategy,
                              select_last_arm = select_last_arm,
                              select_preferences = select_preferences,
                              te_comp = te_comp, raw_ests = raw_ests,
                              final_ests = final_ests, cores = cores)

  if (isTRUE(restrict == "superior")) {
    extr_res <- extr_res[!is.na(extr_res$superior_arm), ]
  } else if (isTRUE(restrict == "selected")) {
    extr_res <- extr_res[!is.na(extr_res$selected_arm), ]
  }
  if (nrow(extr_res) <= 1) {
    stop0("Empirical cumulative distributions cannot be plotted as the number of simulation ",
          "results to plot is <= 1", ifelse(is.null(restrict), ".", " after restriction."))
  }

  # Prepare data for plotting
  plot_dta <- data.frame(metric = character(0), value = numeric(0))
  if ("size" %in% metrics) {
    plot_dta <- rbind(plot_dta,
                      data.frame(metric = "Size",
                                 value = extr_res$final_n))
  }
  if ("sum ys" %in% metrics) {
    plot_dta <- rbind(plot_dta,
                      data.frame(metric = "Sum ys",
                                 value = extr_res$sum_ys))
  }
  if ("ratio ys" %in% metrics) {
    plot_dta <- rbind(plot_dta,
                      data.frame(metric = "Ratio ys",
                                 value = extr_res$ratio_ys))
  }
  if ("sq err" %in% metrics) {
    plot_dta <- rbind(plot_dta,
                      data.frame(metric = "Error^2",
                                 value = extr_res$sq_err))
  }
  if ("sq err te" %in% metrics) {
    if (sum(!is.na(extr_res$sq_err_te)) <= 1) {
      stop0("Empirical cumulative distribution of sq_err_te cannot be plotted as the number of non-NA values is <= 1.")
    }
    plot_dta <- rbind(plot_dta,
                      data.frame(metric = "Error TE^2",
                                 value = extr_res$sq_err_te))
  }
  if ("err" %in% metrics) {
    plot_dta <- rbind(plot_dta,
                      data.frame(metric = "Error",
                                 value = extr_res$err))
  }
  if ("err te" %in% metrics) {
    if (sum(!is.na(extr_res$err_te)) <= 1) {
      stop0("Empirical cumulative distribution of err_te can not be plotted as the number of non-NA values is <= 1.")
    }
    plot_dta <- rbind(plot_dta,
                      data.frame(metric = "Error TE",
                                 value = extr_res$err_te))
  }
  if ("abs err" %in% metrics) {
    plot_dta <- rbind(plot_dta,
                      data.frame(metric = "Abs(error)",
                                 value = abs(extr_res$err)))
  }
  if ("abs err te" %in% metrics) {
    if (sum(!is.na(extr_res$err_te)) <= 1) {
      stop0("Empirical cumulative distribution of abs_err_te can not be plotted as the number of non-NA values is <= 1.")
    }
    plot_dta <- rbind(plot_dta,
                      data.frame(metric = "Abs(error TE)",
                                 value = abs(extr_res$err_te)))
  }
  plot_dta <- na.omit(plot_dta) # Ignore NAs for error metrics
  substr(metrics, 1, 1) <- toupper(substr(metrics, 1, 1))
  metrics[metrics == "Sq err"] <- "Error^2"
  metrics[metrics == "Sq err te"] <- "Error TE^2"
  metrics[metrics == "Err"] <- "Error"
  metrics[metrics == "Err te"] <- "Error TE"
  metrics[metrics == "Abs err"] <- "Abs(error)"
  metrics[metrics == "Abs err te"] <- "Abs(error TE)"
  plot_dta <- transform(plot_dta,
                        metric = factor(metric, levels = metrics))

  # Make the base plot
  p <- ggplot2::ggplot(data = plot_dta, ggplot2::aes(value)) +
    ggplot2::stat_ecdf(geom = "step", pad = "FALSE") +
    ggplot2::labs(x = "Value", y = NULL) +
    ggplot2::theme_bw()
  # Add y-label or facet
  if (length(metrics) == 1) { # Only 1 metric
    p <- p +
      ggplot2::scale_y_continuous(name = metrics, breaks = 0:5 * 0.2, labels = paste0(0:5 * 20, "%"), limits = 0:1, expand = c(0, 0))
  } else { # Multiple metrics plotted
    if (is.null(nrow) & is.null(ncol)) { # Set nrow if both nrow and ncol are NULL
      nrow <- ifelse(length(metrics) <= 3, length(metrics), ceiling(sqrt(length(metrics))))
    }
    p <- p +
      ggplot2::scale_y_continuous(name = NULL, breaks = 0:5 * 0.2, labels = paste0(0:5 * 20, "%"), limits = 0:1, expand = c(0, 0)) +
      ggplot2::facet_wrap(ggplot2::vars(metric), scales = "free", nrow = nrow, ncol = ncol, strip.position = "left") +
      ggplot2::theme(strip.background = ggplot2::element_blank(), strip.placement = "outside")
  }
  # Return
  p
}
