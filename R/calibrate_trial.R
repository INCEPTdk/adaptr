#' Calibrate trial specification
#'
#' This function calibrates a trial specification using a Gaussian process-based
#' Bayesian optimisation algorithm.
#' The function calibrates an input trial specification object (using repeated
#' calls to [run_trials()] while adjusting the trial specification) to a
#' `target` value within a `search_range` in a single input dimension (`x`) in
#' order to find an optimal value (`y`).\cr
#' The default (and expectedly most common use case) is to calibrate a trial
#' specification to adjust the `superiority` and `inferiority` thresholds to
#' obtain a certain probability of superiority; if used with a trial
#' specification with identical underlying outcomes (no between-arm
#' differences), this probability is an estimate of the Bayesian analogue of the
#' total type-1 error rate for the outcome driving the adaptations, and if
#' between-arm differences are present, this corresponds to an estimate of the
#' Bayesian analogue of the power.\cr
#' The default is to perform the calibration while varying single, constant,
#' symmetric thresholds for `superiority` / `inferiority` throughout a trial
#' design, as described in **Details**, and the default values have been chosen
#' to function well in this case.\cr
#' Advanced users may use the function to calibrate trial specifications
#' according to other metrics - see **Details** for how to specify a custom
#' function used to modify (or recreate) a trial specification object during
#' the calibration process.\cr
#' The underlying Gaussian process model and its control hyperparameters are
#' described under **Details**, and the model is partially based on code from
#' Gramacy 2020 (with permission; see **References**).
#'
#' @inheritParams run_trials
#' @param n_rep single integer, the number of simulations to run at each
#'   evaluation. Values `< 100` are not permitted; values `< 1000` are permitted
#'   but recommended against.
#' @param base_seed single integer or `NULL` (default); the random seed used as
#'   the basis for all simulation runs (see [run_trials()]) and random number
#'   generation within the rest of the calibration process; if used, the global
#'   random seed will be restored after the function has been run.\cr
#'   **Note:** providing a `base_seed` is highly recommended, as this will
#'   generally lead to faster and more stable calibration.
#' @param fun `NULL` (the default), in which case the trial specification will
#'   be calibrated using the default process described above and further in
#'   **Details**; otherwise a user-supplied function used during the calibration
#'   process, which should have a structure as described in **Details**.
#' @param target single finite numeric value (defaults to `0.05`); the target
#'   value for `y` to calibrate the `trial_spec` object to.
#' @param search_range finite numeric vector of length `2`; the lower and upper
#'   boundaries in which to search for the best `x`. Defaults to `c(0.9, 1.0)`.
#' @param tol single finite numeric value (defaults to `target / 10`); the
#'   accepted tolerance (in the direction(s) specified by `dir`) accepted; when
#'   a `y`-value within the accepted tolerance of the target is obtained, the
#'   calibration stops.\cr
#'   **Note:** `tol` should be specified to be sensible considering `n_rep`;
#'   e.g., if the probability of superiority is targeted with `n_rep == 1000`, a
#'   `tol` of `0.01` will correspond to `10` simulated trials.\cr
#'   A too low `tol` relative to `n_rep` may lead to very slow calibration or
#'   calibration that cannot succeed regardless of the number of iterations.\cr
#'   **Important:** even when a large number of simulations are conducted,
#'   using a very low `tol` may lead to calibration not succeeding as it may
#'   also be affected by other factors, e.g., the total number of simulated
#'   patients, the possible maximum differences in simulated outcomes, and the
#'   number of posterior draws (`n_draws` in the [setup_trial()] family of
#'   functions), which affects the minimum differences in posterior
#'   probabilities when simulating trials and thus can affect calibration,
#'   including when using the default calibration function. Increasing the
#'   number of posterior draws or the number of repetitions should be attempted
#'   if the desired tolerance cannot be achieved with lower numbers.
#' @param dir single numeric value; specifies the direction(s) of the tolerance
#'   range. If `0` (the default) the tolerance range will be `target - tol` to
#'   `target + tol`. If `< 0`, the range will be `target - tol` to `target`, and
#'   if `> 0`, the range will be `target` to `target + tol`.
#' @param init_n single integer `>= 2`. The number of initial evaluations
#'   evenly spread over the `search_range`, with one evaluation at each boundary
#'   (thus, the default value of `2` is the minimum permitted value; if
#'   calibrating according to a different target than the default, a higher
#'   value may be sensible).
#' @param iter_max  single integer `> 0` (default `25`). The maximum number of
#'   new evaluations after the initial grid (with size specified by `init_n`)
#'   has been set up. If calibration is unsuccessful after the maximum number
#'   of iterations, the `prev_x` and `prev_y` arguments (described below) may be
#'   used to to start a new calibration process re-using previous evaluations.
#' @param resolution single integer (defaults to `5000`), size of the grid at
#'   which the predictions used to select the next value to evaluate at are
#'   made.\cr
#'   **Note:** memory use will substantially increase with higher values. See
#'   also the `narrow` argument below.
#' @param kappa single numeric value `> 0` (default `0.5`); corresponding to the
#'   width of the uncertainty bounds used to find the next target to evaluate.
#'   See **Details**.
#' @param pow single numerical value in the `[1, 2]` range (default `1.95`),
#'   controlling the smoothness of the Gaussian process. See **Details**.
#' @param lengthscale single numerical value (defaults to `1`) or numerical
#'   vector of length `2`; values must be finite and non-negative. If a single
#'   value is provided, this will be used as the `lengthscale` hyperparameter;
#'   if a numerical vector of length `2` is provided, the second value must be
#'   higher than the first and the optimal `lengthscale` in this range will be
#'   found using an optimisation algorithm. If any value is `0`, a small amount
#'   of noise will be added as lengthscales must be `> 0`. Controls smoothness
#'   in combination with `pow`. See **Details**.
#' @param scale_x single logical value; if `TRUE` (the default) the `x`-values
#'   will be scaled to the `[0, 1]` range according to the minimum/maximum
#'   values provided. If `FALSE`, the model will use the original scale. If
#'   distances on the original scale are small, scaling may be preferred. The
#'   returned values will always be on the original scale. See **Details**.
#' @param noisy single logical value; if `FALSE`, a noiseless process is
#'   assumed, and interpolation between values is performed (i.e., with no
#'   uncertainty at the `x`-values assumed). If `TRUE`, the `y`-values are
#'   assumed to come from a noisy process, and regression is performed (i.e.,
#'   some uncertainty at the evaluated `x`-values will be assumed and included
#'   in the predictions). Specifying `FALSE` requires a `base_seed` supplied,
#'   and is generally recommended, as this will usually lead to faster and more
#'   stable calibration. If a low `n_rep` is used (or if trials are calibrated
#'   to other metrics other than the default), specifying `TRUE` may be
#'   necessary even when using a valid `base_seed`. Defaults to `TRUE` if a
#'   `base_seed` is supplied and `FALSE` if not.
#' @param narrow single logical value. If `FALSE`, predictions are evenly spread
#'   over the full `x`-range. If `TRUE`, the prediction grid will be spread
#'   evenly over an interval consisting of the two `x`-values with
#'   corresponding `y`-values closest to the target in opposite directions. Can
#'   only be `TRUE` when a `base_seed` is provided and `noisy` is `FALSE` (the
#'   default value is `TRUE` in that case, otherwise it is `FALSE`), and only if
#'   the function can safely be assumed to be only monotonically increasing or
#'   decreasing (which is generally reasonable if the default is used for
#'   `fun`), in which case this will lead to a faster search and a smoother
#'   prediction grid in the relevant region without increasing memory use.
#' @param prev_x,prev_y numeric vectors of equal lengths, corresponding to
#'   previous evaluations. If provided, these will be used in the calibration
#'   process (added before the initial grid is setup, with values in the grid
#'   matching values in `prev_x` leading to those evaluations being skipped).
#' @param path single character string or `NULL` (the default); if a valid file
#'   path is provided, the calibration results will either be saved to this path
#'   (if the file does not exist or if `overwrite` is `TRUE`, see below) or the
#'   previous results will be loaded and returned (if the file exists,
#'   `overwrite` is `FALSE`, and if the input `trial_spec` and central control
#'   settings are identical to the previous run, otherwise an error is
#'   produced). Results are saved/loaded using the [saveRDS()] / [readRDS()]
#'   functions.
#' @param overwrite single logical, defaults to `FALSE`, in which case previous
#'   results are loaded if a valid file path is provided in `path` and the
#'   object in `path` contains the same input `trial_spec` and the previous
#'   calibration used the same central control settings (otherwise, the function
#'   errors). If `TRUE` and a valid file path is provided in `path`, the
#'   complete calibration function will be run with results saved using
#'   [saveRDS()], regardless of whether or not a previous result was saved
#'   in `path`.
#' @param version passed to [saveRDS()] when saving calibration results,
#'   defaults to `NULL` (as in [saveRDS()]), which means that the current
#'   default version is used. Ignored if calibration results are not saved.
#' @param compress passed to [saveRDS()] when saving calibration results,
#'   defaults to `TRUE` (as in [saveRDS()]), see [saveRDS()] for other options.
#'   Ignored if calibration results are not saved.
#' @param sparse,progress,export,export_envir passed to [run_trials()], see
#'   description there.
#' @param verbose single logical, defaults to `FALSE`. If `TRUE`, the function
#'   will print details on calibration progress.
#' @param plot single logical, defaults to `FALSE`. If `TRUE`, the function
#'   will print plots of the Gaussian process model predictions and return
#'   them as part of the final object; requires the `ggplot2` package installed.
#'
#' @details
#'
#' \strong{Default calibration}
#' \cr\cr
#' If `fun` is `NULL` (as default), the default calibration strategy will be
#' employed. Here, the target `y` is the probability of superiority (as
#' described in [check_performance()] and [summary()]), and the function will
#' calibrate constant stopping thresholds for superiority and inferiority (as
#' described in [setup_trial()], [setup_trial_binom()], and
#' [setup_trial_norm()]), which corresponds to the Bayesian analogues of the
#' type 1 error rate if there are no differences between arms in the trial
#' specification, which we expect to be the most common use case, or the power,
#' if there are differences between arms in the trial specification.\cr
#'
#' The stopping calibration process will, in the default case, use the input `x`
#' as the stopping threshold for superiority and `1 - x` as the stopping
#' threshold for inferiority, respectively, i.e., stopping thresholds will be
#' constant and symmetric.\cr
#'
#' The underlying default function calibrated is typically essentially
#' noiseless if a high enough number of simulations are used with an
#' appropriate random `base_seed`, and generally monotonically decreasing. The
#' default values for the control hyperparameters have been set to normally
#' work well in this case (including `init_n`, `kappa`, `pow`, `lengthscale`,
#' `narrow`, `scale_x`, etc.). Thus, few initial grid evaluations are used in
#' this case, and if a `base_seed` is provided, a noiseless process is assumed
#' and narrowing of the search range with each iteration is performed, and the
#' uncertainty bounds used in the acquisition function (corresponding to
#' quantiles from the posterior predictive distribution) are relatively narrow.
#'
#' \strong{Specifying calibration functions}
#' \cr\cr
#' A user-specified calibration function should have the following structure:
#'
#' ```
#' # The function must take the arguments x and trial_spec
#' # trial_spec is the original trial_spec object which should be modified
#' # (alternatively, it may be re-specified, but the argument should still
#' # be included, even if ignored)
#' function(x, trial_spec) {
#'   # Calibrate trial_spec, here as in the default function
#'   trial_spec$superiority <- x
#'   trial_spec$inferiority <- 1 - x
#'
#'   # If relevant, known y values corresponding to specific x values may be
#'   # returned without running simulations (here done as in the default
#'   # function). In that case, a code block line the one below can be included,
#'   # with changed x/y values - of note, the other return values should not be
#'   # changed
#'   if (x == 1) {
#'     return(list(sims = NULL, trial_spec = trial_spec, y = 0))
#'   }
#'
#'   # Run simulations - this block should be included unchanged
#'   sims <- run_trials(trial_spec, n_rep = n_rep, cores = cores,
#'                      base_seed = base_seed, sparse = sparse,
#'                      progress = progress, export = export,
#'                      export_envir = export_envir)
#'
#'  # Return results - only the y value here should be changed
#'  # summary() or check_performance() will often be used here
#'  list(sims = sims, trial_spec = trial_spec,
#'       y = summary(sims)$prob_superior)
#' }
#' ```
#'
#' **Note:** changes to the trial specification are **not validated**; users who
#' define their own calibration function need to ensure that changes to
#' calibrated trial specifications does not lead to invalid values; otherwise,
#' the procedure is prone to error when simulations are run. Especially, users
#' should be aware that changing `true_ys` in a trial specification generated
#' using the simplified [setup_trial_binom()] and [setup_trial_norm()] functions
#' requires changes in multiple places in the object, including in the functions
#' used to generate random outcomes, and in these cases (and otherwise if in
#' doubt) re-generating the `trial_spec` instead of modifying should be
#' preferred as this is safer and leads to proper validation.
#'
#' **Note:** if the `y` values corresponding to certain `x` values are known,
#' then the user may directly return these values without running simulations
#' (e.g., in the default case an `x` of `1` will require `>100%` or `<0%`
#' probabilities for stopping rules, which is impossible, and hence the `y`
#' value in this case is by definition `1`).
#'
#' \strong{Gaussian process optimisation function and control hyperparameters}
#' \cr\cr
#' The calibration function uses a relatively simple Gaussian optimisation
#' function with settings that should work well for the default calibration
#' function, but can be changed as required, which should be considered if
#' calibrating according to other targets (effects of using other settings may
#' be evaluated in greater detail by setting `verbose` and `plot` to `TRUE`).\cr
#' The function may perform both interpolation (i.e., assuming a noiseless,
#' deterministic process with no uncertainty at the values already evaluated) or
#' regression (i.e., assuming a noisy, stochastic process), controlled by the
#' `noisy` argument.\cr
#'
#' The covariance matrix (or kernel) is defined as:\cr
#'
#' `exp(-||x - x'||^pow / lengthscale)`\cr
#'
#' with `||x -x'||` corresponding to a matrix containing the absolute Euclidean
#' distances of values of `x` (and values on the prediction grid), scaled to
#' the `[0, 1]` range if `scale_x` is `TRUE` and on their original scale if
#' `FALSE`. Scaling i generally recommended (as this leads to more comparable
#' and predictable effects of `pow` and `lengthscale`, regardless of the true
#' scale), and also recommended if the range of values is smaller than this
#' range. The absolute distances are raised to the power `pow`, which must be a
#' value in the `[1, 2]` range. Together with `lengthscale`, `pow` controls the
#' smoothness of the Gaussian process model, with `1` corresponding to less
#' smoothing (i.e., piecewise straight lines between all evaluations if
#' `lengthscale` is `1`) and values `> 1` corresponding to more smoothing. After
#' raising the absolute distances to the chosen power `pow`, the resulting
#' matrix is divided by `lengthscale`. The default is `1` (no change), and
#' values `< 1` leads to faster decay in correlations and thus less smoothing
#' (more wiggly fits), and values `> 1` leads to more smoothing (less wiggly
#' fits). If a single specific value is supplied for `lengthscale` this is used;
#' if a range of values is provided, a secondary optimisation process determines
#' the value to use within that range.\cr
#'
#' Some minimal noise ("jitter") is always added to the diagonals of the
#' matrices where relevant to ensure numerical stability; if `noisy` is `TRUE`,
#' a "nugget" value will be determined using a secondary optimisation process
#' \cr
#'
#' Predictions will be made over an equally spaced grid of `x` values of size
#' `resolution`; if `narrow` is `TRUE`, this grid will only be spread out
#' between the `x` values with corresponding `y` values closest to and below and
#' closes to and above `target`, respectively, leading to a finer grid in the
#' range of relevance (as described above, this should only be used for processes
#' that are assumed to be noiseless and should only be used if the process can
#' safely be assumed to be monotonically increasing or decreasing within the
#' `search_range`). To suggest the next `x` value for evaluations, the function
#' uses an acquisition function based on bi-directional uncertainty bounds
#' (posterior predictive distributions) with widths controlled by the `kappa`
#' hyperparameter. Higher `kappa`/wider uncertainty bounds leads to increased
#' *exploration* (i.e., the algorithm is more prone to select values with high
#' uncertainty, relatively far from existing evaluations), while lower
#' `kappa`/narrower uncertainty bounds leads to increased *exploitation* (i.e.,
#' the algorithm is more prone to select values with less uncertainty, closer to
#' the best predicted mean values). The value in the `x` grid leading with one of
#' the boundaries having the smallest absolute distance to the `target` is
#' chosen (within the narrowed range, if `narrow` is `TRUE`). See
#' Greenhill et al, 2020 under **References** for a general description of
#' acquisition functions.\cr
#'
#' **IMPORTANT:**
#' **we recommend that control hyperparameters are explicitly specified**, even
#' for the default calibration function. Although the default values should be
#' sensible for the default calibration function, these may change in the
#' future. Further, we generally recommend users to perform small-scale
#' comparisons (i.e., with fewer simulations than in the final calibration) of
#' the calibration process with different hyperparameters for specific use cases
#' beyond the default (possibly guided by setting the `verbose` and `plot`
#' options to `TRUE`) before running a substantial number of calibrations or
#' simulations, as the exact choices may have important influence on the speed
#' and likelihood of success of the calibration process.\cr
#' It is the responsibility of the user to specify sensible values for the
#' settings and hyperparameters.
#'
#' @return A list of special class `"trial_calibration"`, which contains the
#'   following elements that can be extracted using `$` or `[[`:
#'   \itemize{
#'     \item `success`: single logical, `TRUE` if the calibration succeeded with
#'       the best result being within the tolerance range, `FALSE` if the
#'       calibration process ended after all allowed iterations without
#'       obtaining a result within the tolerance range.
#'     \item `best_x`: single numerical value, the `x`-value (on the original,
#'       input scale) at which the best `y`-value was found, regardless of
#'       `success`.
#'     \item `best_y`: single numerical value, the best `y`-value obtained,
#'       regardless of `success`.
#'     \item `best_trial_spec`: the best calibrated version of the original
#'       `trial_spec` object supplied, regardless of `success` (i.e., the
#'       returned trial specification object is only adequately calibrated if
#'       `success` is `TRUE`).
#'     \item `best_sims`: the trial simulation results (from [run_trials()])
#'       leading to the best `y`-value, regardless of `success`. If no new
#'       simulations have been conducted (e.g., if the best `y`-value is from
#'       one of the `prev_y`-values), this will be `NULL`.
#'     \item `evaluations`: a two-column `data.frame` containing the variables
#'       `x` and `y`, corresponding to all `x`-values and `y`-values (including
#'       values supplied through `prev_x`/`prev_y`).
#'     \item `input_trial_spec`: the unaltered, uncalibrated, original
#'       `trial_spec`-object provided to the function.
#'     \item `elapsed_time`: the total run time of the calibration process.
#'     \item `control`: list of the most central settings provided to the
#'       function.
#'     \item `fun`: the function used for calibration; if `NULL` was supplied
#'       when starting the calibration, the default function (described in
#'       **Details**) is returned after being used in the function.
#'     \item `adaptr_version`: the version of the `adaptr` package used to run
#'       the calibration process.
#'     \item `plots`: list containing `ggplot2` plot objects of each Gaussian
#'       process suggestion step, only included if `plot` is `TRUE`.
#'   }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Setup a trial specification to calibrate
#' # This trial specification has similar event rates in all arms
#' # and as the default calibration settings are used, this corresponds to
#' # assessing the Bayesian type 1 error rate for this design and scenario
#' binom_trial <- setup_trial_binom(arms = c("A", "B"),
#'                                  true_ys = c(0.25, 0.25),
#'                                  data_looks = 1:5 * 200)
#'
#' # Run calibration using default settings for most parameters
#' res <- calibrate_trial(binom_trial, n_rep = 1000, base_seed = 23)
#'
#' # Print calibration summary result
#' res
#' }
#'
#' @references
#'
#' Gramacy RB (2020). Chapter 5: Gaussian Process Regression. In: Surrogates:
#' Gaussian Process Modeling, Design and Optimization for the Applied Sciences.
#' Chapman Hall/CRC, Boca Raton, Florida, USA.
#' [Available online](https://bookdown.org/rbg/surrogates/chap5.html).
#'
#' Greenhill S, Rana S, Gupta S, Vellanki P, Venkatesh S (2020). Bayesian
#' Optimization for Adaptive Experimental Design: A Review. IEEE Access, 8,
#' 13937-13948. \doi{10.1109/ACCESS.2020.2966228}
#'
calibrate_trial <- function(
  # Calibration-specific arguments
  trial_spec, n_rep = 1000, cores = NULL, base_seed = NULL,
  fun = NULL, target = 0.05, search_range = c(0.9, 1), tol = target / 10, dir = 0,
  init_n = 2, iter_max = 25,
  # Gaussian process control hyperparameters
  resolution = 5000, kappa = 0.5, pow = 1.95, lengthscale = 1,
  scale_x = TRUE, noisy = is.null(base_seed), narrow = !noisy & !is.null(base_seed),
  # Previously evaluated values
  prev_x = NULL, prev_y = NULL,
  # Save calibration
  path = NULL, overwrite = FALSE, version = NULL, compress = TRUE,
  # Arguments of possible interest to pass to run_trials()
  sparse = TRUE, progress = NULL, export = NULL, export_envir = parent.frame(),
  # Verbose and plot
  verbose = FALSE, plot = FALSE
) {

  tic <- Sys.time()

  # Validate trial_spec
  if (!inherits(trial_spec, "trial_spec")) {
    stop0("trial_spec must be a valid trial specification.")
  }

  # Validate n_rep
  if (!verify_int(n_rep, min_value = 100)) {
    stop0("n_rep must be a single integer >= 100 (values < 1000 not recommended).")
  } else if (n_rep < 1000) {
    message("NOTE: values for n_rep < 1000 are not recommended for calibration.")
  }

  # Validate noisy, narrow, and base_seed and set seed
  if (is.null(narrow) | length(narrow) != 1 | any(is.na(narrow)) |
      !is.logical(narrow)) {
    stop0("narrow must be a single TRUE or FALSE.")
  }
  if (isTRUE(noisy)) {
    if (!isFALSE(narrow)) {
      stop0("narrow must be FALSE if noisy is TRUE.")
    }
    if (is.null(base_seed)) {
      message("NOTE: providing a base_seed is highly recommended (see 'help(\"calibrate_trial\")').")
    }
  } else if (isFALSE(noisy)) {
    if (is.null(base_seed)) {
      stop0("base_seed must be provided as a single whole number when noisy is FALSE.")
    }
  } else {
    stop0("noisy must be either FALSE or TRUE.")
  }
  if (!is.null(base_seed)) {
    if (!verify_int(base_seed)) {
      stop0("base_seed must be either NULL (with noisy set to TRUE) or a single whole number.")
    } else { # Valid seed provided
      if (exists(".Random.seed", envir = globalenv(), inherits = FALSE)){ # A global random seed exists (not the case when called from e.g. parallel::parLapply)
        oldseed <- get(".Random.seed", envir = globalenv(), inherits = FALSE)
        on.exit(assign(".Random.seed", value = oldseed, envir = globalenv(), inherits = FALSE), add = TRUE, after = FALSE)
      }
      set.seed(base_seed)
    }
  }

  # Validate target, search range, and tol
  if (!all(is.numeric(target)) | any(!is.finite(target)) | length(target) != 1) {
    stop0("target must be a single finite numerical value.")
  }
  if (!all(is.numeric(search_range)) | any(!is.finite(search_range)) | length(search_range) != 2 |
      isTRUE(search_range[1] >= search_range[2])) {
    stop0("search_range must be a two-length vector of finite, increasing numerical values.")
  }
  if (!all(is.numeric(tol)) | any(!is.finite(tol)) | length(tol) != 1 | any(tol <= 0)) {
    stop0("tol must be a single finite numerical value > 0.")
  }

  # Validate init_n, iter_max, and resolution
  if (!verify_int(init_n, min_value = 2)) {
    stop0("init_n must be a single integer >= 2.")
  }
  if (!verify_int(iter_max, min_value = 1)) {
    stop0("iter_max must be a single integer >= 1.")
  }
  if (!verify_int(resolution, min_value = 100)) {
    stop0("resolution must be a single integer >= 100 (values < 1000 not recommended).")
  } else if (resolution < 1000) {
    message("NOTE: values for resolution < 1000 are not recommended.")
  }

  # Validate kappa, pow, lengthscale, and scale_x
  if (!all(is.numeric(kappa)) | any(!is.finite(kappa)) | length(kappa) != 1 | any(kappa <= 0)) {
    stop0("kappa must be a single finite numerical value > 0.")
  }
  if (!all(is.numeric(pow)) | any(!is.finite(pow)) | length(pow) != 1 | any(pow < 1) | any(pow > 2)) {
    stop0("pow must be a single numerical value between 1 and 2.")
  }
  if (!all(is.numeric(lengthscale)) | any(!is.finite(lengthscale)) | !(length(lengthscale) %in% 1:2) | any(lengthscale < 0)) {
    stop0("lengthscale must be a single numerical or a numerical vector of length two, with the second value ",
          "larger than the first. All values must be finite and non-negative.")
  } else if (length(lengthscale) == 2 & isTRUE(lengthscale[1] >= lengthscale[2])) {
    stop0("If a range is provided for lengthscale, the second value must be larger than the first.")
  }
  if (is.null(scale_x) | length(scale_x) != 1 | any(is.na(scale_x)) |
      !is.logical(scale_x)) {
    stop0("scale_x must be a single TRUE or FALSE.")
  }

  # Validate prev_x and prev_y
  if (!is.null(prev_x) | !is.null(prev_y)) {
    if (!all(is.numeric(prev_x)) | any(!is.finite(prev_x)) |
        !all(is.numeric(prev_y)) | any(!is.finite(prev_y)) |
        length(prev_x) != length(prev_y)) {
      stop0("prev_x and prev_y must either both be NULL or finite numeric vectors of equal length.")
    }
  }

  # Validate overwrite, verbose, and plot and setup plot
  if (is.null(overwrite) | length(overwrite) != 1 | any(is.na(overwrite)) |
      !is.logical(overwrite)) {
    stop0("overwrite must be a single TRUE or FALSE.")
  }
  if (is.null(verbose) | length(verbose) != 1 | any(is.na(verbose)) |
      !is.logical(verbose)) {
    stop0("verbose must be a single TRUE or FALSE.")
  }
  if (is.null(plot) | length(plot) != 1 | any(is.na(plot)) |
      !is.logical(plot)) {
    stop0("plot must be a single TRUE or FALSE.")
  }
  if (plot) {
    assert_pkgs("ggplot2")
    plots <- list()
  }

  # If no function is provided by the user to calibrate, define and use default
  # Default calibrates single matching superiority/inferiority thresholds
  # and returns the probability of superiority
  if (is.null(fun)) {
    fun <- function(x, trial_spec) {
      # Calibrate values
      trial_spec$superiority <- x
      trial_spec$inferiority <- 1 - x

      # Return known result values that do not require simulation
      if (x == 1) {
        # A superiority threshold of 1 and inferiority threshold of 0 should not lead to superiority stopping
        return(list(sims = NULL, trial_spec = trial_spec, y = 0))
      }

      # Run simulations
      sims <- run_trials(trial_spec, n_rep = n_rep, cores = cores,
                         base_seed = base_seed, sparse = sparse,
                         progress = progress, export = export,
                         export_envir = export_envir)

      # Return results
      list(sims = sims, trial_spec = trial_spec, y = summary(sims)$prob_superior)
    }
  } else if (!is.function(fun)) {
    stop0("fun must be either NULL or a function specified as described in 'help(\"calibrate_trial\")'")
  }

  # Prepare tolerance range and make list of control values
  tol_range <- target + tol * c(-1 * (dir <= 0), dir >= 0)
  control <- list(n_rep = n_rep, base_seed = base_seed, target = target,
                  search_range = search_range, tol = tol, dir = dir,
                  init_n = init_n, iter_max = iter_max, resolution = resolution,
                  kappa = kappa, pow = pow, lengthscale = lengthscale,
                  scale_x = scale_x, noisy = noisy, narrow = narrow,
                  prev_x = prev_x, prev_y = prev_y)



  # Check if a previous version should be loaded and returned (only if overwrite is FALSE)
  if (ifelse(!is.null(path) & !overwrite, file.exists(path), FALSE)) {
    prev <- readRDS(path)
    # Compare previous/current objects
    prev_spec_nofun <- prev$input_trial_spec
    spec_nofun <- trial_spec
    prev_spec_nofun$fun_y_gen <- prev_spec_nofun$fun_draws <- prev_spec_nofun$fun_raw_est <- spec_nofun$fun_y_gen <- spec_nofun$fun_draws <- spec_nofun$fun_raw_est <- NULL
    # Compare
    if ((prev$adaptr_version != .adaptr_version)) { # Check version
      stop0("The object in path was created by a previous version of adaptr and ",
            "cannot be used by this version of adaptr unless the object is updated. ",
            "Type 'help(\"update_saved_calibration\")' for help on updating.")
    } else if (!isTRUE(all.equal(prev_spec_nofun, spec_nofun)) | # Check spec besides version
        !equivalent_funs(prev$input_trial_spec$fun_y_gen, trial_spec$fun_y_gen) |
        !equivalent_funs(prev$input_trial_spec$fun_draws, trial_spec$fun_draws) |
        !equivalent_funs(prev$input_trial_spec$fun_raw_est, trial_spec$fun_raw_est)) {
      stop0("The trial specification contained in the object in path is not ",
            "the same as the one provided; thus the previous result was not loaded.")
    } else if (!isTRUE(all.equal(prev$control, control))) { # Compare control arguments
      diff_idxs <- rep(NA, length(control))
      nms <- names(control)
      for (i in seq_along(diff_idxs)) {
        diff_idxs[i] <- !isTRUE(all.equal(prev$control[i], control[i]))
      }
      stop0("The control values contained in the object in path are not ",
            "the same as the ones provided; thus the previous result was not loaded.\n",
            "Differences present in: ", paste(nms[diff_idxs], collapse = ", "), ".")
    } else if (!equivalent_funs(fun, prev$fun)){
      stop0("The calibration function (argument 'fun') in the object in path ",
            "is different from the current calibration function.")
    }
    if (verbose) {
      message(paste0(
        "Loading and returning previous ", ifelse(prev$success, "successful", "unsuccessful"), " calibration results.",
        "\n- Best x: ", prev$best_x, ". Best y: ", prev$best_y, "."
      ))
    }
    return(prev)
  }



  # Prepare additional variables
  best_sims <- best_trial_spec <- best_x <- best_y <- NULL
  success <- FALSE

  # Setup initial grid, use previous x/y values if provided
  evaluations <- data.frame(x = as.numeric(prev_x), y = as.numeric(prev_y))
  if (verbose) {
    message("Setting up initial grid:")
  }

  search_grid <- seq(from = min(search_range), to = max(search_range), length.out = init_n)

  for (i in 1:init_n) {
    x <- search_grid[i]

    # Check if any value is already good enough
    if (nrow(evaluations) > 0) {
      best_idx <- which_nearest(evaluations$y, target, dir)
      best_y <- evaluations$y[best_idx]
      if (best_y >= tol_range[1] & best_y <= tol_range[2]) {
        success <- TRUE
        if (verbose) {
          message(paste0(
            "- Stopping because best y so far falls within ",
            tol_range[1], " to ", tol_range[2], "."
          ))
        }
        break()
      }
    }

    if (verbose) {
      message(paste0("- Evaluating at grid point #", i, "/", init_n, "."))
    }

    # Skip evaluation if already evaluated at x
    if (x %in% evaluations$x) {
      if (verbose) {
        message(paste0("-- Evaluation at x = ", x, " skipped (previously evaluated)."))
      }
      next()
    }

    # Conduct new simulations and save results if they are the best so far
    cur_eval <- fun(x, trial_spec)
    evaluations <- rbind(evaluations, data.frame(x = x, y = cur_eval$y))
    # Save current spec/sim results if they are the best so far
    if (evaluations$x[which_nearest(evaluations$y, target, dir)] == x) {
      best_sims <- cur_eval$sims
      best_trial_spec <- cur_eval$trial_spec
    }
    if (verbose) {
      message(paste0("-- Evaluation at x = ", x, ": y = ", cur_eval$y, "."))
    }
  }

  # Iterations selecting targets using GP (unless already a success)
  if (!success) {
    if (verbose) {
      message("Iterating:")
    }
    for (i in 1:iter_max) {

      # Check if any value is already good enough and stop if that is the case
      best_idx <- which_nearest(evaluations$y, target, dir)
      best_x <- evaluations$x[best_idx]
      best_y <- evaluations$y[best_idx]

      if (best_y >= tol_range[1] & best_y <= tol_range[2]) {
        success <- TRUE
        if (verbose) {
          message(paste0(
            "- Stopping because best y so far falls within ", tol_range[1],
            " to ", tol_range[2], "."
          ))
        }
        break()
      }

      if (verbose) {
        message(paste0(
          "- Iteration #", i, ". Best x so far: ", best_x,
          ". Best y so far: ", best_y, "."
        ))
      }

      # Find new target using Gaussian process and evaluate
      opt <- gp_opt(evaluations$x, evaluations$y, target = target,
                    dir = dir, resolution = resolution,
                    kappa = kappa, pow = pow, lengthscale = lengthscale,
                    scale_x = scale_x, noisy = noisy, narrow = narrow)
      x <- opt$next_x

      # Plot if requested
      if (plot) {
        plots[[i]] <- ggplot2::ggplot(data = opt$predictions) +
          ggplot2::geom_ribbon(ggplot2::aes(x = x, ymin = lub, ymax = uub), colour = "grey", alpha = 0.5) +
          ggplot2::geom_line(ggplot2::aes(x, y_hat)) +
          ggplot2::geom_point(ggplot2::aes(x, y),
                              data = subset(data.frame(x = evaluations$x, y = evaluations$y),
                                            x >= min(opt$predictions$x) & x <= max(opt$predictions$x))) +
          ggplot2::geom_hline(yintercept = target) +
          ggplot2::geom_vline(xintercept = x, linetype = 2) +
          ggplot2::theme_minimal() +
          ggplot2::labs(title = paste0("Iteration #", i, ifelse(narrow, " [narrowed]", "")),
                        subtitle = paste("Suggested x:", x, "(based on", nrow(evaluations), "total evaluations)"), y = "y")
        print(plots[[i]])
      }

      # Evaluate next target
      cur_eval <- fun(x, trial_spec)
      evaluations <- rbind(evaluations, data.frame(x = x, y = cur_eval$y))

      # Save current trial_spec/sims if they are the best so far
      if (evaluations$x[which_nearest(evaluations$y, target, dir)] == x) {
        best_sims <- cur_eval$sims
        best_trial_spec <- cur_eval$trial_spec
      }
      if (verbose) {
        message(paste0("-- Evaluation at x = ", x, ": y = ", cur_eval$y, "."))
      }
    }
  }

  # Finish and prepare return object
  best_idx <- which_nearest(evaluations$y, target, dir)
  best_x <- evaluations$x[best_idx]
  best_y <- evaluations$y[best_idx]
  success <- best_y >= tol_range[1] & best_y <= tol_range[2]
  if (verbose) {
    message(paste0(
      "Finished calibration ", if (success) "successfully" else "without succeeeding",
      ".\n- Best x: ", best_x, ". Best y: ", best_y, "."
    ))
  }

  res <- structure(list(
    success = success,
    best_x = best_x,
    best_y = best_y,
    best_trial_spec = best_trial_spec,
    best_sims = best_sims,
    evaluations = evaluations,
    input_trial_spec = trial_spec,
    elapsed_time = Sys.time() - tic,
    control = control,
    fun = fun,
    adaptr_version = .adaptr_version
  ), class = "trial_calibration")
  if (plot) {
    res$plots <- plots
  }

  # Save if desired
  if (!is.null(path)) {
    saveRDS(res, file = path, version = version, compress = compress)
  }

  # Return
  res
}
