#' Plot statuses
#'
#' Plots the statuses over time of multiple simulated trials (overall or for a
#' specific arm). Requires the `ggplot2` package installed.
#'
#' @inheritParams extract_results
#' @inheritParams plot_history
#' @param arm single character string or `NULL` (default); can be set to a valid
#'   trial `arm`. If `NULL`, the overall trial statuses are plotted, otherwise
#'   the statuses for a single, specific trial arm are plotted.
#' @param area list of styling settings for the area as per \pkg{ggplot2}
#'   conventions (e.g., `alpha`, `size`). The default (`list(alpha = 0.5)`) sets
#'   the transparency to 50% so overlain shaded areas are visible.
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
#'   res_mult <- run_trials(binom_trial, n_rep = 25, base_seed = 12345)
#'
#'   # Plot trial statuses at each look according to total allocations
#'   plot_status(res_mult, x_value = "total n")
#'
#'   # Do not return/print last plot in documentation
#'   invisible(NULL)
#' }
#'
#' @seealso
#' [plot_history()].
#'
plot_status <- function(object, x_value = "look", arm = NULL,
                        area = list(alpha = 0.5)) {
  UseMethod("plot_status")
}



#' Plot statuses for multiple trial simulations
#'
#' @inheritParams plot_status
#'
#' @rdname plot_status
#'
#' @export
#'
plot_status.trial_results <- function(object, x_value = "look", arm = NULL,
                                      area = list(alpha = 0.5)) {

  assert_pkgs("ggplot2")

  if (!isTRUE(x_value %in% c("look", "total n") & length(x_value) == 1)) {
    stop("x_value must be either 'look' or 'total n'.", call. = FALSE)
  }

  # Validate arm
  if (!is.null(arm)) {
    if (!isTRUE(length(arm) == 1 & arm %in% object$trial_spec$trial_arms$arms)) {
      stop("Arm must be either NULL or a single, valid trial arm.", call. = FALSE)
    }
  }

  # Extract data and prepare legend colours
  dta <- extract_statuses(object, x_value = x_value, arm = arm)
  colours <- c(Recruiting = "grey50", Inferiority = "darkred", Futility = "#5C3D00",
               Equivalence = "navy", Superiority = "darkgreen")

  fill_name <- if (is.null(arm)) "Overall statuses" else paste("Arm", arm, "statuses")

  ggplot2::ggplot(dta, ggplot2::aes(x = x, y = p, fill = status)) +
    do.call(ggplot2::geom_area, area %||% formals()$area) +
    ggplot2::scale_fill_manual(values = colours, name = fill_name, breaks = levels(dta$status)) +
    make_x_scale(x_value) +
    make_y_scale("status") +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.title = ggplot2::element_blank())
}



#' Extract statuses
#'
#' Used internally. Extracts overall trial statuses or statuses from a single
#' `arm` from multiple trial simulations. Works with *sparse* results.
#'
#' @param object `trial_results` object from [run_trials()].
#' @inheritParams plot_status.trial_results
#'
#' @return A tidy `data.frame` (one row possible status per look) containing the
#'   following columns:
#'   \itemize{
#'     \item `x`: the look numbers or total number of patients at each look,
#'       as specified in `x_value`.
#'     \item `status`: each possible status (`"Recruiting"`, `"Inferiority"`
#'       (only relevant for individual arms), `"Futility"`, `"Equivalence"`, and
#'       `"Superiority"`, as relevant).
#'     \item `p`: the proportion (`0-1`) of patients with each `status` at each
#'       value of `x`.
#'     \item `value`: as described under `metric`.
#'   }
#'
#' @keywords internal
#'
extract_statuses <- function(object, x_value, arm = NULL) {
  looks <- object$trial_spec$data_looks
  overall_final_looks <- vapply_num(object$trial_results, function(x) x$final_n)
  overall_statuses <- vapply_str(object$trial_results, function(x) x$final_status)

  if (is.null(arm)) { # Overall statuses
    final_looks <- overall_final_looks
    statuses <- ifelse(overall_statuses == "max", "active", overall_statuses)
  } else { # Statuses for specific arm
    idx <- which(object$trial_spec$trial_arms$arms == arm)
    final_looks <- vapply_num(object$trial_results, function(x) x$trial_res$status_look[idx])
    final_looks <- ifelse(is.na(final_looks), overall_final_looks, final_looks)
    statuses <- vapply_str(object$trial_results, function(x) x$trial_res$final_status[idx])

    # Correct statuses
    statuses <- ifelse(
      statuses == "control" & overall_statuses == "equivalence" & overall_final_looks == final_looks,
      "equivalence", # Recode control arms as equivalence in trials stopped for equivalence
      ifelse(
        statuses == "control",
        "active", # Recode other controls as active
        ifelse(
          statuses == "futile",
          "futility",
          ifelse(
            statuses == "superior",
            "superiority",
            ifelse(
              statuses == "inferior",
              "inferiority",
              statuses
            )
          )
        )
      )
    )
  }

  looks <- looks[looks <= max(final_looks)]

  # Create matrix or probabilities, fill values, bind results to data.frame
  status_levels <- c("Recruiting", "Inferiority", "Futility", "Equivalence", "Superiority")
  m <- matrix(rep(NA, length(looks) * 7), ncol = 7, dimnames = list(NULL, c("i", "n", status_levels)))
  for (i in seq_along(looks)) {
    m[i, 1] <- i
    m[i, 2] <- looks[i]
    m[i, 3] <- mean(statuses == "active" | final_looks > looks[i])
    m[i, 4] <- mean(statuses == "inferiority" & final_looks <= looks[i])
    m[i, 5] <- mean(statuses == "futility" & final_looks <= looks[i])
    m[i, 6] <- mean(statuses == "equivalence" & final_looks <= looks[i])
    m[i, 7] <- mean(statuses == "superiority" & final_looks <= looks[i])
  }
  m <- as.data.frame(m)

  dta <- do.call(
    rbind,
    lapply(status_levels, function(s) cbind(m[, c("i", "n")], p = m[[s]], status = s)
    )
  )

  dta$x <- if (x_value == "look") dta$i else dta$n
  if (x_value == "look") {
    dta <- dta[, c("x", "status", "p")]
  } else if (x_value == "total n") {
    dta <- rbind(
      data.frame(x = rep(0, 5), status = status_levels, p = c(1, rep(0, 4))),
      dta[, c("x", "status", "p")]
    )
  }

  # Remove inferiority/equivalence/futility probabilities if not assessed
  if (is.null(arm)) {
    dta <- dta[dta$status != "Inferiority", ]
  }
  if (is.null(object$trial_spec$equivalence_prob)) {
    dta <- dta[dta$status != "Equivalence", ]
  }
  if (is.null(object$trial_spec$futility_prob)) {
    dta <- dta[dta$status != "Futility", ]
  }

  # Recode status as factor and prepare legend colours
  dta$status <- droplevels(factor(dta$status, levels = status_levels))

  # Return
  dta
}
