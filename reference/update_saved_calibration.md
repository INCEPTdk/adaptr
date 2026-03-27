# Update previously saved calibration result

This function updates a previously saved `"trial_calibration"`-object
created and saved by
[`calibrate_trial()`](https://inceptdk.github.io/adaptr/reference/calibrate_trial.md)
using a previous version of `adaptr`, including the embedded trial
specification and trial results objects (internally using the
[`update_saved_trials()`](https://inceptdk.github.io/adaptr/reference/update_saved_trials.md)
function). This allows the use of calibration results, including the
calibrated trial specification and the best simulations results from the
calibration process, to be used without errors by this version of the
package. The function should be run only once per saved simulation
object and will issue a warning if the object is already up to date. An
overview of the changes made according to the `adaptr` package version
used to generate the original object is provided in **Details**.  

## Usage

``` r
update_saved_calibration(path, version = NULL, compress = TRUE)
```

## Arguments

- path:

  single character; the path to the saved `"trial_calibration"`-object
  containing the calibration result saved by
  [`calibrate_trial()`](https://inceptdk.github.io/adaptr/reference/calibrate_trial.md).

- version:

  passed to [`saveRDS()`](https://rdrr.io/r/base/readRDS.html) when
  saving the updated object, defaults to `NULL` (as in
  [`saveRDS()`](https://rdrr.io/r/base/readRDS.html)), which means that
  the current default version is used.

- compress:

  passed to [`saveRDS()`](https://rdrr.io/r/base/readRDS.html) when
  saving the updated object, defaults to `TRUE` (as in
  [`saveRDS()`](https://rdrr.io/r/base/readRDS.html)), see
  [`saveRDS()`](https://rdrr.io/r/base/readRDS.html) for other options.

## Value

Invisibly returns the updated `"trial_calibration"`-object.

## Details

The following changes are made according to the version of `adaptr` used
to generate the original `"trial_calibration"` object:

- `v1.3.0+`: updates version number of the `"trial_calibration"`-object
  and updates the embedded `"trial_results"`-object (saved in
  `$best_sims`, if any) and `"trial_spec"`-objects (saved in
  `$input_trial_spec` and `$best_trial_spec`) as described in
  [`update_saved_trials()`](https://inceptdk.github.io/adaptr/reference/update_saved_trials.md).

## See also

[`run_trials()`](https://inceptdk.github.io/adaptr/reference/run_trials.md).
