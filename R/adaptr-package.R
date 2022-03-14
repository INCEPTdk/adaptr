#' adaptr: Adaptive Trial Simulator
#'
#' @docType package
#' @name adaptr-package
#' @aliases adaptr
#'
#' @description
#' \if{html}{\figure{adaptr.png}{options: align="right" width="120" alt="logo"}}
#'
#' The `adaptr` package simulates adaptive (multi-arm) trials using adaptive
#' stopping, adaptive arm dropping and/or response-adaptive randomisation.
#' The package is developed as part of the
#' [INCEPT (Intensive Care Platform Trial) project](https://incept.dk/),
#' funded primarily by a grant from
#' [Sygeforsikringen "danmark"](https://www.sygeforsikring.dk/).
#'
#' @details
#' The `adaptr` package contains the following primary functions:
#'
#' 1. [setup_trial] is the general function that sets up a trial specification.
#' The simpler, special-case functions [setup_trial_binom] and
#' [setup_trial_norm] may be used for easier specification of trial designs
#' using binary, binomially distributed or continuous, normally distributed
#' outcomes, respectively, with some limitations in flexibility.
#' 2. The [run_trial] and [run_trials] functions are used to conduct single or
#' multiple simulations, respectively, according to a trial specification setup
#' as described in #1.
#' 3. The [extract_results] and [summary] functions are used to
#' extract or summarise the results of multiple trial simulations.
#' 4. The [plot_status] and [plot_history] functions are used to plot the
#' overall trial/arm statuses for multiple simulated trials or the history of
#' trial metrics over time for single/multiple simulated trials, respectively.
#'
#' For further information see the function documentation or the **Overview**
#' vignette (`vignette("Overview", package = "adaptr")`) for an example of how
#' the functions work in combination.
#' For further examples and guidance on setting up trial specifications, see
#' [setup_trial] documentation, the **Basic examples** vignette
#' (`vignette("Basic-examples", package = "adaptr")`) and the
#' **Advanced example** vignette
#' (`vignette("Advanced-example", package = "adaptr")`).
#'
#' If using the package, please consider citing it using
#' `citation(package = "adaptr")`.
#'
#' @references
#' [GitHub repository](https://github.com/INCEPTdk/adaptr/)
#'
#' @seealso
#' [setup_trial], [setup_trial_binom], [setup_trial_norm], [run_trial],
#' [run_trials], [extract_results], [summary], [print], [plot_status] and
#' [plot_history].
#'
NULL
