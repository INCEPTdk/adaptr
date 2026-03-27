# adaptr: Adaptive Trial Simulator

![logo](figures/adaptr.png)*Adaptive Trial Simulator*

The `adaptr` package simulates adaptive (multi-arm, multi-stage)
randomised clinical trials using adaptive stopping, adaptive arm
dropping and/or response-adaptive randomisation. The package is
developed as part of the [INCEPT (Intensive Care Platform Trial)
project](https://incept.dk/), funded primarily by a grant from
[Sygeforsikringen "danmark"](https://www.sygeforsikring.dk/).

## Details

The `adaptr` package contains the following primary functions (in order
of typical use):

1.  The
    [`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md)
    initiates a parallel computation cluster that can be used to run
    simulations and post-processing in parallel, increasing speed.
    Details on parallelisation and other options for running `adaptr`
    functions in parallel are described in the
    [`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md)
    documentation.

2.  The
    [`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
    function is the general function that sets up a trial specification.
    The simpler, special-case functions
    [`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md)
    and
    [`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md)
    may be used for easier specification of trial designs using binary,
    binomially distributed or continuous, normally distributed outcomes,
    respectively, with some limitations in flexibility.

3.  The
    [`calibrate_trial()`](https://inceptdk.github.io/adaptr/reference/calibrate_trial.md)
    function calibrates a trial specification to obtain a certain value
    for a performance metric (typically used to calibrate the Bayesian
    type 1 error rate in a scenario with no between-arm differences),
    using the functions below.

4.  The
    [`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md)
    and
    [`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md)
    functions are used to conduct single or multiple simulations,
    respectively, according to a trial specification setup as described
    in \#2.

5.  The
    [`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md),
    [`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md)
    and
    [`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md)
    functions are used to extract results from multiple trial
    simulations, calculate performance metrics, and summarise results.
    The
    [`plot_convergence()`](https://inceptdk.github.io/adaptr/reference/plot_convergence.md)
    function assesses stability of performance metrics according to the
    number of simulations conducted. The
    [`plot_metrics_ecdf()`](https://inceptdk.github.io/adaptr/reference/plot_metrics_ecdf.md)
    function plots empirical cumulative distribution functions for
    numerical performance metrics. The
    [`check_remaining_arms()`](https://inceptdk.github.io/adaptr/reference/check_remaining_arms.md)
    function summarises all combinations of remaining arms across
    multiple trials simulations.

6.  The
    [`plot_status()`](https://inceptdk.github.io/adaptr/reference/plot_status.md)
    and
    [`plot_history()`](https://inceptdk.github.io/adaptr/reference/plot_history.md)
    functions are used to plot the overall trial/arm statuses for
    multiple simulated trials or the history of trial metrics over time
    for single/multiple simulated trials, respectively.

For further information see the documentation of each function, or the
**Overview** vignette
([`vignette("Overview", package = "adaptr")`](https://inceptdk.github.io/adaptr/articles/Overview.md))
or the practical guide (under **References** below) for examples of how
the functions work in combination. For further examples and guidance on
setting up trial specifications, see the
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md)
documentation, the **Basic examples** vignette
([`vignette("Basic-examples", package = "adaptr")`](https://inceptdk.github.io/adaptr/articles/Basic-examples.md))
and the **Advanced example** vignette
([`vignette("Advanced-example", package = "adaptr")`](https://inceptdk.github.io/adaptr/articles/Advanced-example.md)).

If using the package, please consider citing it using
`citation(package = "adaptr")`.

## References

Granholm A, Jensen AKG, Lange T, Kaas-Hansen BS (2022). adaptr: an R
package for simulating and comparing adaptive clinical trials. Journal
of Open Source Software, 7(72), 4284.
[doi:10.21105/joss.04284](https://doi.org/10.21105/joss.04284)

Granholm A, Kaas-Hansen BS, Lange T, Schjørring OL, Andersen LW, Perner
A, Jensen AKG, Møller MH (2022). An overview of methodological
considerations regarding adaptive stopping, arm dropping and
randomisation in clinical trials. J Clin Epidemiol.
[doi:10.1016/j.jclinepi.2022.11.002](https://doi.org/10.1016/j.jclinepi.2022.11.002)

Granholm A, Jensen AKG, Lange T, Perner A, Møller MH, Kaas-Hansen BS
(2025). Designing and Evaluating Bayesian Advanced Adaptive Randomised
Clinical Trials: A Practical Guide. Pharm Stat 24(6); e70042.
[doi:10.1002/pst.70042](https://doi.org/10.1002/pst.70042)

[Website/manual](https://inceptdk.github.io/adaptr/)

[GitHub repository](https://github.com/INCEPTdk/adaptr/)

**Examples of studies using `adaptr`:**

Granholm A, Lange T, Harhay MO, Jensen AKG, Perner A, Møller MH,
Kaas-Hansen BS (2023). Effects of duration of follow-up and lag in data
collection on the performance of adaptive clinical trials. Pharm Stat.
[doi:10.1002/pst.2342](https://doi.org/10.1002/pst.2342)

Granholm A, Lange T, Harhay MO, Perner A, Møller MH, Kaas-Hansen BS
(2024). Effects of sceptical priors on the performance of adaptive
clinical trials with binary outcomes. Pharm Stat.
[doi:10.1002/pst.2387](https://doi.org/10.1002/pst.2387)

## See also

[`setup_cluster()`](https://inceptdk.github.io/adaptr/reference/setup_cluster.md),
[`setup_trial()`](https://inceptdk.github.io/adaptr/reference/setup_trial.md),
[`setup_trial_binom()`](https://inceptdk.github.io/adaptr/reference/setup_trial_binom.md),
[`setup_trial_norm()`](https://inceptdk.github.io/adaptr/reference/setup_trial_norm.md),
[`calibrate_trial()`](https://inceptdk.github.io/adaptr/reference/calibrate_trial.md),
[`run_trial()`](https://inceptdk.github.io/adaptr/reference/run_trial.md),
[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md),
[`extract_results()`](https://inceptdk.github.io/adaptr/reference/extract_results.md),
[`check_performance()`](https://inceptdk.github.io/adaptr/reference/check_performance.md),
[`summary()`](https://inceptdk.github.io/adaptr/reference/summary.md),
[`check_remaining_arms()`](https://inceptdk.github.io/adaptr/reference/check_remaining_arms.md),
[`plot_convergence()`](https://inceptdk.github.io/adaptr/reference/plot_convergence.md),
[`plot_metrics_ecdf()`](https://inceptdk.github.io/adaptr/reference/plot_metrics_ecdf.md),
[`print()`](https://inceptdk.github.io/adaptr/reference/print.md),
[`plot_status()`](https://inceptdk.github.io/adaptr/reference/plot_status.md),
[`plot_history()`](https://inceptdk.github.io/adaptr/reference/plot_history.md).

## Author

**Maintainer**: Anders Granholm <andersgran@gmail.com>
([ORCID](https://orcid.org/0000-0001-5799-7655))

Authors:

- Benjamin Skov Kaas-Hansen <epiben@hey.com>
  ([ORCID](https://orcid.org/0000-0003-1023-0371))

Other contributors:

- Aksel Karl Georg Jensen <akje@sund.ku.dk>
  ([ORCID](https://orcid.org/0000-0002-1459-0465)) \[contributor\]

- Theis Lange <thlan@sund.ku.dk>
  ([ORCID](https://orcid.org/0000-0001-6807-8347)) \[contributor\]
