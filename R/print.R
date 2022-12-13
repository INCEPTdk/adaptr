### Needed for manual to show up when running ?print ###

#' Print methods for adaptive trial objects
#'
#' Prints contents of the first input `x` in a human-friendly way, see
#' **Details** for more information.
#'
#' @details The behaviour depends on the class of `x`:
#'
#' @return Invisibly returns `x`.
#' @name print
NULL



#' Print method for trial specifications
#'
#' @param x object to print, see **Details** below.
#' @param prob_digits single integer, the number of digits used when printing
#'   probabilities, allocation probabilities and softening powers.
#'
#' @details
#' - `trial_spec`: prints a trial specification setup by
#' [setup_trial()], [setup_trial_binom()] or [setup_trial_norm()].
#'
#' @describeIn print Trial specification
#' @export
#'
print.trial_spec <- function(x, prob_digits = 3, ...) {

  if (!verify_int(prob_digits, min_value = 2)){
    stop0("prob_digits must be a single positive whole number >= 2.")
  }

  # General description
  cat0("Trial specification", if (!is.null(x$description)) paste0(": ", x$description))
  cat0("\n* ", ifelse(x$highest_is_best, "Desirable", "Undesirable"), " outcome\n")

  if (is.null(x$control)) {
    cat("* No common control arm")
  } else {
    cat("* Common control arm:", x$control, "\n")

    if (is.null(x$control_prob_fixed)) {
      "* Control arm probability not fixed"
    } else {
      if (length(x$control_prob_fixed) == 1) {
        if (x$control_prob_fixed == "match") {
          cat("* Control arm probability matched to best non-control arm")
        } else {
          cat0("* Control arm probability fixed at ",
               round(x$control_prob_fixed, prob_digits)) # Fixed at same value all the time
        }
      } else {
        cat0("* Control arm probability fixed at ")
        cat(paste(round(x$control_prob_fixed, prob_digits),
                  "(for", (length(x$control_prob_fixed):1) + 1, "arms)",
                  collapse = ", "))
      }
    }
  }
  cat("\n")

  if (length(x$best_arm) == 1) {
    cat("* Best arm:", x$best_arm)
  } else {
    cat("* Best arms:", paste0(x$best_arm, collapse = " and "))
  }

  cat0("\n\nArms, true outcomes, starting allocation probabilities \n",
       "and allocation probability limits:\n")
  print(x$trial_arms, digits = prob_digits, row.names = FALSE)

  # Samples size and looks
  cat("\nMaximum sample size:", max(x$randomised_at_looks),
      "\nMaximum number of data looks:", x$n_data_looks)
  if (is.null(x$look_after_every)) {
    cat0(paste("\nPlanned data looks after: ", paste(x$data_looks, collapse = ", "), "patients have reached follow-up"), fill = TRUE)
  } else {
    cat0("\nPlanned looks after every ", x$look_after_every,
         " patients have reached follow-up until final look after ", max(x$data_looks), " patients", fill = TRUE)
  }
  cat0(paste("Number of patients randomised at each look: ", paste(x$randomised_at_looks, collapse = ", ")), fill = TRUE)

  if (length(x$superiority) == 1) {
    cat("\nSuperiority threshold:", round(x$superiority, prob_digits), "(all analyses)", fill = TRUE)
  } else {
    cat("\nSuperiority thresholds:", paste(round(x$superiority, prob_digits), collapse = ", "), fill = TRUE)
  }
  if (length(x$inferiority) == 1) {
    cat("Inferiority threshold:", round(x$inferiority, prob_digits), "(all analyses)", fill = TRUE)
  } else {
    cat("Inferiority thresholds:", paste(round(x$inferiority, prob_digits), collapse = ", "), fill = TRUE)
  }


  # Equivalence specifications
  if (is.null(x$equivalence_prob)) {
    cat("No equivalence threshold", fill = TRUE)
  } else {
    if (is.null(x$control)) {
      equi_ctrl <- "(no common control)"
    } else {
      if (x$equivalence_only_first) {
        equi_ctrl <- "(only checked for first control)"
      } else {
        equi_ctrl <- "(checked for first and eventual new controls)"
      }
    }
    if (length(x$equivalence_prob) == 1) {
      cat("Equivalence threshold:", round(x$equivalence_prob, prob_digits), "(all analyses)", equi_ctrl, fill = TRUE)
    } else {
      cat("Equivalence thresholds:", paste(round(x$equivalence_prob, prob_digits), collapse = ", "), equi_ctrl, fill = TRUE)
    }

    cat0("Absolute equivalence difference: ", x$equivalence_diff, "\n")
  }

  # Futility specifications
  if (is.null(x$futility_prob)) {
    cat0("No futility threshold", ifelse(is.null(x$control), " (not relevant - no common control)", ""), fill = TRUE)
  } else {
    futility_ctrl <- ifelse(x$futility_only_first, "(only checked for first control)", "(checked for first and eventual new controls)")
    if (length(x$futility_prob) == 1) {
      cat("Futility threshold:", round(x$futility_prob, prob_digits), "(all analyses)", futility_ctrl, fill = TRUE)
    } else {
      cat("Futility thresholds:", paste(round(x$futility_prob, prob_digits), collapse = ", "), futility_ctrl, fill = TRUE)
    }

    cat("Absolute futility difference (in beneficial direction):", x$futility_diff, "\n")
  }

  # Softening specifications
  soften_power <- if (length(unique(x$soften_power)) == 1) x$soften_power[1] else x$soften_power
  cat0(sprintf("Soften power for %s:",
               ifelse(length(soften_power) == 1, "all analyses", "each consequtive analysis")), " ")

  if (all(soften_power == 1)) {
    if (any(is.na(x$trial_arms$fixed_probs))) {
      cat("1 (no softening)")
    } else {
      cat("1 (no softening - all arms fixed)")
    }
  } else {
    cat(round(soften_power, prob_digits), sep = ", ")
  }

  # Additional info
  if (!is.null(x$add_info)) cat0("\n\n", "Additional info: ", x$add_info)
  cat0("\n")

  # Return invisibly
  invisible(x)
}


#' Print method for a single simulated trial
#'
#' @param x object to print, see **Details** below.
#' @param prob_digits single integer, the number of digits used when printing
#'   probabilities, allocation probabilities and softening powers.
#'
#' @details
#' - `trial_result`: prints the results of a single trial simulated by
#' [run_trial()]. More details are saved in the `trial_result` object and thus
#' printed if the `sparse` argument in [run_trial()] or [run_trials()] is set to
#' `FALSE`; if `TRUE`, fewer details are printed, but the omitted details are
#' available by printing the `trial_spec` object created by [setup_trial()],
#' [setup_trial_binom()] or [setup_trial_norm()].
#'
#' @describeIn print Single trial result
#' @export
#'
print.trial_result <- function(x, prob_digits = 3, ...) {

  if (!verify_int(prob_digits, min_value = 2)) {
    stop0("prob_digits must be a single whole number >= 2.")
  }

  # Status
  final_status <- paste0(
    "\n\nFinal status: ",
    switch(x$final_status,
           max = "inconclusive, stopped at final allowed adaptive analysis",
           futility = "conclusive, stopped for futility",
           superiority = "conclusive, stopped for superiority",
           equivalence = "conclusive, stopped for equivalence")
  )

  # Print overall results
  if (x$sparse) {# Print limited details if sparse == TRUE
    cat("Single simulation result [saved/printed with sparse details]")
    cat(final_status)
    cat0("\nFinal sample size: ", x$final_n,
         "\nAvailable outcome data at last adaptive analysis: ", fmt_pct(x$followed_n, x$final_n), "\n\n")
  } else { # Print more details if sparse == FALSE
    cat0("Single simulation result",
         ifelse(is.null(x$description), "", paste0(": ", x$description)),
         "\n* ", ifelse(x$highest_is_best, "Desirable", "Undesirable"), " outcome\n",

         ifelse(is.null(x$start_control), "* No common control arm",
                paste0("* Initial/final common control arms: ",
                       x$start_control, "/", x$final_control)))

    cat(final_status)
    cat0("\nFinal/maximum allowed sample sizes: ", fmt_pct(x$final_n, x$max_randomised),
         "\nAvailable outcome data at last adaptive analysis: ", fmt_pct(x$followed_n, x$final_n), "\n\n")
  }

  # Define colums and print results
  cols_general <- c("arms", "true_ys", "final_status", "status_look",
                    "status_probs", "final_alloc")
  cols_ests_all <- c("arms", "sum_ys_all", "ns_all", "raw_ests_all",
                     "post_ests_all", "post_errs_all", "lo_cri_all", "hi_cri_all")
  cols_ests <- c("arms", "sum_ys", "ns", "raw_ests", "post_ests", "post_errs", "lo_cri", "hi_cri")

  cat0("Trial results overview:\n")
  print(x$trial_res[cols_general], digits = prob_digits, row.names = FALSE)
  cat0("\nEsimates from final analysis (all patients):\n")
  print(x$trial_res[cols_ests_all], digits = prob_digits, row.names = FALSE)
  cat0("\nEstimates from last adaptive analysis including each arm:\n")
  print(x$trial_res[cols_ests], digits = prob_digits, row.names = FALSE)

  # Print simulation settings and estimation methods
  if (x$sparse) { # Print limited details if sparse == TRUE
    cat0("\nSimulation details:",
         "\n* Random seed: ", ifelse(is.null(x$seed), "none specified", x$seed), "\n")
  } else { # Print more details if sparse == FALSE
    cat0("\nSimulation details:",
         "\n* Random seed: ", ifelse(is.null(x$seed), "none specified", x$seed),
         "\n* Credible interval width: ", round(x$cri_width * 100, prob_digits), "%",
         "\n* Number of posterior draws: ", x$n_draws,
         "\n* Posterior estimation method: ", ifelse(x$robust, "medians with MAD-SDs", "means with SDs"))

    if (!is.null(x$add_info)) cat0("\n\n", "Additional info: ", x$add_info)
    cat0("\n")
  }

  # Return invisibly
  invisible(x)
}



#' Print method for trial performance metrics
#'
#' @param x object to print, output from [check_performance()].
#' @param digits single integer, the number of digits used when printing
#'   the numeric results (for all performance estimates). Default is `3? .
#'
#' @describeIn print Trial performance metrics
#' @export
#'
print.trial_performance <- function(x, digits = 3, ...) {
  x_round <- x
  for (i in 2:ncol(x_round)) {
    x_round[[i]] <- vapply_num(x_round[[i]], function(col) round(col, digits = 3))
  }
  class(x_round) <- "data.frame"
  print(x_round)
  # Return invisibly
  invisible(x)
}


#' Print method for multiple simulated trials
#'
#' @param x object to print, see Details below.
#' @inheritParams summary
#' @param digits single integer, number of digits to print for probabilities.
#'
#' @details
#' - `trial_results`: prints the results of multiple simulations
#' generated using [run_trials()]. Further documentation on how multiple trials
#' are summarised before printing can be found in the [summary()] function
#' documentation.
#'
#' @describeIn print Multiple trial results
#' @export
#'
print.trial_results <- function(x,
                                select_strategy = "control if available",
                                select_last_arm = FALSE,
                                select_preferences = NULL, te_comp = NULL,
                                raw_ests = FALSE, final_ests = NULL,
                                restrict = NULL, digits = 1,
                                ...) {
  print(summary(object = x, select_strategy = select_strategy,
                select_preferences = select_preferences, te_comp = te_comp,
                raw_ests = raw_ests, final_ests = final_ests, restrict = restrict),
        digits = digits)

  # Return invisibly
  invisible(x)
}



#' Print summarised results for multiple simulated trials
#'
#' @param x object to print, see Details below.
#' @param digits single integer, number of digits to print for probabilities and
#'   some other summary values (with 2 extra digits added for outcome rates).
#'
#' @details
#' - `trial_results_summary`: print method for summary of multiple simulations
#' of the same trial specification, generated by using the [summary()] function
#' on an object generated by [run_trials()].
#'
#' @describeIn print Summary of multiple trial results
#' @export
#'
print.trial_results_summary <- function(x, digits = 1, ...) {


  # Selection strategy
  select_strategy  <- x$select_strategy
  if (isTRUE(select_strategy == "control if available")){
    select_strategy <- ifelse(is.null(x$control), "none", "control")
  }

  # Print results - general settings
  cat("Multiple simulation results", ifelse(is.null(x$description), "", paste0(": ", x$description)),
      "\n* ", ifelse(x$highest_is_best, "Desirable", "Undesirable"), " outcome\n",

      "* Number of simulations: ", x$n_rep, "\n",
      "* Number of simulations summarised: ", x$n_summarised, " (", ifelse(x$n_summarised == x$n_rep, "all trials",
                                                                           paste0(fmt_pct(x$n_rep, x$n_summarised),
                                                                                  ifelse(!is.null(x$restrict), paste0("; restricted to ", x$restrict, " arms"), "" ))), ")\n",
      "* ", ifelse(is.null(x$control), "No common control arm",
                   paste0("Common control arm: ", x$control)), "\n",
      "* Selection strategy: ", ifelse(x$select_last_arm, "last remaining arm in trials stopped for equivalence/futility,\n  otherwise ", ""),
      ifelse(select_strategy == "control", "first control if available (otherwise no selection)",
             ifelse(select_strategy == "final control", "final control",
                    ifelse(select_strategy == "none", "no selection if no superior arm",
                           ifelse(select_strategy == "control or best", "control if available, otherwise best remaining",
                                  ifelse(select_strategy == "best", "best remaining available",
                                         ifelse(select_strategy == "list or best", paste0("first on preference list (", paste0(x$select_preferences, collapse = ", "), "), best remaining if none of those available"),
                                                ifelse(select_strategy == "list", paste0("first on preference list (", paste0(x$select_preferences, collapse = ", "), "), no selection if none of those available"),
                                                       "missing selection strategy"))))))), "\n",
      "* Treatment effect compared to: ", ifelse(is.null(x$te_comp), "no comparison", x$te_comp), "\n\n",

      # Performance metrics
      "Performance metrics ", ifelse(x$raw_ests, "(using raw estimates ", "(using posterior estimates "),
      ifelse(x$final_ests, "from final analysis [all patients]", "from last adaptive analysis"), "):\n",
      "* Sample sizes: mean ", fmt_dig(x$size_mean, digits), " (SD: ", fmt_dig(x$size_sd, digits), ") | median ", fmt_dig(x$size_median, digits), " (IQR: ", fmt_dig(x$size_p25, digits), " to ", fmt_dig(x$size_p75, digits), ")", "\n",
      "* Total summarised outcomes: mean ", fmt_dig(x$sum_ys_mean, digits), " (SD: ", fmt_dig(x$sum_ys_sd, digits), ") | median ", fmt_dig(x$sum_ys_median, digits), " (IQR: ", fmt_dig(x$sum_ys_p25, digits), " to ", fmt_dig(x$sum_ys_p75, digits), ")", "\n",
      "* Total summarised outcome rates: mean ", fmt_dig(x$ratio_ys_mean, digits+2), " (SD: ", fmt_dig(x$ratio_ys_sd, digits+2), ") | median ", fmt_dig(x$ratio_ys_median, digits+2), " (IQR: ", fmt_dig(x$ratio_ys_p25, digits+2), " to ", fmt_dig(x$ratio_ys_p75, digits+2), ")", "\n",
      "* Conclusive: ", ifelse(is.null(x$restrict), paste0(fmt_dig(x$prob_conclusive * 100, digits), "%"), "not calculated for restricted summaries"), "\n",
      "* Superiority: ", fmt_dig(x$prob_superior * 100, digits), "%\n",
      "* Equivalence: ", fmt_dig(x$prob_equivalence * 100, digits), "%", ifelse(x$equivalence_assessed, "\n", " [not assessed]\n"),
      "* Futility: ", fmt_dig(x$prob_futility * 100, digits), "%", ifelse(x$futility_assessed, "\n", " [not assessed]\n"),
      "* Inconclusive at max sample size: ", fmt_dig(x$prob_max * 100, digits), "%\n",
      "* Selection probabilities: ", paste0(vapply_str(which(substr(names(x), 1, 12) == "prob_select_"),
                                                       function(i){ paste0(ifelse(names(x)[i] == "prob_select_none", "None", substr(names(x)[i], 17, nchar(names(x)[i]))), ": ", fmt_dig(x[[names(x)[i]]]*100, digits), "%")}),
                                            collapse = " | "), "\n",
      "* RMSE: ", fmt_dig(x$rmse, 5), "\n",
      "* RMSE treatment effect: ", ifelse(is.na(x$rmse_te), "not estimated", fmt_dig(x$rmse_te, 5)), "\n",
      "* Ideal design percentage: ", ifelse(is.na(x$idp), "not estimable", paste0(fmt_dig(x$idp, digits), "%")),

      # Technical simulation details
      "\n\nSimulation details:",
      "\n* Simulation time: ", format(unclass(x$elapsed_time), digits = 3), " ", attr(x$elapsed_time, "units"),
      "\n* Base random seed: ", ifelse(is.null(x$base_seed), "none specified", x$base_seed),
      "\n* Credible interval width: ", round(x$cri_width * 100, digits), "%",
      "\n* Number of posterior draws: ", x$n_draws,
      "\n* Estimation method: ", ifelse(x$raw_ests, "raw estimates", ifelse(x$robust, "posterior medians with MAD-SDs", "posterior means with SDs")),
      ifelse(!is.null(x$add_info), paste0("\n\n", "Additional info: ", x$add_info), ""),

      "\n", sep = "")

  # Return invisibly
  invisible(x)
}
