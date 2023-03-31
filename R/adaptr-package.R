#' adaptr: Adaptive Trial Simulator
#'
#' @docType package
#' @name adaptr-package
#' @aliases adaptr
#'
#' @description
#' \if{html}{
#'   \figure{adaptr.png}{options: width="120" alt="logo"}
#'   \emph{Adaptive Trial Simulator}
#' }
#'
#' The `adaptr` package simulates adaptive (multi-arm, multi-stage) randomised
#' clinical trials using adaptive stopping, adaptive arm dropping and/or
#' response-adaptive randomisation. The package is developed as part of the
#' [INCEPT (Intensive Care Platform Trial) project](https://incept.dk/),
#' funded primarily by a grant from
#' [Sygeforsikringen "danmark"](https://www.sygeforsikring.dk/).
#'
#' @details
#' The `adaptr` package contains the following primary functions (in order of
#' typical use):
#'
#' 1. The [setup_cluster()] initiates a parallel computation cluster that can
#' be used to run simulations and post-processing in parallel, increasing speed.
#' Details on parallelisation and other options for running `adaptr`
#' functions in parallel are described in the [setup_cluster()] documentation.
#' 2. The [setup_trial()] function is the general function that sets up a trial
#' specification. The simpler, special-case functions [setup_trial_binom()] and
#' [setup_trial_norm()] may be used for easier specification of trial designs
#' using binary, binomially distributed or continuous, normally distributed
#' outcomes, respectively, with some limitations in flexibility.
#' 3. The [calibrate_trial()] function calibrates a trial specification to
#' obtain a certain value for a performance metric (typically used to calibrate
#' the Bayesian type 1 error rate in a scenario with no between-arm
#' differences), using the functions below.
#' 4. The [run_trial()] and [run_trials()] functions are used to conduct single
#' or multiple simulations, respectively, according to a trial specification
#' setup as described in #2.
#' 5. The [extract_results()], [check_performance()] and [summary()] functions
#' are used to extract results from multiple trial simulations, calculate
#' performance metrics, and summarise results. The [plot_convergence()] function
#' assesses stability of performance metrics according to the number of
#' simulations conducted. The [plot_metrics_ecdf()] function plots empirical
#' cumulative distribution functions for numerical performance metrics. The
#' [check_remaining_arms()] function summarises all combinations of remaining
#' arms across multiple trials simulations.
#' 6. The [plot_status()] and [plot_history()] functions are used to plot the
#' overall trial/arm statuses for multiple simulated trials or the history of
#' trial metrics over time for single/multiple simulated trials, respectively.
#'
#' For further information see the documentation of each function or the
#' **Overview** vignette (`vignette("Overview", package = "adaptr")`) for an
#' example of how the functions work in combination.
#' For further examples and guidance on setting up trial specifications, see the
#' [setup_trial()] documentation, the **Basic examples** vignette
#' (`vignette("Basic-examples", package = "adaptr")`) and the
#' **Advanced example** vignette
#' (`vignette("Advanced-example", package = "adaptr")`).
#'
#' If using the package, please consider citing it using
#' `citation(package = "adaptr")`.
#'
#' @references
#'
#' Granholm A, Jensen AKG, Lange T, Kaas-Hansen BS (2022). adaptr: an R package
#' for simulating and comparing adaptive clinical trials. Journal of Open Source
#' Software, 7(72), 4284. \doi{10.21105/joss.04284}
#'
#' Granholm A, Kaas-Hansen BS, Lange T, Schjørring OL, Andersen LW, Perner A,
#' Jensen AKG, Møller MH (2022). An overview of methodological considerations
#' regarding adaptive stopping, arm dropping and randomisation in clinical
#' trials. J Clin Epidemiol. \doi{10.1016/j.jclinepi.2022.11.002}
#'
#' [Website/manual](https://inceptdk.github.io/adaptr/)
#'
#' [GitHub repository](https://github.com/INCEPTdk/adaptr/)
#'
#'
#' @seealso
#' [setup_cluster()], [setup_trial()], [setup_trial_binom()],
#' [setup_trial_norm()], [calibrate_trial()], [run_trial()], [run_trials()],
#' [extract_results()], [check_performance()], [summary()],
#' [check_remaining_arms()], [plot_convergence()], [plot_metrics_ecdf()],
#' [print()], [plot_status()], [plot_history()].
#'
NULL
