# print and summary of single trial work

    Code
      print(res)
    Output
      Single simulation result: generic binomially distributed outcome trial
      * Desirable outcome
      * Initial/final common control arms: B/C
      
      Final status: conclusive, stopped for futility
      Final/maximum allowed sample sizes: 900/2000 (45.0%)
      Available outcome data at last adaptive analysis: 900/900 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         900       1.0000        0.15
          B    0.20     inferior         900       0.0012        0.15
          C    0.30      control         900           NA        0.70
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         48    244        0.197         0.198        0.0258      0.151
          B         41    223        0.184         0.186        0.0257      0.138
          C        126    433        0.291         0.292        0.0222      0.249
       hi_cri_all
            0.250
            0.238
            0.336
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     48 244    0.197     0.198    0.0253  0.153  0.252
          B     41 223    0.184     0.186    0.0259  0.138  0.239
          C    126 433    0.291     0.291    0.0221  0.251  0.335
      
      Simulation details:
      * Random seed: 12345
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs

---

    Code
      print(res)
    Output
      Single simulation result [saved/printed with sparse details]
      
      Final status: inconclusive, stopped at final allowed adaptive analysis
      Final sample size: 2000
      Available outcome data at last adaptive analysis: 2000/2000 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       active          NA           NA       0.194
          B    0.20       active          NA           NA       0.656
          C    0.30     inferior        2000        0.007       0.150
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A        180    742        0.243         0.243        0.0161      0.213
          B        178    841        0.212         0.212        0.0141      0.185
          C        113    417        0.271         0.272        0.0221      0.230
       hi_cri_all
            0.274
            0.240
            0.316
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    180 742    0.243     0.243    0.0159  0.213  0.275
          B    178 841    0.212     0.212    0.0141  0.185  0.241
          C    113 417    0.271     0.271    0.0215  0.230  0.316
      
      Simulation details:
      * Random seed: 12345

---

    Code
      print(res)
    Output
      Single simulation result: generic normally distributed outcome trial
      * Undesirable outcome
      * Initial/final common control arms: B/B
      
      Final status: inconclusive, stopped at final allowed adaptive analysis
      Final/maximum allowed sample sizes: 1000/1000 (100.0%)
      Available outcome data at last adaptive analysis: 1000/1000 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       active          NA           NA       0.333
          B    0.25      control          NA           NA       0.333
          C    0.30       active          NA           NA       0.333
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A       81.8    355        0.230         0.229        0.0550      0.120
          B       69.9    328        0.213         0.213        0.0560      0.105
          C       72.1    317        0.228         0.228        0.0565      0.119
       hi_cri_all
            0.337
            0.325
            0.338
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A   81.8 355    0.230     0.231    0.0541  0.123  0.337
          B   69.9 328    0.213     0.213    0.0551  0.104  0.320
          C   72.1 317    0.228     0.228    0.0559  0.119  0.338
      
      Simulation details:
      * Random seed: 12345
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: means with SDs
      
      Additional info: Arm SDs - A: 1; B: 1; C: 1.

# print and summary of multiple trials work

    Code
      print(res)
    Output
      Multiple simulation results: generic binomially distributed outcome trial
      * Desirable outcome
      * Number of simulations: 20
      * Number of simulations summarised: 20 (all trials)
      * Common control arm: B
      * Selection strategy: first control if available (otherwise no selection)
      * Treatment effect compared to: no comparison
      
      Performance metrics (using posterior estimates from last adaptive analysis):
      * Sample sizes: mean 800.0 (SD: 432.9) | median 700.0 (IQR: 475.0 to 1100.0) [range: 300.0 to 1900.0]
      * Total summarised outcomes: mean 206.8 (SD: 117.6) | median 183.5 (IQR: 117.0 to 271.8) [range: 69.0 to 523.0]
      * Total summarised outcome rates: mean 0.257 (SD: 0.022) | median 0.253 (IQR: 0.238 to 0.277) [range: 0.228 to 0.295]
      * Conclusive: 100.0%
      * Superiority: 25.0%
      * Equivalence: 0.0%
      * Futility: 75.0%
      * Inconclusive at max sample size: 0.0%
      * Selection probabilities: A: 0.0% | B: 0.0% | C: 25.0% | None: 75.0%
      * RMSE: 0.02621
      * RMSE treatment effect: 0.02309
      * Ideal design percentage: 100.0%
      
      Simulation details:
      * Simulation time: 0.83 secs
      * Base random seed: 12345
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Estimation method: posterior medians with MAD-SDs

---

    Code
      summary(res)
    Output
      Multiple simulation results: generic binomially distributed outcome trial
      * Desirable outcome
      * Number of simulations: 20
      * Number of simulations summarised: 20 (all trials)
      * Common control arm: B
      * Selection strategy: first control if available (otherwise no selection)
      * Treatment effect compared to: no comparison
      
      Performance metrics (using posterior estimates from last adaptive analysis):
      * Sample sizes: mean 800.0 (SD: 432.9) | median 700.0 (IQR: 475.0 to 1100.0) [range: 300.0 to 1900.0]
      * Total summarised outcomes: mean 206.8 (SD: 117.6) | median 183.5 (IQR: 117.0 to 271.8) [range: 69.0 to 523.0]
      * Total summarised outcome rates: mean 0.257 (SD: 0.022) | median 0.253 (IQR: 0.238 to 0.277) [range: 0.228 to 0.295]
      * Conclusive: 100.0%
      * Superiority: 25.0%
      * Equivalence: 0.0%
      * Futility: 75.0%
      * Inconclusive at max sample size: 0.0%
      * Selection probabilities: A: 0.0% | B: 0.0% | C: 25.0% | None: 75.0%
      * RMSE: 0.02621
      * RMSE treatment effect: 0.02309
      * Ideal design percentage: 100.0%
      
      Simulation details:
      * Simulation time: 0.83 secs
      * Base random seed: 12345
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Estimation method: posterior medians with MAD-SDs

---

    Code
      print(res)
    Output
      Single simulation result [saved/printed with sparse details]
      
      Final status: inconclusive, stopped at final allowed adaptive analysis
      Final sample size: 2000
      Available outcome data at last adaptive analysis: 2000/2000 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       active          NA           NA       0.194
          B    0.20       active          NA           NA       0.656
          C    0.30     inferior        2000        0.007       0.150
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A        180    742        0.243         0.243        0.0161      0.213
          B        178    841        0.212         0.212        0.0141      0.185
          C        113    417        0.271         0.272        0.0221      0.230
       hi_cri_all
            0.274
            0.240
            0.316
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    180 742    0.243     0.243    0.0159  0.213  0.275
          B    178 841    0.212     0.212    0.0141  0.185  0.241
          C    113 417    0.271     0.271    0.0215  0.230  0.316
      
      Simulation details:
      * Random seed: 12345

---

    Code
      summary(res)
    Output
                   Length Class      Mode     
      final_status  1     -none-     character
      final_n       1     -none-     numeric  
      followed_n    1     -none-     numeric  
      trial_res    25     data.frame list     
      seed          1     -none-     numeric  
      sparse        1     -none-     logical  

# print of trial setup works

    Code
      print(res)
    Output
      Trial specification: generic binomially distributed outcome trial
      * Desirable outcome
      * Common control arm: B 
      
      * Best arm: C
      
      Arms, true outcomes, starting allocation probabilities 
      and allocation probability limits:
       arms true_ys start_probs fixed_probs min_probs max_probs
          A    0.25       0.333          NA      0.15        NA
          B    0.20       0.333          NA      0.15        NA
          C    0.30       0.333          NA      0.15        NA
      
      Maximum sample size: 2000 
      Maximum number of data looks: 18
      Planned data looks after:  300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000 patients have reached follow-up
      Number of patients randomised at each look:  300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000
      
      Superiority threshold: 0.99 (all analyses)
      Inferiority threshold: 0.01 (all analyses)
      Equivalence threshold: 0.9 (all analyses) 
      (checked for first and eventual new controls)
      Absolute equivalence difference: 0.05
      Futility threshold: 0.95 (all analyses) 
      (checked for first and eventual new controls)
      Absolute futility difference (in beneficial direction): 0.05 
      Soften power for all analyses: 0.5

---

    Code
      print(res)
    Output
      Trial specification: generic normally distributed outcome trial
      * Undesirable outcome
      * Common control arm: B 
      * Control arm probability matched to best non-control arm
      * Best arms: A and B
      
      Arms, true outcomes, starting allocation probabilities 
      and allocation probability limits:
       arms true_ys start_probs fixed_probs min_probs max_probs
          A    0.25       0.333          NA        NA        NA
          B    0.25       0.333          NA        NA        NA
          C    0.30       0.333          NA        NA        NA
      
      Maximum sample size: 1000 
      Maximum number of data looks: 5
      Planned data looks after:  200, 400, 600, 800, 1000 patients have reached follow-up
      Number of patients randomised at each look:  200, 400, 600, 800, 1000
      
      Superiority thresholds: 0.99, 0.98, 0.97, 0.96, 0.95
      Inferiority thresholds: 0.01, 0.02, 0.03, 0.04, 0.05
      Equivalence thresholds: 0.99, 0.98, 0.97, 0.96, 0.95 
      (only checked for first control)
      Absolute equivalence difference: 0.05
      Futility thresholds: 0.99, 0.98, 0.97, 0.96, 0.95 
      (only checked for first control)
      Absolute futility difference (in beneficial direction): 0.05 
      Soften power for all analyses: 1 (no softening)
      
      Additional info: Arm SDs - A: 1; B: 1; C: 1.

---

    Code
      print(res)
    Output
      Trial specification: generic normally distributed outcome trial
      * Undesirable outcome
      * Common control arm: B 
      * Control arm probability fixed at 0.333
      * Best arms: A and B
      
      Arms, true outcomes, starting allocation probabilities 
      and allocation probability limits:
       arms true_ys start_probs fixed_probs min_probs max_probs
          A    0.25       0.333       0.333        NA        NA
          B    0.25       0.333       0.333        NA        NA
          C    0.30       0.333       0.333        NA        NA
      
      Maximum sample size: 1000 
      Maximum number of data looks: 5
      Planned data looks after:  200, 400, 600, 800, 1000 patients have reached follow-up
      Number of patients randomised at each look:  200, 400, 600, 800, 1000
      
      Superiority threshold: 0.99 (all analyses)
      Inferiority threshold: 0.01 (all analyses)
      No equivalence threshold
      No futility threshold
      Soften power for all analyses: 1 (no softening - all arms fixed)
      
      Additional info: Arm SDs - A: 1; B: 1; C: 1.

---

    Code
      print(res)
    Output
      Trial specification: generic normally distributed outcome trial
      * Undesirable outcome
      * Common control arm: B 
      * Control arm probability matched to best non-control arm
      * Best arms: A and B
      
      Arms, true outcomes, starting allocation probabilities 
      and allocation probability limits:
       arms true_ys start_probs fixed_probs min_probs max_probs
          A    0.25       0.333          NA        NA        NA
          B    0.25       0.333          NA        NA        NA
          C    0.30       0.333          NA        NA        NA
      
      Maximum sample size: 1000 
      Maximum number of data looks: 5
      Planned data looks after:  200, 400, 600, 800, 1000 patients have reached follow-up
      Number of patients randomised at each look:  200, 400, 600, 800, 1000
      
      Superiority thresholds: 0.99, 0.98, 0.97, 0.96, 0.95
      Inferiority thresholds: 0.01, 0.02, 0.03, 0.04, 0.05
      Equivalence thresholds: 0.99, 0.98, 0.97, 0.96, 0.95 
      (only checked for first control)
      Absolute equivalence difference: 0.05
      Futility thresholds: 0.99, 0.98, 0.97, 0.96, 0.95 
      (only checked for first control)
      Absolute futility difference (in beneficial direction): 0.05 
      Soften power for all analyses: 1 (no softening)
      
      Additional info: Arm SDs - A: 1; B: 1; C: 1.

