#' Plot statuses
#'
#' Plots the statuses over time of multiple simulated trials (overall or for a
#' specific arm). Requires the `ggplot2` package installed.
#'
#' @inheritParams extract_results
#' @inheritParams plot_history
#' @param arm character string of one or more unique, valid `arm` names, `NA`,
#'  or `NULL` (default). If `NULL`, the overall trial statuses are plotted,
#'  otherwise the specified arms or all arms (if `NA`) are plotted.
#' @param area list of styling settings for the area as per \pkg{ggplot2}
#'   conventions (e.g., `alpha`, `size`). The default (`list(alpha = 0.5)`) sets
#'   the transparency to 50% so overlain shaded areas are visible.
#' @param nrow,ncol the number of rows and columns when plotting statuses for
#'   multiple arms in the same plot (using faceting in `ggplot2`). Defaults to
#'   `NULL`, in which case this will be determined automatically where relevant.
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
#'   # Plot trial statuses for all arms
#'   plot_status(res_mult, arm = NA)
#'
#'   # Do not return/print last plot in documentation
#'   invisible(NULL)
#' }
#'
#' @seealso
#' [plot_history()].
#'
plot_status <- function(object, x_value = "look", arm = NULL,
                        area = list(alpha = 0.5), nrow = NULL, ncol = NULL) {
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
                                      area = list(alpha = 0.5), nrow = NULL, ncol = NULL) {

  assert_pkgs("ggplot2")

  adaptr_version <- object$trial_spec$adaptr_version
  if (is.null(adaptr_version) | isTRUE(adaptr_version < .adaptr_version)) {
    stop0("object was created by a previous version of adaptr and cannot be used ",
          "by this version of adaptr unless the object is updated. ",
          "Type 'help(\"update_saved_trials\")' for help on updating.")
  }

  if (!isTRUE(x_value %in% c("look", "total n", "followed n") & length(x_value) == 1)) {
    stop0("x_value must be either 'look', 'total n', or 'followed n'.")
  }

  # Validate arm(s)
  arm_null <- is.null(arm)
  if (!arm_null) {
    available_arms <- object$trial_spec$trial_arms$arms
    if (all(is.na(arm)) & length(arm) == 1) { # Single NA supplied - use all arms
      arm <- available_arms
    } else if (!isTRUE(all(arm %in% available_arms) & length(arm) == length(unique(arm)))) { # Multiple values or 1 arm other than NA supplied
      stop0("arm must be either NULL, NA, or one or multiple unique, valid trial arm(s).")
    }
  }

  # Extract data and prepare legend colours
  if (arm_null) {
    dta <- extract_statuses(object, x_value = x_value, arm = arm)
  } else {
    dta <- list()
    for (i in seq_along(arm)) {
      cur_dta <- extract_statuses(object, x_value = x_value, arm = arm[i])
      cur_dta$facet <- paste0("Arm: ", arm[i])
      dta[[i]] <- cur_dta
    }
    dta <- do.call(rbind, dta)
    dta$facet <- factor(dta$facet, levels = paste0("Arm: ", arm))
  }

  colours <- c(Recruiting = "grey50", Inferiority = "darkred", Futility = "#5C3D00",
               Equivalence = "navy", Superiority = "darkgreen")

  # Make the base plot
  p <- ggplot2::ggplot(dta, ggplot2::aes(x = x, y = p, fill = status)) +
    do.call(ggplot2::geom_area, area %||% formals()$area) +
    ggplot2::scale_fill_manual(values = colours, breaks = levels(dta$status)) +
    make_x_scale(x_value) +
    make_y_scale("status") +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.title = ggplot2::element_blank())
  # Facet if plotting one or more arms (to add arm labels to the top)
  if (!arm_null) {
    if (is.null(nrow) & is.null(ncol)) { # Set nrow if both nrow and ncol are NULL
      nrow <- ceiling(sqrt(length(arm)))
    }
    p <- p +
      ggplot2::facet_wrap(ggplot2::vars(facet), nrow = nrow, ncol = ncol, strip.position = "top") +
      ggplot2::theme(strip.background = ggplot2::element_blank(), strip.placement = "outside")
  }
  # Return
  p
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
  data_looks <- object$trial_spec$data_looks
  randomised_at_looks <- object$trial_spec$randomised_at_looks
  overall_final_looks <- vapply_num(object$trial_results, function(x) x$final_n)
  overall_final_followed <- vapply_num(object$trial_results, function(x) x$followed_n)
  overall_statuses <- vapply_str(object$trial_results, function(x) x$final_status)

  if (is.null(arm)) { # Overall statuses
    final_looks <- overall_final_looks
    final_followed <- overall_final_followed
    statuses <- ifelse(overall_statuses == "max", "active", overall_statuses)
  } else { # Statuses for specific arm
    idx <- which(object$trial_spec$trial_arms$arms == arm)
    final_followed <- vapply_num(object$trial_results, function(x) x$trial_res$status_look[idx])
    final_followed <- ifelse(is.na(final_followed), overall_final_followed, final_followed)
    final_looks <- vapply_num(final_followed, function(l) randomised_at_looks[which(data_looks == l)])
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

  data_looks <- data_looks[data_looks <= max(final_followed)]
  randomised_at_looks <- randomised_at_looks[randomised_at_looks <= max(final_looks)]

  # Create matrix or probabilities, fill values, bind results to data.frame
  status_levels <- c("Recruiting", "Inferiority", "Futility", "Equivalence", "Superiority")
  m <- matrix(rep(NA, length(data_looks) * 8), ncol = 8, dimnames = list(NULL, c("i", "nf", "nr", status_levels)))
  for (i in seq_along(randomised_at_looks)) {
    m[i, 1] <- i
    m[i, 2] <- data_looks[i]
    m[i, 3] <- randomised_at_looks[i]
    m[i, 4] <- mean(statuses == "active" | final_looks > randomised_at_looks[i])
    m[i, 5] <- mean(statuses == "inferiority" & final_looks <= randomised_at_looks[i])
    m[i, 6] <- mean(statuses == "futility" & final_looks <= randomised_at_looks[i])
    m[i, 7] <- mean(statuses == "equivalence" & final_looks <= randomised_at_looks[i])
    m[i, 8] <- mean(statuses == "superiority" & final_looks <= randomised_at_looks[i])
  }
  m <- as.data.frame(m)

  dta <- do.call(
    rbind,
    lapply(status_levels, function(s) cbind(m[, c("i", "nf", "nr")], p = m[[s]], status = s)
    )
  )

  dta$x <- switch(
    x_value,
    "look" = dta$i,
    "total n" = dta$nr,
    "followed n" = dta$nf
  )

  if (x_value == "look") {
    dta <- dta[, c("x", "status", "p")]
  } else if (x_value %in% c("total n", "followed n")) {
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
