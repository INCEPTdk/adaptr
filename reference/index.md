# Package index

## Package overview

- [`adaptr`](https://inceptdk.github.io/adaptr/reference/adaptr-package.md)
  [`adaptr-package`](https://inceptdk.github.io/adaptr/reference/adaptr-package.md)
  : adaptr: Adaptive Trial Simulator

## Parallelisation

- [`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md)
  : Setup default cluster for use in parallelised adaptr functions

## Setup, calibrate, and run trials

- [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
  : Setup a generic trial specification
- [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
  : Setup a trial specification using a binary, binomially distributed
  outcome
- [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)
  : Setup a trial specification using a continuous, normally distributed
  outcome
- [`calibrate_trial()`](https://inceptdk.github.io/adaptr/reference/calibrate_trial.md)
  : Calibrate trial specification
- [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)
  : Simulate a single trial
- [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
  : Simulate multiple trials

## Extract and summarise results

- [`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md)
  : Extract simulation results
- [`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md)
  : Check performance metrics for trial simulations
- [`summary(`*`<trial_results>`*`)`](https://inceptdk.github.io/adaptr/reference/summary.md)
  : Summary of simulated trial results
- [`check_remaining_arms()`](https://inceptdk.github.io/adaptr/reference/check_remaining_arms.md)
  : Check remaining arm combinations

## Plotting functions

- [`plot_convergence()`](https://inceptdk.github.io/adaptr/reference/plot_convergence.md)
  : Plot convergence of performance metrics
- [`plot_metrics_ecdf()`](https://inceptdk.github.io/adaptr/reference/plot_metrics_ecdf.md)
  : Plot empirical cumulative distribution functions of performance
  metrics
- [`plot_status()`](https://inceptdk.github.io/adaptr/reference/plot_status.md)
  : Plot statuses
- [`plot_history()`](https://inceptdk.github.io/adaptr/reference/plot_history.md)
  : Plot trial metric history

## Print methods

- [`print(`*`<trial_spec>`*`)`](https://inceptdk.github.io/adaptr/reference/print.md)
  [`print(`*`<trial_result>`*`)`](https://inceptdk.github.io/adaptr/reference/print.md)
  [`print(`*`<trial_performance>`*`)`](https://inceptdk.github.io/adaptr/reference/print.md)
  [`print(`*`<trial_results>`*`)`](https://inceptdk.github.io/adaptr/reference/print.md)
  [`print(`*`<trial_results_summary>`*`)`](https://inceptdk.github.io/adaptr/reference/print.md)
  [`print(`*`<trial_calibration>`*`)`](https://inceptdk.github.io/adaptr/reference/print.md)
  : Print methods for adaptive trial objects

## Helper functions

- [`update_saved_trials()`](https://inceptdk.github.io/adaptr/reference/update_saved_trials.md)
  : Update previously saved simulation results
- [`update_saved_calibration()`](https://inceptdk.github.io/adaptr/reference/update_saved_calibration.md)
  : Update previously saved calibration result
- [`find_beta_params()`](https://inceptdk.github.io/adaptr/reference/find_beta_params.md)
  : Find beta distribution parameters from thresholds
