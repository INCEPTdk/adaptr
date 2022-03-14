#' Make x-axis scale for history/status plots
#'
#' Used internally. Prepares the x-axis scale for history/status plots.
#' Requires the `ggplot2` package installed.
#'
#' @inheritParams plot_history

#' @return An appropriate scale for the `ggplot2` plot x-axis according to
#'   the value specified in `x_value`.
#'
#' @keywords internal
#'
make_x_scale <- function(x_value) {
  if (x_value == "look") {
    ggplot2::scale_x_continuous(name = "Look",
                                limits = c(1, NA),
                                expand = c(0, 0))
  } else if (x_value == "total n") {
    ggplot2::scale_x_continuous(name = "Total no. of patients randomised",
                                limits = c(0, NA),
                                expand = c(0, 0))
  }
}



#' Make y-axis scale for history/status plots
#'
#' Used internally. Prepares the y-axis scale for history/status plots.
#' Requires the `ggplot2` package installed.
#'
#' @inheritParams plot_history

#' @return An appropriate scale for the `ggplot2` plot y-axis according to
#'   the value specified in `y_value`.
#'
#' @keywords internal
#'
make_y_scale <- function(y_value) {
  pct_args <- list(breaks = seq(from = 0, to = 1, by = 0.2),
                   minor_breaks = seq(from = 0, to = 1, by = 0.05),
                   labels = paste0(0:5 * 20, "%"),
                   limits = c(0, 1),
                   expand = c(0, 0))

  num_args <- list(limits = c(0, NA),
                   expand = c(0, 0))

  args <- switch(
    y_value,
    "prob" = c(pct_args, name = "Allocation probability"),
    "pct" = c(pct_args, name = "Percentage randomised"),
    "n" = c(num_args, name = "No. of patients randomised"),
    "sum ys" = c(num_args, name = "Sum of outcomes"),
    "ratio ys" = c(num_args, name = "Ratio of outcomes"),
    "status" = c(pct_args, name = "Status probabilities")
  )

  do.call(ggplot2::scale_y_continuous, args)
}
