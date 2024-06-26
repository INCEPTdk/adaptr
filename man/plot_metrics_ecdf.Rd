% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_metrics_ecdf.R
\name{plot_metrics_ecdf}
\alias{plot_metrics_ecdf}
\title{Plot empirical cumulative distribution functions of performance metrics}
\usage{
plot_metrics_ecdf(
  object,
  metrics = c("size", "sum_ys", "ratio_ys"),
  select_strategy = "control if available",
  select_last_arm = FALSE,
  select_preferences = NULL,
  te_comp = NULL,
  raw_ests = FALSE,
  final_ests = NULL,
  restrict = NULL,
  nrow = NULL,
  ncol = NULL,
  cores = NULL
)
}
\arguments{
\item{object}{\code{trial_results} object, output from the \code{\link[=run_trials]{run_trials()}}
function.}

\item{metrics}{the performance metrics to plot, as described in
\code{\link[=extract_results]{extract_results()}}. Multiple metrics may be plotted at the same time.
Valid metrics include: \code{size}, \code{sum_ys}, \code{ratio_ys_mean}, \code{sq_err},
\code{sq_err_te}, \code{err}, \code{err_te}, \code{abs_err}, \code{abs_err_te}, (as described in
\code{\link[=extract_results]{extract_results()}}, with the addition of \code{abs_err} and \code{abs_err_te}, which
are the absolute errors, i.e., \code{abs(err)} and \code{abs(err_te)}). All
may be specified using either spaces or underlines (case sensitive).
Defaults to plotting \code{size}, \code{sum_ys}, and \code{ratio_ys_mean}.}

\item{select_strategy}{single character string. If a trial was not stopped
due to superiority (or had only 1 arm remaining, if \code{select_last_arm} is
set to \code{TRUE} in trial designs with a common \code{control} arm; see below),
this parameter specifies which arm will be considered selected when
calculating trial design performance metrics, as described below;
this corresponds to the consequence of an inconclusive trial, i.e., which
arm would then be used in practice.\cr
The following options are available and must be written exactly as below
(case sensitive, cannot be abbreviated):
\itemize{
\item \code{"control if available"} (default): selects the \strong{first}
\code{control} arm for trials with a common \code{control} arm \emph{\strong{if}} this
arm is active at end-of-trial, otherwise no arm will be selected. For
trial designs without a common \code{control}, no arm will be selected.
\item \code{"none"}: selects no arm in trials not ending with superiority.
\item \code{"control"}: similar to \code{"control if available"}, but will throw
an error if used for trial designs without a common \code{control} arm.
\item \code{"final control"}: selects the \strong{final} \code{control} arm regardless
of whether the trial was stopped for practical equivalence, futility,
or at the maximum sample size; this strategy can only be specified
for trial designs with a common \code{control} arm.
\item \code{"control or best"}: selects the \strong{first} \code{control} arm if still
active at end-of-trial, otherwise selects the best remaining arm
(defined as the remaining arm with the highest probability of being
the best in the last adaptive analysis conducted). Only works for
trial designs with a common \code{control} arm.
\item \code{"best"}: selects the best remaining arm (as described under
\code{"control or best"}).
\item \code{"list or best"}: selects the first remaining arm from a specified
list (specified using \code{select_preferences}, technically a character
vector). If none of these arms are are active at end-of-trial, the best
remaining arm will be selected (as described above).
\item \code{"list"}: as specified above, but if no arms on the provided list
remain active at end-of-trial, no arm is selected.
}}

\item{select_last_arm}{single logical, defaults to \code{FALSE}. If \code{TRUE}, the
only remaining active arm (the last \code{control}) will be selected in trials
with a common \code{control} arm ending with \code{equivalence} or \code{futility}, before
considering the options specified in \code{select_strategy}. Must be \code{FALSE} for
trial designs without a common \code{control} arm.}

\item{select_preferences}{character vector specifying a number of arms used
for selection if one of the \code{"list or best"} or \code{"list"} options are
specified for \code{select_strategy}. Can only contain valid \code{arms}
available in the trial.}

\item{te_comp}{character string, treatment-effect comparator. Can be either
\code{NULL} (the default) in which case the \strong{first} \code{control} arm is used for
trial designs with a common control arm, or a string naming a single trial
\code{arm}. Will be used when calculating \code{err_te} and \code{sq_err_te} (the error
and the squared error of the treatment effect comparing the selected arm to
the comparator arm, as described below).}

\item{raw_ests}{single logical. If \code{FALSE} (default), the
posterior estimates (\code{post_ests} or \code{post_ests_all}, see \code{\link[=setup_trial]{setup_trial()}}
and \code{\link[=run_trial]{run_trial()}}) will be used to calculate \code{err} and \code{sq_err} (the error
and the squared error of the estimated compared to the specified effect in
the selected arm) and \code{err_te} and \code{sq_err_te} (the error and the squared
error of the treatment effect comparing the selected arm to the comparator
arm, as described for \code{te_comp} and below). If \code{TRUE}, the raw estimates
(\code{raw_ests} or \code{raw_ests_all}, see \code{\link[=setup_trial]{setup_trial()}} and \code{\link[=run_trial]{run_trial()}}) will
be used instead of the posterior estimates.}

\item{final_ests}{single logical. If \code{TRUE} (recommended) the final estimates
calculated using outcome data from all patients randomised when trials are
stopped are used (\code{post_ests_all} or \code{raw_ests_all}, see \code{\link[=setup_trial]{setup_trial()}}
and \code{\link[=run_trial]{run_trial()}}); if \code{FALSE}, the estimates calculated for each arm when
an arm is stopped (or at the last adaptive analysis if not before) using
data from patients having reach followed up at this time point and not all
patients randomised are used (\code{post_ests} or \code{raw_ests}, see
\code{\link[=setup_trial]{setup_trial()}} and \code{\link[=run_trial]{run_trial()}}). If \code{NULL} (the default), this argument
will be set to \code{FALSE} if outcome data are available immediate after
randomisation for all patients (for backwards compatibility, as final
posterior estimates may vary slightly in this situation, even if using the
same data); otherwise it will be said to \code{TRUE}. See \code{\link[=setup_trial]{setup_trial()}} for
more details on how these estimates are calculated.}

\item{restrict}{single character string or \code{NULL}. If \code{NULL} (default),
results are summarised for all simulations; if \code{"superior"}, results are
summarised for simulations ending with superiority only; if \code{"selected"},
results are summarised for simulations ending with a selected arm only
(according to the specified arm selection strategy for simulations not
ending with superiority). Some summary measures (e.g., \code{prob_conclusive})
have substantially different interpretations if restricted, but are
calculated nonetheless.}

\item{nrow, ncol}{the number of rows and columns when plotting multiple
metrics in the same plot (using faceting in \code{ggplot2}). Defaults to \code{NULL},
in which case this will be determined automatically.}

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
Plots empirical cumulative distribution functions (ECDFs) of numerical
performance metrics across multiple simulations from a \code{"trial_results"}
object returned by \code{\link[=run_trials]{run_trials()}}. Requires the \code{ggplot2} package installed.
}
\details{
Note that the arguments related to arm selection and error calculation are
only relevant if errors are visualised.
}
\examples{
#### Only run examples if ggplot2 is installed ####
if (requireNamespace("ggplot2", quietly = TRUE)){

  # Setup a trial specification
  binom_trial <- setup_trial_binom(arms = c("A", "B", "C", "D"),
                                   control = "A",
                                   true_ys = c(0.20, 0.18, 0.22, 0.24),
                                   data_looks = 1:20 * 100)

  # Run multiple simulation with a fixed random base seed
  res_mult <- run_trials(binom_trial, n_rep = 25, base_seed = 678)

  # NOTE: the number of simulations in this example is smaller than
  # recommended - the plots reflect that, and would likely be smoother if
  # a larger number of trials had been simulated

  # Plot ECDFs of continuous performance metrics
  plot_metrics_ecdf(res_mult)

}

}
\seealso{
\code{\link[=check_performance]{check_performance()}}, \code{\link[=summary]{summary()}}, \code{\link[=extract_results]{extract_results()}},
\code{\link[=plot_convergence]{plot_convergence()}}, \code{\link[=check_remaining_arms]{check_remaining_arms()}}.
}
