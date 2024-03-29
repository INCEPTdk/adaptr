% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_history.R
\name{plot_history}
\alias{plot_history}
\alias{plot_history.trial_result}
\alias{plot_history.trial_results}
\title{Plot trial metric history}
\usage{
plot_history(object, x_value = "look", y_value = "prob", line = NULL, ...)

\method{plot_history}{trial_result}(object, x_value = "look", y_value = "prob", line = NULL, ...)

\method{plot_history}{trial_results}(
  object,
  x_value = "look",
  y_value = "prob",
  line = NULL,
  ribbon = list(width = 0.5, alpha = 0.2),
  cores = NULL,
  ...
)
}
\arguments{
\item{object}{\code{trial_results} object, output from the \code{\link[=run_trials]{run_trials()}}
function.}

\item{x_value}{single character string, determining whether the number of
adaptive analysis looks (\code{"look"}, default), the total cumulated number of
patients randomised (\code{"total n"}) or the total cumulated number of patients
with outcome data available at each adaptive analysis (\code{"followed n"}) are
plotted on the x-axis.}

\item{y_value}{single character string, determining which values are plotted
on the y-axis. The following options are available: allocation
probabilities (\code{"prob"}, default), the total number of patients with
outcome data available (\code{"n"}) or randomised (\code{"n all"}) to each arm,
the percentage of patients with outcome data available (\code{"pct"}) or
randomised (\code{"pct all"}) to each arm out of the current total, the sum of
all available (\code{"sum ys"}) outcome data or all outcome data for randomised
patients including outcome data not available at the time of the current
adaptive analysis (\code{"sum ys all"}), the ratio of outcomes as defined for
\code{"sum ys"}/\code{"sum ys all"} divided by the corresponding number of patients
in each arm.}

\item{line}{list styling the lines as per \code{ggplot2} conventions (e.g.,
\code{linetype}, \code{linewidth}).}

\item{...}{additional arguments, not used.}

\item{ribbon}{list, as \code{line} but only appropriate for \code{trial_results}
objects (i.e., when multiple simulations are run). Also allows to specify
the \code{width} of the interval: must be between 0 and 1, with \code{0.5} (default)
showing the inter-quartile ranges.}

\item{cores}{\code{NULL} or single integer. If \code{NULL}, a default value set by
\code{\link[=setup_cluster]{setup_cluster()}} will be used to control whether extractions of simulation
results are done in parallel on a default cluster or sequentially in the
main process; if a value has not been specified by \code{\link[=setup_cluster]{setup_cluster()}},
\code{cores} will then be set to the value stored in the global \code{"mc.cores"}
option (if previously set by \verb{options(mc.cores = <number of cores>}), and
\code{1} if that option has not been specified.\cr
If \code{cores = 1}, computations
will be run sequentially in the primary process, and if \code{cores > 1}, a new
parallel cluster will be setup using the \code{parallel} library and removed
once the function completes. See \code{\link[=setup_cluster]{setup_cluster()}} for details.}
}
\value{
A \code{ggplot2} plot object.
}
\description{
Plots the history of relevant metrics over the progress of a single or
multiple trial simulations. Simulated trials \strong{only} contribute until the
time they are stopped, i.e., if some trials are stopped earlier than others,
they will not contribute to the summary statistics at later adaptive looks.
Data from individual arms in a trial contribute until the complete trial is
stopped.\cr
These history plots require non-sparse results (\code{sparse} set to
\code{FALSE}; see \code{\link[=run_trial]{run_trial()}} and \code{\link[=run_trials]{run_trials()}}) and the \code{ggplot2} package
installed.
}
\examples{
#### Only run examples if ggplot2 is installed ####
if (requireNamespace("ggplot2", quietly = TRUE)){

  # Setup a trial specification
  binom_trial <- setup_trial_binom(arms = c("A", "B", "C", "D"),
                                   control = "A",
                                   true_ys = c(0.20, 0.18, 0.22, 0.24),
                                   data_looks = 1:20 * 100)



  # Run a single simulation with a fixed random seed
  res <- run_trial(binom_trial, seed = 12345)

  # Plot total allocations to each arm according to overall total allocations
  plot_history(res, x_value = "total n", y_value = "n")

}

if (requireNamespace("ggplot2", quietly = TRUE)){

  # Run multiple simulation with a fixed random base seed
  # Notice that sparse = FALSE is required
  res_mult <- run_trials(binom_trial, n_rep = 15, base_seed = 12345, sparse = FALSE)

  # Plot allocation probabilities at each look
  plot_history(res_mult, x_value = "look", y_value = "prob")

  # Other y_value options are available but not shown in these examples

}

}
\seealso{
\code{\link[=plot_status]{plot_status()}}.
}
