# adaptr (development version)

* No changes yet

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
