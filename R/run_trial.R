#' Simulate a single trial
#'
#' This function conducts a single trial simulation using a trial specification
#' as specified by [setup_trial()], [setup_trial_binom()] or
#' [setup_trial_norm()].
#' During simulation, the function randomises "patients", randomly generates
#' outcomes, calculates the probabilities that each `arm` is the best (and
#' better than the control, if any). This is followed by checking inferiority,
#' superiority, equivalence and/or futility as desired; dropping arms, and
#' re-adjusting allocation probabilities according to the criteria specified in
#' the trial specification. If there is no common `control` arm, the trial
#' simulation will be stopped at the final specified adaptive analysis, when 1
#' arm is superior to the others, or when all arms are considered equivalent (if
#' equivalence testing is specified).\cr
#' If a common `control` arm is specified, all other arms will be compared to
#' that, and if 1 comparison crosses the applicable superiority threshold at an
#' adaptive analysis, that arm will become the new control and the old control
#' will be considered inferior. If multiple non-control arms cross the
#' applicable superiority threshold in the same adaptive analysis, the one with
#' the highest probability of being the overall best will become the new
#' control. Equivalence/futility will also be checked if specified, and
#' equivalent or futile arms will be dropped in designs with a common `control`
#' arm and the entire trial will be stopped if all remaining arms are equivalent
#' in designs without a common `control` arm. The trial simulation will be
#' stopped when only 1 arm is left, when the final arms are all equivalent, or
#' after the final specified adaptive analysis.\cr
#' After stopping (regardless of reason), a final analysis including outcome
#' data from all patients randomised to all arms will be conducted (with the
#' final `control` arm, if any, used as the `control` in this analysis).
#' Results from this analysis will be saved, but not used with regards to the
#' adaptive stopping rules. This is particularly relevant if less patients have
#' available outcome data at the adaptive analyses than the total number of
#' patients randomised (as specified in [setup_trial()], [setup_trial_binom()],
#' or [setup_trial_norm()]), as the final analysis will then include all
#' patients randomised, which may be more than in the last adaptive analysis
#' conducted.
#'
#' @param trial_spec `trial_spec` object, generated and validated by the
#'   [setup_trial()], [setup_trial_binom()] or [setup_trial_norm()] function.
#' @param seed single integer or `NULL` (default). If a value is provided, this
#'   value will be used as the random seed when running and the global random
#'   seed will be restored after the function has run, so it is not affected.
#' @param sparse single logical; if `FALSE` (default) everything listed below is
#'   included in the returned object. If `TRUE`, only a limited amount of data
#'   is included in the returned object. This can be practical when running many
#'   simulations and saving the results using the [run_trials()] function (which
#'   relies on this function), as the output file will thus be substantially
#'   smaller. However, printing of individual trial results will be
#'   substantially less detailed for sparse results and non-sparse results are
#'   required by [plot_history()].
#'
#' @return A `trial_result` object containing everything listed below if
#'   `sparse` (as described above) is `FALSE`. Otherwise only `final_status`,
#'   `final_n`, `followed_n`, `trial_res`, `seed`, and `sparse` are included.
#'   \itemize{
#'     \item `final_status`: either `"superiority"`, `"equivalence"`,
#'       `"futility"`, or `"max"` (stopped at the last possible adaptive
#'       analysis), as calculated during the adaptive analyses.
#'     \item `final_n`: the total number of patients randomised.
#'     \item `followed_n`: the total number of patients with available outcome
#'       data at the last adaptive analysis conducted.
#'     \item `max_n`: the pre-specified maximum number of patients with outcome
#'       data available at the last possible adaptive analysis.
#'     \item `max_randomised`: the pre-specified maximum number of patients
#'       randomised at the last possible adaptive analysis.
#'     \item `looks`: numeric vector, the total number of patients with outcome
#'       data available at each conducted adaptive analysis.
#'     \item `planned_looks`: numeric vector, the cumulated number of patients
#'       planned to have outcome data available at each adaptive analysis, even
#'       those not conducted if the simulation is stopped before the final
#'       possible analysis.
#'     \item `randomised_at_looks`: numeric vector, the total number of patients
#'       randomised at each conducted adaptive analysis.
#'     \item `start_control`: character, initial common control arm (if
#'       specified).
#'     \item `final_control`: character, final common control arm (if relevant).
#'     \item `control_prob_fixed`: fixed common control arm probabilities (if
#'       specified; see [setup_trial()]).
#'     \item `inferiority`, `superiority`, `equivalence_prob`,
#'       `equivalence_diff`, `equivalence_only_first`, `futility_prob`,
#'       `futility_diff`, `futility_only_first`, `highest_is_best`, and
#'       `soften_power`: as specified in [setup_trial()].
#'     \item `best_arm`: the best arm(s), as described in [setup_trial()].
#'     \item `trial_res`: a `data.frame` containing most of the information
#'       specified for each arm in [setup_trial()] including `true_ys` (true
#'       outcomes as specified in [setup_trial()]) and for each arm the sum of
#'       the outcomes (`sum_ys`/`sum_ys_all`; i.e., the total number of events
#'       for binary outcomes or the totals of continuous outcomes) and sum of
#'       patients (`ns`/`ns_all`), summary statistics for the raw outcome data
#'       (`raw_ests`/`raw_ests_all`, calculated as specified in [setup_trial()],
#'       defaults to mean values, i.e., event rates for binary outcomes or means
#'       for continuous outcomes) and posterior estimates
#'       (`post_ests`/`post_ests_all`, `post_errs`/`post_errs_all`,
#'       `lo_cri`/`lo_cri_all`, and `hi_cri`/`hi_cri_all`, calculated as
#'       specified in [setup_trial()]), `final_status` of each arm
#'       (`"inferior"`, `"superior"`, `"equivalence"`, `"futile"`, `"active"`,
#'       or `"control"` (currently active control arm, including if the current
#'       control when stopped for equivalence)), `status_look` (specifying the
#'       cumulated number of patients with outcome data available when an
#'       adaptive analysis changed the `final_status` to `"superior"`,
#'       `"inferior"`, `"equivalence"`, or `"futile"`), `status_probs`, the
#'       probability (in the last adaptive analysis for each arm) that each
#'       arm was the best/better than the common control arm (if any)/equivalent
#'       to the common control arm (if any and stopped for equivalence; `NA` if
#'       the control arm was stopped due to the last remaining other arm(s)
#'       being stopped for equivalence)/futile if stopped for futility at the
#'       last analysis it was included in, `final_alloc`, the final allocation
#'       probability for each arm the last time patients were randomised to it,
#'       including for arms stopped at the maximum sample size, and
#'       `probs_best_last`, the probabilities of each remaining arm being the
#'       overall best in the last conducted adaptive analysis (`NA` for
#'       previously dropped arms).\cr
#'       **Note:** for the variables in the `data.frame` where a version
#'       including the `_all`-suffix is included, the versions WITHOUT this
#'       suffix are calculated using patients with available outcome data at the
#'       time of analysis, while the versions WITH the `_all`-suffixes are
#'       calculated using outcome data for all patients randomised at the time
#'       of analysis, even if they have not reached the time of follow-up yet
#'       (see [setup_trial()]).
#'     \item `all_looks`: a list of lists containing one list per conducted
#'       trial look (adaptive analysis). These lists contain the variables
#'       `arms`, `old_status` (status before the analysis of the current round
#'       was conducted), `new_status` (as specified above, status after current
#'       analysis has been conducted), `sum_ys`/`sum_ys_all` (as described
#'       above), `ns`/`ns_all` (as described above), `old_alloc` (the allocation
#'       probability used during this look), `probs_best` (the probabilities of
#'       each arm being the best in the current adaptive analysis), `new_alloc`
#'       (the allocation probabilities after updating these in the current
#'       adaptive analysis; NA for all arms when the trial is stopped and no
#'       further adaptive analyses will be conducted), `probs_better_first` (if
#'       a common control is provided, specifying the probabilities that each
#'       arm was better than the control in the first analysis conducted during
#'       that look), `probs_better` (as `probs_better_first`, but updated if
#'       another arm becomes the new control), `probs_equivalence_first` and
#'       `probs_equivalence` (as for `probs_better`/`probs_better_first`, but
#'       for equivalence if equivalence is assessed). The last variables are
#'       `NA` if the arm was not active in the applicable adaptive analysis or
#'       if they would not be included during the next adaptive analysis.
#'     \item `allocs`: a character vector containing the allocations of all
#'       patients in the order of randomization.
#'     \item `ys`: a numeric vector containing the outcomes of all patients in
#'       the order of randomization (`0` or `1` for binary outcomes).
#'     \item `seed`: the random seed used, if specified.
#'     \item `description`, `add_info`, `cri_width`, `n_draws`, `robust`: as
#'       specified in [setup_trial()], [setup_trial_binom()] or
#'       [setup_trial_norm()].
#'     \item `sparse`: single logical, corresponding to the `sparse` input.
#'    }
#'
#' @export
#'
#' @importFrom stats setNames na.omit
#'
#' @examples
#' # Setup a trial specification
#' binom_trial <- setup_trial_binom(arms = c("A", "B", "C", "D"),
#'                                  true_ys = c(0.20, 0.18, 0.22, 0.24),
#'                                  data_looks = 1:20 * 100)
#'
#' # Run trial with a specified random seed
#' res <- run_trial(binom_trial, seed = 12345)
#'
#' # Print results with 3 decimals
#' print(res, digits = 3)
#'
run_trial <- function(trial_spec, seed = NULL, sparse = FALSE) {

  # Check class (validation takes place when the trial is setup)
  if (!inherits(trial_spec, "trial_spec")) {
    stop0("trial_spec must be an object created by the setup_trial, ",
          "setup_trial_binom or setup_trial_norm function.")
  }

  # Random seed
  if (!is.null(seed)) {
    if (!verify_int(seed)) {
      stop0("seed must be either NULL or a single whole number.")
    } else { # Valid seed provided
      if (exists(".Random.seed", envir = globalenv())) { # A global random seed exists (not the case when called from parallel::parLapply)
        oldseed <- get(".Random.seed", envir = globalenv())
        on.exit(assign(".Random.seed", value = oldseed, envir = globalenv()), add = TRUE, after = FALSE)
      }
      set.seed(seed)
    }
  }
  # Validate sparse
  if (is.null(sparse) | length(sparse) != 1 | any(is.na(sparse)) | !is.logical(sparse)) {
    stop0("sparse must be a single TRUE or FALSE.")
  }

  # Prepare variables/extract from specification
  trial_arms <- as.list(trial_spec$trial_arms)
  arms <- trial_arms$arms
  control <- trial_spec$control
  control_prob_fixed <- trial_spec$control_prob_fixed
  match_arm <- isTRUE(control_prob_fixed == "match") # Match control arm allocation probability to highest non-control arm
  true_ys <- trial_arms$true_ys
  n_arms <- length(arms)
  aai <- 1:n_arms # aai = active arm indices
  sum_ys <- sum_ys_all <- ns <- ns_all <- rep(0, n_arms)
  total_n <- 0
  n_data_looks <- trial_spec$n_data_looks
  inferiority <- trial_spec$inferiority
  if (length(inferiority) == 1) {
    inferiority <- rep(inferiority, n_data_looks)
  }
  superiority <- trial_spec$superiority
  if (length(superiority) == 1) {
    superiority <- rep(superiority, n_data_looks)
  }
  equivalence_prob <- trial_spec$equivalence_prob
  equivalence_diff <- trial_spec$equivalence_diff
  equivalence_only_first <- trial_spec$equivalence_only_first
  check_equivalence <- !is.null(equivalence_prob)
  if (check_equivalence & length(equivalence_prob) == 1) {
    equivalence_prob <- rep(equivalence_prob, n_data_looks)
  }
  equivalence_stop <- FALSE
  prob_all_equivalent <- NULL
  futility_diff <- trial_spec$futility_diff
  futility_prob <- trial_spec$futility_prob
  futility_only_first <- trial_spec$futility_only_first
  check_futility <- !is.null(futility_prob)
  if (check_futility & length(futility_prob) == 1) {
    futility_prob <- rep(futility_prob, n_data_looks)
  }
  futility_stop <- FALSE
  highest_is_best <- trial_spec$highest_is_best
  cri_width <- trial_spec$cri_width
  n_draws <- trial_spec$n_draws
  robust <- trial_spec$robust
  data_looks <- trial_spec$data_looks
  randomised_at_looks <- trial_spec$randomised_at_looks
  allocs <- rep(NA_character_, randomised_at_looks[n_data_looks]) # All allocations
  ys <- rep(NA_real_, randomised_at_looks[n_data_looks]) # All outcomes
  fun_y_gen <- trial_spec$fun_y_gen
  fun_draws <- trial_spec$fun_draws
  # Prepare objects with final/current statuses
  trial_arms$final_status <- rep("active", n_arms)
  trial_arms$status_look <- rep(NA, n_arms)
  trial_arms$status_probs <- rep(NA, n_arms)
  trial_arms$final_alloc <- rep(NA, n_arms)
  trial_arms$probs_best_last <- rep(NA, n_arms)
  post <- matrix(rep(NA, 4*n_arms), ncol = 4) # Contains current/final posterior for each arm
  cur_status <- list(arms = arms,
                     old_status = rep("active", n_arms),
                     new_status = rep("active", n_arms),
                     sum_ys = sum_ys, sum_ys_all = sum_ys_all,
                     ns = ns, ns_all = ns_all,
                     old_alloc = rep(NA, n_arms),
                     probs_best = rep(NA, n_arms),
                     new_alloc = trial_arms$start_probs)
  if (!is.null(control)) {
    control_index <- which(cur_status$arms == control)
    cur_status$old_status[control_index] <- "control"
    cur_status$new_status[control_index] <- "control"
    cur_status$probs_better_first <- rep(NA, n_arms)
    cur_status$probs_better <- rep(NA, n_arms)
  }
  soften_power <- trial_spec$soften_power
  trial_break <- FALSE
  if (!sparse) looks_status <- list()

  # Loop through each look (adaptive analysis) - break loop when relevant
  for (look in 1:n_data_looks) {

    # Randomise new patients and get outcomes after setting up indices and saving "old" allocation ratios (including starting ratios)
    cur_status$old_status <- cur_status$new_status
    cur_status$old_alloc <- cur_status$new_alloc
    cur_status$new_alloc <- rep(NA, n_arms) # Delete old values
    aai <- which(cur_status$new_status %in% c("active", "control"))
    n_new <- randomised_at_looks[look] - total_n
    if (n_new > 0) { # If no more patients are randomised at this analysis (but more have reached follow-up)
      new_patients <- sample(arms[aai], size = n_new, prob = cur_status$old_alloc[aai], replace = TRUE)
      allocs[(total_n+1):(total_n+n_new)] <- new_patients
      ys[(total_n+1):(total_n+n_new)] <- fun_y_gen(new_patients)
    }
    followed_n <- data_looks[look] # Number of patients with outcome data
    total_n <- randomised_at_looks[look] # Number of patients randomised
    cur_status$ns[aai] <- ns[aai] <- vapply_int(arms[aai], function(a) sum(allocs[1:followed_n] == a))
    cur_status$ns_all <- ns_all <- vapply_int(arms, function(a) sum(allocs[1:total_n] == a))
    # which() required to avoid summing over NA's (which yields an NA sum)
    cur_status$sum_ys[aai] <- sum_ys[aai] <- vapply_num(arms[aai], function(a) sum(ys[which(allocs[1:followed_n] == a)]))
    cur_status$sum_ys_all <- sum_ys_all <- vapply_num(arms, function(a) sum(ys[which(allocs[1:total_n] == a)]))

    # Get draws and probabilities that each treatment is superior (and better/equivalent if specified)
    draws <- fun_draws(arms = arms[aai], allocs = allocs[1:followed_n],
                       ys = ys[1:followed_n], control = control, n_draws = n_draws)
    probs_best <- prob_best(draws, highest_is_best)
    cur_status$probs_best <- rep(NA, n_arms) # Delete old values
    cur_status$probs_best[aai] <- probs_best # Save the first set of best values this round, only for active arms

    if (!is.null(control)) { # A common control exists - get probabilities compared to control

      probs_res_better <- prob_better(draws, control, highest_is_best, equivalence_diff, futility_diff)
      probs_better <- probs_res_better[, "probs_better"]
      cur_status$probs_better_first <- rep(NA, n_arms) # Delete old values
      cur_status$probs_better <- rep(NA, n_arms) # Delete old values
      cur_status$probs_better_first[aai] <- probs_better # Save the first set of comparative values this round, only for active arms
      cur_status$probs_better[aai] <- probs_better # Save the first set of comparative values this round, only for active arms, but possibly updated later

      if (check_equivalence){
        probs_equivalence <- probs_res_better[, "probs_equivalence"]
        cur_status$probs_equivalence_first <- rep(NA, n_arms) # Delete old values
        cur_status$probs_equivalence <- rep(NA, n_arms) # Delete old values
        cur_status$probs_equivalence_first[aai] <- probs_equivalence # Save the first set of comparative values this round, only for active arms
        cur_status$probs_equivalence[aai] <- probs_equivalence # Save the first set of comparative values this round, only for active arms, but possibly updated later
      }

      if (check_futility){
        probs_futility <- probs_res_better[, "probs_futility"]
        cur_status$probs_futility_first <- rep(NA, n_arms) # Delete old values
        cur_status$probs_futility <- rep(NA, n_arms) # Delete old values
        cur_status$probs_futility_first[aai] <- probs_futility # Save the first set of comparative values this round, only for active arms
        cur_status$probs_futility[aai] <- probs_futility # Save the first set of comparative values this round, only for active arms, but possibly to be updated later
      }
    }

    # Run comparisons

    # No common control
    if (is.null(control)) { # No common control:

      # Keep removing inferior arms until they are all dropped
      # - for every inferior arm dropped, draws/probabilities are updated
      check_equivalence <- !is.null(equivalence_prob)
      while(any(probs_best < inferiority[look])) {
        inferior_probs <- probs_best[probs_best < inferiority[look]]
        inferior_arms <- names(probs_best)[probs_best < inferiority[look]]

        for (i in seq_along(inferior_arms)) {
          cur_index <- which(cur_status$arms == inferior_arms[i])
          cur_status$new_status[cur_index] <- "inferior"
          aai <- aai[!(aai == cur_index)]
          trial_arms$final_status[cur_index] <- "inferior"
          trial_arms$status_look[cur_index] <- followed_n
          trial_arms$status_probs[cur_index] <- inferior_probs[i]
          trial_arms$final_alloc[cur_index] <- cur_status$old_alloc[cur_index]
          post[cur_index, ] <- summarise_dist(draws[, inferior_arms[i]], robust, cri_width)
        }

        # Update draws again
        draws <- fun_draws(arms = arms[aai], allocs = allocs[1:followed_n],
                           ys = ys[1:followed_n], control = control, n_draws = n_draws)
        probs_best <- prob_best(draws, highest_is_best)
      } # End inferiority checks no common control

      # Check if an arm is superior
      superior_prob <- max(probs_best)
      if (superior_prob > superiority[look]) {
        superior_arm <- names(probs_best)[which.max(probs_best)]
        cur_index <- which(cur_status$arms == superior_arm)
        cur_status$new_status[cur_index] <- "superior"
        aai <- cur_index
        trial_arms$final_status[cur_index] <- "superior"
        trial_arms$status_look[cur_index] <- followed_n
        trial_arms$status_probs[cur_index] <- superior_prob
        trial_arms$final_alloc[cur_index] <- cur_status$old_alloc[cur_index]
        post[cur_index, ] <- summarise_dist(draws[, superior_arm], robust, cri_width)
        trial_break <- TRUE
        check_equivalence <- FALSE
      } # End superiority check no common control

      # Equivalence check no common control
      if (check_equivalence) {
        prob_all_equivalent <- prob_all_equi(draws, equivalence_diff)
        if (prob_all_equivalent > equivalence_prob[look]){
          cur_status$new_status[aai] <- "equivalence"
          trial_arms$final_status[aai] <- "equivalence"
          trial_arms$status_look[aai] <- followed_n
          trial_arms$status_probs[aai] <- probs_best
          trial_arms$final_alloc[aai] <- cur_status$old_alloc[aai]
          for (ie in aai){
            post[ie, ]<- summarise_dist(draws[, arms[ie]], robust, cri_width)
          }
          trial_break <- TRUE
          equivalence_stop <- TRUE
        }
      } # End equivalence check no common control

      # Reallocate probabilities (unless the trial has been stopped)
      if (!trial_break) {
        cur_status$new_alloc[aai] <- reallocate_probs(
          probs_best,
          fixed_probs = trial_arms$fixed_probs[aai],
          min_probs = trial_arms$min_probs[aai],
          max_probs = trial_arms$max_probs[aai],
          soften_power = soften_power[look]
        )
      }


      # Common control
    } else { # Common control:
      run_check <- TRUE # Used to signal that it is necessary to run a new round of checks - checks must be run multiple times if new control is found
      update_draws <- FALSE # Only update if arms dropped
      control_index <- which(cur_status$arms == control)

      # Run checks
      while (run_check) {
        run_check <- FALSE

        # Inferiority checks common control
        # Check if at least one arm is inferior to the control - if that is the case, then drop all inferior arms
        # No need to re-run this part after each inferior arm is dropped, as all comparisons are relative to the control only
        if (any(probs_better < inferiority[look], na.rm = TRUE)) {
          which_inferior <- which(probs_better < inferiority[look])
          inferior_arms <- rownames(probs_res_better)[which_inferior]
          inferior_probs <- probs_better[which_inferior]
          update_draws <- TRUE

          for (i in seq_along(inferior_arms)) {
            cur_index <- which(cur_status$arms == inferior_arms[i])
            cur_status$new_status[cur_index] <- "inferior"
            aai <- aai[aai != cur_index]
            trial_arms$final_status[cur_index] <- "inferior"
            trial_arms$status_look[cur_index] <- followed_n
            trial_arms$status_probs[cur_index] <- inferior_probs[i]
            trial_arms$final_alloc[cur_index] <- cur_status$old_alloc[cur_index]
            post[cur_index, ] <- summarise_dist(draws[, inferior_arms[i]], robust, cri_width)
          }
        }
        # End inferiority checks common control

        # Superiority check common control
        # Not necessary to update draws again before superiority has been claimed
        # Relative superiority check common control
        if (any(probs_better > superiority[look], na.rm = TRUE)) { # Set new control - only 1 is declared superior at a time (if multiple are better, the best is chosen)
          update_draws <- TRUE
          new_control <- rownames(probs_res_better)[which.max(probs_better)]
          cur_index <- which(cur_status$arms == new_control)
          cur_status$new_status[cur_index] <- "control"
          cur_status$new_status[control_index] <- "inferior"
          aai <- aai[!(aai == control_index)]
          trial_arms$final_status[control_index] <- "inferior"
          trial_arms$status_look[control_index] <- followed_n
          trial_arms$status_probs[control_index] <- 1 - max(probs_better, na.rm = TRUE)
          trial_arms$final_alloc[control_index] <- cur_status$old_alloc[control_index]
          post[control_index, ]  <- summarise_dist(draws[, control], robust, cri_width)
          control <- new_control
          run_check <- TRUE # There is a new control - run a new check
          if (isTRUE(check_equivalence & equivalence_only_first)) {
            check_equivalence <- FALSE # Don't check for equivalence when control changes if only wanted for first comparison
          }
          if (isTRUE(check_futility & futility_only_first)) {
            check_futility <- FALSE # Don't check for futility when control changes if only wanted for first comparison
          } # End superiority check common control

          # Equivalence check common control - only if no arms are superior
          # No arms are superior - check equivalence if specified; NOT done until new draws are
          # obtained if one arm has just been deemed superior and made the new control
        } else {
          if (check_equivalence) {
            if (any(probs_equivalence > equivalence_prob[look], na.rm = TRUE)) {
              which_equivalent <- which(probs_equivalence > equivalence_prob[look])
              equivalent_arms <- rownames(probs_res_better)[which_equivalent]
              equivalence_probs <- probs_equivalence[which_equivalent]
              update_draws <- TRUE

              for (i in seq_along(equivalent_arms)) {
                cur_index <- which(cur_status$arms == equivalent_arms[i])
                cur_status$new_status[cur_index] <- "equivalence"
                aai <- aai[aai != cur_index]
                trial_arms$final_status[cur_index] <- "equivalence"
                trial_arms$status_look[cur_index] <- followed_n
                trial_arms$status_probs[cur_index] <- equivalence_probs[i]
                trial_arms$final_alloc[cur_index] <- cur_status$old_alloc[cur_index]
                post[cur_index, ]  <- summarise_dist(draws[, equivalent_arms[i]], robust, cri_width)
              }

              if (length(aai) == 1) {
                equivalence_stop <- TRUE # Only one arm left - others stopped for equivalence
                check_futility <- FALSE # No need to check for futility any more then
              }
            }
          } # End equivalence check common control

          # Futility check common control
          if (check_futility) {
            if (any(probs_futility > futility_prob[look], na.rm = TRUE)) {
              which_futile <- which(probs_futility > futility_prob[look])
              futile_arms <- rownames(probs_res_better)[which_futile]
              # Don't consider an arm futile if it's already judged to be equivalent
              non_equi_index <- !futile_arms %in% cur_status$arms[which(cur_status$new_status == "equivalence")]
              futile_arms <- futile_arms[non_equi_index]
              futility_probs <- probs_futility[which_futile]

              if (length(futile_arms > 0)) { # Truly futile (not equivalent) arms exist
                update_draws <- TRUE

                for (i in seq_along(futile_arms)) {
                  cur_index <- which(cur_status$arms == futile_arms[i])
                  cur_status$new_status[cur_index] <- "futile"
                  aai <- aai[aai != cur_index]
                  trial_arms$final_status[cur_index] <- "futile"
                  trial_arms$status_look[cur_index] <- followed_n
                  trial_arms$status_probs[cur_index] <- futility_probs[i]
                  trial_arms$final_alloc[cur_index] <- cur_status$old_alloc[cur_index]
                  post[cur_index, ] <- summarise_dist(draws[, futile_arms[i]], robust, cri_width)
                }

                if (length(aai) == 1) {
                  futility_stop <- TRUE # Only one arm left - others stopped for futility
                }
              }
            }
          } # End futility check common control

        }

        # Overall superiority/conclusiveness check common control
        if (length(aai) == 1) { # Only 1 arm left - break loop
          cur_index <- aai
          cur_status$new_status[cur_index] <- if (equivalence_stop | futility_stop) "active" else "superior"
          trial_arms$final_status[cur_index] <- if (equivalence_stop | futility_stop) "active" else "superior"
          trial_arms$status_look[cur_index] <- followed_n

          if (any(!is.na(probs_better)) & !equivalence_stop & !futility_stop) { # Only if some are not NA, to avoid problems when checking for the last control (and if not stopped for equivalence/futility)
            trial_arms$status_probs[cur_index] <- max(na.omit(probs_better), 1 - na.omit(probs_better)) # Get highest of the current relative probs for last control (2+ comparisons, or inverse)
          }

          trial_arms$final_alloc[cur_index] <- cur_status$old_alloc[cur_index]
          post[cur_index, ] <- summarise_dist(draws[, arms[cur_index]], robust, cri_width)
          trial_break <- TRUE
        }

        # Get updated draws and probabilities that each treatment is superior again if necessary (otherwise reuse)
        if (update_draws) {
          draws <- fun_draws(arms = arms[aai], allocs = allocs[1:followed_n],
                             ys = ys[1:followed_n], control = control, n_draws = n_draws)
          probs_best <- prob_best(draws, highest_is_best)

          if (run_check) { # New control, updated
            probs_res_better <- prob_better(draws, control, highest_is_best,
                                            equivalence_diff, futility_diff)
            probs_better <- probs_res_better[, "probs_better"]

            if (check_equivalence) {
              probs_equivalence <- probs_res_better[, "probs_equivalence"]
            }

            if (check_futility) {
              probs_futility <- probs_res_better[, "probs_futility"]
            }
          } else {
            better_active_arms <- rownames(probs_res_better) %in% trial_arms$arms[aai]
            probs_better <- probs_res_better[, "probs_better"][better_active_arms] # Reuse the same draws

            if (check_equivalence) {
              probs_equivalence <- probs_res_better[, "probs_equivalence"][better_active_arms] # Reuse the same draws
            }

            if (check_futility) {
              probs_futility <- probs_res_better[, "probs_futility"][better_active_arms] # Reuse the same draws
            }
          }

          cur_status$probs_better <- rep(NA, n_arms) # Delete old values
          cur_status$probs_better[aai] <- probs_better # Save the new set of comparative probabilities this round, only for active arms

          if(check_equivalence) {
            cur_status$probs_equivalence <- rep(NA, n_arms) # Delete the old values
            cur_status$probs_equivalence[aai] <- probs_equivalence # Save the new set of comparative probabilities for this round, only for active arms
          }

          if(check_futility) {
            cur_status$probs_futility <- rep(NA, n_arms) # Delete the old values
            cur_status$probs_futility[aai] <- probs_futility # Save the new set of comparative probabilities for this round, only for active arms
          }
        }

        # Reallocate probabilities(unless the trial has been stopped)
        if (!trial_break) {
          fixed_probs_control <- trial_arms$fixed_probs[aai]
          min_probs_control <- trial_arms$min_probs[aai]
          max_probs_control <- trial_arms$max_probs[aai]

          if (!is.null(control_prob_fixed)) {
            active_control_arm <- which(trial_arms$arms[aai] == control)
            if (!match_arm) {
              if (length(control_prob_fixed) == 1){
                fixed_probs_control[active_control_arm] <- control_prob_fixed
              } else { # Multiple control_prob_fixed values provided
                fixed_probs_control[active_control_arm] <-
                  c(control_prob_fixed, 1)[1 + n_arms - length(aai)]
              }
            }
            min_probs_control[active_control_arm] <- NA
            max_probs_control[active_control_arm] <- NA
          }
          cur_status$new_alloc[aai] <- reallocate_probs(
            probs_best,
            fixed_probs = fixed_probs_control,
            min_probs = min_probs_control,
            max_probs = max_probs_control,
            soften_power = soften_power[look],
            if (match_arm) active_control_arm else NULL
          )
        }

      } # End run check
    } # End common control

    # Relevant for all designs regardless of common control arm or not

    # Save values from this round if non-sparse
    if (!sparse) looks_status[[look]] <- cur_status

    # If conclusive, then break loop (no more adaptive analyses)
    if (trial_break) {
      break()
    }
  } # End of data looks/adaptive analyses

  # Prepare and return final object
  final_status <- if (trial_break) {
    if (equivalence_stop) {
      "equivalence"
    } else if (futility_stop) {
      "futility"
    } else {
      "superiority"
    }
  } else {
    final_status <- "max"
  }

  trial_arms$sum_ys <- sum_ys
  trial_arms$sum_ys_all <- sum_ys_all
  trial_arms$ns <- ns
  trial_arms$ns_all <- ns_all

  # Add final_alloc, post_ests and post_errs for remaining arms
  for (i in aai) {
    trial_arms$final_alloc[i] <- cur_status$old_alloc[i]
    post[i, ]  <- summarise_dist(draws[, arms[i]], robust, cri_width)
  }

  # Set final arm status to control if one of the final arms is a control
  if (!is.null(control)) {
    control_index <- which(arms == control)
    if (trial_arms$final_status[control_index] == "active") {
      trial_arms$final_status[control_index] <- "control"
    }
  }

  # Conduct final analysis including all patients from all arms
  draws_final <- fun_draws(arms = arms, allocs = allocs[1:total_n],
                           ys = ys[1:total_n], control = control, n_draws = n_draws)
  post_final <- matrix(rep(NA, 4*n_arms), ncol = 4)
  for (i in 1:n_arms) {
    post_final[i, ] <- summarise_dist(draws_final[, arms[i]], robust, cri_width)
  }

  # Save posterior and raw estimates and final probabilities of being best
  trial_arms$post_ests <- post[, 1]
  trial_arms$post_errs <- post[, 2]
  trial_arms$lo_cri <- post[, 3]
  trial_arms$hi_cri <- post[, 4]
  status_ns <- ifelse(is.na(trial_arms$status_look), followed_n, trial_arms$status_look)
  trial_arms$raw_ests <- vapply_num(1:n_arms, function(i) trial_spec$fun_raw_est(ys[1:status_ns[i]][which(allocs[1:status_ns[i]] == arms[i])]))
  trial_arms$post_ests_all <- post_final[, 1]
  trial_arms$post_errs_all <- post_final[, 2]
  trial_arms$lo_cri_all <- post_final[, 3]
  trial_arms$hi_cri_all <- post_final[, 4]
  trial_arms$raw_ests_all <- vapply_num(arms, function(a) trial_spec$fun_raw_est(ys[1:total_n][which(allocs[1:total_n] == a)]))
  trial_arms$probs_best_last <- vapply_num(arms, function(a) ifelse(a %in% names(probs_best), probs_best[which(names(probs_best) == a)], NA))

  # Rearrange values in trial_arms and convert to data.frame
  trial_arms_cols <- c("arms", "true_ys", "start_probs", "fixed_probs", "min_probs",
                       "max_probs", "sum_ys", "ns", "sum_ys_all", "ns_all",
                       "raw_ests", "post_ests", "post_errs", "lo_cri", "hi_cri",
                       "raw_ests_all", "post_ests_all", "post_errs_all",
                       "lo_cri_all", "hi_cri_all", "final_status",
                       "status_look", "status_probs", "final_alloc", "probs_best_last")
  trial_arms <- as.data.frame(trial_arms, stringsAsFactors = FALSE)[, trial_arms_cols]

  # Return sparse or non-sparse object
  if (sparse){
    structure(list(final_status = final_status,
                   final_n = total_n,
                   followed_n = followed_n,
                   trial_res = trial_arms,
                   seed = seed,
                   sparse = TRUE),
              class = c("trial_result", "list"))
  } else {
    structure(list(final_status = final_status,
                   final_n = total_n,
                   followed_n = followed_n,
                   max_n = data_looks[n_data_looks],
                   max_randomised = max(randomised_at_looks),
                   looks = data_looks[1:look],
                   planned_looks = data_looks,
                   randomised_at_looks = randomised_at_looks[1:look],
                   start_control = trial_spec$control,
                   final_control = control,
                   control_prob_fixed = control_prob_fixed,
                   inferiority = trial_spec$inferiority,
                   superiority = trial_spec$superiority,
                   equivalence_prob = trial_spec$equivalence_prob,
                   equivalence_diff = equivalence_diff,
                   equivalence_only_first = equivalence_only_first,
                   futility_prob = trial_spec$futility_prob,
                   futility_diff = futility_diff,
                   futility_only_first = futility_only_first,
                   highest_is_best = highest_is_best,
                   soften_power = soften_power,
                   best_arm = trial_spec$best_arm,
                   trial_res = trial_arms,
                   all_looks = looks_status,
                   allocs = allocs[1:total_n],
                   ys = ys[1:total_n],
                   seed = seed,
                   description = trial_spec$description,
                   add_info = trial_spec$add_info,
                   cri_width = cri_width,
                   n_draws = n_draws,
                   robust = robust,
                   sparse = FALSE),
              class = c("trial_result", "list"))
  }
}
