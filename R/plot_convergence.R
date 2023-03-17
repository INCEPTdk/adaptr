#' Plot convergence of performance metrics
#'
#' Plots performance metrics according to the number of simulations conducted
#' for multiple simulated trials. The number of trials may be split into a
#' a number of batches to illustrate stability of performance metrics across
#' different simulations. Calculations are done according to specified selection
#' and restriction strategies as described in [extract_results()] and
#' [check_performance()]. Requires the `ggplot2` package installed.
#'
#' @inheritParams extract_results
#' @inheritParams check_performance
#' @param metrics the performance metrics to plot, as described in
#'   [check_performance()]. Multiple metrics may be plotted at the same time.
#'   Valid metrics include: `size_mean`, `size_sd`, `size_median`, `size_p25`,
#'   `size_p75`, `size_p0`, `size_p100`, `sum_ys_mean`, `sum_ys_sd`,
#'   `sum_ys_median`, `sum_ys_p25`, `sum_ys_p75`, `sum_ys_p0`, `sum_ys_p100`,
#'   `ratio_ys_mean`, `ratio_ys_sd`, `ratio_ys_median`, `ratio_ys_p25`,
#'   `ratio_ys_p75`, `ratio_ys_p0`, `ratio_ys_p100`, `prob_conclusive`,
#'   `prob_superior`, `prob_equivalence`, `prob_futility`, `prob_max`,
#'   `prob_select_*` (with `*` being an `arm` name), `rmse`, `rmse_te`, and
#'   `idp`. All may be specified with either spaces or underlines. Defaults to
#'   `"size mean"`.
#' @param resolution single positive integer, the number of points calculated
#'   and plotted, defaults to `100` and must be `>= 10`. Higher numbers lead to
#'   smoother plots, but increases computing time. If the value specified is
#'   higher than the number of simulations (or simulations per split), the
#'   maximum possible value will be used.
#' @param n_split single positive integer, the number of consecutive batches the
#'   simulation results will be split into, which will be plotted separately.
#'   Default is `1` (no splitting); maximum value is the number of simulations
#'   summarised (after restrictions) divided by 10.
#' @param nrow,ncol the number of rows and columns when plotting multiple
#'   metrics in the same plot (using faceting in `ggplot2`). Defaults to `NULL`,
#'   in which case this will be determined automatically.
#'
#' @return A `ggplot2` plot object.
#'
#' @export
#'
#' @importFrom stats sd median quantile
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
#'   # recommended - the plots reflect that, and show that performance metrics
#'   # are not stable and have likely not converged yet
#'
#'   # Convergence plot of mean sample sizes
#'   plot_convergence(res_mult, metrics = "size mean")
#'
#' }
#'
#' if (requireNamespace("ggplot2", quietly = TRUE)){
#'
#'   # Convergence plot of mean sample sizes and ideal design percentages,
#'   # with simulations split in 2 batches
#'   plot_convergence(res_mult, metrics = c("size mean", "idp"), n_split = 2)
#'
#' }
#'
#' @seealso
#' [check_performance()], [summary()], [extract_results()].
#'
plot_convergence <- function(object, metrics = "size mean", resolution = 100,
                             select_strategy = "control if available",
                             select_last_arm = FALSE, select_preferences = NULL,
                             te_comp = NULL, raw_ests = FALSE, final_ests = NULL,
                             restrict = NULL, n_split = 1, nrow = NULL, ncol = NULL,
                             cores = NULL) {

  # Check packages
  assert_pkgs("ggplot2")

  # Extract necessary values from object
  arms <- object$trial_spec$trial_arms$arms
  true_ys <- object$trial_spec$trial_arms$true_ys
  highest_is_best <- object$trial_spec$highest_is_best
  n_rep <- object$n_rep

  # Make list of valid metrics and validate metrics argument
  valid_metrics <- c("size_mean", "size_sd", "size_median", "size_p25", "size_p75",
                     "size_p0", "size_p100", "sum_ys_mean", "sum_ys_sd", "sum_ys_median",
                     "sum_ys_p25", "sum_ys_p75", "sum_ys_p0", "sum_ys_p100", "ratio_ys_mean",
                     "ratio_ys_sd", "ratio_ys_median", "ratio_ys_p25", "ratio_ys_p75",
                     "ratio_ys_p0", "ratio_ys_p100", "prob_conclusive", "prob_superior",
                     "prob_equivalence", "prob_futility", "prob_max",
                     paste0("prob_select_", c(paste0("arm_", arms), "none")),
                     "rmse", "rmse_te", "idp")

  # Validate metrics
  if (!isTRUE(is.character(metrics) & length(metrics) >= 1)) {
    stop0("metrics must be a character vector of length 1 or more specifying valid metric(s) ",
          "to plot, and each metric must be specified only once.")
  } else {
    metrics <- chartr(" ", "_", metrics) # Replace spaces with underlines
    if (!all(metrics %in% valid_metrics)) {
      stop0("Invalid metric(s) specified. Type 'help(plot_convergence)' to see a list of the metrics ",
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
  extr_res <- extract_results(object, select_strategy = select_strategy, select_last_arm = select_last_arm,
                              select_preferences = select_preferences, te_comp = te_comp, raw_ests = raw_ests,
                              final_ests = final_ests, cores = cores)

  if (isTRUE(restrict == "superior")) {
    extr_res <- extr_res[!is.na(extr_res$superior_arm), ]
  } else if (isTRUE(restrict == "selected")) {
    extr_res <- extr_res[!is.na(extr_res$selected_arm), ]
  }
  n_restrict <- nrow(extr_res)

  # Check validity of n_split argument
  if (!verify_int(n_split, min_value = 1, max_value = floor(n_restrict / 10))) {
    stop0("n_split must be a single whole number >=1 and <= the number of simulations ",
          "summarised divided by 10 (in this case: ", floor(n_restrict / 10), ").")
  }

  # Check validity of resolution argument
  if (!verify_int(resolution, min_value = 10)) {
    stop0("resolution must be a whole number >= 10.")
  } else if (resolution > floor(n_restrict / n_split)) {
    resolution <- floor(n_restrict / n_split)
  }
  res_points <- ceiling(seq(from = 0, to = ceiling(n_restrict / n_split), length.out = resolution + 1)[-1])

  # Prepare data for plotting
  plot_dta <- list()
  for (p in seq_along(metrics)) {
    cur_metric <- metrics[p]
    # Get current function
    if (substr(cur_metric, 1, 16) == "prob_select_arm_") {
      cur_arm <- substr(cur_metric, 17, nchar(cur_metric))
      cur_fun <- function(i) sum(extr_res$selected_arm[start_id:i] == cur_arm, na.rm = TRUE) / n_restrict  * 100
    } else {
      cur_fun <- switch(cur_metric,
                        size_mean = function(i) mean(extr_res$final_n[start_id:i]),
                        size_sd = function(i) sd(extr_res$final_n[start_id:i]),
                        size_median = function(i) median(extr_res$final_n[start_id:i]),
                        size_p25 = function(i) quantile(extr_res$final_n[start_id:i], probs = 0.25, names = FALSE),
                        size_p75 = function(i) quantile(extr_res$final_n[start_id:i], probs = 0.75, names = FALSE),
                        size_p0 = function(i) min(extr_res$final_n[start_id:i]),
                        size_p100 = function(i) max(extr_res$final_n[start_id:i]),
                        sum_ys_mean = function(i) mean(extr_res$sum_ys[start_id:i]),
                        sum_ys_sd = function(i) sd(extr_res$sum_ys[start_id:i]),
                        sum_ys_median = function(i) median(extr_res$sum_ys[start_id:i]),
                        sum_ys_p25 = function(i) quantile(extr_res$sum_ys[start_id:i], probs = 0.25, names = FALSE),
                        sum_ys_p75 = function(i) quantile(extr_res$sum_ys[start_id:i], probs = 0.75, names = FALSE),
                        sum_ys_p0 = function(i) min(extr_res$sum_ys[start_id:i]),
                        sum_ys_p100 = function(i) max(extr_res$sum_ys[start_id:i]),
                        ratio_ys_mean = function(i) mean(extr_res$ratio_ys[start_id:i]),
                        ratio_ys_sd = function(i) sd(extr_res$ratio_ys[start_id:i]),
                        ratio_ys_median = function(i) median(extr_res$ratio_ys[start_id:i]),
                        ratio_ys_p25 = function(i) quantile(extr_res$ratio_ys[start_id:i], probs = 0.25, names = FALSE),
                        ratio_ys_p75 = function(i) quantile(extr_res$ratio_ys[start_id:i], probs = 0.75, names = FALSE),
                        ratio_ys_p0 = function(i) min(extr_res$ratio_ys[start_id:i]),
                        ratio_ys_p100 = function(i) max(extr_res$ratio_ys[start_id:i]),
                        prob_conclusive = function(i) mean(extr_res$final_status[start_id:i] != "max") * 100,
                        prob_superior = function(i) mean(extr_res$final_status[start_id:i] == "superiority") * 100,
                        prob_equivalence = function(i) mean(extr_res$final_status[start_id:i] == "equivalence") * 100,
                        prob_futility = function(i) mean(extr_res$final_status[start_id:i] == "futility") * 100,
                        prob_max = function(i) mean(extr_res$final_status[start_id:i] == "max") * 100,
                        prob_select_none = function(i) mean(is.na(extr_res$selected_arm[start_id:i])) * 100,
                        rmse = function(i) sqrt(mean(extr_res$sq_err[start_id:i], na.rm = TRUE)) %f|% NA,
                        rmse_te = function(i) sqrt(mean(extr_res$sq_err_te[start_id:i], na.rm = TRUE)) %f|% NA,
                        idp = function(i) calculate_idp(extr_res$selected_arm[start_id:i], arms, true_ys, highest_is_best) %f|% NA
      )
    }

    # Extract data
    start_id <- 1
    for (s in 1:n_split) {
      cur_idx <- res_points + start_id - 1
      if (max(cur_idx) > n_restrict) {
        cur_idx[length(cur_idx)] <- n_restrict
      }
      plot_dta[[n_split * (p-1) + s]] <- data.frame(
        res_points = cur_idx - (start_id - 1),
        y = vapply_num(cur_idx, cur_fun),
        metric = cur_metric,
        split = s
      )
      start_id <- max(cur_idx) + 1
    }
  }
  # Convert to data.frame and format appropriately
  plot_dta <- do.call(rbind, plot_dta)
  plot_dta <- transform(plot_dta,
                        split = factor(split),
                        metric = factor(metric, levels = metrics))

  # Make nicely formatted labels and add to the data.frame
  metric_labels <- chartr("_", " ", valid_metrics)
  substr(metric_labels, 1, 1) <- toupper(substr(metric_labels, 1, 1))
  metric_labels <- gsub("sd", "SD", metric_labels)
  metric_labels <- vapply_str(metric_labels, function(l) ifelse(grepl("Prob", l, fixed = TRUE), paste0("Pr(", substr(l, 6, nchar(l)), ") (%)"), l))
  metric_labels[metric_labels == "Idp"] <- "IDP (%)"
  metric_labels[metric_labels == "Rmse"] <- "RMSE"
  metric_labels[metric_labels == "Rmse te"] <- "RMSE TE"
  metric_labels <- gsub("select ", "", metric_labels)
  plot_dta$labels <- factor(vapply_str(plot_dta$metric, function(l) metric_labels[which(l == valid_metrics)]),
                            levels = vapply_str(metrics, function(l) metric_labels[which(l == valid_metrics)]))

  # Make the base plot
  p <- ggplot2::ggplot(data = plot_dta, ggplot2::aes(res_points, y)) +
    ggplot2::geom_line(ggplot2::aes(group = split), show.legend = FALSE) +
    ggplot2::scale_x_continuous(limits = c(0, max(res_points)),
                                name = ifelse(n_split == 1, "Number of simulations", "Number of simulations per split"),
                                expand = ggplot2::expansion(mult = c(0, 0.035))) +
    ggplot2::theme_bw()
  # Add y-label or facet
  if (length(metrics) == 1) { # Only 1 metric
    p <- p +
      ggplot2::scale_y_continuous(name = plot_dta$labels[1])
  } else { # Multiple metrics plotted
    if (is.null(nrow) & is.null(ncol)) { # Set nrow if both nrow and ncol are NULL
      nrow <- ceiling(sqrt(length(metrics)))
    }
    p <- p +
      ggplot2::scale_y_continuous(name = NULL) +
      ggplot2::facet_wrap(ggplot2::vars(labels), scales = "free", nrow = nrow, ncol = ncol, strip.position = "left") +
      ggplot2::theme(strip.background = ggplot2::element_blank(), strip.placement = "outside")
  }
  # Return
  p
}
