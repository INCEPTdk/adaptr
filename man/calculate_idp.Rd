% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_performance.R
\name{calculate_idp}
\alias{calculate_idp}
\title{Calculate the ideal design percentage}
\usage{
calculate_idp(sels, arms, true_ys, highest_is_best)
}
\arguments{
\item{sels}{a character vector specifying the selected arms (according to the
selection strategies described in \code{\link[=extract_results]{extract_results()}}).}

\item{arms}{character vector with unique names for the trial arms.}

\item{true_ys}{numeric vector specifying true outcomes (e.g., event
probabilities, mean values, etc.) for all trial \code{arms}.}

\item{highest_is_best}{single logical, specifies whether larger estimates of
the outcome are favourable or not; defaults to \code{FALSE}, corresponding to,
e.g., an undesirable binary outcomes (e.g., mortality) or a continuous
outcome where lower numbers are preferred (e.g., hospital length of stay).}
}
\value{
A single numeric value between \code{0} and \code{100} corresponding to the
ideal design percentage.
}
\description{
Used internally by \code{\link[=check_performance]{check_performance()}}, calculates the ideal design
percentage as described in that function's documentation.
}
\keyword{internal}
