# adaptr (development version)

Minor patch version:

* Updates to the run_trials function to allow exporting objects to clusters when
running simulations on multiple cores, and updated documentation accordingly.

* Updates to internal function verify_int due to updates in R >= 4.2.0, to
avoid incorrect error messages in future versions due to changed behaviour with
the `&&` function and multiple inputs
(https://stat.ethz.ch/pipermail/r-announce/2022/000683.html).

* Minor documentation edits and updated citation info (reference to software
paper published in Journal of Open Source Software, doi: 10.21105/joss.04284).

# adaptr 1.0.0

* First release.
