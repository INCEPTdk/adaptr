## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 6, 
  fig.align = "center"
)

## ----setup--------------------------------------------------------------------
library(adaptr)

## -----------------------------------------------------------------------------
set.seed(89)

## -----------------------------------------------------------------------------
get_ys_binom_custom <- function(allocs) {
  # Binary outcome coded as 0/1 - prepare returned vector of appropriate length
  y <- integer(length(allocs))
  
  # Specify trial arms and true event probabilities for each arm
  # These values should exactly match those supplied to setup_trial
  # NB! This is not validated, so this is the user's responsibility
  arms <- c("Control", "Experimental arm A", "Experimental arm B")
  true_ys <- c(0.25, 0.27, 0.20)
  
  # Loop through arms and generate outcomes
  for (i in seq_along(arms)) {
    # Indices of patients allocated to the current arm
    ii <- which(allocs == arms[i])
    # Generate outcomes for all patients allocated to current arm
    y[ii] <- rbinom(length(ii), 1, true_ys[i])
  }
  
  # Return outcome vector
  y
}

## -----------------------------------------------------------------------------
(allocs <- sample(c("Control", "Experimental arm A", "Experimental arm  B"),
                  size = 50, replace = TRUE))

## -----------------------------------------------------------------------------
(ys <- get_ys_binom_custom(allocs))

## -----------------------------------------------------------------------------
find_beta_params(
  theta = 0.25, # Event ratio
  boundary = "lower",
  boundary_target = 0.15,
  interval_width = 0.95
)

## ---- echo = FALSE------------------------------------------------------------
# Helper function for plotting priors and posteriors together
plot_prior_posterior <- function(events, non_events, prior_events, prior_non_events) {
  beta_curve <- function(prior_alpha, prior_beta, events = 0, non_events = 0, type = "prior") {
    ggplot2::geom_function(
      ggplot2::aes(colour = sprintf("beta(%i, %i) prior", prior_alpha, prior_beta), linetype = type), 
      fun = dbeta, args = list(shape1 = prior_alpha + events, shape2 = prior_beta + non_events)
    )
  }
  
  ggplot2::ggplot(data.frame(x = seq(from = 0, to = 1, by = 0.01)), ggplot2::aes(x = x)) +
    beta_curve(1, 1) +
    beta_curve(1, 1, events, non_events, "posterior") +
    beta_curve(prior_events, prior_non_events) +
    beta_curve(prior_events, prior_non_events, events, non_events, "posterior") +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.title = ggplot2::element_blank()) +
    ggplot2::scale_colour_brewer(palette = "Set1") +
    ggplot2::scale_x_continuous(breaks = 0.1 * 0:10, minor_breaks = 0.05 * 0:20, 
                                labels = paste0(0:10 * 10, "%"), expand = c(0.01, 0.01)) +
    ggplot2::scale_y_continuous(breaks = NULL, expand = c(0, 0), name = NULL) + 
    ggplot2::labs(x = "Event probability",
                  title = sprintf("Single trial arm - %i patients (%i events, %i non-events)", events + non_events, events, non_events)
  )
}

## ----prior_posterior_20, echo=FALSE-------------------------------------------
plot_prior_posterior(12, 8, 15, 45)

## ----prior_posterior_200, echo=FALSE------------------------------------------
plot_prior_posterior(56, 144, 15, 45)

## -----------------------------------------------------------------------------
get_draws_binom_custom <- function(arms, allocs, ys, control, n_draws) {
  # Setup a list to store the posterior draws for each arm
  draws <- list()
  
  # Loop through the ACTIVE arms and generate posterior draws
  for (a in arms) {
    # Indices of patients allocated to the current arm
    ii <- which(allocs == a)
    # Sum the number of events in the current arm
    n_events <- sum(ys[ii])
    # Compute the number of patients in the current arm
    n_patients <- length(ii)
    # Generate draws using the number of events, the number of patients
    # and the prior specified above: beta(15, 45)
    # Saved using the current arms' name in the list, ensuring that the
    # resulting matrix has column names corresponding to the ACTIVE arms
    draws[[a]] <- rbeta(n_draws, 15 + n_events, 45 + n_patients - n_events)
  }
  
  # Bind all elements of the list column-wise to form a matrix with
  # 1 named column per ACTIVE arm and 1 row per posterior draw.
  # Multiply result with 100, as we're using percentages and not proportions
  # in this example (just to correspond to the illustrated custom function to
  # generate RAW outcome estimates below)
  do.call(cbind, draws) * 100
}

## -----------------------------------------------------------------------------
get_draws_binom_custom(
  # Only currently ACTIVE arms, but all are considered active at this time
  arms = c("Control", "Experimental arm A", "Experimental arm B"),
  allocs = allocs, # Generated above
  ys = ys, # Generated above
  # Input control arm, argument is supplied even if not used in the function
  control = "Control",
  # Input number of draws (for brevity, only 10 draws here)
  n_draws = 10
)

## -----------------------------------------------------------------------------
fun_raw_est_custom <- function(ys) {
  mean(ys) * 100
}

## -----------------------------------------------------------------------------
cat(sprintf(
  "Raw outcome percentage estimate in the 'Control' group: %.1f%%", 
  fun_raw_est_custom(ys[allocs == "Control"])
))

## -----------------------------------------------------------------------------
setup_trial(
  arms = c("Control", "Experimental arm A", "Experimental arm B"),
  
  # true_ys, true outcome percentages (since posterior draws and raw estimates
  # are returned as percentages, this must be a percentage as well, even if
  # probabilities are specified as proportions internally in the outcome
  # generating function specified above
  true_ys = c(25, 27, 20),
  
  # Supply the functions to generate outcomes and posterior draws
  fun_y_gen = get_ys_binom_custom,
  fun_draws = get_draws_binom_custom,
  
  # Define looks
  max_n = 2000,
  look_after_every = 100,
  
  # Define control and allocation strategy
  control = "Control",
  control_prob_fixed = "sqrt-based",
  
  # Define equivalence assessment - drop non-control arms at > 90% probability
  # of equivalence, defined as an absolute difference of 10 %-points
  # (specified on the percentage-point scale as the rest of probabilities in
  # the example)
  equivalence_prob = 0.9,
  equivalence_diff = 10,
  equivalence_only_first = TRUE,
  
  # Input the function used to calculate raw outcome estimates
  fun_raw_est = fun_raw_est_custom,
  
  # Description and additional information
  description = "custom trial [binary outcome, weak priors]",
  add_info = "Trial using beta-binomial conjugate prior models and beta(15, 45) priors in each arm."
)

