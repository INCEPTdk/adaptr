#' Update previously saved simulations
#'
#' This function updates a previously saved `"trial_results"`-object created and
#' saved by [run_trials()] using a previous version of `adaptr`, allowing the
#' results from these previous simulations to be post-processed (including
#' printing and plotting) by this version of the package. The function should be
#' run only once per saved simulation object (and will print a warning if the
#' object is already up to date).\cr
#' **NOTE:** some values cannot be updated and will be set to `NA` (the
#' posterior estimates from the 'final' analysis conducted after the last
#' adaptive analysis and including outcome data for all patients), and thus
#' using both `raw_ests = TRUE` and `final_ests = TRUE` in the
#' [extract_results()] and [summary()] functions will lead to missing values for
#' some of the values calculated for updated simulation objects.
#'
#' @inheritParams run_trial
#' @param path single character; the path to the saved `"trial_results"`-object
#'   containing the simulations saved by [run_trials()].
#' @param version passed to [saveRDS()] when saving the updated object, defaults
#'   to `NULL` (as in [saveRDS()]), which means that the current default version
#'   is used.
#' @param compress passed to [saveRDS()] when saving the updated object,
#'   defaults to `TRUE` (as in [saveRDS()]), see [saveRDS()] for other options.
#'
#' @return Invisibly returns the updated `"trial_results"`-object.
#'
#' @export
#'
#' @seealso
#' [run_trials()].
#'
update_saved_trials <- function(path, version = NULL, compress = TRUE) {
  # Check if file exists at path
  if (!file.exists(path)) stop("path must be a valid path to a trial_results-object.", call. = FALSE)
  object <- readRDS(path)
  if (!inherits(object, "trial_results")) {
    stop("path must lead to a valid trial_results-object previously saved by run_trials().", call. = FALSE)
  }
  prev_version <- object$trial_spec$adaptr_version
  save_object <- TRUE
  if (isTRUE(!is.null(prev_version) & prev_version == .adaptr_version)) { # Already up-to-date
    save_object <- FALSE
    warning("path leads to a trial_results-object that is already up to date; object not updated.", call. = FALSE)
  } else if (is.null(prev_version)) { # Saved by version 1.1.1 or earlier
# Do the updating

    # Update the trial_spec-part of the object, re-arrange order of objects, set class
    object$trial_spec$adaptr_version <- .adaptr_version
    object$trial_spec$randomised_at_looks <- object$trial_spec$data_looks
    object$trial_spec <- object$trial_spec[c("trial_arms", "data_looks", "max_n", "look_after_every",
                                             "n_data_looks", "randomised_at_looks", "control", "control_prob_fixed",
                                             "inferiority", "superiority", "equivalence_prob", "equivalence_diff",
                                             "equivalence_only_first", "futility_prob", "futility_diff", "futility_only_first",
                                             "highest_is_best", "soften_power", "best_arm", "cri_width", "n_draws", "robust",
                                             "description", "add_info", "fun_y_gen", "fun_draws", "fun_raw_est", "adaptr_version")]
    class(object$trial_spec) <- c("trial_spec", "list")

    # Update the trial_results-part of the object
    object$adaptr_version <- .adaptr_version

    # Update all resulting individual trial_result objects, re-arrange order of objecs, set class
    sparse <- object$sparse

    for (i in 1:object$n_rep) {
      tmp <- object$trial_results[[i]]
      tmp$adaptr_version <- .adaptr_version
      tmp$followed_n <- tmp$final_n
      tmp$trial_res$sum_ys_all <- tmp$trial_res$sum_ys
      tmp$trial_res$ns_all <- tmp$trial_res$ns
      tmp$trial_res$raw_ests_all <- tmp$trial_res$raw_ests
      tmp$trial_res[, c("post_ests_all", "post_errs_all", "lo_cri_all", "hi_cri_all")] <- NA
      tmp$trial_res <- tmp$trial_res[, c("arms", "true_ys", "start_probs", "fixed_probs", "min_probs", "max_probs",
                                         "sum_ys", "ns", "sum_ys_all", "ns_all", "raw_ests", "post_ests", "post_errs",
                                         "lo_cri", "hi_cri", "raw_ests_all", "post_ests_all", "post_errs_all", "lo_cri_all",
                                         "hi_cri_all", "final_status", "status_look", "status_probs", "final_alloc", "probs_best_last")]

      if (!sparse) { # Update results for non-sparse objects
        tmp$randomised_at_looks <- tmp$looks
        for (l in seq_along(tmp$all_looks)) { # Update results for each look
          tmp$all_looks[[l]]$sum_ys_all <- tmp$all_looks[[l]]$sum_ys
          tmp$all_looks[[l]]$ns_all <- tmp$all_looks[[l]]$ns
          tmp$all_looks[[l]] <- tmp$all_looks[[l]][c("arms", "old_status", "new_status", "sum_ys", "sum_ys_all", "ns", "ns_all",
                                                     "old_alloc", "probs_best", "new_alloc")]
        }
      }


      object$trial_results[[i]] <- if (sparse) {
        tmp[c("final_status", "final_n", "followed_n", "trial_res", "seed", "sparse", "adaptr_version")]
      } else {
        tmp[c("final_status", "final_n", "followed_n", "max_n", "looks", "planned_looks", "randomised_at_looks",
              "start_control", "final_control", "control_prob_fixed", "inferiority", "superiority", "equivalence_prob",
              "equivalence_diff", "equivalence_only_first", "futility_prob", "futility_diff", "futility_only_first",
              "highest_is_best", "soften_power", "best_arm", "trial_res", "all_looks", "allocs", "ys", "seed", "description",
              "add_info", "cri_width", "n_draws", "robust", "sparse", "adaptr_version")]
      }
      class(object$trial_results[[i]]) <- c("trial_result", "list")
    }
  }
  # Save and return invisibly
  if (save_object) {
    saveRDS(object, file = path, version = version, compress = compress)
  }
  invisible(object)
}
