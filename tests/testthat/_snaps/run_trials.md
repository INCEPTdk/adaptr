# single trial simulation works

    Code
      run_trial(setup_equi_futil_only_first, seed = 12345)
    Output
      Single simulation result: generic binomially distributed outcome trial
      * Undesirable outcome
      * Initial/final common control arms: B/B
      
      Final status: conclusive, stopped for equivalence
      Final/maximum allowed sample sizes: 500/2000 (25.0%)
      Available outcome data at last adaptive analysis: 500/500 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.20  equivalence         500            1       0.333
          B    0.21      control         500           NA       0.333
          C    0.70     inferior         500            0       0.333
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         39    195        0.200         0.202        0.0286      0.151
          B         25    152        0.164         0.168        0.0294      0.115
          C        114    153        0.745         0.743        0.0358      0.668
       hi_cri_all
            0.262
            0.230
            0.807
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     39 195    0.200     0.202    0.0282  0.149  0.261
          B     25 152    0.164     0.167    0.0295  0.113  0.231
          C    114 153    0.745     0.744    0.0346  0.669  0.807
      
      Simulation details:
      * Random seed: 12345
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs

---

    Code
      run_trial(setup_equi_futil_only_first, seed = 12345)
    Output
      Single simulation result: generic binomially distributed outcome trial
      * Undesirable outcome
      * Initial/final common control arms: B/B
      
      Final status: conclusive, stopped for equivalence
      Final/maximum allowed sample sizes: 500/2000 (25.0%)
      Available outcome data at last adaptive analysis: 500/500 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.20  equivalence         500            1       0.333
          B    0.21      control         500           NA       0.333
          C    0.70     inferior         500            0       0.333
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         39    195        0.200         0.202        0.0286      0.151
          B         25    152        0.164         0.168        0.0294      0.115
          C        114    153        0.745         0.743        0.0358      0.668
       hi_cri_all
            0.262
            0.230
            0.807
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     39 195    0.200     0.202    0.0282  0.149  0.261
          B     25 152    0.164     0.167    0.0295  0.113  0.231
          C    114 153    0.745     0.744    0.0346  0.669  0.807
      
      Simulation details:
      * Random seed: 12345
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs

---

    Code
      run_trial(setup_rescale_probs, seed = 12345)
    Output
      Single simulation result: generic binomially distributed outcome trial
      * Undesirable outcome
      * Initial/final common control arms: B/B
      
      Final status: conclusive, stopped for superiority
      Final/maximum allowed sample sizes: 1500/2000 (75.0%)
      Available outcome data at last adaptive analysis: 1500/1500 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.20     inferior        1500       0.0046        0.60
          B    0.15     superior        1500       0.9954        0.40
          C    0.30     inferior        1000       0.0010        0.15
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A        143    701        0.204         0.205        0.0152      0.176
          B         88    593        0.148         0.149        0.0151      0.122
          C         56    206        0.272         0.273        0.0310      0.213
       hi_cri_all
            0.235
            0.179
            0.336
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    143 701    0.204     0.205    0.0151  0.176  0.235
          B     88 593    0.148     0.149    0.0144  0.122  0.180
          C     56 206    0.272     0.274    0.0303  0.216  0.334
      
      Simulation details:
      * Random seed: 12345
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs

# dispatch_trial_runs works

    Code
      dispatch_trial_runs(1:5, setup, seeds = seeds, sparse = FALSE, cores = 1)
    Output
      [[1]]
      Single simulation result: generic binomially distributed outcome trial
      * Desirable outcome
      * Initial/final common control arms: B/C
      
      Final status: conclusive, stopped for futility
      Final/maximum allowed sample sizes: 500/2000 (25.0%)
      Available outcome data at last adaptive analysis: 500/500 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         500        0.953       0.466
          B    0.20     inferior         500        0.006       0.150
          C    0.30      control         500           NA       0.384
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         44    182        0.242         0.243        0.0309     0.1855
          B         18    123        0.146         0.151        0.0321     0.0962
          C         52    195        0.267         0.269        0.0312     0.2087
       hi_cri_all
            0.307
            0.221
            0.333
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     44 182    0.242     0.244    0.0308 0.1834  0.308
          B     18 123    0.146     0.150    0.0314 0.0957  0.218
          C     52 195    0.267     0.268    0.0318 0.2103  0.333
      
      Simulation details:
      * Random seed: none specified
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs
      
      [[2]]
      Single simulation result: generic binomially distributed outcome trial
      * Desirable outcome
      * Initial/final common control arms: B/C
      
      Final status: conclusive, stopped for superiority
      Final/maximum allowed sample sizes: 500/2000 (25.0%)
      Available outcome data at last adaptive analysis: 500/500 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         300       0.9534       0.333
          B    0.20     inferior         500       0.0092       0.150
          C    0.30     superior         500       0.9908       0.850
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         20    116        0.172         0.176        0.0351      0.115
          B         26    119        0.218         0.221        0.0384      0.151
          C         90    265        0.340         0.341        0.0289      0.285
       hi_cri_all
            0.251
            0.302
            0.400
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     20 116    0.172     0.175    0.0340  0.115  0.249
          B     26 119    0.218     0.222    0.0387  0.155  0.303
          C     90 265    0.340     0.340    0.0284  0.286  0.400
      
      Simulation details:
      * Random seed: none specified
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs
      
      [[3]]
      Single simulation result: generic binomially distributed outcome trial
      * Desirable outcome
      * Initial/final common control arms: B/C
      
      Final status: conclusive, stopped for futility
      Final/maximum allowed sample sizes: 700/2000 (35.0%)
      Available outcome data at last adaptive analysis: 700/700 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         700       0.9944       0.313
          B    0.20     inferior         700       0.0094       0.150
          C    0.30      control         700           NA       0.537
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         59    253        0.233         0.234        0.0266      0.185
          B         27    152        0.178         0.180        0.0312      0.124
          C         82    295        0.278         0.279        0.0265      0.229
       hi_cri_all
            0.290
            0.249
            0.333
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     59 253    0.233     0.235    0.0266  0.186  0.289
          B     27 152    0.178     0.181    0.0308  0.125  0.245
          C     82 295    0.278     0.279    0.0262  0.229  0.330
      
      Simulation details:
      * Random seed: none specified
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs
      
      [[4]]
      Single simulation result: generic binomially distributed outcome trial
      * Desirable outcome
      * Initial/final common control arms: B/C
      
      Final status: conclusive, stopped for futility
      Final/maximum allowed sample sizes: 900/2000 (45.0%)
      Available outcome data at last adaptive analysis: 900/900 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         900        0.991       0.328
          B    0.20     inferior         900        0.008       0.150
          C    0.30      control         900           NA       0.522
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         83    318        0.261         0.262        0.0246      0.216
          B         38    191        0.199         0.201        0.0288      0.150
          C        114    391        0.292         0.291        0.0229      0.250
       hi_cri_all
            0.312
            0.261
            0.339
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     83 318    0.261     0.262    0.0245  0.217  0.312
          B     38 191    0.199     0.201    0.0296  0.146  0.259
          C    114 391    0.292     0.293    0.0225  0.250  0.336
      
      Simulation details:
      * Random seed: none specified
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs
      
      [[5]]
      Single simulation result: generic binomially distributed outcome trial
      * Desirable outcome
      * Initial/final common control arms: B/C
      
      Final status: conclusive, stopped for superiority
      Final/maximum allowed sample sizes: 1200/2000 (60.0%)
      Available outcome data at last adaptive analysis: 1200/1200 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         300       0.9692       0.333
          B    0.20     inferior        1200       0.0096       0.150
          C    0.30     superior        1200       0.9904       0.850
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         16     88        0.182         0.186        0.0398      0.114
          B         70    292        0.240         0.241        0.0251      0.194
          C        255    820        0.311         0.311        0.0161      0.280
       hi_cri_all
            0.273
            0.293
            0.344
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     16  88    0.182     0.187    0.0410  0.118  0.273
          B     70 292    0.240     0.241    0.0243  0.193  0.292
          C    255 820    0.311     0.311    0.0166  0.280  0.343
      
      Simulation details:
      * Random seed: none specified
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs
      

# prog_breaks

    Code
      prog_breaks(0.1, prev_n_rep = 10, n_rep_new = 20, cores = 1)
    Output
      $breaks
       [1]  2  4  7  8 10 13 15 16 18 20
      
      $start_mess
      [1] "run_trials:  0/20   (0%) [starting]"
      
      $prog_mess
       [1] "run_trials:  2/20  (10%)" "run_trials:  4/20  (20%)"
       [3] "run_trials:  7/20  (30%)" "run_trials:  8/20  (40%)"
       [5] "run_trials: 10/20  (50%)" "run_trials: 13/20  (60%)"
       [7] "run_trials: 15/20  (70%)" "run_trials: 16/20  (80%)"
       [9] "run_trials: 18/20  (90%)" "run_trials: 20/20 (100%)"
      
      $batches
      $batches[[1]]
      [1] 11 12
      
      $batches[[2]]
      [1] 13 14
      
      $batches[[3]]
      [1] 15 16 17
      
      $batches[[4]]
      [1] 18
      
      $batches[[5]]
      [1] 19 20
      
      $batches[[6]]
      [1] 21 22 23
      
      $batches[[7]]
      [1] 24 25
      
      $batches[[8]]
      [1] 26
      
      $batches[[9]]
      [1] 27 28
      
      $batches[[10]]
      [1] 29 30
      
      

---

    Code
      prog_breaks(0.1, prev_n_rep = 0, n_rep_new = 10, cores = 2)
    Output
      $breaks
      [1]  2  4  6  8 10
      
      $start_mess
      [1] "run_trials:  0/10   (0%) [starting]"
      
      $prog_mess
      [1] "run_trials:  2/10  (20%)" "run_trials:  4/10  (40%)"
      [3] "run_trials:  6/10  (60%)" "run_trials:  8/10  (80%)"
      [5] "run_trials: 10/10 (100%)"
      
      $batches
      $batches[[1]]
      [1] 1 2
      
      $batches[[2]]
      [1] 3 4
      
      $batches[[3]]
      [1] 5 6
      
      $batches[[4]]
      [1] 7 8
      
      $batches[[5]]
      [1]  9 10
      
      

# Multiple trials simulation works on multiple cores

    Code
      extract_results(res)
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    110 0.2200000  superiority            B            B
      2    2    1200    273 0.2275000  superiority            B            B
      3    3    1200    266 0.2216667  superiority            B            B
      4    4     700    156 0.2228571  superiority            B            B
      5    5    1300    295 0.2269231  superiority            B            B
      6    6     600    131 0.2183333  superiority            B            B
      7    7    1900    420 0.2210526  superiority            B            B
      8    8    2000    433 0.2165000          max         <NA>         <NA>
      9    9    1600    353 0.2206250  superiority            B            B
      10  10    1000    220 0.2200000  equivalence         <NA>         <NA>
      11  11    1200    264 0.2200000  superiority            B            B
      12  12     400     94 0.2350000  superiority            B            B
      13  13    2000    469 0.2345000          max         <NA>         <NA>
      14  14     900    197 0.2188889  equivalence         <NA>         <NA>
      15  15    1400    303 0.2164286  superiority            B            B
      16  16    2000    462 0.2310000          max         <NA>         <NA>
      17  17    1000    215 0.2150000  equivalence         <NA>         <NA>
      18  18    2000    472 0.2360000          max         <NA>         <NA>
      19  19    1600    372 0.2325000  superiority            B            B
      20  20     500    135 0.2700000  superiority            B            B
                  err       sq_err err_te sq_err_te
      1  -0.037462579 1.403445e-03     NA        NA
      2  -0.008091122 6.546625e-05     NA        NA
      3  -0.009209925 8.482272e-05     NA        NA
      4  -0.025234966 6.368035e-04     NA        NA
      5  -0.003681956 1.355680e-05     NA        NA
      6  -0.032735518 1.071614e-03     NA        NA
      7  -0.001214794 1.475723e-06     NA        NA
      8            NA           NA     NA        NA
      9  -0.003254965 1.059480e-05     NA        NA
      10           NA           NA     NA        NA
      11 -0.011561899 1.336775e-04     NA        NA
      12 -0.035424899 1.254923e-03     NA        NA
      13           NA           NA     NA        NA
      14           NA           NA     NA        NA
      15 -0.017683969 3.127227e-04     NA        NA
      16           NA           NA     NA        NA
      17           NA           NA     NA        NA
      18           NA           NA     NA        NA
      19  0.004641866 2.154692e-05     NA        NA
      20  0.006639065 4.407718e-05     NA        NA

