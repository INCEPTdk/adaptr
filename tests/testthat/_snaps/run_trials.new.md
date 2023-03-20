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
               sq_err sq_err_te
      1  1.403445e-03        NA
      2  6.546625e-05        NA
      3  8.482272e-05        NA
      4  6.368035e-04        NA
      5  1.355680e-05        NA
      6  1.071614e-03        NA
      7  1.475723e-06        NA
      8            NA        NA
      9  1.059480e-05        NA
      10           NA        NA
      11 1.336775e-04        NA
      12 1.254923e-03        NA
      13           NA        NA
      14           NA        NA
      15 3.127227e-04        NA
      16           NA        NA
      17           NA        NA
      18           NA        NA
      19 2.154692e-05        NA
      20 4.407718e-05        NA

