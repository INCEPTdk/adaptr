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
      
      

