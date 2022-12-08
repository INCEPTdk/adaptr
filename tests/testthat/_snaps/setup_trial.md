# Trial with normally distributed outcome is set up correctly

    Code
      norm_trial
    Output
      Trial specification: generic normally distributed outcome trial
      * Desirable outcome
      * Common control arm: Control 
      * Control arm probability fixed at 0.366 (for 4 arms), 0.414 (for 3 arms), 0.5 (for 2 arms)
      * Best arm: New A
      
      Arms, true outcomes, starting allocation probabilities 
      and allocation probability limits:
          arms true_ys start_probs fixed_probs min_probs max_probs
       Control      15       0.366       0.366        NA        NA
         New A      20       0.211       0.211        NA        NA
         New B      14       0.211       0.211        NA        NA
         New C      13       0.211       0.211        NA        NA
      
      Maximum sample size: 500 
      Maximum number of data looks: 10
      Planned looks after every 50
       patients have reached follow-up until final look after 500 patients
      Number of patients randomised at each look:  50, 100, 150, 200, 250, 300, 350, 400, 450, 500
      
      Superiority threshold: 0.99 (all analyses)
      Inferiority threshold: 0.01 (all analyses)
      No equivalence threshold
      No futility threshold
      Soften power for all analyses: 0.5
      
      Additional info: Arm SDs - Control: 2; New A: 2.5; New B: 1.9; New C: 1.8.

# Trial with binomially distributed outcome is set up correctly

    Code
      setup
    Output
      Trial specification: generic binomially distributed outcome trial
      * Undesirable outcome
      * No common control arm
      * Best arm: Arm B
      
      Arms, true outcomes, starting allocation probabilities 
      and allocation probability limits:
        arms true_ys start_probs fixed_probs min_probs max_probs
       Arm A    0.25       0.333          NA      0.15        NA
       Arm B    0.20       0.333          NA      0.15        NA
       Arm C    0.30       0.333          NA      0.15        NA
      
      Maximum sample size: 2000 
      Maximum number of data looks: 18
      Planned data looks after:  300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000 patients have reached follow-up
      Number of patients randomised at each look:  300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000
      
      Superiority threshold: 0.99 (all analyses)
      Inferiority threshold: 0.01 (all analyses)
      Equivalence threshold: 0.9 (all analyses) (no common control)
      Absolute equivalence difference: 0.05
      No futility threshold (not relevant - no common control)
      Soften power for all analyses: 0.5

---

    Code
      setup
    Output
      Trial specification: generic binomially distributed outcome trial
      * Undesirable outcome
      * No common control arm
      * Best arm: Arm B
      
      Arms, true outcomes, starting allocation probabilities 
      and allocation probability limits:
        arms true_ys start_probs fixed_probs min_probs max_probs
       Arm A    0.25         0.2         0.2        NA        NA
       Arm B    0.20         0.4          NA       0.2        NA
       Arm C    0.30         0.4          NA       0.2        NA
      
      Maximum sample size: 2000 
      Maximum number of data looks: 18
      Planned data looks after:  300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000 patients have reached follow-up
      Number of patients randomised at each look:  300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000
      
      Superiority threshold: 0.99 (all analyses)
      Inferiority threshold: 0.01 (all analyses)
      Equivalence threshold: 0.9 (all analyses) (no common control)
      Absolute equivalence difference: 0.05
      No futility threshold (not relevant - no common control)
      Soften power for all analyses: 0.5

# Custom trial with log-normally distributed outcome is set up correctly

    Code
      lognorm_trial
    Output
      Trial specification: continuous, log-normally distributed outcome
      * Undesirable outcome
      * Common control arm: Control 
      * Control arm probability fixed at 0.414 (for 3 arms), 0.5 (for 2 arms)
      * Best arm: Experimental A
      
      Arms, true outcomes, starting allocation probabilities 
      and allocation probability limits:
                 arms true_ys start_probs fixed_probs min_probs max_probs
              Control    9.03       0.414       0.414        NA        NA
       Experimental A    8.17       0.293          NA        NA        NA
       Experimental B    9.97       0.293          NA        NA        NA
      
      Maximum sample size: 5000 
      Maximum number of data looks: 25
      Planned looks after every 200
       patients have reached follow-up until final look after 5000 patients
      Number of patients randomised at each look:  200, 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3200, 3400, 3600, 3800, 4000, 4200, 4400, 4600, 4800, 5000
      
      Superiority threshold: 0.99 (all analyses)
      Inferiority threshold: 0.01 (all analyses)
      Equivalence threshold: 0.9 (all analyses) (only checked for first control)
      Absolute equivalence difference: 0.5
      No futility threshold
      Soften power for all analyses: 1 (no softening)
      
      Additional info: SD on the log scale for all arms: 1.5

