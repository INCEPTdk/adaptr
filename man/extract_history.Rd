% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_history.R
\name{extract_history}
\alias{extract_history}
\title{Extract history}
\usage{
extract_history(object, metric = "prob")
}
\arguments{
\item{object}{single \code{trial_result} from \code{\link[=run_trial]{run_trial()}}, only works if run
with argument \code{sparse = FALSE}.}

\item{metric}{either \code{"prob"} (default), in which case allocation
probabilities at each adaptive analysis are returned; \code{"n"}, in which
case the total number of patients allocated to each \code{arm} after each
adaptive analysis are returned; \code{"pct"} in which case the proportions
of patients allocated to each arm of the total number of patients
randomised are returned; \code{"sum ys"}, in which case the total summed
outcomes in each arm after each analysis are returned; or \code{"ratio ys"}, in
which case the total summed outcomes in each arm divided by the total
number of patients randomised to that arm after each analysis are returned.}
}
\value{
A tidy \code{data.frame} (one row per arm per look) containing the following
columns:
\itemize{
\item \code{look}: consecutive numbers (integers) of each interim look.
\item \code{look_ns}: total number of patients (integers) allocated at current
adaptive analysis look to all arms in the trial.
\item \code{arm}: the current \code{arm} in the trial.
\item \code{value}: as described under \code{metric}.
}
}
\description{
Used internally. Extracts relevant parameters at each conducted adaptive
analysis from a single trial.
}
\keyword{internal}
