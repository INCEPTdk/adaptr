% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_ys_and_draws.R
\name{get_ys_binom}
\alias{get_ys_binom}
\title{Generate binary outcomes from binomial distributions}
\usage{
get_ys_binom(arms, event_probs)
}
\arguments{
\item{arms}{character vector of \code{arms} as specified in \code{\link[=setup_trial_binom]{setup_trial_binom()}}.}

\item{event_probs}{numeric vector of true event probabilities in all \code{arms}
as specified in \code{\link[=setup_trial_binom]{setup_trial_binom()}}.}
}
\value{
A function which takes the argument \code{allocs} (a character vector
with the allocations) and returns a numeric vector of similar length with
the corresponding, randomly generated outcomes (0 or 1, from binomial
distribution).
}
\description{
Used internally. Function factory used to generate a function that generates
binary outcomes from binomial distributions.
}
\keyword{internal}
