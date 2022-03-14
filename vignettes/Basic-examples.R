## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(adaptr)

## -----------------------------------------------------------------------------
setup_trial_binom(
  # Four arms
  arms = c("A", "B", "C", "D"),
  # Set true outcomes (in this example event probabilities) for all arms
  true_ys = c(0.3, 0.35, 0.31, 0.27), # 30%, 34%, 31% and 27%, respectively
  
  # Set starting allocation probabilities
  # Defaults to equal allocation if not specified
  start_probs = c(0.3, 0.3, 0.2, 0.2),
  # Set fixed allocation probability for first arm
  # NA corresponds to no limits for specific arms
  # Default (NULL) corresponds to no limits for all arms
  fixed_probs = c(0.3, NA, NA, NA),
  # Set minimum and maximum probability limits for some arms
  # NA corresponds to no limits for specific arms
  # Default (NULL) corresponds to no limits for all arms
  # Must be NA for arms with fixed_probs (first arm in this example)
  # sum(fixed_probs) + sum(min_probs) must not exceed 1
  # sum(fixed_probs) + sum(max_probs) may be greater than 1, and must be at least
  # 1 if specified for all arms
  min_probs = c(NA, 0.2, NA, NA),
  max_probs = c(NA, 0.7, NA, NA),
  
  # Set looks - alternatively, specify both max_n AND look_after_every
  data_looks = seq(from = 300, to = 1000, by = 100),
  
  # No common control arm (as default, but explicitly specified in this example)
  control = NULL,
  
  # Set inferiority/superiority thresholds (different values than the defaults)
  inferiority = 0.025,
  superiority = 0.975,
  
  # Define that the outcome is desirable (as opposed to the default setting)
  highest_is_best = TRUE,
  
  # No softening (the default setting, but made explicit here)
  soften_power = 1,
  
  # Use different simulation/summary settings than default
  cri_width = 0.89, # 89% credible intervals
  n_draws = 1000, # Only 1000 posterior draws in each arm
  robust = TRUE, # Summarise posteriors using medians/MAD-SDs (as default)
  
  # Trial description (used by print methods)
  description = "example trial specification 1"
)

## -----------------------------------------------------------------------------
setup_trial_binom(
  # Specify arms and true outcome probabilities (undesirable outcome as default)
  arms = c("A", "B", "C", "D"),
  true_ys = c(0.2, 0.22, 0.24, 0.18),
  
  # Specify adaptive analysis looks using max_n and look_after_every
  # max_n does not need to be a multiple of look_after_every - a final look
  # will be conducted at max_n regardless
  max_n = 1250, # Maximum 1250 patients
  look_after_every = 100, # Look after every 100 patients
  
  # Assess equivalence between all arms: stop if >90 % probability that the
  # absolute difference between the best and worst arms is < 5 %-points
  # Note: equivalence_only_first must be NULL (default) in designs without a
  # common control arm (such as this trial)
  equivalence_prob = 0.9,
  equivalence_diff = 0.05,
  
  # Different softening powers at each look (13 possible looks in total)
  # Starts at 0 (softens all allocation probabilities to be equal) and ends at
  # 1 (no softening) for the final possible look in the trial
  soften_power = seq(from = 0, to = 1, length.out = 13)
)

## -----------------------------------------------------------------------------
setup_trial_binom(
  arms = c("A", "B", "C", "D"),
  # Specify control arm
  control = "A",
  
  true_ys = c(0.2, 0.22, 0.24, 0.18), 
  
  data_looks = seq(from = 100, to = 1000, by = 100),
  
  # Fixed, square-root-transformation-based allocation throughout
  control_prob_fixed = "sqrt-based fixed",
  
  # Assess equivalence: drop non-control arms if > 90% probability that they
  # are equivalent to the common control, defined as an absolute difference of
  # < 3 %-points
  equivalence_prob = 0.9,
  equivalence_diff = 0.03,
  # Only assess against the initial control (i.e., not assessed if an arm is
  # declared superior to the initial control and becomes the new control)
  equivalence_only_first = TRUE,
  
  # Assess futility: drop non-control arms if > 80% probability that they are
  # < 10 %-points better (in this case lower because outcome is undesirable in
  # this example) compared to the common control
  futility_prob = 0.8,
  futility_diff = 0.1,
  # Only assessed for the initial control, as described above
  futility_only_first = TRUE
)

## -----------------------------------------------------------------------------
setup_trial_binom(
  arms = c("A", "B", "C", "D"),
  control = "A",
  
  true_ys = c(0.2, 0.22, 0.24, 0.18), 
  
  data_looks = seq(from = 100, to = 1000, by = 100),
  
  # Square-root-transformation-based control arm allocation including for
  # subsequent controls and initial equal allocation to the non-control arms,
  # followed by response-adaptive randomisation
  control_prob_fixed = "sqrt-based",
  
  # Restricted response-adaptive randomisation
  # Minimum probabilities of 20% for non-control arms, must be NA for the
  # control arm with fixed allocation probability
  # Limits are ignored for arms that become subsequent controls
  min_probs = c(NA, 0.2, 0.2, 0.2),
  
  # Constant softening of 0.5 (= square-root transformation)
  soften_power = 0.5
)

## -----------------------------------------------------------------------------
setup_trial_binom(
  arms = c("A", "B", "C", "D"),
  control = "A",
  
  true_ys = c(0.2, 0.22, 0.24, 0.18), 
  
  data_looks = seq(from = 100, to = 1000, by = 100),
  
  # Square-root-transformation-based control arm allocation for the initial
  # control only and initial equal allocation to the non-control arms, followed
  # by response-adaptive randomisation
  control_prob_fixed = "sqrt-based start",
  
  # Restrict response-adaptive randomisation
  # Minimum probabilities of 20% for all non-control arms
  # - must be NA for the initial control arm with fixed allocation probability
  min_probs = c(NA, 0.2, 0.2, 0.2),
  # Maximum probabilities of 65% for all non-control arms
  # - must be NA for the initial control arm with fixed allocation probability
  max_probs = c(NA, 0.65, 0.65, 0.65),
  
  soften_power = 0.75
)

## -----------------------------------------------------------------------------
setup_trial_binom(
  arms = c("A", "B", "C", "D"),
  control = "A",
  
  true_ys = c(0.2, 0.22, 0.24, 0.18), 
  
  data_looks = seq(from = 100, to = 1000, by = 100),
  
  # Specify starting probabilities
  # When "match" is specified below in control_prob_fixed, the initial control
  # arm's initial allocation probability must match the highest initial
  # non-control arm allocation probability
  start_probs = c(0.3, 0.3, 0.2, 0.2),
  
  control_prob_fixed = "match",
  
  # Restrict response-adaptive randomisation 
  # - these are applied AFTER "matching" when calculating new allocation
  #   probabilities 
  # - min_probs must be NA for the initial control arm when using matching
  min_probs = c(NA, 0.2, 0.2, 0.2),
  
  soften_power = 0.7
)

