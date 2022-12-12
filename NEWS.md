---
editor_options: 
  markdown: 
    wrap: 72
---

# adaptr (development version)

### New features:

*   Simulate follow-up (and data collection) lag: added option to have
    different numbers of simulated patients with outcome data available
    compared to the total number of simulated patients randomised at
    each adaptive analysis (`randomised_at_looks` argument in
    `setup_trial()` family of functions); defaults to same behaviour as
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
    compatibility and use the final estimates in situations where not
    all patients are included in the final adaptive analysis). An
    example has been added to the `Basic examples` vignette illustrating
    the use of this argument.

*   Updated `plot_history()` and `plot_status()` to add the possibility
    to plot different metrics relevant after the addition of the new
    `randomised_at_looks` argument described above.

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
    considerations in adaptive clinical trials to the package
    documentation (<https://doi.org/10.1016/j.jclinepi.2022.11.002>).

*   The proportion of conclusive trials when restricting the trials
    summarised (in `extract_results()`) may now be calculated by the
    `summary()` method for multiple trial simulations and by the new
    `check_performance()` function, even if this measure may be
    difficult to interpret under such circumstances.

*   Minor fixes, updates, and added clarification to the documentation
    in multiple places, including in vignettes, which have also been
    updated to illustrate some of the new functions added.

*   Minor changes to trial setup/validation including proper error
    messages in an edge case with invalid inputs and proper errors if
    non-integer numbers used for patient count arguments.

*   Minor fix to `print()` method for individual trial results, which did
    not correctly print additional information about trials.

*   Fixed a bug where the same number of patients followed could be used
    for subsequent data_looks in the `setup_trial()` family of
    functions; this now produces an error.

*   Added internal `vapply_lgl()` helper function; `vapply()` helpers
    are now used consistently to simplify the code.

*   Added multiple internal (non-exported) helper functions to simplify
    code throughout the package: `stop0()`, `warning0()`, `%f|%`, and
    `summarise_num()`.

*   Added `names = FALSE` argument to `quantile()` calls in the
    `summary()` method for `trial_results` objects, to avoid unnecessary
    naming of some components if they are subsequently extracted from
    the returned object.

*   Ideal design percentages may be calculated as `NaN`, `Inf` or `-Inf`
    in scenarios with no differences; these are now all converted to
    `NA` before being returned by the various functions.

*   Minor edits/clarifications to several errors/warnings/messages.

*   Minor fix to internal `verify_int()` function; when supplied with,
    e.g., a character vector, execution was stopped with an error
    instead of returning `FALSE`, as needed to print the proper error
    after checks.

*   Minor fix to `plot_status()`, where the upper area (representing
    trials/arms still recruiting) was sometimes erroneously not plotted
    due to a floating point issue where the summed proportions could
    sometimes slightly exceed 100%.
    
*   Added additional tests to test increase coverage of existing functions.

*   Minor fix in internal `reallocate_probs()` function, when `"match"`-ing
    control arm allocation to the highest probability in a non-control arm and
    if all probabilities were initially 0, the returned vector lacked names,
    which are now added.

*   Minor fix to internal `validate_trial()` function to not give an error when
    multiple values were supplied to the `control_prob_fixed` argument.

# adaptr 1.1.1

This is a patch release triggered by a CRAN request for updates.

*   Minor formatting changes to the `adaptr-package` help page to comply
    with CRAN request to only use HTML5 (as used by R \>=4.2.0).

*   Minor bugfixes in `print()` methods for trial specifications and
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
