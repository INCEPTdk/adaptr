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
      summary(res)
    Output
                             Length Class      Mode     
      final_status             1    -none-     character
      final_n                  1    -none-     numeric  
      followed_n               1    -none-     numeric  
      max_n                    1    -none-     numeric  
      max_randomised           1    -none-     numeric  
      looks                    7    -none-     numeric  
      planned_looks           18    -none-     numeric  
      randomised_at_looks      7    -none-     numeric  
      start_control            1    -none-     character
      final_control            1    -none-     character
      control_prob_fixed       0    -none-     NULL     
      inferiority              1    -none-     numeric  
      superiority              1    -none-     numeric  
      equivalence_prob         1    -none-     numeric  
      equivalence_diff         1    -none-     numeric  
      equivalence_only_first   1    -none-     logical  
      futility_prob            1    -none-     numeric  
      futility_diff            1    -none-     numeric  
      futility_only_first      1    -none-     logical  
      highest_is_best          1    -none-     logical  
      soften_power            18    -none-     numeric  
      best_arm                 1    -none-     character
      trial_res               25    data.frame list     
      all_looks                7    -none-     list     
      allocs                 900    -none-     character
      ys                     900    -none-     numeric  
      seed                     1    -none-     numeric  
      description              1    -none-     character
      add_info                 0    -none-     NULL     
      cri_width                1    -none-     numeric  
      n_draws                  1    -none-     numeric  
      robust                   1    -none-     logical  
      sparse                   1    -none-     logical  

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
      * Sample sizes: mean 680.0 (SD: 433.6) | median 500.0 (IQR: 400.0 to 800.0)
      * Total summarised outcomes: mean 176.6 (SD: 115.0) | median 133.0 (IQR: 102.2 to 210.8)
      * Total summarised outcome rates: mean 0.258 (SD: 0.015) | median 0.260 (IQR: 0.248 to 0.268)
      * Conclusive: 95.0%
      * Superiority: 5.0%
      * Equivalence: 10.0%
      * Futility: 80.0%
      * Inconclusive at max sample size: 5.0%
      * Selection probabilities: A: 0.0% | B: 5.0% | C: 5.0% | None: 90.0%
      * RMSE: 0.02360
      * RMSE treatment effect: 0.00487
      * Ideal design percentage: 50.0%
      
      Simulation details:
      * Simulation time: 1.03 secs
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
      * Sample sizes: mean 680.0 (SD: 433.6) | median 500.0 (IQR: 400.0 to 800.0)
      * Total summarised outcomes: mean 176.6 (SD: 115.0) | median 133.0 (IQR: 102.2 to 210.8)
      * Total summarised outcome rates: mean 0.258 (SD: 0.015) | median 0.260 (IQR: 0.248 to 0.268)
      * Conclusive: 95.0%
      * Superiority: 5.0%
      * Equivalence: 10.0%
      * Futility: 80.0%
      * Inconclusive at max sample size: 5.0%
      * Selection probabilities: A: 0.0% | B: 5.0% | C: 5.0% | None: 90.0%
      * RMSE: 0.02360
      * RMSE treatment effect: 0.00487
      * Ideal design percentage: 50.0%
      
      Simulation details:
      * Simulation time: 1.03 secs
      * Base random seed: 12345
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Estimation method: posterior medians with MAD-SDs

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

