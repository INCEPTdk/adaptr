# adaptr (development version)

* Added option to have different numbers of simulated patients with outcome data
available compared to the total number of simulated patients randomised at each
adaptive analysis (`randomised_at_looks` argument in `setup_trial()`-family of
functions); defaults to same behaviour as previously (i.e., assuming that
outcome data are immediately available following randomisation).
As a consequence, `run_trial()` now always conducts a final analysis after the
last adaptive analysis (including both final posterior and 'raw' estimates),
including the outcome data of all patients randomised to all arms, regardless of
how many had outcome data available at the last conducted adaptive analysis.
Both sets of results are saved and printed for individual simulations;
`extract_results()` and the `summary()`- and
`print()`-methods for multiple simulations have gained the additional argument
`final_ests` that controls whether the results from this final analysis or from
the last relevant adaptive analysis including each arm are used when calculating
some performance metrics (defaults are set to ensure backwards compatibility and
use the final estimates in situations where not all patients are included in the
final adaptive analysis).

* Updated `plot_history()` and `plot_status()` to add the possibility to plot
different metrics relevant after the addition of the new
`randomised_at_looks`-argument described above.

* Added the `update_saved_trials()`-function, which 'updates' multiple trial
simulation objects saved by `run_trials()` using a previous version of `adaptr`,
which reformats the objects to work with the updated functions. Other saved
objects will have to be re-created using the same settings as previously (due to
some internal reformatting). Not all values can be added for updated, saved
simulation results without re-running; these values will be replaced with `NA`s,
and - if used - may lead to printing or plotting of missing values. However, the
function allows re-use of the same data from previous simulations without having
to re-run them (mostly relevant for time-consuming simulations).

**WORK IN PROGRESS - ADD EXAMPLES TO SETUP FUNCTIONS AND/OR VIGNETTES SHOWING  THE NEW LAG OF FOLLOW-UP SETTINGS IN ACTION**

* Added the possibility to define different probability thresholds for different
adaptive analyses to the `setup_trials()`-family of functions (for inferiority,
superiority, equivalence, and futility probability thresholds), with according
updates in `run_trial()` and the `print()`-method for trial specifications.

* Additional minor changes to trial setup/validation including proper error
messages in an edge case with invalid inputs and proper errors if non-integer
numbers used for patient count arguments.

* Minor fix to print method for individual trial results, which did not
correctly print additional information about trials.

* Fixed a bug where the same number of patients followed could be used for
subsequent data_looks in the `setup_trial()`-family of functions did incorrectly
not produce an error.

* Minor fixes, updates, and added clarification to the documentation in multiple
places.

* Added internal `vapply_lgl()`-helper function.

* Added reference to open access article describing key methodological
considerations in adaptive clinical trials to the package documentation
(doi: 10.1016/j.jclinepi.2022.11.002).

# adaptr 1.1.1

This is a patch release triggered by a CRAN request for updates.

* Minor formatting changes to the `adaptr-package` help page to comply with CRAN
request to only use HTML5 (as used by R >=4.2.0).

* Minor bugfixes in print methods for trial specifications and summaries of
multiple trial results.

* Minor updates in messages in setup_trial.

# adaptr 1.1.0

Minor release:

* Updates to the `run_trials()` function to allow exporting objects to clusters
when running simulations on multiple cores.

* Updates to internal function `verify_int()` due to updates in R >= 4.2.0, to
avoid incorrect error messages in future versions due to changed behaviour with
the `&&` function when used with arguments with length > 1
(https://stat.ethz.ch/pipermail/r-announce/2022/000683.html).

* Minor documentation edits and updated citation info (reference to software
paper published in Journal of Open Source Software, doi: 10.21105/joss.04284).

# adaptr 1.0.0

* First release.
