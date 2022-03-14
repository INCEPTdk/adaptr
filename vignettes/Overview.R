## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.align = "center",
  fig.width = 6
)

## -----------------------------------------------------------------------------
library(adaptr)

## -----------------------------------------------------------------------------
binom_trial <- setup_trial_binom(
  arms = c("Arm A", "Arm B", "Arm C"),
  true_ys = c(0.25, 0.20, 0.30),
  min_probs = rep(0.15, 3), 
  data_looks = seq(from = 300, to = 2000, by = 100),
  equivalence_prob = 0.9,
  equivalence_diff = 0.05,
  soften_power = 0.5 
) 

## -----------------------------------------------------------------------------
binom_trial

## -----------------------------------------------------------------------------

print(binom_trial, prob_digits = 2)

## -----------------------------------------------------------------------------
trial_res <- run_trial(binom_trial, seed = 12345)

trial_res

## -----------------------------------------------------------------------------
print(trial_res, prob_digits = 2)

## -----------------------------------------------------------------------------
trial_res_mult <- run_trials(binom_trial, n_rep = 25, base_seed = 67890)

trial_res_mult

## -----------------------------------------------------------------------------
extr_res <- extract_results(trial_res_mult)

nrow(extr_res)

head(extr_res)

## -----------------------------------------------------------------------------
res_sum <- summary(trial_res_mult)

print(res_sum, digits = 1)

## -----------------------------------------------------------------------------
trial_res_mult <- run_trials(binom_trial, n_rep = 25, base_seed = 67890,
                             sparse = FALSE)

## -----------------------------------------------------------------------------
plot_status(trial_res_mult, x_value = "total n")

## -----------------------------------------------------------------------------
plot_status(trial_res_mult, x_value = "total n", arm = "Arm A")

## -----------------------------------------------------------------------------
plot_history(trial_res_mult)

## -----------------------------------------------------------------------------
citation(package = "adaptr")

