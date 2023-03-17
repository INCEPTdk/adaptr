#' Validate trial specification
#'
#' Used internally. Validates the inputs common to all trial specifications, as
#' specified in [setup_trial()], [setup_trial_binom()] and [setup_trial_norm()].
#'
#' @inheritParams setup_trial
#'
#' @return An object of class `trial_spec` containing the validated trial
#'   specification.
#'
#' @keywords internal
#'
validate_trial <- function(arms, true_ys, start_probs = NULL,
                           fixed_probs = NULL,
                           min_probs = rep(NA, length(arms)),
                           max_probs = rep(NA, length(arms)),
                           data_looks = NULL,
                           max_n = NULL, look_after_every = NULL,
                           randomised_at_looks = NULL,
                           control = NULL, control_prob_fixed = NULL,
                           inferiority = 0.01, superiority = 0.99,
                           equivalence_prob = NULL, equivalence_diff = NULL,
                           equivalence_only_first = NULL, futility_prob = NULL,
                           futility_diff = NULL, futility_only_first = NULL,
                           highest_is_best = FALSE, soften_power = 1,
                           cri_width = 0.95, n_draws = 5000, robust = FALSE,
                           description = NULL, add_info = NULL,
                           fun_y_gen, fun_draws, fun_raw_est) {

  # Count arms before validating inputs and check that they are unique
  n_arms <- length(arms)
  match <- isTRUE(control_prob_fixed == "match")
  # Convert arms to characters
  if (isTRUE(is.numeric(arms) | is.logical(arms))) {
    arms <- as.character(arms)
  }
  if (isTRUE(is.numeric(control) | is.logical(control))) {
    control <- as.character(control)
  }
  if (length(unique(arms)) != length(arms)) {
    stop0("All arms must have unique names.")
  }

  # If control_prob_fixed is set to a valid non-numeric value, then set according to that
  if (!is.null(control_prob_fixed)) {
    if (is.null(control) | sum(control %in% arms) != 1) {
      stop0("control_prob_fixed is specified, but no single valid control is specified.")
    }
    if (isTRUE(length(control_prob_fixed) == 1 & control_prob_fixed %in% c("sqrt-based", "sqrt-based start", "sqrt-based fixed"))) {
      control_prob_fixed_orig <- control_prob_fixed
      if (!is.null(start_probs)) {
        stop0("When control_prob_fixed is set to 'sqrt-based', 'sqrt-based start', ",
              "or 'sqrt-based fixed', start_probs must be NULL.")
      }
      if (control_prob_fixed == "sqrt-based" | control_prob_fixed == "sqrt-based fixed") {
        control_prob_fixed <- vapply_num(n_arms:2, function(x) sqrt(x - 1) / (sqrt(x - 1) + x - 1))
      } else if (control_prob_fixed == "sqrt-based start") {
        control_prob_fixed <- sqrt(n_arms - 1) / (sqrt(n_arms - 1) + n_arms - 1)
      }
      start_probs <- ifelse(arms == control, control_prob_fixed[1], 1 / (sqrt(n_arms - 1) + n_arms - 1))
      if (control_prob_fixed_orig == "sqrt-based fixed") {
        if (!is.null(fixed_probs)) {
          stop0("When control_prob_fixed is set to 'sqrt-based fixed', fixed_probs must be NULL.")
        }
        fixed_probs <- start_probs
      } else {
        if (!isTRUE(is.null(fixed_probs) | isTRUE(is.na(fixed_probs[arms == control])))) {
          stop0("When control_prob_fixed is set to 'sqrt-based' or 'sqrt-based start', ",
                "fixed_probs must either be NULL or NA for the control arm.")
        }
        if (is.null(fixed_probs)) {
          fixed_probs <- rep(NA, n_arms)
        }
        fixed_probs[arms == control] <- start_probs[arms == control]
      }
    }
  }

  # Equal initial allocation if start_probs is not specified or set above
  if (is.null(start_probs)) {
    start_probs <- rep(1 / length(arms), length(arms))
  } else if(match) { # start_probs not null and 'match'
    if (!isTRUE(max(start_probs[!(arms %in% control)], na.rm = TRUE) == start_probs[which(arms %in% control)])) {
      stop0("If control_prob_fixed is set to 'match' and start_probs are specified, the control group starting ",
            "allocation probability must be similar to the highest specified non-control arm allocation probability.")
    }
  }

  # If no fixed_probs are specified, set to NA
  if (is.null(fixed_probs)) {
    fixed_probs <- rep(NA, length(arms))
  }

  # Check that all limits are of correct length
  if (!all(length(start_probs) == n_arms,
           length(fixed_probs) == n_arms,
           length(min_probs) == n_arms,
           length(max_probs) == n_arms)) {
    stop0("arms, start_probs, fixed_probs, min_probs and max_probs must of the same length.")
  }

  # Check that start_probs sum to 1 and that start_probs are not missing
  if (any(is.na(start_probs))) {
    stop0("start_probs values cannot be missing.")
  }
  if (abs(sum(start_probs) - 1) > .Machine$double.eps^0.5) {
    stop0("start_probs values do not sum to 1.")
  }

  # Check that the specified probabilities are valid
  if (any(start_probs > 1) | any(start_probs < 0) |
      any(fixed_probs > 1, na.rm = TRUE) | any(fixed_probs < 0, na.rm = TRUE) |
      any(min_probs > 1, na.rm = TRUE) | any(min_probs < 0, na.rm = TRUE) |
      any(max_probs > 1, na.rm = TRUE) | any(max_probs < 0, na.rm = TRUE)) {
    stop0("All allocation probability values/limits (start_probs, fixed_probs, ",
          "min_probs and max_probs) must be between 0 and 1.")
  }

  # fixed_probs and start_probs must be the same if both are specified, and start_probs must be between min_probs and max_probs if specified
  for (i in 1:n_arms) {
    if (!is.na(fixed_probs[i]) & fixed_probs[i] != start_probs[i]) {
      stop0("When fixed_probs is specified for an arm (including when set by using one of the ",
            "special arguments to control_prob_fixed), it has to equal start_probs for the same arm.")
    }
    if (!is.na(min_probs[i])) {
      if (start_probs[i] < min_probs[i]) {
        stop0("start_probs must be greater than or equal to corresponding min_probs when specified.")
      }
    }
    if (!is.na(max_probs[i])){
      if (start_probs[i] > max_probs[i]) {
        stop0("start_probs must be less than or equal to corresponding max_probs when specified.")
      }
    }
  }

  # Check that combined fixed/minimum probs are not too large or combined fixed/maximum probs
  # are not too small and that only 1 of min/max is specified
  min_check <- numeric(n_arms)
  max_check <- numeric(n_arms)
  for (i in 1:n_arms) {
    # If fixed_probs is specified, min_probs and max_probs must be NA for that arm
    if (!is.na(fixed_probs[i])) {
      if (!is.na(min_probs[i] | !is.na(max_probs[i]))) {
        stop0("When fixed_probs is specified, min_probs and/or max_probs cannot be specified for the ",
              "same arm (also applies if control_prob_fixed is set to 'sqrt-based', 'sqrt-based start', or 'sqrt-based fixed').")
      }
    }
    # If both min_probs and max_probs are specified, max_probs has to be larger than min_probs
    if (!is.na(min_probs[i]) & !is.na(max_probs[i])) {
      if (!(max_probs[i] > min_probs[i])) {
        stop0("When both min_probs and max_probs are specified, max_probs has to be larger than min_probs.")
      }
    }
    min_check[i] <- ifelse(is.na(fixed_probs[i]), min_probs[i], fixed_probs[i])
    max_check[i] <- ifelse(is.na(fixed_probs[i]), max_probs[i], fixed_probs[i])
  }

  if (sum(min_check, na.rm = TRUE) - 1 > .Machine$double.eps^0.5) {
    stop0("The combined fixed_probs/min_probs values specified exceed 1.")
  }

  if (sum(is.na(max_check)) == 0 & sum(max_check) - 1 < -.Machine$double.eps^0.5) {
    stop0("fixed_probs or max_probs specified for all arms, but they sum to less than 1.")
  }

  # Check or setup data looks
  if (!is.null(data_looks)) { # data_looks is specified, validate that
    n_data_looks <- length(data_looks)
    if (!is.numeric(data_looks) | any(data_looks != cummax(data_looks)) | any(data_looks <= c(0, data_looks[-n_data_looks])) | isTRUE(any(data_looks < 1)) | isTRUE(any(is.na(data_looks)))) {
      stop0("data_looks must be a numeric vector with values > 0 and of increasing size.")
    }
    if (!is.null(max_n) | !is.null(look_after_every)) {
      stop0("If data_looks is specified, both max_n and look_after_every must be NULL.")
    }
  } else { # data_looks is not specified, generate from max_n and look_after every and validate those
    if (is.null(max_n) | is.null(look_after_every)) {
      stop0("If data_looks is not specified, max_n and look_after_every each must be specified ",
            "as whole numbers of size 1.")
    }
    if (!verify_int(max_n, min_value = 1) | !verify_int(look_after_every, min_value = 1)) {
      stop0("If data_looks is not specified, max_n and look_after_every each must be specified ",
            "as whole numbers of size 1 with values > 0.")
    } else { # Values are OK - create data_looks
      n_data_looks <- ceiling(max_n/look_after_every)
      data_looks <- look_after_every * 1:n_data_looks
      data_looks[n_data_looks] <- ifelse(data_looks[n_data_looks] > max_n, max_n, data_looks[n_data_looks])
    }
  }
  data_looks <- round(data_looks, digits = 10) # Round to avoid floating point errors
  if (!all(vapply_lgl(data_looks, verify_int, min_value = 1))) {
    stop0("data_looks must only include whole numbers > 0.")
  }

  # Check or setup total number of patients randomised
  if (is.null(randomised_at_looks)) {
    randomised_at_looks <- data_looks
  } else if (!is.numeric(randomised_at_looks) | any(randomised_at_looks != cummax(randomised_at_looks)) | isTRUE(any(randomised_at_looks < 1)) |
             isTRUE(any(is.na(randomised_at_looks)))) {
    stop0("randomised_at_looks must be a numeric vector with values > 0 and of increasing size.")
  } else if (length(randomised_at_looks) != length(data_looks) | isTRUE(any(data_looks > randomised_at_looks))) {
    stop0("randomised_at_looks must match the number of adaptive analyses specified and ",
          "all numbers must be >= the number of patients with available outcome data ",
          "at each analysis, as specified by data_looks or max_n/look_after_every.")
  }
  randomised_at_looks <- round(randomised_at_looks, digits = 10) # Round to avoid floating point errors
  if (!all(vapply_lgl(randomised_at_looks, verify_int, min_value = 1))) {
    stop0("randomised_at_looks must only include whole numbers > 0.")
  }

  # Common control checks
  if (!is.null(control)) {
    if (!(control) %in% arms | length(control) != 1) {
      stop0("control must be a single character string matching one of the arms.")
    }
    if (!is.null(control_prob_fixed)) {
      if (!(length(control_prob_fixed) %in% c(1, n_arms - 1)) | any(control_prob_fixed > 1) | any(control_prob_fixed < 0)) {
        if (!isTRUE(control_prob_fixed == "match")) {
          stop0("control_prob_fixed must be either NULL, a numeric vector with values between 0 and 1 of length 1 ",
                "or (number of arms - 1), or one of the following: 'sqrt-based', 'sqrt-based start', 'sqrt-based fixed' or 'match'.")
        }
      }
      control_index <- arms == control
      if (!is.na(min_probs[control_index]) | !is.na(max_probs[control_index])) {
        stop0("When control_prob_fixed is specified, min_probs or max_probs cannot be specified for the same arm.")
      }
      if (!match) {
        if (is.na(fixed_probs[control_index])) {
          stop0("When control_prob_fixed is specified and is not 'match', fixed_probs for ",
                "the control arm must be set to the first value of control_prob_fixed.")
        } else if (abs(fixed_probs[control_index] - control_prob_fixed[1]) > .Machine$double.eps^0.5) {
          stop0("When control_prob_fixed is specified and is not 'match', fixed_probs for ",
                "the control arm must be set to the first value of control_prob_fixed.")
        }
      }
    }
  }

  # Check superiority/inferiority thresholds and correspondence
  if (!(length(inferiority) %in% c(1, n_data_looks)) | !all(is.numeric(inferiority)) | any(inferiority < 0) |
      any(inferiority > 1) | any(inferiority != cummax(inferiority))) {
    stop0("inferiority must be a single numeric value beween 0 and 1 or a numeric vector of the same length ",
          "as the maximum possible number of adaptive analyses, with all values between 0 and 1 and no ",
          "values lower than the previous value.")
  }
  if (!(length(superiority) %in% c(1, n_data_looks)) | !all(is.numeric(superiority)) | any(superiority < 0) |
      any(superiority > 1) | any(superiority != cummin(superiority))) {
    stop0("superiority must be a single numeric value beween 0 and 1 or a numeric vector of the same length ",
          "as the maximum possible number of adaptive analyses, with all values between 0 and 1 and no ",
          "values higher than the previous value.")
  }
  if (any(inferiority >= superiority)) {
    stop0("Invalid combination of inferiority/superiority thresholds - inferiority threshold(s) must be ",
          "lower than the corresponding superiority threshold(s) at all adaptive analyses.")
  }
  if (any(inferiority >= (1 / n_arms)) & is.null(control)) {
    stop0("All inferiority thresholds must be less than 1 divided by the number of arms when a ",
          "common control group is not used.")
  }

  # Check that highest_is_best is correct
  if (!(is.logical(highest_is_best) & length(highest_is_best) == 1)) {
    stop0("highest_is_best must be a single logical (TRUE/FALSE).")
  }

  # Checks equivalence settings
  if (!is.null(equivalence_prob) | !is.null(equivalence_diff)) {
    if (is.null(equivalence_prob) | is.null(equivalence_diff)) {
      stop0("Either equivalence_prob or equivalence_diff is specified - both need to be specified at the same time.")
    }
    if (!(length(equivalence_prob) %in% c(1, n_data_looks)) | !all(is.numeric(equivalence_prob)) | any(equivalence_prob <= 0) |
        any(equivalence_prob >= 1) | any(equivalence_prob != cummin(equivalence_prob))) {
      stop0("equivalence_prob must be a single numeric value > 0 and < 1 or a numeric vector of the same length ",
            "as the maximum possible number of adaptive analyses, with all values > 0 and < 1 and no values ",
            "higher than the previous value.")
    }
    if (isTRUE(length(equivalence_diff) != 1 | !is.numeric(equivalence_diff) | any(equivalence_diff <= 0))) {
      stop0("equivalence_diff must be a single numeric value > 0.")
    }
    if (is.null(control)) {
      if (!is.null(equivalence_only_first)) {
        stop0("For trials without a common control arm, equivalence_only_first must be NULL.")
      }
    } else if (!isTRUE(equivalence_only_first) & !isFALSE(equivalence_only_first)) {
      stop0("equivalence_prob and equivalence_diff are specified for a trial with a common control - ",
            "equivalence_only_first must be either TRUE or FALSE.")
    }
  }
  if (isTRUE(is.null(equivalence_prob) | is.null(equivalence_diff)) & !is.null(equivalence_only_first)) {
    stop0("equivalence_only_first specified, this requires that equivalence_prob and equivalence_diff are specified too.")
  }

  # Check futility settings
  if (any(!is.null(futility_prob), !is.null(futility_diff), !is.null(futility_only_first))) {
    if (is.null(control)) {
      stop0("Futility can only be assessed in trial designs with a common control.")
    }
    if (is.null(futility_prob) | is.null(futility_diff) | is.null(futility_only_first)) {
      stop0("Valid values for futility_prob, futility_diff and futility_only_first must all be specified for futility assessment.")
    }
    if (!(length(futility_prob) %in% c(1, n_data_looks)) | !all(is.numeric(futility_prob)) | any(futility_prob <= 0) |
        any(futility_prob >= 1) | any(futility_prob != cummin(futility_prob))) {
      stop0("futility_prob must be a single numeric value > 0 and < 1 or a numeric vector of the same length ",
            "as the maximum possible number of adaptive analyses, with all values > 0 and < 1 and no values ",
            "higher than the previous value.")
    }
    if (isTRUE(length(futility_diff) != 1 | !is.numeric(futility_diff) | any(futility_diff <= 0))) {
      stop0("futility_diff must be a single numeric value > 0.")
    }
    if (isTRUE(length(futility_only_first) > 1 | !is.logical(futility_only_first) | is.na(futility_only_first))) {
      stop0("futility_only_first must be either TRUE or FALSE for futility assessment.")
    }
  }

  # Check softening
  if (length(soften_power) == 1) {
    soften_power <- rep(soften_power, n_data_looks)
  } else if (length(soften_power) != n_data_looks) {
    stop0("soften_power must be either a single numeric of a numeric vector of the same length as the number of data looks.")
  }

  if (!is.numeric(soften_power) | any(soften_power > 1) | any(soften_power < 0)) {
    stop0("soften_power must only include numeric values between 0 and 1.")
  }

  # Get best arm(s)
  best_arm <- arms[true_ys == ifelse(highest_is_best, max(true_ys), min(true_ys))]

  # Validate Bayesian settings
  if (isTRUE(is.null(cri_width) | is.na(cri_width) | !is.numeric(cri_width) | cri_width >= 1 | cri_width < 0) | length(cri_width) != 1) {
    stop0("cri_width must be a single numeric value >= 0 and < 1.")
  }
  if (!verify_int(n_draws, min_value = 100)) {
    stop0("n_draws must be a single integer >= 100 (values < 1000 not recommended and will result in a warning).")
  } else if (n_draws < 1000) {
    warning0("Values for n_draws < 1000 are not recommended, as they may cause instable results.")
  }
  if (isTRUE(!is.logical(robust) | is.na(robust)) | length(robust) != 1) {
    stop0("robust must be either TRUE or FALSE.")
  }

  # Ensure that global random seed is not affected by function validation below
  if (exists(".Random.seed", envir = globalenv())) {
    oldseed <- get(".Random.seed", envir = globalenv())
    on.exit(assign(".Random.seed", value = oldseed, envir = globalenv()), add = TRUE, after = FALSE)
  }

  # Validate outcome generator function
  if (isTRUE(is.null(fun_y_gen) | !(class(fun_y_gen) == "function"))) {
    stop0("A valid function to generate outcomes (fun_y_gen) must be specified (see '?setup_trial').")
  } else {
    test_y <- fun_y_gen(c(arms, arms))
    if (isTRUE(any(is.na(test_y)) | is.null(test_y) | length(test_y) != length(arms) * 2) | !is.numeric(sum(test_y))) {
      stop0("A valid function to generate outcomes (fun_y_gen) must be specified (see '?setup_trial').")
    }
  }

  # Validate draws generator function
  if (isTRUE(is.null(fun_draws) | !(class(fun_draws) == "function"))) {
    stop0("A valid function to generate posterior draws (fun_draws) must be specified (see '?setup_trial').")
  } else {
    test_draws1 <- fun_draws(arms, c(arms, arms), test_y, control, n_draws) # Two patients in each arm
    test_draws2 <- fun_draws(arms, rep(c(arms[2:n_arms], arms[2]), 2), test_y, control, n_draws) # One arm without allocations, but should still work
    if (isTRUE(any(is.na(test_draws1)) | any(is.na(test_draws2)) | class(test_draws1)[1] != "matrix" | class(test_draws2)[1] != "matrix" |
               is.null(colnames(test_draws1)) | is.null(colnames(test_draws2)) | isTRUE(colnames(test_draws1) != arms) | isTRUE(colnames(test_draws2) != arms) |
               isTRUE(nrow(test_draws1) != n_draws) | isTRUE(nrow(test_draws2) != n_draws) | isTRUE(ncol(test_draws1) != n_arms) | isTRUE(ncol(test_draws2) != n_arms) |
               !is.numeric(test_draws1) | !is.numeric(test_draws2))) {
      stop0("A valid function to generate posterior draws (fun_draws) must be specified (see '?setup_trial').")
    }
    # For > 2 arms, verify that only columns for active arms are returned (this check is not relevant
    # for 2 arms only, as they will always be included in comparisons, and as this check could then
    # cause problems with more complex estimation methods, e.g., regression-based comparisons with only
    # one arm, depending on how such functions are specified)
    if (n_arms > 2) { # For >2 arms
      test_draws3 <- fun_draws(arms[2:n_arms], c(arms, arms), test_y, control, n_draws)
      if (isTRUE(any(is.na(test_draws3)) | class(test_draws3)[1] != "matrix" | is.null(colnames(test_draws3)) | isTRUE(colnames(test_draws3) != arms[2:n_arms]) |
                 isTRUE(nrow(test_draws3) != n_draws) | isTRUE(ncol(test_draws3) != n_arms-1) | !is.numeric(test_draws3))) {
        stop0("A valid function to generate posterior draws (fun_draws) must be specified (see '?setup_trial').\n",
              "fun_draws must return a matrix with named columns for currently active arms only.")
      }
    }
  }

  # Validate function that calculates raw summary estimates
  if (isTRUE(is.null(fun_raw_est) | !(class(fun_raw_est) == "function"))) {
    stop0("A valid function to summarise raw outcomes (fun_est_raw) must be specified (see '?setup_trial').")
  } else {
    test_raw_est <- vapply_num(arms, function(a) fun_raw_est(test_y[which(c(arms, arms) == a)]))
    if (isTRUE(any(is.na(test_raw_est)) | is.null(test_raw_est) | length(test_raw_est) != length(arms)) | !is.numeric(sum(test_y))) {
      stop0("A valid function to summarise raw outcomes (fun_est_raw) must be specified (see '?setup_trial').")
    }
  }

  # Check description and additional info
  if (!is.null(description)) {
    if (!is.character(description) | length(description) != 1) {
      stop0("description must be either NULL or a single character string.")
    }
  }
  if (!is.null(add_info)) {
    if (!is.character(add_info) | length(add_info) != 1) {
      stop0("add_info must be either NULL or a single character string.")
    }
  }

  # Everything validated - create and return trial_spec object
  trial_arms <- data.frame(arms, true_ys, start_probs, fixed_probs, min_probs, max_probs,
                           stringsAsFactors = FALSE)
  structure(list(trial_arms = trial_arms,
                 data_looks = data_looks,
                 max_n = max_n,
                 look_after_every = look_after_every,
                 n_data_looks = n_data_looks,
                 randomised_at_looks = randomised_at_looks,
                 control = control,
                 control_prob_fixed = if (match) "match" else control_prob_fixed,
                 inferiority = inferiority,
                 superiority = superiority,
                 equivalence_prob = equivalence_prob,
                 equivalence_diff = equivalence_diff,
                 equivalence_only_first = equivalence_only_first,
                 futility_prob = futility_prob,
                 futility_diff = futility_diff,
                 futility_only_first = futility_only_first,
                 highest_is_best = highest_is_best,
                 soften_power = soften_power,
                 best_arm = best_arm,
                 cri_width = cri_width,
                 n_draws = n_draws,
                 robust = robust,
                 description = description,
                 add_info = add_info,
                 fun_y_gen = fun_y_gen,
                 fun_draws = fun_draws,
                 fun_raw_est = fun_raw_est),
            class = c("trial_spec", "list"))
}



#' Setup a generic trial specification
#'
#' Specifies the design of an adaptive trial with any type of outcome and
#' validates all inputs. Use [run_trial()] or [run_trials()] to conduct
#' single/multiple simulations of the specified trial, respectively.\cr
#' See [setup_trial_binom()] and [setup_trial_norm()] for simplified setup of
#' trial designs common outcome types. For additional trial specification
#' examples, see the the **Basic examples** vignette
#' (`vignette("Basic-examples", package = "adaptr")`) and the
#' **Advanced example** vignette
#' (`vignette("Advanced-example", package = "adaptr")`).
#'
#'
#' @param arms character vector with unique names for the trial arms.
#' @param true_ys numeric vector specifying true outcomes (e.g., event
#'   probabilities, mean values, etc.) for all trial `arms`.
#' @param fun_y_gen function, generates outcomes. See [setup_trial()]
#'   **Details**
#'   for information on how to specify this function.\cr
#'   **Note:** this function is called once during setup to validate the output
#'   structure  (with the global random seed restored afterwards).
#' @param fun_draws function, generates posterior draws. See [setup_trial()]
#'   **Details** for information on how to specify this function.\cr
#'   **Note:** this function is called up to three times during setup to
#'   validate the output structure (with the global random seed restored
#'   afterwards).
#' @param start_probs numeric vector, allocation probabilities for each arm at
#'   the beginning of the trial. The default (`NULL`) is automatically
#'   changed to equal randomisation.
#' @param fixed_probs numeric vector, fixed allocation probabilities for each
#'   arm - must be either a numeric vector with `NA` for arms without fixed
#'   probabilities and values between `0` and `1` for the other arms or `NULL`
#'   (default), if adaptive randomisation is used for all arms or if one of the
#'   special settings (`"sqrt-based"`, `"sqrt-based start"`,
#'   `"sqrt-based fixed"`, or `"match"`) is specified for `control_prob_fixed`
#'   (described below).
#' @param min_probs numeric vector, lower threshold for adaptive allocation
#'   probabilities, lower probabilities will be rounded up to these values. Must
#'   be `NA` (default for all arms) if no boundary is wanted.
#' @param max_probs numeric vector, upper threshold for adaptive allocation
#'   probabilities, higher probabilities will be rounded down to these values.
#'   Must be `NA` (default for all arms) if no boundary is wanted.
#' @param data_looks vector of increasing integers, specifies when to conduct
#'   adaptive analyses (= the total number of patients with available outcome
#'   data at each adaptive analysis). The last number in the vector represents
#'   the final adaptive analysis, i.e., the final analysis where superiority,
#'   inferiority, practical equivalence, or futility can be claimed.
#'   Instead of specifying `data_looks`, the `max_n` and `look_after_every`
#'   arguments can be used in combination (then `data_looks` must be `NULL`,
#'   the default).
#' @param max_n single integer, number of patients with available outcome data
#'   at the last possible adaptive analysis (defaults to `NULL`).
#'   Must only be specified if `data_looks` is `NULL`. Requires specification of
#'   the `look_after_every` argument.
#' @param look_after_every single integer, specified together with `max_n`.
#'   Adaptive analyses will be conducted after every `look_after_every`
#'   patients have available outcome data, and at the total sample size as
#'   specified by `max_n` (`max_n` does not need to be a multiple of
#'   `look_after_every`). If specified, `data_looks` must be `NULL` (default).
#' @param randomised_at_looks vector of increasing integers or `NULL`,
#'   specifying the number of patients randomised at the time of each adaptive
#'   analysis using the current allocation probabilities at said analysis.
#'   If `NULL` (the default), the number of patients randomised at each analysis
#'   will match the number of patients with available outcome data at said
#'   analysis, as specified by `data_looks` or `max_n` and `look_after_every`,
#'   i.e., outcome data will be available immediately after randomisation for
#'   all patients.\cr
#'   If not `NULL`, the vector must be of the same length as the number of
#'   adaptive analyses specified by `data_looks` or `max_n` and
#'   `look_after_every`, and all values must be larger than or equal to the
#'   number of patients with available outcome data at each analysis.
#' @param control single character string, name of one of the `arms` or `NULL`
#'   (default). If specified, this arm will serve as a common control arm, to
#'   which all other arms will be compared and the
#'   inferiority/superiority/equivalence thresholds (see below) will be for
#'   those comparisons. See [setup_trial()] **Details** below for information on
#'   behaviour with respect to these comparisons.
#' @param control_prob_fixed if a common `control` arm is specified, this must
#'   be set to either `NULL` (the default), in which case the control arm
#'   allocation probability will not be fixed if control arms change (the
#'   allocation probability to the first control arm may still be fixed using
#'   `fixed_probs`) Otherwise a vector of probabilities of either length `1` or
#'   `number of arms - 1` can be provided, or one of the special arguments
#'   `"sqrt-based"`, `"sqrt-based start"`, `"sqrt-based fixed"` or `"match"`.
#'   See [setup_trial()] **Details** below for details in behaviour.
#' @param inferiority single numeric value or vector of numeric values of the
#'   same length as the maximum number of possible adaptive analyses, specifying
#'   the probability threshold(s) for inferiority (default is `0.01`). All
#'   values must be `>= 0` and `<= 1`, and if multiple values are supplied, no
#'   values may be lower than the preceding value. If a common `control`is not
#'   used, all values must be `< 1 / number of arms`. An arm will be considered
#'   inferior and dropped if the probability that it is best (when comparing all
#'   arms) or better than the control arm (when a common `control` is used)
#'   drops below the inferiority threshold at an adaptive analysis.
#' @param superiority single numeric value or vector of numeric values of the
#'   same length as the maximum number of possible adaptive analyses, specifying
#'   the probability threshold(s) for superiority (default is `0.99`). All
#'   values must be `>= 0` and `<= 1`, and if multiple values are supplied, no
#'   values may be higher than the preceding value. If the probability that an
#'   arm is best (when comparing all arms) or better than the control arm (when
#'   a common `control` is used) exceeds the superiority threshold at an
#'   adaptive analysis, said arm will be declared the winner and the trial will
#'   be stopped (if no common `control` is used or if the last comparator is
#'   dropped in a design with a common control) *or* become the new control and
#'   the trial will continue (if a common control is specified).
#' @param equivalence_prob single numeric value, vector of numeric values of the
#'   same length as the maximum number of possible adaptive analyses or `NULL`
#'   (default, corresponding to no equivalence assessment), specifying the
#'   probability threshold(s) for equivalence. All values must be `> 0` and
#'   `< 1`, and if multiple values are supplied, no values may be higher than
#'   the preceding value. If not `NULL`, arms will be dropped for equivalence if
#'   the probability of either *(a)* equivalence compared to a common `control`
#'   or *(b)* equivalence between all arms remaining (designs without a common
#'   `control`) exceeds the equivalence threshold at an adaptive analysis.
#'   Requires specification of `equivalence_diff`, and `equivalence_only_first`.
#' @param equivalence_diff single numeric value (`> 0`) or `NULL` (default,
#'   corresponding to no equivalence assessment). If a numeric value is
#'   specified, estimated differences below this threshold will be considered
#'   equivalent when assessing equivalence. For designs with a common `control`
#'   arm, the differences between each non-control arm and the `control` arm is
#'   used, and for trials without a common `control` arm, the difference between
#'   the highest and lowest estimated outcome rates are used and the trial is
#'   only stopped for equivalence if all remaining arms are thus equivalent.
#' @param equivalence_only_first single logical in trial specifications where
#'   `equivalence_prob` and `equivalence_diff` are specified, otherwise `NULL`
#'   (default). Must be `NULL` for designs without a common control arm. If a
#'   common `control` arm is used, this specifies whether equivalence will only
#'   be assessed for the first control (if `TRUE`) or also for subsequent
#'   control arms (if `FALSE`) if one arm is superior to the first control and
#'   becomes the new control.
#' @param futility_prob single numeric value, vector of numeric values of the
#'   same length as the maximum number of possible adaptive analyses or `NULL`
#'   (default, corresponding to no futility assessment), specifying the
#'   probability threshold(s) for futility. All values must be `> 0` and `< 1`,
#'   and if multiple values are supplied, no values may be higher than
#'   the preceding value. If not `NULL`, arms will be dropped for futility if
#'   the probability for futility compared to the common `control` exceeds the
#'   futility threshold at an adaptive analysis. Requires a common `control`
#'   arm, specification of `futility_diff`, and `futility_only_first`.
#' @param futility_diff single numeric value (`> 0`) or `NULL` (default,
#'   corresponding to no futility assessment). If a numeric value is specified,
#'   estimated differences below this threshold in the *beneficial* direction
#'   (as specified in `highest_is_best`) will be considered futile when
#'   assessing futility in designs with a common `control` arm. If only 1 arm
#'   remains after dropping arms for futility, the trial will be stopped without
#'   declaring the last arm superior.
#' @param futility_only_first single logical in trial specifications designs
#'   where `futility_prob` and `futility_diff` are specified, otherwise `NULL
#'   (default). Must be `NULL` for designs without a common `control` arm.
#'   Specifies whether futility will only be assessed against the first
#'   `control` (if `TRUE`) or also for subsequent control arms (if `FALSE`) if
#'   one arm is superior to the first control and becomes the new control.
#' @param highest_is_best single logical, specifies whether larger estimates of
#'   the outcome are favourable or not; defaults to `FALSE`, corresponding to,
#'   e.g., an undesirable binary outcomes (e.g., mortality) or a continuous
#'   outcome where lower numbers are preferred (e.g., hospital length of stay).
#' @param soften_power either a single numeric value or a numeric vector of
#'   exactly the same length as the maximum number of looks/adaptive analyses.
#'   Values must be between `0` and `1` (default); if `< 1`, then re-allocated
#'   non-fixed allocation probabilities are all raised to this power to make
#'   allocation probabilities less extreme, in turn used to redistribute
#'   remaining probability while respecting limits when defined by `min_probs`
#'   and/or `max_probs`. If `1`, then no *softening* is applied.
#' @param fun_raw_est function that takes a numeric vector and returns a
#'   single numeric value, used to calculate a raw summary estimate of the
#'   outcomes in each `arm`. Defaults to [mean()], which is always used in the
#'   [setup_trial_binom()] and [setup_trial_norm()] functions.\cr
#'   **Note:** the function is called one time per arm during setup to validate
#'   the output structure.
#' @param cri_width single numeric `>= 0` and `< 1`, the width of the
#'   percentile-based credible intervals used when summarising individual trial
#'   results. Defaults to `0.95`, corresponding to 95% credible intervals.
#' @param n_draws single integer, the number of draws from the posterior
#'   distributions (for each arm) used when running the trial. Defaults to
#'   `5000`; can be reduced for a speed gain (at the potential loss of stability
#'   of results if too low) or increased for increased precision (takes longer).
#'   Values `< 100` are not allowed and values `< 1000` are not recommended
#'   and warned against.
#' @param robust single logical, if `TRUE` (default) the medians and median
#'   absolute deviations (scaled to be comparable to the standard deviation for
#'   normal distributions; MAD_SDs) are used to summarise the posterior
#'   distributions; if `FALSE`, the means and standard deviations (SDs) are used
#'   instead (slightly faster, but may be less appropriate for posteriors skewed
#'   on the natural scale).
#' @param description optional single character string describing the trial
#'   design, will only be used in print functions if not `NULL` (the default).
#' @param add_info optional single string containing additional information
#'   regarding the trial design or specifications, will only be used in print
#'   functions if not `NULL` (the default).
#'
#' @details
#'
#' \strong{How to specify the `fun_y_gen` function}
#'
#' The function must take the following inputs:
#' - `allocs`: character vector, the trial `arms` that new patients allocated
#' since the last adaptive analysis are randomised to.
#'
#' The function must return a single numeric vector, corresponding to the
#' outcomes for all patients allocated since the last adaptive analysis, in the
#' same order as `allocs`.\cr
#' See the **Advanced example** vignette
#' (`vignette("Advanced-example", package = "adaptr")`) for an example with
#' further details.
#'
#' \strong{How to specify the `fun_draws` function}
#'
#' The function must take the following inputs:
#' - `arms`: character vector, the unique trial arms, in the same order as
#' above, but only the **currently active** arms are specified when the function is
#' called.
#' - `allocs`: a vector of allocations for all patients, corresponding to the
#' trial arms, including patients allocated to **currently inactive** `arms` when
#' called,
#' - `ys`: a vector of outcomes for all patients in the same order as `allocs`,
#' including outcomes for patients allocated to **currently inactive** `arms`
#' when called.
#' - `control`: single character, the current `control arm`, will be `NULL` for
#' designs without a common control arm, but required regardless as the argument
#' is supplied by [run_trial()]/[run_trials()].
#' - `n_draws`: single integer, the number of posterior draws for each arm.
#'
#' The function must return a `matrix` (with numeric values) with `arms` columns
#' and `n_draws` rows. The `matrix` must have columns
#' **only for currently active arms** (when called). Each row should contain a
#' single posterior draw for each arm on the original outcome
#' scale: if they are estimated as, e.g., the *log(odds)*, these estimates must
#' be transformed to probabilities and similarly for other measures.\cr
#' Important: the `matrix` cannot contain `NA`s, even if no patients have been
#' randomised to an arm yet. See the provided example for one way to alleviate
#' this.\cr
#' See the **Advanced examples** vignette
#' (`vignette("Advanced-example", package = "adaptr")`) for an example with
#' further details.
#'
#' _Notes_
#' - Different estimation methods and prior distributions may be used;
#' complex functions will lead to slower simulations compared to simpler
#' methods for obtaining posterior draws, including those specified using the
#' [setup_trial_binom()] and [setup_trial_norm()] functions.
#' - Technically, using log relative effect measures — e.g. log(odds ratio) or
#' log(risk ratios) - or differences compared to a reference arm (e.g., mean
#' differences or absolute risk differences) instead of absolute values in each
#' arm will work to some extent (**be cautious!**):
#' - Stopping for superiority/inferiority/max sample sizes will work.
#' - Stopping for equivalence/futility may be used with relative effect
#' measures on the log scale.
#' - Several summary statistics from [run_trial()] (`sum_ys` and posterior
#' estimates) may be nonsensical if relative effect measures are used
#' (depending on calculation method).
#' - In the same vein, [extract_results()] (`sum_ys`, `sq_err`, and
#' `sq_err_te`), and [summary()] (`sum_ys_mean/sd/median/q25/q75`, `rmse`,
#' `rmse_te` and `idp`) may be equally nonsensical when calculated on the
#' relative scale.
#'
#' \strong{Using additional custom or functions from loaded packages in the
#' custom functions}
#' If the `fun_y_gen`, `fun_draws`, or `fun_raw_est` functions calls other
#' user-specified functions (or uses objects defined by the user outside these
#' functions or the [setup_trial()]-call) or functions from external packages
#' and simulations are conducted on multiple cores, these objects or functions
#' must be exported or prefixed with their namespaces, respectively, as
#' described in [run_trials()].
#'
#'
#' \strong{More information on arguments}
#' - `control`: if one or more treatment arms are superior to the control arm
#' (i.e., passes the superiority threshold as defined above), this arm will
#' become the new control (if multiple arms are superior, the one with the
#' highest probability of being the overall best will become the new control),
#' the previous control will be dropped for inferiority, and all remaining arms
#' will be immediately compared to the new control in the same adaptive analysis
#' and dropped if inferior (or possibly equivalent/futile, see below) compared
#' to this new control arm. Only applies in trials with a common `control`.
#' - `control_prob_fixed`: If the length is 1, then this allocation probability
#' will be used for the `control` group (including if a new arm becomes the
#' control and the original control is dropped). If multiple values are specified
#' the first value will be used when all arms are active, the second when one
#' arm has been dropped, and so forth. If 1 or more values are specified,
#' previously set `fixed_probs`, `min_probs` or `max_probs` for new control arms
#' will be ignored. If all allocation probabilities do not sum to 1 (e.g, due to
#' multiple limits) they will be re-scaled to do so.\cr
#' Can also be set to one of the special arguments `"sqrt-based"`,
#' `"sqrt-based start"`, `"sqrt-based fixed"` or `"match"` (written exactly as
#' one of those, case sensitive). This requires `start_probs` to be `NULL` and
#' relevant `fixed_probs` to be `NULL` (or `NA` for the control arm).\cr
#' If one of the `"sqrt-based"/"sqrt-based start"/"sqrt-based fixed"` options
#' are used, the function will set *square-root-transformation-based* starting
#' allocation probabilities. These are defined as:\cr
#' `square root of number of non-control arms to 1-ratio for other arms`\cr
#' scaled to sum to 1, which will generally increase power for comparisons
#' against the common control, as discussed in, e.g., *Park et al, 2020*
#' \doi{10.1016/j.jclinepi.2020.04.025}.\cr
#' If `"sqrt-based"`, square-root-transformation-based allocation probabilities
#' will also be used for new controls when arms are dropped. If
#' `"sqrt-based start"`, the control arm will be fixed to this allocation
#' probability at all times (also after arm dropping, with re-scaling as
#' necessary, as specified above). If `"sqrt-based fixed"` is chosen,
#' square-root-transformation-based allocation probabilities will be used and
#' all allocation probabilities will be fixed throughout the trial (with
#' re-scaling when arms are dropped).\cr
#' If `"match"` is specified, the control group allocation will always be
#' *matched* to be similar to the highest non-control arm allocation ratio.
#'
#' \strong{Superiority and inferiority}
#'
#' In trial designs without a common control arm, superiority and inferiority
#' are assessed by comparing all ***currently active*** groups. This means that
#' if a "final" analysis of a trial without a common control and `> 2 arms` is
#' conducted including all arms (as will often be done in practice) *after* an
#' adaptive trial have stopped, the final probabilities of the best arm being
#' superior may differ slightly.\cr
#' For example, in a trial with three arms and no common `control` arm, one arm
#' may be dropped early for inferiority defined as `< 1%` probability of being
#' the overall best `arm`. The trial may then continue with the two remaining
#' arms, and stopped when one is declared superior to the other defined as
#' `> 99%` probability of being the overall best `arm`. If a final analysis is
#' then conducted including all arms, the final probability of the best arm
#' being overall superior will generally be slightly lower as the probability
#' of the first dropped arm being the best will generally be `> 0%`, even if
#' very low and below the inferiority threshold.\cr
#' This is not relevant trial designs *with* a common `control`, as pairwise
#' assessments of superiority/inferiority compared to the common `control` will
#' not be influenced similarly by previously dropped arms (and previously
#' dropped arms may be included in the analyses, even if posterior distributions
#' are not returned for those).
#' Similarly, in actual clinical trials, final probabilities may change slightly
#' as the most recently randomised patients will generally not have outcome data
#' available at the final adaptive analysis where the trial is stopped.
#'
#' \strong{Equivalence}
#'
#' Equivalence is assessed ***after*** both inferiority and
#' superiority have been assessed (and in case of superiority, it will be
#' assessed against the new `control` arm in designs with a common `control`, if
#' specified - see above).
#'
#' \strong{Futility}
#'
#' Futility is assessed ***after*** inferiority, superiority, ***and***
#' equivalence have been assessed (and in case of superiority, it will be
#' assessed against the new control arm in designs with a common control, if
#' specified - see above). Arms will thus be dropped for equivalence before
#' futility.
#'
#' \strong{Varying probability thresholds}
#'
#' Different probability thresholds (for superiority, inferiority, equivalence,
#' and futility) may be specified for different adaptive analyses. This may be
#' used, e.g., to apply more strict probability thresholds at earlier analyses,
#' similar to the use of monitoring boundaries with different thresholds used
#' for interim analyses in conventional, frequentist group sequential trial
#' designs. See the **Basic examples** vignette
#' (`vignette("Basic-examples", package = "adaptr")`) for an example.
#'
#' @return A `trial_spec` object used to run simulations by [run_trial()] or
#'   [run_trials()]. The output is essentially a list containing the input
#'   values (some combined in a `data.frame` called `trial_arms`), but its class
#'   signals that these inputs have been validated and inappropriate
#'   combinations and settings have been ruled out. Also contains `best_arm`
#'   holding the arm(s) with the best value(s) in `true_ys`. Use `str()` to
#'   peruse the actual content of the returned object.
#'
#' @examples
#' # Setup a custom trial specification with right-skewed, log-normally
#' # distributed continuous outcomes (higher values are worse)
#'
#' # Define the function that will generate the outcomes in each arm
#' # Notice: contents should match arms/true_ys in the setup_trial() call below
#' get_ys_lognorm <- function(allocs) {
#'   y <- numeric(length(allocs))
#'   # arms (names and order) and values (except for exponentiation) should match
#'   # those used in setup_trial (below)
#'   means <- c("Control" = 2.2, "Experimental A" = 2.1, "Experimental B" = 2.3)
#'   for (arm in names(means)) {
#'     ii <- which(allocs == arm)
#'     y[ii] <- rlnorm(length(ii), means[arm], 1.5)
#'   }
#'   y
#' }
#'
#' # Define the function that will generate posterior draws
#' # In this example, the function uses no priors (corresponding to improper
#' # flat priors) and calculates results on the log-scale, before exponentiating
#' # back to the natural scale, which is required for assessments of
#' # equivalence, futility and general interpretation
#' get_draws_lognorm <- function(arms, allocs, ys, control, n_draws) {
#'   draws <- list()
#'   logys <- log(ys)
#'   for (arm in arms){
#'     ii <- which(allocs == arm)
#'     n <- length(ii)
#'     if (n > 1) {
#'       # Necessary to avoid errors if too few patients randomised to this arm
#'       draws[[arm]] <- exp(rnorm(n_draws, mean = mean(logys[ii]), sd = sd(logys[ii])/sqrt(n - 1)))
#'     } else {
#'       # Too few patients randomised to this arm - extreme uncertainty
#'       draws[[arm]] <- exp(rnorm(n_draws, mean = mean(logys), sd = 1000 * (max(logys) - min(logys))))
#'     }
#'   }
#'   do.call(cbind, draws)
#' }
#'
#' # The actual trial specification is then defined
#' lognorm_trial <- setup_trial(
#'   # arms should match those above
#'   arms = c("Control", "Experimental A", "Experimental B"),
#'   # true_ys should match those above
#'   true_ys = exp(c(2.2, 2.1, 2.3)),
#'   fun_y_gen = get_ys_lognorm, # as specified above
#'   fun_draws = get_draws_lognorm, # as specified above
#'   max_n = 5000,
#'   look_after_every = 200,
#'   control = "Control",
#'   # Qquare-root-based, fixed control group allocation ratio
#'   # and response-adaptive randomisation for other arms
#'   control_prob_fixed = "sqrt-based",
#'   # Equivalence assessment
#'   equivalence_prob = 0.9,
#'   equivalence_diff = 0.5,
#'   equivalence_only_first = TRUE,
#'   highest_is_best = FALSE,
#'   # Summarise raw results by taking the mean on the
#'   # log scale and back-transforming
#'   fun_raw_est = function(x) exp(mean(log(x))) ,
#'   # Summarise posteriors using medians with MAD-SDs,
#'   # as distributions will not be normal on the actual scale
#'   robust = TRUE,
#'   # Description/additional info used when printing
#'   description = "continuous, log-normally distributed outcome",
#'   add_info = "SD on the log scale for all arms: 1.5"
#' )
#'
#' # Print trial specification with 3 digits for all probabilities
#' print(lognorm_trial, prob_digits = 3)
#'
#' @export
#'
setup_trial <- function(arms, true_ys, fun_y_gen = NULL, fun_draws = NULL,
                        start_probs = NULL, fixed_probs = NULL,
                        min_probs = rep(NA, length(arms)),
                        max_probs = rep(NA, length(arms)),
                        data_looks = NULL,
                        max_n = NULL, look_after_every = NULL,
                        randomised_at_looks = NULL,
                        control = NULL,
                        control_prob_fixed = NULL, inferiority = 0.01,
                        superiority = 0.99, equivalence_prob = NULL,
                        equivalence_diff = NULL, equivalence_only_first = NULL,
                        futility_prob = NULL, futility_diff = NULL,
                        futility_only_first = NULL, highest_is_best = FALSE,
                        soften_power = 1, fun_raw_est = mean, cri_width = 0.95,
                        n_draws = 5000, robust = TRUE, description = NULL,
                        add_info = NULL) {

  validate_trial(arms = arms, true_ys = true_ys, start_probs = start_probs, fixed_probs = fixed_probs,
                 min_probs = min_probs, max_probs = max_probs, data_looks = data_looks, max_n = max_n,
                 look_after_every = look_after_every, randomised_at_looks = randomised_at_looks,
                 control = control, control_prob_fixed = control_prob_fixed, inferiority = inferiority,
                 superiority = superiority, equivalence_prob = equivalence_prob,
                 equivalence_diff = equivalence_diff, equivalence_only_first = equivalence_only_first,
                 futility_prob = futility_prob, futility_diff = futility_diff, futility_only_first = futility_only_first,
                 highest_is_best = highest_is_best, soften_power = soften_power,
                 cri_width = cri_width, n_draws = n_draws, robust = robust,
                 description = description, add_info = add_info,
                 fun_y_gen = fun_y_gen, fun_draws = fun_draws, fun_raw_est = fun_raw_est)
}



#' Setup a trial specification using a binary, binomially distributed outcome
#'
#' Specifies the design of an adaptive trial with a binary, binomially
#' distributed outcome and validates all inputs. Uses *beta-binomial*
#' conjugate models with `beta(1, 1)` prior distributions, corresponding to a
#' uniform prior (or the addition of 2 patients, 1 with an event and 1 without)
#' to the trial. Use [run_trial()] or [run_trials()] to conduct single/multiple
#' simulations of the specified trial, respectively.\cr
#' **Note:** `add_info` as specified in [setup_trial()] is set to `NULL` for
#' trial specifications setup by this function.\cr
#' **Further details:** please see [setup_trial()]. See [setup_trial_norm()] for
#' simplified setup of trials with normally distributed continuous outcomes.\cr
#' For additional trial specification examples, see the the **Basic examples**
#' vignette (`vignette("Basic-examples", package = "adaptr")`) and the
#' **Advanced example** vignette
#' (`vignette("Advanced-example", package = "adaptr")`).
#'
#' @inheritParams setup_trial
#' @param true_ys numeric vector, true probabilities (between `0` and `1`) of
#'   outcomes in all trial `arms`.
#' @param description character string, default is
#'   `"generic binomially distributed outcome trial"`. See arguments of
#'   [setup_trial()].
#'
#' @inherit setup_trial return
#'
#' @export
#'
#' @examples
#' # Setup a trial specification a binary, binomially distributed, undesirable outcome
#' binom_trial <- setup_trial_binom(
#'   arms = c("Arm A", "Arm B", "Arm C"),
#'   true_ys = c(0.25, 0.20, 0.30),
#'   # Minimum allocation of 15% in all arms
#'   min_probs = rep(0.15, 3),
#'   data_looks = seq(from = 300, to = 2000, by = 100),
#'   # Stop for equivalence if > 90% probability of
#'   # differences < 5 percentage points
#'   equivalence_prob = 0.9,
#'   equivalence_diff = 0.05,
#'   soften_power = 0.5 # Limit extreme allocation ratios
#' )
#'
#' # Print using 3 digits for probabilities
#' print(binom_trial, prob_digits = 3)
#'
setup_trial_binom <- function(arms, true_ys, start_probs = NULL,
                              fixed_probs = NULL,
                              min_probs = rep(NA, length(arms)),
                              max_probs = rep(NA, length(arms)),
                              data_looks = NULL,
                              max_n = NULL, look_after_every = NULL,
                              randomised_at_looks = NULL,
                              control = NULL, control_prob_fixed = NULL,
                              inferiority = 0.01, superiority = 0.99,
                              equivalence_prob = NULL, equivalence_diff = NULL,
                              equivalence_only_first = NULL,
                              futility_prob = NULL, futility_diff = NULL,
                              futility_only_first = NULL,
                              highest_is_best = FALSE, soften_power = 1,
                              cri_width = 0.95, n_draws = 5000, robust = TRUE,
                              description = "generic binomially distributed outcome trial") {

  # Validate specific arguments to trials with binary outcomes
  if (!isFALSE(length(arms) != length(true_ys) | any(is.na(true_ys)) | any(true_ys > 1) | any(true_ys < 0) | !is.numeric(true_ys))) {
    stop0("true_ys must be a vector of the same length as the number of arms containing ",
          "values (event probabilities) between 0 and 1 with no missing values.")
  }

  # General setup and validation
  trial <- validate_trial(arms = arms, true_ys = true_ys, start_probs = start_probs, fixed_probs = fixed_probs,
                          min_probs = min_probs, max_probs = max_probs, data_looks = data_looks, max_n = max_n,
                          look_after_every = look_after_every, randomised_at_looks = randomised_at_looks,
                          control = control, control_prob_fixed = control_prob_fixed, inferiority = inferiority,
                          superiority = superiority, equivalence_prob = equivalence_prob,
                          equivalence_diff = equivalence_diff, equivalence_only_first = equivalence_only_first,
                          futility_prob = futility_prob, futility_diff = futility_diff, futility_only_first = futility_only_first,
                          highest_is_best = highest_is_best, soften_power = soften_power,
                          cri_width = cri_width, n_draws = n_draws, robust = robust,
                          description = description, add_info = NULL,
                          fun_y_gen = get_ys_binom(arms, true_ys),
                          fun_draws = get_draws_binom,
                          fun_raw_est = mean)

  # Additional specific validation
  if (!is.null(equivalence_diff)) {
    if (equivalence_diff <= 0 | equivalence_diff >= 1) {
      stop0("equivalence_diff must be a single numeric value > 0 and < 1.")
    }
  }
  if (!is.null(futility_diff)) {
    if (futility_diff <= 0 | futility_diff >= 1) {
      stop0("futility_diff must be a single numeric value > 0 and < 1.")
    }
  }

  # Return
  trial
}



#' Setup a trial specification using a continuous, normally distributed outcome
#'
#' Specifies the design of an adaptive trial with a continuous, normally
#' distributed outcome and validates all inputs. Uses normally distributed
#' posterior distributions for the mean values in each
#' trial arm; technically, no priors are used (as using *normal-normal*
#' conjugate prior models with extremely wide or uniform priors gives similar
#' results for these simple, unadjusted estimates). Technically, this thus
#' corresponds to using improper, flat priors, although not explicitly specified
#' as such. Use [run_trial()] or [run_trials()] to conduct single/multiple
#' simulations of the specified trial, respectively.\cr
#' **Note:** `add_info` as specified in [setup_trial()] is set to the arms and
#' standard deviations used for trials specified using this function.\cr
#' **Further details:** please see [setup_trial()]. See [setup_trial_binom()]
#' for simplified setup of trials with binomially distributed binary outcomes.
#' \cr
#' For additional trial specification examples, see the the
#' **Basic examples** vignette
#' (`vignette("Basic-examples", package = "adaptr")`) and the
#' **Advanced example** vignette
#' (`vignette("Advanced-example", package = "adaptr")`).
#'
#' @inheritParams setup_trial
#' @param true_ys numeric vector, simulated means of the outcome in all trial
#'   `arms`.
#' @param sds numeric vector, true standard deviations (must be > 0) of the
#'   outcome in all trial `arms`.
#' @param description character string, default is
#' `"generic normally distributed outcome trial"`. See arguments of
#' [setup_trial()].
#'
#' @inherit setup_trial return
#'
#' @details
#' Because the posteriors used in this type of trial (with a generic,
#' continuous, normally distributed outcome) are by definition normally
#' distributed, `FALSE` is used as the default value for the `robust` argument.
#'
#' @export
#'
#' @examples
#' # Setup a trial specification using a continuous, normally distributed, desirable outcome
#' norm_trial <- setup_trial_norm(
#'   arms = c("Control", "New A", "New B", "New C"),
#'   true_ys = c(15, 20, 14, 13),
#'   sds = c(2, 2.5, 1.9, 1.8), # SDs in each arm
#'   max_n = 500,
#'   look_after_every = 50,
#'   control = "Control", # Common control arm
#'   # Square-root-based, fixed control group allocation ratios
#'   control_prob_fixed = "sqrt-based fixed",
#'   # Desirable outcome
#'   highest_is_best = TRUE,
#'   soften_power = 0.5 # Limit extreme allocation ratios
#' )
#'
#' # Print using 3 digits for probabilities
#' print(norm_trial, prob_digits = 3)
#'
setup_trial_norm <- function(arms, true_ys, sds, start_probs = NULL,
                             fixed_probs = NULL,
                             min_probs = rep(NA, length(arms)),
                             max_probs = rep(NA, length(arms)),
                             data_looks = NULL,
                             max_n = NULL, look_after_every = NULL,
                             randomised_at_looks = NULL,
                             control = NULL, control_prob_fixed = NULL,
                             inferiority = 0.01, superiority = 0.99,
                             equivalence_prob = NULL, equivalence_diff = NULL,
                             equivalence_only_first = NULL,
                             futility_prob = NULL, futility_diff = NULL,
                             futility_only_first = NULL,
                             highest_is_best = FALSE, soften_power = 1,
                             cri_width = 0.95, n_draws = 5000, robust = FALSE,
                             description = "generic normally distributed outcome trial") {

  # Validate specific arguments to generic continuous, normally distributed outcome trials
  if (!isFALSE(length(arms) != length(true_ys) | any(is.na(true_ys)) | !is.numeric(true_ys) |
               length(arms) != length(sds) | any(is.na(sds)) | !is.numeric(sds) | any(sds <= 0))) {
    stop0("true_ys and sds must be vectors of the same length as the number of arms and all sds must be > 0.")
  }

  # General setup and validation and return
  validate_trial(arms = arms, true_ys = true_ys, start_probs = start_probs, fixed_probs = fixed_probs,
                 min_probs = min_probs, max_probs = max_probs, data_looks = data_looks, max_n = max_n,
                 look_after_every = look_after_every, randomised_at_looks = randomised_at_looks,
                 control = control, control_prob_fixed = control_prob_fixed, inferiority = inferiority,
                 superiority = superiority, equivalence_prob = equivalence_prob,
                 equivalence_diff = equivalence_diff, equivalence_only_first = equivalence_only_first,
                 futility_prob = futility_prob, futility_diff = futility_diff, futility_only_first = futility_only_first,
                 highest_is_best = highest_is_best, soften_power = soften_power,
                 cri_width = cri_width, n_draws = n_draws, robust = robust,
                 description = description, add_info = paste0("Arm SDs - ", paste0(paste0(arms, ": ", sds), collapse = "; "), "."),
                 fun_y_gen = get_ys_norm(arms, true_ys, sds),
                 fun_draws = get_draws_norm,
                 fun_raw_est = mean)
}
