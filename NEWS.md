# adaptr 1.3.1

This is a patch release triggered by a CRAN request to fix a failing test that
also includes minor documentation updates.
    
*   Fixed a single test that failed on CRAN due to an update in the `testthat`
    dependency `waldo`.
    
*   Fixed erroneous duplicated text in README and thus also on GitHub and the
    package website.
    
*   Minor edits/clarifications in the documentation including function
    documentation, README, and vignettes.

# adaptr 1.3.0

This release implements new functionality (most importantly trial calibration),
improved parallelism, a single important bug fix, and multiple minor fixes,
changes, and improvements.

### New features and major changes:

*   Added the `calibrate_trial()` function, which can be used to calibrate a
    trial specification to obtain (approximately) a desired value for a certain
    performance characteristic. Typically, this will be used to calibrate trial
    specifications to control the overall Bayesian type-1 error rates in a
    scenario with no between-arm differences, but the function is extensible and
    may be used to calibrate trial specifications to other performance metrics.
    The function uses a quite efficient Gaussian process-based Bayesian
    optimisation algorithm, based in part on code by Robert Gramacy (Surrogates
    chapter 5, see: https://bookdown.org/rbg/surrogates/chap5.html), with
    permission.

*   More and better parallelism. The functions `extract_results()`,
    `check_performance()`, `plot_convergence()`, `plot_history()`, and the
    `summary()` and `print()` methods for `trial_results` objects may now be run
    in parallel via the `cores` argument or as described below. Please note, some
    other functions have not been parallelised, as they were already fast and
    the time it took to copy data to the clusters meant that the parallel
    versions of those functions were actually slower than the original ones,
    even when run on results from 10-100K simulations.
    
*   The `setup_cluster()` function has been added and can now be used to setup
    and use the same parallel cluster throughout a session, avoiding the
    overhead of setting up and stopping new clusters each time. The default
    value for the `cores` argument in all functions is now `NULL`; if an actual
    value is supplied, it will always be used to initiate a new, temporary
    cluster of that size, but if left at `NULL` the defaults defined by
    `setup_cluster()` will be used (if any), otherwise the `"mc.cores"` global
    option will be used (for new, temporary clusters of that size) if specified
    by `options(mc.cores = <number>)`, and otherwise `1`. 
    Finally, `adaptr` now always uses parallel (not forked) clusters as is the
    default in `parallel` and which works on all operating systems.
    
*   Better (safer, more correct) random number generation. Previously, random
    number generation was managed in an *ad-hoc* fashion to produce similar
    results sequentially and in parallel; while the influence of this was
    minimal, the package now uses the `"L'Ecuyer-CMRG"` random number generator
    (see `base::RNGkind()`) and appropriately manages random number streams
    across parallel workers, also when run sequentially, ensuring identical
    results regardless of the use of parallelism or not.
    **Important:** Due to this change, simulation results from `run_trials()`
    and bootstrapped uncertainty measures from `check_performance()` will not be
    identical to those generated with previous versions of the package. In
    addition, individual `trial_result` objects in a `trial_results` object
    returned from `run_trials()` no longer contain any individual seed values,
    but instead `NULL`.
    
*   Added the `plot_metrics_ecdf()` function, which plots empirical cumulative
    distribution functions of numerical performance metrics across multiple
    trial simulations.
    
*   Added the `check_remaining_arms()` function, which summarises all
    combinations of remaining arms across multiple simulations.

### Bug fixes:

*   Fixed a bug in `extract_results()` (and thus also in functionality relying on
    it: `check_performance()`, `plot_convergence()`, and the `summary()`
    method for multiple simulated trials) that caused incorrect total event
    counts and event rates being calculated for trial specification with
    follow-up/outcome-data lag (the total event count from the last adaptive
    analysis was incorrectly used, and for ratios this was divided by the total
    number of patients randomised). This has been fixed and the documentation of
    the relevant functions has been updated to clarify the behaviour further.
    This bug did not affect results for simulations without follow-up/outcome-
    data lag.
    
*   Values for `inferiority` must now be less than `1 / number of arms` if no
    common control group is used, and the `setup_trial()` family of functions
    now throws an error if this is not the case. Larger values are invalid and
    could lead to simultaneous dropping of all arms, which caused `run_trial()`
    to crash.
    
*   The `print()` method for results from `check_performance()` did not respect
    the `digits` argument; this has been fixed.

### Minor changes:

*   Now includes min/max values when summarising numerical performance metrics
    in `check_performance()` and `summary()`, and these may be plotted using
    `plot_convergence()` as well.
    
*   The `setup_trial()` functions now accepts `equivalence_prob` and
    `futility_prob` thresholds of `1`. As `run_trial()` only stops or drops arms
    for equivalence/futility if the probabilities exceed the current threshold,
    values of `1` makes stopping impossible. These values, however, may be used
    in a sequence of thresholds to effectively prevent early stopping for
    equivalence/futility but allowing it later.

*   When `overwrite` is `TRUE` in `run_trials()`, the previous object will be
    overwritten, even if the previous object used a different trial
    specification.

*   Various minor updates, corrections, clarifications, and structural changes
    to package documentation (including package description and website).
    
*   Changed `size` to `linewidth` in the examples in `plot_status()` and
    `plot_history()` when describing further arguments that may be passed on to
    `ggplot2` due to deprecation/change of aesthetic names in `ggplot2` 3.4.0.

*   Documentation for `plot_convergence()`, `plot_status()`, and
    `plot_history()` now prints all plots when rendering documentation if
    `ggplot2` is installed (to include all example plots on the website).
    
*   The `setup_trial()` functions no longer prints a message informing that
    there is no single best arm.
    
*   Various minor changes to `print()` methods (including changed number of
    digits for stopping rule probability thresholds).
    
*   The `setup_trial()` family of functions now restores the global random seed
    after being run as the outcome generator/draws generator functions are
    called during validation, involving random number generation. While this was
    always documented, it seems preferable that to restore the global random
    seed during trial setup when functions are only validated.
    
*   Always explicitly uses `inherits = FALSE` in calls to `base::get()`,
    `base::exists()`, and `base::assign()` to ensure that `.Random.seed` is only
    checked/used/assigned in the global environment. It is very unlikely that
    this would ever cause errors if not done, but this serves as an extra
    safety.

# adaptr 1.2.0

This is a minor release implementing new functionality, updating
documentation, and fixing multiple minor issues, mostly in validation of
supplied arguments.

### New features:

*   Simulate follow-up (and data collection) lag: added option to have
    different numbers of simulated patients with outcome data available
    compared to the total number of simulated patients randomised at
    each adaptive analysis (`randomised_at_looks` argument in
    `setup_trial()` family of functions). Defaults to same behaviour as
    previously (i.e., assuming that outcome data are immediately
    available following randomisation). As a consequence, `run_trial()`
    now always conducts a final analysis after the last adaptive
    analysis (including both final posterior and 'raw' estimates),
    including the outcome data of all patients randomised to all arms,
    regardless of how many had outcome data available at the last
    conducted adaptive analysis. Both sets of results are saved and
    printed for individual simulations; `extract_results()`, the
    `summary()` and the `print()` methods for multiple simulations have
    gained the additional argument `final_ests` that controls whether
    the results from this final analysis or from the last relevant
    adaptive analysis including each arm are used when calculating some
    performance metrics (defaults are set to ensure backwards
    compatibility and otherwise use the final estimates in situations where
    not all patients are included in the final adaptive analysis). An
    example has been added to the `Basic examples` vignette illustrating
    the use of this argument.

*   Updated `plot_history()` and `plot_status()` to add the possibility
    to plot different metrics according to the number of patients
    randomised as specified by the the new `randomised_at_looks`
    argument to the `setup_trial()` functions as described above.

*   Added the `update_saved_trials()` function, which 'updates' multiple
    trial simulation objects saved by `run_trials()` using previous
    versions of `adaptr`. This reformats the objects to work with the
    updated functions. Not all values can be added to previously saved
    simulation results without re-running; these values will be replaced
    with `NA`s, and - if used - may lead to printing or plotting of
    missing values. However, the function allows re-use of the same data
    from previous simulations without having to re-run them (mostly
    relevant for time-consuming simulations). **Important:** please
    notice that other objects (i.e., objects returned from the
    `setup_trial()` family of functions and single simulations returned
    by `run_trial()`) may create problems or errors with some functions
    if created by previous versions of the package and manually
    reloaded; these objects will have to be updated by re-running the
    code using the newest version of the package. Similarly, manually
    reloaded results from `run_trials()` that are not updated using this
    function may cause errors/problems when used.

*   Added the `check_performance()` function (and a corresponding
    `print()` method) which calculates performance metrics and can be
    used to calculate uncertainty measures using non-parametric
    bootstrapping. This function is now used internally by the
    `summary()` method for multiple trial objects.

*   Added the `plot_convergence()` function which plots performance
    metrics according to the number of simulations conducted for
    multiple simulated trials (possibly after splitting the simulations
    into batches), used to assess stability of performance metrics.

*   Added the possibility to define different probability thresholds for
    different adaptive analyses to the `setup_trials()` family of
    functions (for inferiority, superiority, equivalence, and futility
    probability thresholds), with according updates in `run_trial()` and
    the `print()` method for trial specifications.

*   Updated `plot_status()`; multiple arms may now simultaneously be
    plotted by specifying more than one valid arm or `NA` (which lead to
    statuses for all arms being plotted) in the `arm` argument. In
    addition, `arm` name(s) are now always included on the plots.

### Documentation, bug fixes, and other changes:

*   Added reference to open access article describing key methodological
    considerations in adaptive clinical trials using adaptive stopping,
    arm dropping, and randomisation to the package documentation
    (<https://doi.org/10.1016/j.jclinepi.2022.11.002>).

*   The proportion of conclusive trials when restricting the trials
    summarised (in `extract_results()`) may now be calculated by the
    `summary()` method for multiple trial simulations and by the new
    `check_performance()` function, even if this measure may be
    difficult to interpret when the trials summarised is restricted.

*   Minor fixes, updates, and added clarification to the documentation
    in multiple places, including in vignettes, which have also been
    updated to illustrate some of the new functions added.

*   Minor fix to `print()` method for individual trial results, which did
    not correctly print additional information about trials.

*   Fixed a bug where the same number of patients included could be used
    for subsequent `data_looks` in the `setup_trial()` family of
    functions; this now produces an error.

*   Added internal `vapply_lgl()` helper function; the internal `vapply()`
    helper functions are now used consistently to simplify the code.

*   Added multiple internal (non-exported) helper functions to simplify
    code throughout the package: `stop0()`, `warning0()`, `%f|%`, and
    `summarise_num()`.

*   Added `names = FALSE` argument to `quantile()` calls in the
    `summary()` method for `trial_results` objects to avoid unnecessary
    naming of some components if they are subsequently extracted from
    the returned object.

*   Ideal design percentages may be calculated as `NaN`, `Inf` or `-Inf`
    in scenarios with no differences; these are now all converted to
    `NA` before being returned by the various functions.

*   Minor edits/clarifications to several errors/warnings/messages.

*   Minor fix to internal `verify_int()` function; when supplied with,
    e.g., a character vector, execution was stopped with an error
    instead of returning `FALSE`, as needed to print the proper error
    messages after checks.

*   Minor fix to `plot_status()`, where the upper area (representing
    trials/arms still recruiting) was sometimes erroneously not plotted
    due to a floating point issue where the summed proportions could
    sometimes slightly exceed 1.
    
*   Added additional tests to test increase coverage of existing and
    new functions.

*   Minor fix in internal `reallocate_probs()` function, when `"match"`-ing
    control arm allocation to the highest probability in a non-control arm and
    if all probabilities were initially 0, the returned vector lacked names,
    which have now been added.

*   Minor fixes to internal `validate_trial()` function in order to: not
    give an error when multiple values were supplied to the
    `control_prob_fixed` argument; and to give the correct error when
    multiple values were provided to `equivalence_diff` or `futility_diff`;
    and to give an error when `NA` was supplied to `futility_only_first`;
    and to add some tolerance to the checks of `data_looks` and
    `randomised_at_looks` to avoid errors due to floating point imprecision
    when specified using multiplication or similar; and correct errors if
    decimal numbers for patient count arguments were supplied; and additional
    minor updates to errors/messages.

# adaptr 1.1.1

This is a patch release triggered by a CRAN request for updates.

*   Minor formatting changes to the `adaptr-package` help page to comply
    with CRAN request to only use HTML5 (as used by R \>=4.2.0).

*   Minor bug fixes in `print()` methods for trial specifications and
    summaries of multiple trial results.

*   Minor updates in messages in `setup_trial()`.

# adaptr 1.1.0

Minor release:

*   Updates to the `run_trials()` function to allow exporting objects to
    clusters when running simulations on multiple cores.

*   Updates to internal function `verify_int()` due to updates in R \>=
    4.2.0, to avoid incorrect error messages in future versions due to
    changed behaviour with the `&&` function when used with arguments
    with length \> 1
    (<https://stat.ethz.ch/pipermail/r-announce/2022/000683.html>).

*   Minor documentation edits and updated citation info (reference to
    software paper published in Journal of Open Source Software,
    <https://doi.org/10.21105/joss.04284>).

# adaptr 1.0.0

*   First release.
