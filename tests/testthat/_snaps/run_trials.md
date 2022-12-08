# dispatch_trial_runs works

    Code
      dispatch_trial_runs(1:5, setup, base_seed = 12345, sparse = FALSE, cores = 1)
    Output
      [[1]]
      Single simulation result: generic binomially distributed outcome trial
      * Desirable outcome
      * Initial/final common control arms: B/C
      
      Final status: conclusive, stopped for futility
      Final/maximum allowed sample sizes: 700/2000 (35.0%)
      Available outcome data at last adaptive analysis: 700/700 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         700       0.9950       0.203
          B    0.20     inferior         700       0.0098       0.150
          C    0.30      control         700           NA       0.647
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         51    205        0.249         0.251        0.0302      0.195
          B         32    160        0.200         0.202        0.0311      0.146
          C        101    335        0.301         0.303        0.0255      0.255
       hi_cri_all
            0.313
            0.266
            0.352
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     51 205    0.249     0.251    0.0304  0.195  0.311
          B     32 160    0.200     0.201    0.0315  0.143  0.267
          C    101 335    0.301     0.303    0.0249  0.254  0.354
      
      Simulation details:
      * Random seed: 12346
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs
      
      [[2]]
      Single simulation result: generic binomially distributed outcome trial
      * Desirable outcome
      * Initial/final common control arms: B/C
      
      Final status: conclusive, stopped for futility
      Final/maximum allowed sample sizes: 300/2000 (15.0%)
      Available outcome data at last adaptive analysis: 300/300 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         300       0.9942       0.333
          B    0.20     inferior         300       0.0006       0.333
          C    0.30      control         300           NA       0.333
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         24     89        0.270         0.273        0.0452      0.189
          B         20    110        0.182         0.186        0.0363      0.121
          C         40    101        0.396         0.397        0.0489      0.304
       hi_cri_all
            0.370
            0.264
            0.493
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     24  89    0.270     0.274    0.0475  0.190  0.370
          B     20 110    0.182     0.186    0.0371  0.120  0.263
          C     40 101    0.396     0.398    0.0468  0.308  0.491
      
      Simulation details:
      * Random seed: 12347
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs
      
      [[3]]
      Single simulation result: generic binomially distributed outcome trial
      * Desirable outcome
      * Initial/final common control arms: B/C
      
      Final status: conclusive, stopped for futility
      Final/maximum allowed sample sizes: 400/2000 (20.0%)
      Available outcome data at last adaptive analysis: 400/400 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         400       0.9978       0.216
          B    0.20     inferior         400       0.0012       0.150
          C    0.30      control         400           NA       0.634
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         32    135        0.237         0.240        0.0375      0.173
          B         19    107        0.178         0.180        0.0365      0.116
          C         53    158        0.335         0.337        0.0373      0.266
       hi_cri_all
            0.318
            0.259
            0.412
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     32 135    0.237     0.240    0.0369  0.175  0.315
          B     19 107    0.178     0.183    0.0367  0.117  0.261
          C     53 158    0.335     0.336    0.0372  0.267  0.413
      
      Simulation details:
      * Random seed: 12348
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs
      
      [[4]]
      Single simulation result: generic binomially distributed outcome trial
      * Desirable outcome
      * Initial/final common control arms: B/C
      
      Final status: conclusive, stopped for futility
      Final/maximum allowed sample sizes: 500/2000 (25.0%)
      Available outcome data at last adaptive analysis: 500/500 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         500       0.9886       0.463
          B    0.20     inferior         300       0.0052       0.333
          C    0.30      control         500           NA       0.537
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         47    189        0.249         0.251        0.0307      0.193
          B         17     91        0.187         0.192        0.0407      0.121
          C         66    220        0.300         0.301        0.0303      0.243
       hi_cri_all
            0.315
            0.278
            0.363
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     47 189    0.249     0.250    0.0311  0.192  0.315
          B     17  91    0.187     0.191    0.0410  0.121  0.280
          C     66 220    0.300     0.301    0.0303  0.243  0.363
      
      Simulation details:
      * Random seed: 12349
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs
      
      [[5]]
      Single simulation result: generic binomially distributed outcome trial
      * Desirable outcome
      * Initial/final common control arms: B/C
      
      Final status: conclusive, stopped for futility
      Final/maximum allowed sample sizes: 400/2000 (20.0%)
      Available outcome data at last adaptive analysis: 400/400 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         400       0.9946       0.276
          B    0.20     inferior         400       0.0058       0.150
          C    0.30      control         400           NA       0.574
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         33    137        0.241         0.244        0.0367      0.176
          B         22    115        0.191         0.195        0.0370      0.130
          C         49    148        0.331         0.333        0.0383      0.260
       hi_cri_all
            0.321
            0.271
            0.412
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     33 137    0.241     0.242    0.0364  0.176  0.318
          B     22 115    0.191     0.196    0.0368  0.129  0.272
          C     49 148    0.331     0.332    0.0381  0.260  0.413
      
      Simulation details:
      * Random seed: 12350
      * Credible interval width: 95%
      * Number of posterior draws: 5000
      * Posterior estimation method: medians with MAD-SDs
      

---

    Code
      dispatch_trial_runs(1:5, setup, base_seed = 12345, sparse = TRUE, cores = 2,
      cl = cl)
    Output
      [[1]]
      Single simulation result [saved/printed with sparse details]
      
      Final status: conclusive, stopped for futility
      Final sample size: 700
      Available outcome data at last adaptive analysis: 700/700 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         700       0.9950       0.203
          B    0.20     inferior         700       0.0098       0.150
          C    0.30      control         700           NA       0.647
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         51    205        0.249         0.251        0.0302      0.195
          B         32    160        0.200         0.202        0.0311      0.146
          C        101    335        0.301         0.303        0.0255      0.255
       hi_cri_all
            0.313
            0.266
            0.352
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     51 205    0.249     0.251    0.0304  0.195  0.311
          B     32 160    0.200     0.201    0.0315  0.143  0.267
          C    101 335    0.301     0.303    0.0249  0.254  0.354
      
      Simulation details:
      * Random seed: 12346
      
      [[2]]
      Single simulation result [saved/printed with sparse details]
      
      Final status: conclusive, stopped for futility
      Final sample size: 300
      Available outcome data at last adaptive analysis: 300/300 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         300       0.9942       0.333
          B    0.20     inferior         300       0.0006       0.333
          C    0.30      control         300           NA       0.333
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         24     89        0.270         0.273        0.0452      0.189
          B         20    110        0.182         0.186        0.0363      0.121
          C         40    101        0.396         0.397        0.0489      0.304
       hi_cri_all
            0.370
            0.264
            0.493
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     24  89    0.270     0.274    0.0475  0.190  0.370
          B     20 110    0.182     0.186    0.0371  0.120  0.263
          C     40 101    0.396     0.398    0.0468  0.308  0.491
      
      Simulation details:
      * Random seed: 12347
      
      [[3]]
      Single simulation result [saved/printed with sparse details]
      
      Final status: conclusive, stopped for futility
      Final sample size: 400
      Available outcome data at last adaptive analysis: 400/400 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         400       0.9978       0.216
          B    0.20     inferior         400       0.0012       0.150
          C    0.30      control         400           NA       0.634
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         32    135        0.237         0.240        0.0375      0.173
          B         19    107        0.178         0.180        0.0365      0.116
          C         53    158        0.335         0.337        0.0373      0.266
       hi_cri_all
            0.318
            0.259
            0.412
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     32 135    0.237     0.240    0.0369  0.175  0.315
          B     19 107    0.178     0.183    0.0367  0.117  0.261
          C     53 158    0.335     0.336    0.0372  0.267  0.413
      
      Simulation details:
      * Random seed: 12348
      
      [[4]]
      Single simulation result [saved/printed with sparse details]
      
      Final status: conclusive, stopped for futility
      Final sample size: 500
      Available outcome data at last adaptive analysis: 500/500 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         500       0.9886       0.463
          B    0.20     inferior         300       0.0052       0.333
          C    0.30      control         500           NA       0.537
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         47    189        0.249         0.251        0.0307      0.193
          B         17     91        0.187         0.192        0.0407      0.121
          C         66    220        0.300         0.301        0.0303      0.243
       hi_cri_all
            0.315
            0.278
            0.363
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     47 189    0.249     0.250    0.0311  0.192  0.315
          B     17  91    0.187     0.191    0.0410  0.121  0.280
          C     66 220    0.300     0.301    0.0303  0.243  0.363
      
      Simulation details:
      * Random seed: 12349
      
      [[5]]
      Single simulation result [saved/printed with sparse details]
      
      Final status: conclusive, stopped for futility
      Final sample size: 400
      Available outcome data at last adaptive analysis: 400/400 (100.0%)
      
      Trial results overview:
       arms true_ys final_status status_look status_probs final_alloc
          A    0.25       futile         400       0.9946       0.276
          B    0.20     inferior         400       0.0058       0.150
          C    0.30      control         400           NA       0.574
      
      Esimates from final analysis (all patients):
       arms sum_ys_all ns_all raw_ests_all post_ests_all post_errs_all lo_cri_all
          A         33    137        0.241         0.244        0.0367      0.176
          B         22    115        0.191         0.195        0.0370      0.130
          C         49    148        0.331         0.333        0.0383      0.260
       hi_cri_all
            0.321
            0.271
            0.412
      
      Estimates from last adaptive analysis including each arm:
       arms sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A     33 137    0.241     0.242    0.0364  0.176  0.318
          B     22 115    0.191     0.196    0.0368  0.129  0.272
          C     49 148    0.331     0.332    0.0381  0.260  0.413
      
      Simulation details:
      * Random seed: 12350
      

# prog_breaks

    Code
      prog_breaks(0.1, n_rep_new = 10, cores = 1)
    Output
      $breaks
      [1]  2  3  4  5  6  7  8  9 10
      
      $start_mess
      [1] "run_trials:  0/10   (0%) [starting]"
      
      $prog_mess
      [1] "run_trials:  2/10  (20%)" "run_trials:  3/10  (30%)"
      [3] "run_trials:  4/10  (40%)" "run_trials:  5/10  (50%)"
      [5] "run_trials:  6/10  (60%)" "run_trials:  7/10  (70%)"
      [7] "run_trials:  8/10  (80%)" "run_trials:  9/10  (90%)"
      [9] "run_trials: 10/10 (100%)"
      
      $batches
      $batches[[1]]
      [1] 1 2
      
      $batches[[2]]
      [1] 3
      
      $batches[[3]]
      [1] 4
      
      $batches[[4]]
      [1] 5
      
      $batches[[5]]
      [1] 6
      
      $batches[[6]]
      [1] 7
      
      $batches[[7]]
      [1] 8
      
      $batches[[8]]
      [1] 9
      
      $batches[[9]]
      [1] 10
      
      

---

    Code
      prog_breaks(0.1, n_rep_new = 10, cores = 2)
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
      
      

