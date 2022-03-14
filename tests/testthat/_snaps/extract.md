# Tidy results of simulations from binomial-outcome trial with common control works

    Code
      extract_results(res, select_strategy = "control if available")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     700    184 0.2628571     futility         <NA>         <NA>
      2    2     300     84 0.2800000     futility         <NA>         <NA>
      3    3     400    104 0.2600000     futility         <NA>         <NA>
      4    4     500    130 0.2600000     futility         <NA>         <NA>
      5    5     400    104 0.2600000     futility         <NA>         <NA>
      6    6     700    198 0.2828571     futility         <NA>         <NA>
      7    7    1000    248 0.2480000  equivalence         <NA>         <NA>
      8    8     400     97 0.2425000     futility         <NA>         <NA>
      9    9     800    216 0.2700000  superiority            C            C
      10  10    1300    337 0.2592308     futility         <NA>         <NA>
      11  11     600    148 0.2466667     futility         <NA>         <NA>
      12  12     400    107 0.2675000     futility         <NA>         <NA>
      13  13     500    117 0.2340000     futility         <NA>         <NA>
      14  14    1300    349 0.2684615  equivalence         <NA>         <NA>
      15  15     300     77 0.2566667     futility         <NA>         <NA>
      16  16     500    136 0.2720000     futility         <NA>         <NA>
      17  17     400     93 0.2325000     futility         <NA>         <NA>
      18  18    2000    524 0.2620000          max         <NA>            B
      19  19     800    209 0.2612500     futility         <NA>         <NA>
      20  20     300     69 0.2300000     futility         <NA>         <NA>
               sq_err    sq_err_te
      1            NA           NA
      2            NA           NA
      3            NA           NA
      4            NA           NA
      5            NA           NA
      6            NA           NA
      7            NA           NA
      8            NA           NA
      9  0.0003460047 2.371558e-05
      10           NA           NA
      11           NA           NA
      12           NA           NA
      13           NA           NA
      14           NA           NA
      15           NA           NA
      16           NA           NA
      17           NA           NA
      18 0.0007676781           NA
      19           NA           NA
      20           NA           NA

---

    Code
      extract_results(res, select_strategy = "none")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     700    184 0.2628571     futility         <NA>         <NA>
      2    2     300     84 0.2800000     futility         <NA>         <NA>
      3    3     400    104 0.2600000     futility         <NA>         <NA>
      4    4     500    130 0.2600000     futility         <NA>         <NA>
      5    5     400    104 0.2600000     futility         <NA>         <NA>
      6    6     700    198 0.2828571     futility         <NA>         <NA>
      7    7    1000    248 0.2480000  equivalence         <NA>         <NA>
      8    8     400     97 0.2425000     futility         <NA>         <NA>
      9    9     800    216 0.2700000  superiority            C            C
      10  10    1300    337 0.2592308     futility         <NA>         <NA>
      11  11     600    148 0.2466667     futility         <NA>         <NA>
      12  12     400    107 0.2675000     futility         <NA>         <NA>
      13  13     500    117 0.2340000     futility         <NA>         <NA>
      14  14    1300    349 0.2684615  equivalence         <NA>         <NA>
      15  15     300     77 0.2566667     futility         <NA>         <NA>
      16  16     500    136 0.2720000     futility         <NA>         <NA>
      17  17     400     93 0.2325000     futility         <NA>         <NA>
      18  18    2000    524 0.2620000          max         <NA>         <NA>
      19  19     800    209 0.2612500     futility         <NA>         <NA>
      20  20     300     69 0.2300000     futility         <NA>         <NA>
               sq_err    sq_err_te
      1            NA           NA
      2            NA           NA
      3            NA           NA
      4            NA           NA
      5            NA           NA
      6            NA           NA
      7            NA           NA
      8            NA           NA
      9  0.0003460047 2.371558e-05
      10           NA           NA
      11           NA           NA
      12           NA           NA
      13           NA           NA
      14           NA           NA
      15           NA           NA
      16           NA           NA
      17           NA           NA
      18           NA           NA
      19           NA           NA
      20           NA           NA

---

    Code
      extract_results(res, select_strategy = "control")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     700    184 0.2628571     futility         <NA>         <NA>
      2    2     300     84 0.2800000     futility         <NA>         <NA>
      3    3     400    104 0.2600000     futility         <NA>         <NA>
      4    4     500    130 0.2600000     futility         <NA>         <NA>
      5    5     400    104 0.2600000     futility         <NA>         <NA>
      6    6     700    198 0.2828571     futility         <NA>         <NA>
      7    7    1000    248 0.2480000  equivalence         <NA>         <NA>
      8    8     400     97 0.2425000     futility         <NA>         <NA>
      9    9     800    216 0.2700000  superiority            C            C
      10  10    1300    337 0.2592308     futility         <NA>         <NA>
      11  11     600    148 0.2466667     futility         <NA>         <NA>
      12  12     400    107 0.2675000     futility         <NA>         <NA>
      13  13     500    117 0.2340000     futility         <NA>         <NA>
      14  14    1300    349 0.2684615  equivalence         <NA>         <NA>
      15  15     300     77 0.2566667     futility         <NA>         <NA>
      16  16     500    136 0.2720000     futility         <NA>         <NA>
      17  17     400     93 0.2325000     futility         <NA>         <NA>
      18  18    2000    524 0.2620000          max         <NA>            B
      19  19     800    209 0.2612500     futility         <NA>         <NA>
      20  20     300     69 0.2300000     futility         <NA>         <NA>
               sq_err    sq_err_te
      1            NA           NA
      2            NA           NA
      3            NA           NA
      4            NA           NA
      5            NA           NA
      6            NA           NA
      7            NA           NA
      8            NA           NA
      9  0.0003460047 2.371558e-05
      10           NA           NA
      11           NA           NA
      12           NA           NA
      13           NA           NA
      14           NA           NA
      15           NA           NA
      16           NA           NA
      17           NA           NA
      18 0.0007676781           NA
      19           NA           NA
      20           NA           NA

---

    Code
      extract_results(res, select_strategy = "final control")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     700    184 0.2628571     futility         <NA>            C
      2    2     300     84 0.2800000     futility         <NA>            C
      3    3     400    104 0.2600000     futility         <NA>            C
      4    4     500    130 0.2600000     futility         <NA>            C
      5    5     400    104 0.2600000     futility         <NA>            C
      6    6     700    198 0.2828571     futility         <NA>            C
      7    7    1000    248 0.2480000  equivalence         <NA>            C
      8    8     400     97 0.2425000     futility         <NA>            C
      9    9     800    216 0.2700000  superiority            C            C
      10  10    1300    337 0.2592308     futility         <NA>            C
      11  11     600    148 0.2466667     futility         <NA>            C
      12  12     400    107 0.2675000     futility         <NA>            C
      13  13     500    117 0.2340000     futility         <NA>            C
      14  14    1300    349 0.2684615  equivalence         <NA>            C
      15  15     300     77 0.2566667     futility         <NA>            C
      16  16     500    136 0.2720000     futility         <NA>            C
      17  17     400     93 0.2325000     futility         <NA>            C
      18  18    2000    524 0.2620000          max         <NA>            B
      19  19     800    209 0.2612500     futility         <NA>            C
      20  20     300     69 0.2300000     futility         <NA>            C
               sq_err    sq_err_te
      1  7.330292e-06 1.471770e-06
      2  9.656507e-03 1.271588e-02
      3  1.280860e-03 2.837911e-03
      4  2.021069e-06 9.867365e-05
      5  1.040610e-03 1.349391e-03
      6  2.179889e-04 5.563714e-07
      7  1.472684e-03 1.828682e-06
      8  4.948102e-04 4.427692e-03
      9  3.460047e-04 2.371558e-05
      10 3.985100e-06 5.100981e-04
      11 3.920587e-04 2.517456e-04
      12 4.380296e-04 4.533468e-03
      13 6.107714e-04 1.855591e-04
      14 9.375119e-05 1.842998e-04
      15 1.701100e-03 3.641698e-03
      16 1.428275e-03 5.722907e-04
      17 6.210527e-05 7.315873e-03
      18 7.676781e-04           NA
      19 2.063887e-05 6.959340e-05
      20 5.280892e-04 7.664284e-03

---

    Code
      extract_results(res, select_strategy = "control or best")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     700    184 0.2628571     futility         <NA>            C
      2    2     300     84 0.2800000     futility         <NA>            C
      3    3     400    104 0.2600000     futility         <NA>            C
      4    4     500    130 0.2600000     futility         <NA>            C
      5    5     400    104 0.2600000     futility         <NA>            C
      6    6     700    198 0.2828571     futility         <NA>            C
      7    7    1000    248 0.2480000  equivalence         <NA>            C
      8    8     400     97 0.2425000     futility         <NA>            C
      9    9     800    216 0.2700000  superiority            C            C
      10  10    1300    337 0.2592308     futility         <NA>            C
      11  11     600    148 0.2466667     futility         <NA>            C
      12  12     400    107 0.2675000     futility         <NA>            C
      13  13     500    117 0.2340000     futility         <NA>            C
      14  14    1300    349 0.2684615  equivalence         <NA>            C
      15  15     300     77 0.2566667     futility         <NA>            C
      16  16     500    136 0.2720000     futility         <NA>            C
      17  17     400     93 0.2325000     futility         <NA>            C
      18  18    2000    524 0.2620000          max         <NA>            B
      19  19     800    209 0.2612500     futility         <NA>            C
      20  20     300     69 0.2300000     futility         <NA>            C
               sq_err    sq_err_te
      1  7.330292e-06 1.471770e-06
      2  9.656507e-03 1.271588e-02
      3  1.280860e-03 2.837911e-03
      4  2.021069e-06 9.867365e-05
      5  1.040610e-03 1.349391e-03
      6  2.179889e-04 5.563714e-07
      7  1.472684e-03 1.828682e-06
      8  4.948102e-04 4.427692e-03
      9  3.460047e-04 2.371558e-05
      10 3.985100e-06 5.100981e-04
      11 3.920587e-04 2.517456e-04
      12 4.380296e-04 4.533468e-03
      13 6.107714e-04 1.855591e-04
      14 9.375119e-05 1.842998e-04
      15 1.701100e-03 3.641698e-03
      16 1.428275e-03 5.722907e-04
      17 6.210527e-05 7.315873e-03
      18 7.676781e-04           NA
      19 2.063887e-05 6.959340e-05
      20 5.280892e-04 7.664284e-03

---

    Code
      extract_results(res, select_strategy = "best")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     700    184 0.2628571     futility         <NA>            C
      2    2     300     84 0.2800000     futility         <NA>            C
      3    3     400    104 0.2600000     futility         <NA>            C
      4    4     500    130 0.2600000     futility         <NA>            C
      5    5     400    104 0.2600000     futility         <NA>            C
      6    6     700    198 0.2828571     futility         <NA>            C
      7    7    1000    248 0.2480000  equivalence         <NA>            C
      8    8     400     97 0.2425000     futility         <NA>            C
      9    9     800    216 0.2700000  superiority            C            C
      10  10    1300    337 0.2592308     futility         <NA>            C
      11  11     600    148 0.2466667     futility         <NA>            C
      12  12     400    107 0.2675000     futility         <NA>            C
      13  13     500    117 0.2340000     futility         <NA>            C
      14  14    1300    349 0.2684615  equivalence         <NA>            C
      15  15     300     77 0.2566667     futility         <NA>            C
      16  16     500    136 0.2720000     futility         <NA>            C
      17  17     400     93 0.2325000     futility         <NA>            C
      18  18    2000    524 0.2620000          max         <NA>            C
      19  19     800    209 0.2612500     futility         <NA>            C
      20  20     300     69 0.2300000     futility         <NA>            C
               sq_err    sq_err_te
      1  7.330292e-06 1.471770e-06
      2  9.656507e-03 1.271588e-02
      3  1.280860e-03 2.837911e-03
      4  2.021069e-06 9.867365e-05
      5  1.040610e-03 1.349391e-03
      6  2.179889e-04 5.563714e-07
      7  1.472684e-03 1.828682e-06
      8  4.948102e-04 4.427692e-03
      9  3.460047e-04 2.371558e-05
      10 3.985100e-06 5.100981e-04
      11 3.920587e-04 2.517456e-04
      12 4.380296e-04 4.533468e-03
      13 6.107714e-04 1.855591e-04
      14 9.375119e-05 1.842998e-04
      15 1.701100e-03 3.641698e-03
      16 1.428275e-03 5.722907e-04
      17 6.210527e-05 7.315873e-03
      18 1.529679e-04 1.606008e-03
      19 2.063887e-05 6.959340e-05
      20 5.280892e-04 7.664284e-03

---

    Code
      extract_results(res, select_strategy = "list or best", select_preferences = "B")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     700    184 0.2628571     futility         <NA>            C
      2    2     300     84 0.2800000     futility         <NA>            C
      3    3     400    104 0.2600000     futility         <NA>            C
      4    4     500    130 0.2600000     futility         <NA>            C
      5    5     400    104 0.2600000     futility         <NA>            C
      6    6     700    198 0.2828571     futility         <NA>            C
      7    7    1000    248 0.2480000  equivalence         <NA>            C
      8    8     400     97 0.2425000     futility         <NA>            C
      9    9     800    216 0.2700000  superiority            C            C
      10  10    1300    337 0.2592308     futility         <NA>            C
      11  11     600    148 0.2466667     futility         <NA>            C
      12  12     400    107 0.2675000     futility         <NA>            C
      13  13     500    117 0.2340000     futility         <NA>            C
      14  14    1300    349 0.2684615  equivalence         <NA>            C
      15  15     300     77 0.2566667     futility         <NA>            C
      16  16     500    136 0.2720000     futility         <NA>            C
      17  17     400     93 0.2325000     futility         <NA>            C
      18  18    2000    524 0.2620000          max         <NA>            B
      19  19     800    209 0.2612500     futility         <NA>            C
      20  20     300     69 0.2300000     futility         <NA>            C
               sq_err    sq_err_te
      1  7.330292e-06 1.471770e-06
      2  9.656507e-03 1.271588e-02
      3  1.280860e-03 2.837911e-03
      4  2.021069e-06 9.867365e-05
      5  1.040610e-03 1.349391e-03
      6  2.179889e-04 5.563714e-07
      7  1.472684e-03 1.828682e-06
      8  4.948102e-04 4.427692e-03
      9  3.460047e-04 2.371558e-05
      10 3.985100e-06 5.100981e-04
      11 3.920587e-04 2.517456e-04
      12 4.380296e-04 4.533468e-03
      13 6.107714e-04 1.855591e-04
      14 9.375119e-05 1.842998e-04
      15 1.701100e-03 3.641698e-03
      16 1.428275e-03 5.722907e-04
      17 6.210527e-05 7.315873e-03
      18 7.676781e-04           NA
      19 2.063887e-05 6.959340e-05
      20 5.280892e-04 7.664284e-03

---

    Code
      extract_results(res, select_strategy = "list", select_preferences = "B")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     700    184 0.2628571     futility         <NA>         <NA>
      2    2     300     84 0.2800000     futility         <NA>         <NA>
      3    3     400    104 0.2600000     futility         <NA>         <NA>
      4    4     500    130 0.2600000     futility         <NA>         <NA>
      5    5     400    104 0.2600000     futility         <NA>         <NA>
      6    6     700    198 0.2828571     futility         <NA>         <NA>
      7    7    1000    248 0.2480000  equivalence         <NA>         <NA>
      8    8     400     97 0.2425000     futility         <NA>         <NA>
      9    9     800    216 0.2700000  superiority            C            C
      10  10    1300    337 0.2592308     futility         <NA>         <NA>
      11  11     600    148 0.2466667     futility         <NA>         <NA>
      12  12     400    107 0.2675000     futility         <NA>         <NA>
      13  13     500    117 0.2340000     futility         <NA>         <NA>
      14  14    1300    349 0.2684615  equivalence         <NA>         <NA>
      15  15     300     77 0.2566667     futility         <NA>         <NA>
      16  16     500    136 0.2720000     futility         <NA>         <NA>
      17  17     400     93 0.2325000     futility         <NA>         <NA>
      18  18    2000    524 0.2620000          max         <NA>            B
      19  19     800    209 0.2612500     futility         <NA>         <NA>
      20  20     300     69 0.2300000     futility         <NA>         <NA>
               sq_err    sq_err_te
      1            NA           NA
      2            NA           NA
      3            NA           NA
      4            NA           NA
      5            NA           NA
      6            NA           NA
      7            NA           NA
      8            NA           NA
      9  0.0003460047 2.371558e-05
      10           NA           NA
      11           NA           NA
      12           NA           NA
      13           NA           NA
      14           NA           NA
      15           NA           NA
      16           NA           NA
      17           NA           NA
      18 0.0007676781           NA
      19           NA           NA
      20           NA           NA

---

    Code
      extract_results(res, te_comp = "C")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     700    184 0.2628571     futility         <NA>         <NA>
      2    2     300     84 0.2800000     futility         <NA>         <NA>
      3    3     400    104 0.2600000     futility         <NA>         <NA>
      4    4     500    130 0.2600000     futility         <NA>         <NA>
      5    5     400    104 0.2600000     futility         <NA>         <NA>
      6    6     700    198 0.2828571     futility         <NA>         <NA>
      7    7    1000    248 0.2480000  equivalence         <NA>         <NA>
      8    8     400     97 0.2425000     futility         <NA>         <NA>
      9    9     800    216 0.2700000  superiority            C            C
      10  10    1300    337 0.2592308     futility         <NA>         <NA>
      11  11     600    148 0.2466667     futility         <NA>         <NA>
      12  12     400    107 0.2675000     futility         <NA>         <NA>
      13  13     500    117 0.2340000     futility         <NA>         <NA>
      14  14    1300    349 0.2684615  equivalence         <NA>         <NA>
      15  15     300     77 0.2566667     futility         <NA>         <NA>
      16  16     500    136 0.2720000     futility         <NA>         <NA>
      17  17     400     93 0.2325000     futility         <NA>         <NA>
      18  18    2000    524 0.2620000          max         <NA>            B
      19  19     800    209 0.2612500     futility         <NA>         <NA>
      20  20     300     69 0.2300000     futility         <NA>         <NA>
               sq_err   sq_err_te
      1            NA          NA
      2            NA          NA
      3            NA          NA
      4            NA          NA
      5            NA          NA
      6            NA          NA
      7            NA          NA
      8            NA          NA
      9  0.0003460047          NA
      10           NA          NA
      11           NA          NA
      12           NA          NA
      13           NA          NA
      14           NA          NA
      15           NA          NA
      16           NA          NA
      17           NA          NA
      18 0.0007676781 0.001606008
      19           NA          NA
      20           NA          NA

---

    Code
      extract_results(res, raw_ests = TRUE)
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     700    184 0.2628571     futility         <NA>         <NA>
      2    2     300     84 0.2800000     futility         <NA>         <NA>
      3    3     400    104 0.2600000     futility         <NA>         <NA>
      4    4     500    130 0.2600000     futility         <NA>         <NA>
      5    5     400    104 0.2600000     futility         <NA>         <NA>
      6    6     700    198 0.2828571     futility         <NA>         <NA>
      7    7    1000    248 0.2480000  equivalence         <NA>         <NA>
      8    8     400     97 0.2425000     futility         <NA>         <NA>
      9    9     800    216 0.2700000  superiority            C            C
      10  10    1300    337 0.2592308     futility         <NA>         <NA>
      11  11     600    148 0.2466667     futility         <NA>         <NA>
      12  12     400    107 0.2675000     futility         <NA>         <NA>
      13  13     500    117 0.2340000     futility         <NA>         <NA>
      14  14    1300    349 0.2684615  equivalence         <NA>         <NA>
      15  15     300     77 0.2566667     futility         <NA>         <NA>
      16  16     500    136 0.2720000     futility         <NA>         <NA>
      17  17     400     93 0.2325000     futility         <NA>         <NA>
      18  18    2000    524 0.2620000          max         <NA>            B
      19  19     800    209 0.2612500     futility         <NA>         <NA>
      20  20     300     69 0.2300000     futility         <NA>         <NA>
               sq_err    sq_err_te
      1            NA           NA
      2            NA           NA
      3            NA           NA
      4            NA           NA
      5            NA           NA
      6            NA           NA
      7            NA           NA
      8            NA           NA
      9  0.0003144944 1.169542e-05
      10           NA           NA
      11           NA           NA
      12           NA           NA
      13           NA           NA
      14           NA           NA
      15           NA           NA
      16           NA           NA
      17           NA           NA
      18 0.0007438017           NA
      19           NA           NA
      20           NA           NA

# Tidy results of simulations from binomial-outcome trial without common control works

    Code
      extract_results(res, select_strategy = "control if available")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1    1300    329 0.2530769  equivalence         <NA>         <NA>
      2    2    1300    306 0.2353846  superiority            B            B
      3    3    1300    261 0.2007692  superiority            B            B
      4    4    1800    414 0.2300000  equivalence         <NA>         <NA>
      5    5    1000    221 0.2210000  superiority            B            B
      6    6    2000    448 0.2240000          max         <NA>         <NA>
      7    7     800    169 0.2112500  superiority            B            B
      8    8    2000    426 0.2130000          max         <NA>         <NA>
      9    9    1100    259 0.2354545  equivalence         <NA>         <NA>
      10  10    2000    468 0.2340000          max         <NA>         <NA>
      11  11     500    123 0.2460000  superiority            B            B
      12  12     600    127 0.2116667  superiority            B            B
      13  13     500    112 0.2240000  superiority            B            B
      14  14    2000    470 0.2350000          max         <NA>         <NA>
      15  15    1000    201 0.2010000  superiority            B            B
      16  16    1300    298 0.2292308  superiority            B            B
      17  17     700    145 0.2071429  superiority            B            B
      18  18    1300    273 0.2100000  superiority            B            B
      19  19     600    139 0.2316667  superiority            B            B
      20  20     500    105 0.2100000  superiority            B            B
               sq_err sq_err_te
      1            NA        NA
      2  3.596022e-05        NA
      3  6.573150e-04        NA
      4            NA        NA
      5  1.765044e-04        NA
      6            NA        NA
      7  7.646365e-04        NA
      8            NA        NA
      9            NA        NA
      10           NA        NA
      11 1.495443e-05        NA
      12 1.262834e-03        NA
      13 9.001071e-04        NA
      14           NA        NA
      15 1.340530e-03        NA
      16 1.802045e-06        NA
      17 6.622977e-04        NA
      18 5.508946e-04        NA
      19 8.399707e-04        NA
      20 2.576842e-03        NA

---

    Code
      extract_results(res, select_strategy = "none")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1    1300    329 0.2530769  equivalence         <NA>         <NA>
      2    2    1300    306 0.2353846  superiority            B            B
      3    3    1300    261 0.2007692  superiority            B            B
      4    4    1800    414 0.2300000  equivalence         <NA>         <NA>
      5    5    1000    221 0.2210000  superiority            B            B
      6    6    2000    448 0.2240000          max         <NA>         <NA>
      7    7     800    169 0.2112500  superiority            B            B
      8    8    2000    426 0.2130000          max         <NA>         <NA>
      9    9    1100    259 0.2354545  equivalence         <NA>         <NA>
      10  10    2000    468 0.2340000          max         <NA>         <NA>
      11  11     500    123 0.2460000  superiority            B            B
      12  12     600    127 0.2116667  superiority            B            B
      13  13     500    112 0.2240000  superiority            B            B
      14  14    2000    470 0.2350000          max         <NA>         <NA>
      15  15    1000    201 0.2010000  superiority            B            B
      16  16    1300    298 0.2292308  superiority            B            B
      17  17     700    145 0.2071429  superiority            B            B
      18  18    1300    273 0.2100000  superiority            B            B
      19  19     600    139 0.2316667  superiority            B            B
      20  20     500    105 0.2100000  superiority            B            B
               sq_err sq_err_te
      1            NA        NA
      2  3.596022e-05        NA
      3  6.573150e-04        NA
      4            NA        NA
      5  1.765044e-04        NA
      6            NA        NA
      7  7.646365e-04        NA
      8            NA        NA
      9            NA        NA
      10           NA        NA
      11 1.495443e-05        NA
      12 1.262834e-03        NA
      13 9.001071e-04        NA
      14           NA        NA
      15 1.340530e-03        NA
      16 1.802045e-06        NA
      17 6.622977e-04        NA
      18 5.508946e-04        NA
      19 8.399707e-04        NA
      20 2.576842e-03        NA

---

    Code
      extract_results(res, select_strategy = "best")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1    1300    329 0.2530769  equivalence         <NA>            A
      2    2    1300    306 0.2353846  superiority            B            B
      3    3    1300    261 0.2007692  superiority            B            B
      4    4    1800    414 0.2300000  equivalence         <NA>            B
      5    5    1000    221 0.2210000  superiority            B            B
      6    6    2000    448 0.2240000          max         <NA>            B
      7    7     800    169 0.2112500  superiority            B            B
      8    8    2000    426 0.2130000          max         <NA>            B
      9    9    1100    259 0.2354545  equivalence         <NA>            B
      10  10    2000    468 0.2340000          max         <NA>            B
      11  11     500    123 0.2460000  superiority            B            B
      12  12     600    127 0.2116667  superiority            B            B
      13  13     500    112 0.2240000  superiority            B            B
      14  14    2000    470 0.2350000          max         <NA>            B
      15  15    1000    201 0.2010000  superiority            B            B
      16  16    1300    298 0.2292308  superiority            B            B
      17  17     700    145 0.2071429  superiority            B            B
      18  18    1300    273 0.2100000  superiority            B            B
      19  19     600    139 0.2316667  superiority            B            B
      20  20     500    105 0.2100000  superiority            B            B
               sq_err sq_err_te
      1  2.927854e-05        NA
      2  3.596022e-05        NA
      3  6.573150e-04        NA
      4  3.133885e-04        NA
      5  1.765044e-04        NA
      6  2.797419e-05        NA
      7  7.646365e-04        NA
      8  2.149695e-05        NA
      9  3.340441e-04        NA
      10 1.295516e-04        NA
      11 1.495443e-05        NA
      12 1.262834e-03        NA
      13 9.001071e-04        NA
      14 1.308318e-04        NA
      15 1.340530e-03        NA
      16 1.802045e-06        NA
      17 6.622977e-04        NA
      18 5.508946e-04        NA
      19 8.399707e-04        NA
      20 2.576842e-03        NA

---

    Code
      extract_results(res, select_strategy = "list or best", select_preferences = "B")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1    1300    329 0.2530769  equivalence         <NA>            B
      2    2    1300    306 0.2353846  superiority            B            B
      3    3    1300    261 0.2007692  superiority            B            B
      4    4    1800    414 0.2300000  equivalence         <NA>            B
      5    5    1000    221 0.2210000  superiority            B            B
      6    6    2000    448 0.2240000          max         <NA>            B
      7    7     800    169 0.2112500  superiority            B            B
      8    8    2000    426 0.2130000          max         <NA>            B
      9    9    1100    259 0.2354545  equivalence         <NA>            B
      10  10    2000    468 0.2340000          max         <NA>            B
      11  11     500    123 0.2460000  superiority            B            B
      12  12     600    127 0.2116667  superiority            B            B
      13  13     500    112 0.2240000  superiority            B            B
      14  14    2000    470 0.2350000          max         <NA>            B
      15  15    1000    201 0.2010000  superiority            B            B
      16  16    1300    298 0.2292308  superiority            B            B
      17  17     700    145 0.2071429  superiority            B            B
      18  18    1300    273 0.2100000  superiority            B            B
      19  19     600    139 0.2316667  superiority            B            B
      20  20     500    105 0.2100000  superiority            B            B
               sq_err sq_err_te
      1  3.164873e-03        NA
      2  3.596022e-05        NA
      3  6.573150e-04        NA
      4  3.133885e-04        NA
      5  1.765044e-04        NA
      6  2.797419e-05        NA
      7  7.646365e-04        NA
      8  2.149695e-05        NA
      9  3.340441e-04        NA
      10 1.295516e-04        NA
      11 1.495443e-05        NA
      12 1.262834e-03        NA
      13 9.001071e-04        NA
      14 1.308318e-04        NA
      15 1.340530e-03        NA
      16 1.802045e-06        NA
      17 6.622977e-04        NA
      18 5.508946e-04        NA
      19 8.399707e-04        NA
      20 2.576842e-03        NA

---

    Code
      extract_results(res, select_strategy = "list", select_preferences = "B")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1    1300    329 0.2530769  equivalence         <NA>            B
      2    2    1300    306 0.2353846  superiority            B            B
      3    3    1300    261 0.2007692  superiority            B            B
      4    4    1800    414 0.2300000  equivalence         <NA>            B
      5    5    1000    221 0.2210000  superiority            B            B
      6    6    2000    448 0.2240000          max         <NA>            B
      7    7     800    169 0.2112500  superiority            B            B
      8    8    2000    426 0.2130000          max         <NA>            B
      9    9    1100    259 0.2354545  equivalence         <NA>            B
      10  10    2000    468 0.2340000          max         <NA>            B
      11  11     500    123 0.2460000  superiority            B            B
      12  12     600    127 0.2116667  superiority            B            B
      13  13     500    112 0.2240000  superiority            B            B
      14  14    2000    470 0.2350000          max         <NA>            B
      15  15    1000    201 0.2010000  superiority            B            B
      16  16    1300    298 0.2292308  superiority            B            B
      17  17     700    145 0.2071429  superiority            B            B
      18  18    1300    273 0.2100000  superiority            B            B
      19  19     600    139 0.2316667  superiority            B            B
      20  20     500    105 0.2100000  superiority            B            B
               sq_err sq_err_te
      1  3.164873e-03        NA
      2  3.596022e-05        NA
      3  6.573150e-04        NA
      4  3.133885e-04        NA
      5  1.765044e-04        NA
      6  2.797419e-05        NA
      7  7.646365e-04        NA
      8  2.149695e-05        NA
      9  3.340441e-04        NA
      10 1.295516e-04        NA
      11 1.495443e-05        NA
      12 1.262834e-03        NA
      13 9.001071e-04        NA
      14 1.308318e-04        NA
      15 1.340530e-03        NA
      16 1.802045e-06        NA
      17 6.622977e-04        NA
      18 5.508946e-04        NA
      19 8.399707e-04        NA
      20 2.576842e-03        NA

---

    Code
      extract_results(res, te_comp = "C")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1    1300    329 0.2530769  equivalence         <NA>         <NA>
      2    2    1300    306 0.2353846  superiority            B            B
      3    3    1300    261 0.2007692  superiority            B            B
      4    4    1800    414 0.2300000  equivalence         <NA>         <NA>
      5    5    1000    221 0.2210000  superiority            B            B
      6    6    2000    448 0.2240000          max         <NA>         <NA>
      7    7     800    169 0.2112500  superiority            B            B
      8    8    2000    426 0.2130000          max         <NA>         <NA>
      9    9    1100    259 0.2354545  equivalence         <NA>         <NA>
      10  10    2000    468 0.2340000          max         <NA>         <NA>
      11  11     500    123 0.2460000  superiority            B            B
      12  12     600    127 0.2116667  superiority            B            B
      13  13     500    112 0.2240000  superiority            B            B
      14  14    2000    470 0.2350000          max         <NA>         <NA>
      15  15    1000    201 0.2010000  superiority            B            B
      16  16    1300    298 0.2292308  superiority            B            B
      17  17     700    145 0.2071429  superiority            B            B
      18  18    1300    273 0.2100000  superiority            B            B
      19  19     600    139 0.2316667  superiority            B            B
      20  20     500    105 0.2100000  superiority            B            B
               sq_err    sq_err_te
      1            NA           NA
      2  3.596022e-05 8.493827e-03
      3  6.573150e-04 5.562313e-03
      4            NA           NA
      5  1.765044e-04 6.384572e-05
      6            NA           NA
      7  7.646365e-04 1.840682e-03
      8            NA           NA
      9            NA           NA
      10           NA           NA
      11 1.495443e-05 7.208610e-05
      12 1.262834e-03 1.655695e-03
      13 9.001071e-04 7.083643e-05
      14           NA           NA
      15 1.340530e-03 6.089902e-03
      16 1.802045e-06 5.312707e-03
      17 6.622977e-04 1.792421e-04
      18 5.508946e-04 2.962571e-04
      19 8.399707e-04 2.865260e-03
      20 2.576842e-03 5.250350e-03

---

    Code
      extract_results(res, raw_ests = TRUE)
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1    1300    329 0.2530769  equivalence         <NA>         <NA>
      2    2    1300    306 0.2353846  superiority            B            B
      3    3    1300    261 0.2007692  superiority            B            B
      4    4    1800    414 0.2300000  equivalence         <NA>         <NA>
      5    5    1000    221 0.2210000  superiority            B            B
      6    6    2000    448 0.2240000          max         <NA>         <NA>
      7    7     800    169 0.2112500  superiority            B            B
      8    8    2000    426 0.2130000          max         <NA>         <NA>
      9    9    1100    259 0.2354545  equivalence         <NA>         <NA>
      10  10    2000    468 0.2340000          max         <NA>         <NA>
      11  11     500    123 0.2460000  superiority            B            B
      12  12     600    127 0.2116667  superiority            B            B
      13  13     500    112 0.2240000  superiority            B            B
      14  14    2000    470 0.2350000          max         <NA>         <NA>
      15  15    1000    201 0.2010000  superiority            B            B
      16  16    1300    298 0.2292308  superiority            B            B
      17  17     700    145 0.2071429  superiority            B            B
      18  18    1300    273 0.2100000  superiority            B            B
      19  19     600    139 0.2316667  superiority            B            B
      20  20     500    105 0.2100000  superiority            B            B
               sq_err sq_err_te
      1            NA        NA
      2  3.349841e-05        NA
      3  7.008653e-04        NA
      4            NA        NA
      5  1.969837e-04        NA
      6            NA        NA
      7  7.803767e-04        NA
      8            NA        NA
      9            NA        NA
      10           NA        NA
      11 2.197266e-05        NA
      12 1.379592e-03        NA
      13 1.021903e-03        NA
      14           NA        NA
      15 1.381687e-03        NA
      16 4.658144e-06        NA
      17 7.248521e-04        NA
      18 5.573106e-04        NA
      19 9.271920e-04        NA
      20 2.745605e-03        NA

# Metric history of specific trial works

    Code
      extract_history(res)
    Output
         look look_ns arm old_alloc  ns sum_ys     value
      A     1     300   A 0.3333333 122     30 0.3333333
      B     1     300   B 0.3333333  91     21 0.3333333
      C     1     300   C 0.3333333  87     20 0.3333333
      A1    2     400   A 0.3762498 158     34 0.3762498
      B1    2     400   B 0.3113363 124     28 0.3113363
      C1    2     400   C 0.3124139 118     30 0.3124139
      A2    3     500   A 0.2283302 184     38 0.2283302
      B2    3     500   B 0.3000846 158     33 0.3000846
      C2    3     500   C 0.4715852 158     40 0.4715852
      A3    4     600   A 0.2171704 210     40 0.2171704
      B3    4     600   B 0.2395724 180     34 0.2395724
      C3    4     600   C 0.5432572 210     56 0.5432572
      A4    5     700   A 0.1500000 225     43 0.1500000
      B4    5     700   B 0.1500000 194     37 0.1500000
      C4    5     700   C 0.7000000 281     75 0.7000000
      A5    6     800   A 0.1500000 234     43 0.1500000
      B5    6     800   B 0.1500000 210     39 0.1500000
      C5    6     800   C 0.7000000 356     97 0.7000000
      A6    7     900   A 0.1500000 244     48 0.1500000
      B6    7     900   B 0.1500000 223     41 0.1500000
      C6    7     900   C 0.7000000 433    126 0.7000000

