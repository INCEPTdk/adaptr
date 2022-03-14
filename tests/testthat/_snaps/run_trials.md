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
      
      Final trial results:
       arms true_ys sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    0.25     51 205    0.249     0.251    0.0304  0.195  0.311
          B    0.20     32 160    0.200     0.201    0.0315  0.143  0.267
          C    0.30    101 335    0.301     0.303    0.0249  0.254  0.354
       final_status status_look status_probs final_alloc
             futile         700       0.9950       0.203
           inferior         700       0.0098       0.150
            control         700           NA       0.647
      
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
      
      Final trial results:
       arms true_ys sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    0.25     24  89    0.270     0.274    0.0475  0.190  0.370
          B    0.20     20 110    0.182     0.186    0.0371  0.120  0.263
          C    0.30     40 101    0.396     0.398    0.0468  0.308  0.491
       final_status status_look status_probs final_alloc
             futile         300       0.9942       0.333
           inferior         300       0.0006       0.333
            control         300           NA       0.333
      
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
      
      Final trial results:
       arms true_ys sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    0.25     32 135    0.237     0.240    0.0369  0.175  0.315
          B    0.20     19 107    0.178     0.183    0.0367  0.117  0.261
          C    0.30     53 158    0.335     0.336    0.0372  0.267  0.413
       final_status status_look status_probs final_alloc
             futile         400       0.9978       0.216
           inferior         400       0.0012       0.150
            control         400           NA       0.634
      
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
      
      Final trial results:
       arms true_ys sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    0.25     47 189    0.249     0.250    0.0311  0.192  0.315
          B    0.20     17  91    0.187     0.191    0.0410  0.121  0.280
          C    0.30     66 220    0.300     0.301    0.0303  0.243  0.363
       final_status status_look status_probs final_alloc
             futile         500       0.9886       0.463
           inferior         300       0.0052       0.333
            control         500           NA       0.537
      
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
      
      Final trial results:
       arms true_ys sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    0.25     33 137    0.241     0.242    0.0364  0.176  0.318
          B    0.20     22 115    0.191     0.196    0.0368  0.129  0.272
          C    0.30     49 148    0.331     0.332    0.0381  0.260  0.413
       final_status status_look status_probs final_alloc
             futile         400       0.9946       0.276
           inferior         400       0.0058       0.150
            control         400           NA       0.574
      
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
      
      Final trial results:
       arms true_ys sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    0.25     51 205    0.249     0.251    0.0304  0.195  0.311
          B    0.20     32 160    0.200     0.201    0.0315  0.143  0.267
          C    0.30    101 335    0.301     0.303    0.0249  0.254  0.354
       final_status status_look status_probs final_alloc
             futile         700       0.9950       0.203
           inferior         700       0.0098       0.150
            control         700           NA       0.647
      
      Simulation details:
      * Random seed: 12346
      [[2]]
      Single simulation result [saved/printed with sparse details]
      
      Final status: conclusive, stopped for futility
      Final sample size: 300
      
      Final trial results:
       arms true_ys sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    0.25     24  89    0.270     0.274    0.0475  0.190  0.370
          B    0.20     20 110    0.182     0.186    0.0371  0.120  0.263
          C    0.30     40 101    0.396     0.398    0.0468  0.308  0.491
       final_status status_look status_probs final_alloc
             futile         300       0.9942       0.333
           inferior         300       0.0006       0.333
            control         300           NA       0.333
      
      Simulation details:
      * Random seed: 12347
      [[3]]
      Single simulation result [saved/printed with sparse details]
      
      Final status: conclusive, stopped for futility
      Final sample size: 400
      
      Final trial results:
       arms true_ys sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    0.25     32 135    0.237     0.240    0.0369  0.175  0.315
          B    0.20     19 107    0.178     0.183    0.0367  0.117  0.261
          C    0.30     53 158    0.335     0.336    0.0372  0.267  0.413
       final_status status_look status_probs final_alloc
             futile         400       0.9978       0.216
           inferior         400       0.0012       0.150
            control         400           NA       0.634
      
      Simulation details:
      * Random seed: 12348
      [[4]]
      Single simulation result [saved/printed with sparse details]
      
      Final status: conclusive, stopped for futility
      Final sample size: 500
      
      Final trial results:
       arms true_ys sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    0.25     47 189    0.249     0.250    0.0311  0.192  0.315
          B    0.20     17  91    0.187     0.191    0.0410  0.121  0.280
          C    0.30     66 220    0.300     0.301    0.0303  0.243  0.363
       final_status status_look status_probs final_alloc
             futile         500       0.9886       0.463
           inferior         300       0.0052       0.333
            control         500           NA       0.537
      
      Simulation details:
      * Random seed: 12349
      [[5]]
      Single simulation result [saved/printed with sparse details]
      
      Final status: conclusive, stopped for futility
      Final sample size: 400
      
      Final trial results:
       arms true_ys sum_ys  ns raw_ests post_ests post_errs lo_cri hi_cri
          A    0.25     33 137    0.241     0.242    0.0364  0.176  0.318
          B    0.20     22 115    0.191     0.196    0.0368  0.129  0.272
          C    0.30     49 148    0.331     0.332    0.0381  0.260  0.413
       final_status status_look status_probs final_alloc
             futile         400       0.9946       0.276
           inferior         400       0.0058       0.150
            control         400           NA       0.574
      
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
      
      

