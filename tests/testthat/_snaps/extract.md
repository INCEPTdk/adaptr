# Tidy results of simulations from binomial-outcome trial with common control works

    Code
      extract_results(res, select_strategy = "control if available")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    114 0.2280000     futility         <NA>         <NA>
      2    2     500    136 0.2720000  superiority            C            C
      3    3     700    168 0.2400000     futility         <NA>         <NA>
      4    4     900    235 0.2611111     futility         <NA>         <NA>
      5    5    1200    341 0.2841667  superiority            C            C
      6    6     900    225 0.2500000     futility         <NA>         <NA>
      7    7     300     71 0.2366667     futility         <NA>         <NA>
      8    8    1400    356 0.2542857     futility         <NA>         <NA>
      9    9    1100    277 0.2518182     futility         <NA>         <NA>
      10  10     700    165 0.2357143  superiority            C            C
      11  11    1100    270 0.2454545     futility         <NA>         <NA>
      12  12    1900    523 0.2752632  superiority            C            C
      13  13     400    113 0.2825000     futility         <NA>         <NA>
      14  14     300     69 0.2300000     futility         <NA>         <NA>
      15  15     900    206 0.2288889  superiority            C            C
      16  16     400    118 0.2950000     futility         <NA>         <NA>
      17  17     500    119 0.2380000     futility         <NA>         <NA>
      18  18     700    199 0.2842857     futility         <NA>         <NA>
      19  19    1300    345 0.2653846     futility         <NA>         <NA>
      20  20     300     86 0.2866667     futility         <NA>         <NA>
                   err       sq_err      err_te    sq_err_te
      1             NA           NA          NA           NA
      2   0.0403056552 1.624546e-03  0.01870902 3.500275e-04
      3             NA           NA          NA           NA
      4             NA           NA          NA           NA
      5   0.0112871320 1.273993e-04 -0.02971112 8.827508e-04
      6             NA           NA          NA           NA
      7             NA           NA          NA           NA
      8             NA           NA          NA           NA
      9             NA           NA          NA           NA
      10 -0.0186526388 3.479209e-04 -0.00666836 4.446702e-05
      11            NA           NA          NA           NA
      12  0.0003741639 1.399986e-07  0.02338760 5.469797e-04
      13            NA           NA          NA           NA
      14            NA           NA          NA           NA
      15 -0.0365313171 1.334537e-03 -0.02900154 8.410892e-04
      16            NA           NA          NA           NA
      17            NA           NA          NA           NA
      18            NA           NA          NA           NA
      19            NA           NA          NA           NA
      20            NA           NA          NA           NA

---

    Code
      extract_results(res, select_strategy = "none")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    114 0.2280000     futility         <NA>         <NA>
      2    2     500    136 0.2720000  superiority            C            C
      3    3     700    168 0.2400000     futility         <NA>         <NA>
      4    4     900    235 0.2611111     futility         <NA>         <NA>
      5    5    1200    341 0.2841667  superiority            C            C
      6    6     900    225 0.2500000     futility         <NA>         <NA>
      7    7     300     71 0.2366667     futility         <NA>         <NA>
      8    8    1400    356 0.2542857     futility         <NA>         <NA>
      9    9    1100    277 0.2518182     futility         <NA>         <NA>
      10  10     700    165 0.2357143  superiority            C            C
      11  11    1100    270 0.2454545     futility         <NA>         <NA>
      12  12    1900    523 0.2752632  superiority            C            C
      13  13     400    113 0.2825000     futility         <NA>         <NA>
      14  14     300     69 0.2300000     futility         <NA>         <NA>
      15  15     900    206 0.2288889  superiority            C            C
      16  16     400    118 0.2950000     futility         <NA>         <NA>
      17  17     500    119 0.2380000     futility         <NA>         <NA>
      18  18     700    199 0.2842857     futility         <NA>         <NA>
      19  19    1300    345 0.2653846     futility         <NA>         <NA>
      20  20     300     86 0.2866667     futility         <NA>         <NA>
                   err       sq_err      err_te    sq_err_te
      1             NA           NA          NA           NA
      2   0.0403056552 1.624546e-03  0.01870902 3.500275e-04
      3             NA           NA          NA           NA
      4             NA           NA          NA           NA
      5   0.0112871320 1.273993e-04 -0.02971112 8.827508e-04
      6             NA           NA          NA           NA
      7             NA           NA          NA           NA
      8             NA           NA          NA           NA
      9             NA           NA          NA           NA
      10 -0.0186526388 3.479209e-04 -0.00666836 4.446702e-05
      11            NA           NA          NA           NA
      12  0.0003741639 1.399986e-07  0.02338760 5.469797e-04
      13            NA           NA          NA           NA
      14            NA           NA          NA           NA
      15 -0.0365313171 1.334537e-03 -0.02900154 8.410892e-04
      16            NA           NA          NA           NA
      17            NA           NA          NA           NA
      18            NA           NA          NA           NA
      19            NA           NA          NA           NA
      20            NA           NA          NA           NA

---

    Code
      extract_results(res, select_strategy = "control")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    114 0.2280000     futility         <NA>         <NA>
      2    2     500    136 0.2720000  superiority            C            C
      3    3     700    168 0.2400000     futility         <NA>         <NA>
      4    4     900    235 0.2611111     futility         <NA>         <NA>
      5    5    1200    341 0.2841667  superiority            C            C
      6    6     900    225 0.2500000     futility         <NA>         <NA>
      7    7     300     71 0.2366667     futility         <NA>         <NA>
      8    8    1400    356 0.2542857     futility         <NA>         <NA>
      9    9    1100    277 0.2518182     futility         <NA>         <NA>
      10  10     700    165 0.2357143  superiority            C            C
      11  11    1100    270 0.2454545     futility         <NA>         <NA>
      12  12    1900    523 0.2752632  superiority            C            C
      13  13     400    113 0.2825000     futility         <NA>         <NA>
      14  14     300     69 0.2300000     futility         <NA>         <NA>
      15  15     900    206 0.2288889  superiority            C            C
      16  16     400    118 0.2950000     futility         <NA>         <NA>
      17  17     500    119 0.2380000     futility         <NA>         <NA>
      18  18     700    199 0.2842857     futility         <NA>         <NA>
      19  19    1300    345 0.2653846     futility         <NA>         <NA>
      20  20     300     86 0.2866667     futility         <NA>         <NA>
                   err       sq_err      err_te    sq_err_te
      1             NA           NA          NA           NA
      2   0.0403056552 1.624546e-03  0.01870902 3.500275e-04
      3             NA           NA          NA           NA
      4             NA           NA          NA           NA
      5   0.0112871320 1.273993e-04 -0.02971112 8.827508e-04
      6             NA           NA          NA           NA
      7             NA           NA          NA           NA
      8             NA           NA          NA           NA
      9             NA           NA          NA           NA
      10 -0.0186526388 3.479209e-04 -0.00666836 4.446702e-05
      11            NA           NA          NA           NA
      12  0.0003741639 1.399986e-07  0.02338760 5.469797e-04
      13            NA           NA          NA           NA
      14            NA           NA          NA           NA
      15 -0.0365313171 1.334537e-03 -0.02900154 8.410892e-04
      16            NA           NA          NA           NA
      17            NA           NA          NA           NA
      18            NA           NA          NA           NA
      19            NA           NA          NA           NA
      20            NA           NA          NA           NA

---

    Code
      extract_results(res, select_strategy = "final control")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    114 0.2280000     futility         <NA>            C
      2    2     500    136 0.2720000  superiority            C            C
      3    3     700    168 0.2400000     futility         <NA>            C
      4    4     900    235 0.2611111     futility         <NA>            C
      5    5    1200    341 0.2841667  superiority            C            C
      6    6     900    225 0.2500000     futility         <NA>            C
      7    7     300     71 0.2366667     futility         <NA>            C
      8    8    1400    356 0.2542857     futility         <NA>            C
      9    9    1100    277 0.2518182     futility         <NA>            A
      10  10     700    165 0.2357143  superiority            C            C
      11  11    1100    270 0.2454545     futility         <NA>            A
      12  12    1900    523 0.2752632  superiority            C            C
      13  13     400    113 0.2825000     futility         <NA>            C
      14  14     300     69 0.2300000     futility         <NA>            C
      15  15     900    206 0.2288889  superiority            C            C
      16  16     400    118 0.2950000     futility         <NA>            C
      17  17     500    119 0.2380000     futility         <NA>            C
      18  18     700    199 0.2842857     futility         <NA>            C
      19  19    1300    345 0.2653846     futility         <NA>            C
      20  20     300     86 0.2866667     futility         <NA>            C
                   err       sq_err       err_te    sq_err_te
      1  -0.0320615980 1.027946e-03  0.018209246 3.315766e-04
      2   0.0403056552 1.624546e-03  0.018709023 3.500275e-04
      3  -0.0212254131 4.505182e-04 -0.002104886 4.430545e-06
      4  -0.0070080201 4.911235e-05 -0.007796942 6.079230e-05
      5   0.0112871320 1.273993e-04 -0.029711123 8.827508e-04
      6  -0.0163034180 2.658014e-04 -0.004564815 2.083754e-05
      7   0.0418074601 1.747864e-03  0.062301746 3.881508e-03
      8  -0.0211408830 4.469369e-04 -0.028364667 8.045543e-04
      9   0.0241545653 5.834430e-04  0.039945617 1.595652e-03
      10 -0.0186526388 3.479209e-04 -0.006668360 4.446702e-05
      11  0.0236137388 5.576087e-04  0.031337078 9.820124e-04
      12  0.0003741639 1.399986e-07  0.023387597 5.469797e-04
      13  0.0683181104 4.667364e-03  0.039680849 1.574570e-03
      14  0.0654952119 4.289623e-03  0.131084491 1.718314e-02
      15 -0.0365313171 1.334537e-03 -0.029001538 8.410892e-04
      16  0.0552824892 3.056154e-03  0.041808151 1.747921e-03
      17  0.0104174470 1.085232e-04  0.040491379 1.639552e-03
      18  0.0317224271 1.006312e-03 -0.004951673 2.451906e-05
      19 -0.0047998954 2.303900e-05 -0.018678309 3.488792e-04
      20  0.0757048898 5.731230e-03  0.071794904 5.154508e-03

---

    Code
      extract_results(res, select_strategy = "control or best")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    114 0.2280000     futility         <NA>            C
      2    2     500    136 0.2720000  superiority            C            C
      3    3     700    168 0.2400000     futility         <NA>            C
      4    4     900    235 0.2611111     futility         <NA>            C
      5    5    1200    341 0.2841667  superiority            C            C
      6    6     900    225 0.2500000     futility         <NA>            C
      7    7     300     71 0.2366667     futility         <NA>            C
      8    8    1400    356 0.2542857     futility         <NA>            C
      9    9    1100    277 0.2518182     futility         <NA>            A
      10  10     700    165 0.2357143  superiority            C            C
      11  11    1100    270 0.2454545     futility         <NA>            A
      12  12    1900    523 0.2752632  superiority            C            C
      13  13     400    113 0.2825000     futility         <NA>            C
      14  14     300     69 0.2300000     futility         <NA>            C
      15  15     900    206 0.2288889  superiority            C            C
      16  16     400    118 0.2950000     futility         <NA>            C
      17  17     500    119 0.2380000     futility         <NA>            C
      18  18     700    199 0.2842857     futility         <NA>            C
      19  19    1300    345 0.2653846     futility         <NA>            C
      20  20     300     86 0.2866667     futility         <NA>            C
                   err       sq_err       err_te    sq_err_te
      1  -0.0320615980 1.027946e-03  0.018209246 3.315766e-04
      2   0.0403056552 1.624546e-03  0.018709023 3.500275e-04
      3  -0.0212254131 4.505182e-04 -0.002104886 4.430545e-06
      4  -0.0070080201 4.911235e-05 -0.007796942 6.079230e-05
      5   0.0112871320 1.273993e-04 -0.029711123 8.827508e-04
      6  -0.0163034180 2.658014e-04 -0.004564815 2.083754e-05
      7   0.0418074601 1.747864e-03  0.062301746 3.881508e-03
      8  -0.0211408830 4.469369e-04 -0.028364667 8.045543e-04
      9   0.0241545653 5.834430e-04  0.039945617 1.595652e-03
      10 -0.0186526388 3.479209e-04 -0.006668360 4.446702e-05
      11  0.0236137388 5.576087e-04  0.031337078 9.820124e-04
      12  0.0003741639 1.399986e-07  0.023387597 5.469797e-04
      13  0.0683181104 4.667364e-03  0.039680849 1.574570e-03
      14  0.0654952119 4.289623e-03  0.131084491 1.718314e-02
      15 -0.0365313171 1.334537e-03 -0.029001538 8.410892e-04
      16  0.0552824892 3.056154e-03  0.041808151 1.747921e-03
      17  0.0104174470 1.085232e-04  0.040491379 1.639552e-03
      18  0.0317224271 1.006312e-03 -0.004951673 2.451906e-05
      19 -0.0047998954 2.303900e-05 -0.018678309 3.488792e-04
      20  0.0757048898 5.731230e-03  0.071794904 5.154508e-03

---

    Code
      extract_results(res, select_strategy = "best")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    114 0.2280000     futility         <NA>            C
      2    2     500    136 0.2720000  superiority            C            C
      3    3     700    168 0.2400000     futility         <NA>            C
      4    4     900    235 0.2611111     futility         <NA>            C
      5    5    1200    341 0.2841667  superiority            C            C
      6    6     900    225 0.2500000     futility         <NA>            C
      7    7     300     71 0.2366667     futility         <NA>            C
      8    8    1400    356 0.2542857     futility         <NA>            C
      9    9    1100    277 0.2518182     futility         <NA>            A
      10  10     700    165 0.2357143  superiority            C            C
      11  11    1100    270 0.2454545     futility         <NA>            A
      12  12    1900    523 0.2752632  superiority            C            C
      13  13     400    113 0.2825000     futility         <NA>            C
      14  14     300     69 0.2300000     futility         <NA>            C
      15  15     900    206 0.2288889  superiority            C            C
      16  16     400    118 0.2950000     futility         <NA>            C
      17  17     500    119 0.2380000     futility         <NA>            C
      18  18     700    199 0.2842857     futility         <NA>            C
      19  19    1300    345 0.2653846     futility         <NA>            C
      20  20     300     86 0.2866667     futility         <NA>            C
                   err       sq_err       err_te    sq_err_te
      1  -0.0320615980 1.027946e-03  0.018209246 3.315766e-04
      2   0.0403056552 1.624546e-03  0.018709023 3.500275e-04
      3  -0.0212254131 4.505182e-04 -0.002104886 4.430545e-06
      4  -0.0070080201 4.911235e-05 -0.007796942 6.079230e-05
      5   0.0112871320 1.273993e-04 -0.029711123 8.827508e-04
      6  -0.0163034180 2.658014e-04 -0.004564815 2.083754e-05
      7   0.0418074601 1.747864e-03  0.062301746 3.881508e-03
      8  -0.0211408830 4.469369e-04 -0.028364667 8.045543e-04
      9   0.0241545653 5.834430e-04  0.039945617 1.595652e-03
      10 -0.0186526388 3.479209e-04 -0.006668360 4.446702e-05
      11  0.0236137388 5.576087e-04  0.031337078 9.820124e-04
      12  0.0003741639 1.399986e-07  0.023387597 5.469797e-04
      13  0.0683181104 4.667364e-03  0.039680849 1.574570e-03
      14  0.0654952119 4.289623e-03  0.131084491 1.718314e-02
      15 -0.0365313171 1.334537e-03 -0.029001538 8.410892e-04
      16  0.0552824892 3.056154e-03  0.041808151 1.747921e-03
      17  0.0104174470 1.085232e-04  0.040491379 1.639552e-03
      18  0.0317224271 1.006312e-03 -0.004951673 2.451906e-05
      19 -0.0047998954 2.303900e-05 -0.018678309 3.488792e-04
      20  0.0757048898 5.731230e-03  0.071794904 5.154508e-03

---

    Code
      extract_results(res, select_strategy = "list or best", select_preferences = "B")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    114 0.2280000     futility         <NA>            C
      2    2     500    136 0.2720000  superiority            C            C
      3    3     700    168 0.2400000     futility         <NA>            C
      4    4     900    235 0.2611111     futility         <NA>            C
      5    5    1200    341 0.2841667  superiority            C            C
      6    6     900    225 0.2500000     futility         <NA>            C
      7    7     300     71 0.2366667     futility         <NA>            C
      8    8    1400    356 0.2542857     futility         <NA>            C
      9    9    1100    277 0.2518182     futility         <NA>            A
      10  10     700    165 0.2357143  superiority            C            C
      11  11    1100    270 0.2454545     futility         <NA>            A
      12  12    1900    523 0.2752632  superiority            C            C
      13  13     400    113 0.2825000     futility         <NA>            C
      14  14     300     69 0.2300000     futility         <NA>            C
      15  15     900    206 0.2288889  superiority            C            C
      16  16     400    118 0.2950000     futility         <NA>            C
      17  17     500    119 0.2380000     futility         <NA>            C
      18  18     700    199 0.2842857     futility         <NA>            C
      19  19    1300    345 0.2653846     futility         <NA>            C
      20  20     300     86 0.2866667     futility         <NA>            C
                   err       sq_err       err_te    sq_err_te
      1  -0.0320615980 1.027946e-03  0.018209246 3.315766e-04
      2   0.0403056552 1.624546e-03  0.018709023 3.500275e-04
      3  -0.0212254131 4.505182e-04 -0.002104886 4.430545e-06
      4  -0.0070080201 4.911235e-05 -0.007796942 6.079230e-05
      5   0.0112871320 1.273993e-04 -0.029711123 8.827508e-04
      6  -0.0163034180 2.658014e-04 -0.004564815 2.083754e-05
      7   0.0418074601 1.747864e-03  0.062301746 3.881508e-03
      8  -0.0211408830 4.469369e-04 -0.028364667 8.045543e-04
      9   0.0241545653 5.834430e-04  0.039945617 1.595652e-03
      10 -0.0186526388 3.479209e-04 -0.006668360 4.446702e-05
      11  0.0236137388 5.576087e-04  0.031337078 9.820124e-04
      12  0.0003741639 1.399986e-07  0.023387597 5.469797e-04
      13  0.0683181104 4.667364e-03  0.039680849 1.574570e-03
      14  0.0654952119 4.289623e-03  0.131084491 1.718314e-02
      15 -0.0365313171 1.334537e-03 -0.029001538 8.410892e-04
      16  0.0552824892 3.056154e-03  0.041808151 1.747921e-03
      17  0.0104174470 1.085232e-04  0.040491379 1.639552e-03
      18  0.0317224271 1.006312e-03 -0.004951673 2.451906e-05
      19 -0.0047998954 2.303900e-05 -0.018678309 3.488792e-04
      20  0.0757048898 5.731230e-03  0.071794904 5.154508e-03

---

    Code
      extract_results(res, select_strategy = "list", select_preferences = "B")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    114 0.2280000     futility         <NA>         <NA>
      2    2     500    136 0.2720000  superiority            C            C
      3    3     700    168 0.2400000     futility         <NA>         <NA>
      4    4     900    235 0.2611111     futility         <NA>         <NA>
      5    5    1200    341 0.2841667  superiority            C            C
      6    6     900    225 0.2500000     futility         <NA>         <NA>
      7    7     300     71 0.2366667     futility         <NA>         <NA>
      8    8    1400    356 0.2542857     futility         <NA>         <NA>
      9    9    1100    277 0.2518182     futility         <NA>         <NA>
      10  10     700    165 0.2357143  superiority            C            C
      11  11    1100    270 0.2454545     futility         <NA>         <NA>
      12  12    1900    523 0.2752632  superiority            C            C
      13  13     400    113 0.2825000     futility         <NA>         <NA>
      14  14     300     69 0.2300000     futility         <NA>         <NA>
      15  15     900    206 0.2288889  superiority            C            C
      16  16     400    118 0.2950000     futility         <NA>         <NA>
      17  17     500    119 0.2380000     futility         <NA>         <NA>
      18  18     700    199 0.2842857     futility         <NA>         <NA>
      19  19    1300    345 0.2653846     futility         <NA>         <NA>
      20  20     300     86 0.2866667     futility         <NA>         <NA>
                   err       sq_err      err_te    sq_err_te
      1             NA           NA          NA           NA
      2   0.0403056552 1.624546e-03  0.01870902 3.500275e-04
      3             NA           NA          NA           NA
      4             NA           NA          NA           NA
      5   0.0112871320 1.273993e-04 -0.02971112 8.827508e-04
      6             NA           NA          NA           NA
      7             NA           NA          NA           NA
      8             NA           NA          NA           NA
      9             NA           NA          NA           NA
      10 -0.0186526388 3.479209e-04 -0.00666836 4.446702e-05
      11            NA           NA          NA           NA
      12  0.0003741639 1.399986e-07  0.02338760 5.469797e-04
      13            NA           NA          NA           NA
      14            NA           NA          NA           NA
      15 -0.0365313171 1.334537e-03 -0.02900154 8.410892e-04
      16            NA           NA          NA           NA
      17            NA           NA          NA           NA
      18            NA           NA          NA           NA
      19            NA           NA          NA           NA
      20            NA           NA          NA           NA

---

    Code
      extract_results(res, te_comp = "C")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    114 0.2280000     futility         <NA>         <NA>
      2    2     500    136 0.2720000  superiority            C            C
      3    3     700    168 0.2400000     futility         <NA>         <NA>
      4    4     900    235 0.2611111     futility         <NA>         <NA>
      5    5    1200    341 0.2841667  superiority            C            C
      6    6     900    225 0.2500000     futility         <NA>         <NA>
      7    7     300     71 0.2366667     futility         <NA>         <NA>
      8    8    1400    356 0.2542857     futility         <NA>         <NA>
      9    9    1100    277 0.2518182     futility         <NA>         <NA>
      10  10     700    165 0.2357143  superiority            C            C
      11  11    1100    270 0.2454545     futility         <NA>         <NA>
      12  12    1900    523 0.2752632  superiority            C            C
      13  13     400    113 0.2825000     futility         <NA>         <NA>
      14  14     300     69 0.2300000     futility         <NA>         <NA>
      15  15     900    206 0.2288889  superiority            C            C
      16  16     400    118 0.2950000     futility         <NA>         <NA>
      17  17     500    119 0.2380000     futility         <NA>         <NA>
      18  18     700    199 0.2842857     futility         <NA>         <NA>
      19  19    1300    345 0.2653846     futility         <NA>         <NA>
      20  20     300     86 0.2866667     futility         <NA>         <NA>
                   err       sq_err err_te sq_err_te
      1             NA           NA     NA        NA
      2   0.0403056552 1.624546e-03     NA        NA
      3             NA           NA     NA        NA
      4             NA           NA     NA        NA
      5   0.0112871320 1.273993e-04     NA        NA
      6             NA           NA     NA        NA
      7             NA           NA     NA        NA
      8             NA           NA     NA        NA
      9             NA           NA     NA        NA
      10 -0.0186526388 3.479209e-04     NA        NA
      11            NA           NA     NA        NA
      12  0.0003741639 1.399986e-07     NA        NA
      13            NA           NA     NA        NA
      14            NA           NA     NA        NA
      15 -0.0365313171 1.334537e-03     NA        NA
      16            NA           NA     NA        NA
      17            NA           NA     NA        NA
      18            NA           NA     NA        NA
      19            NA           NA     NA        NA
      20            NA           NA     NA        NA

---

    Code
      extract_results(res, raw_ests = TRUE)
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    114 0.2280000     futility         <NA>         <NA>
      2    2     500    136 0.2720000  superiority            C            C
      3    3     700    168 0.2400000     futility         <NA>         <NA>
      4    4     900    235 0.2611111     futility         <NA>         <NA>
      5    5    1200    341 0.2841667  superiority            C            C
      6    6     900    225 0.2500000     futility         <NA>         <NA>
      7    7     300     71 0.2366667     futility         <NA>         <NA>
      8    8    1400    356 0.2542857     futility         <NA>         <NA>
      9    9    1100    277 0.2518182     futility         <NA>         <NA>
      10  10     700    165 0.2357143  superiority            C            C
      11  11    1100    270 0.2454545     futility         <NA>         <NA>
      12  12    1900    523 0.2752632  superiority            C            C
      13  13     400    113 0.2825000     futility         <NA>         <NA>
      14  14     300     69 0.2300000     futility         <NA>         <NA>
      15  15     900    206 0.2288889  superiority            C            C
      16  16     400    118 0.2950000     futility         <NA>         <NA>
      17  17     500    119 0.2380000     futility         <NA>         <NA>
      18  18     700    199 0.2842857     futility         <NA>         <NA>
      19  19    1300    345 0.2653846     futility         <NA>         <NA>
      20  20     300     86 0.2866667     futility         <NA>         <NA>
                 err       sq_err       err_te    sq_err_te
      1           NA           NA           NA           NA
      2   0.03962264 0.0015699537  0.021135247 4.466986e-04
      3           NA           NA           NA           NA
      4           NA           NA           NA           NA
      5   0.01097561 0.0001204640 -0.028750418 8.265865e-04
      6           NA           NA           NA           NA
      7           NA           NA           NA           NA
      8           NA           NA           NA           NA
      9           NA           NA           NA           NA
      10 -0.01954023 0.0003818206 -0.004253606 1.809316e-05
      11          NA           NA           NA           NA
      12  0.00000000 0.0000000000  0.025757576 6.634527e-04
      13          NA           NA           NA           NA
      14          NA           NA           NA           NA
      15 -0.03706897 0.0013741082 -0.028291536 8.004110e-04
      16          NA           NA           NA           NA
      17          NA           NA           NA           NA
      18          NA           NA           NA           NA
      19          NA           NA           NA           NA
      20          NA           NA           NA           NA

# Tidy results of simulations from binomial-outcome trial without common control works

    Code
      extract_results(res, select_strategy = "control if available")
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

---

    Code
      extract_results(res, select_strategy = "none")
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

---

    Code
      extract_results(res, select_strategy = "best")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    110 0.2200000  superiority            B            B
      2    2    1200    273 0.2275000  superiority            B            B
      3    3    1200    266 0.2216667  superiority            B            B
      4    4     700    156 0.2228571  superiority            B            B
      5    5    1300    295 0.2269231  superiority            B            B
      6    6     600    131 0.2183333  superiority            B            B
      7    7    1900    420 0.2210526  superiority            B            B
      8    8    2000    433 0.2165000          max         <NA>            B
      9    9    1600    353 0.2206250  superiority            B            B
      10  10    1000    220 0.2200000  equivalence         <NA>            B
      11  11    1200    264 0.2200000  superiority            B            B
      12  12     400     94 0.2350000  superiority            B            B
      13  13    2000    469 0.2345000          max         <NA>            B
      14  14     900    197 0.2188889  equivalence         <NA>            B
      15  15    1400    303 0.2164286  superiority            B            B
      16  16    2000    462 0.2310000          max         <NA>            B
      17  17    1000    215 0.2150000  equivalence         <NA>            A
      18  18    2000    472 0.2360000          max         <NA>            B
      19  19    1600    372 0.2325000  superiority            B            B
      20  20     500    135 0.2700000  superiority            B            B
                   err       sq_err err_te sq_err_te
      1  -3.746258e-02 1.403445e-03     NA        NA
      2  -8.091122e-03 6.546625e-05     NA        NA
      3  -9.209925e-03 8.482272e-05     NA        NA
      4  -2.523497e-02 6.368035e-04     NA        NA
      5  -3.681956e-03 1.355680e-05     NA        NA
      6  -3.273552e-02 1.071614e-03     NA        NA
      7  -1.214794e-03 1.475723e-06     NA        NA
      8   4.290576e-05 1.840904e-09     NA        NA
      9  -3.254965e-03 1.059480e-05     NA        NA
      10  2.185308e-05 4.775573e-10     NA        NA
      11 -1.156190e-02 1.336775e-04     NA        NA
      12 -3.542490e-02 1.254923e-03     NA        NA
      13  1.557587e-02 2.426079e-04     NA        NA
      14  1.185545e-04 1.405516e-08     NA        NA
      15 -1.768397e-02 3.127227e-04     NA        NA
      16  1.393885e-02 1.942916e-04     NA        NA
      17 -4.658115e-02 2.169804e-03     NA        NA
      18  1.884488e-02 3.551297e-04     NA        NA
      19  4.641866e-03 2.154692e-05     NA        NA
      20  6.639065e-03 4.407718e-05     NA        NA

---

    Code
      extract_results(res, select_strategy = "list or best", select_preferences = "B")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    110 0.2200000  superiority            B            B
      2    2    1200    273 0.2275000  superiority            B            B
      3    3    1200    266 0.2216667  superiority            B            B
      4    4     700    156 0.2228571  superiority            B            B
      5    5    1300    295 0.2269231  superiority            B            B
      6    6     600    131 0.2183333  superiority            B            B
      7    7    1900    420 0.2210526  superiority            B            B
      8    8    2000    433 0.2165000          max         <NA>            B
      9    9    1600    353 0.2206250  superiority            B            B
      10  10    1000    220 0.2200000  equivalence         <NA>            B
      11  11    1200    264 0.2200000  superiority            B            B
      12  12     400     94 0.2350000  superiority            B            B
      13  13    2000    469 0.2345000          max         <NA>            B
      14  14     900    197 0.2188889  equivalence         <NA>            B
      15  15    1400    303 0.2164286  superiority            B            B
      16  16    2000    462 0.2310000          max         <NA>            B
      17  17    1000    215 0.2150000  equivalence         <NA>            B
      18  18    2000    472 0.2360000          max         <NA>            B
      19  19    1600    372 0.2325000  superiority            B            B
      20  20     500    135 0.2700000  superiority            B            B
                   err       sq_err err_te sq_err_te
      1  -3.746258e-02 1.403445e-03     NA        NA
      2  -8.091122e-03 6.546625e-05     NA        NA
      3  -9.209925e-03 8.482272e-05     NA        NA
      4  -2.523497e-02 6.368035e-04     NA        NA
      5  -3.681956e-03 1.355680e-05     NA        NA
      6  -3.273552e-02 1.071614e-03     NA        NA
      7  -1.214794e-03 1.475723e-06     NA        NA
      8   4.290576e-05 1.840904e-09     NA        NA
      9  -3.254965e-03 1.059480e-05     NA        NA
      10  2.185308e-05 4.775573e-10     NA        NA
      11 -1.156190e-02 1.336775e-04     NA        NA
      12 -3.542490e-02 1.254923e-03     NA        NA
      13  1.557587e-02 2.426079e-04     NA        NA
      14  1.185545e-04 1.405516e-08     NA        NA
      15 -1.768397e-02 3.127227e-04     NA        NA
      16  1.393885e-02 1.942916e-04     NA        NA
      17  1.076086e-02 1.157961e-04     NA        NA
      18  1.884488e-02 3.551297e-04     NA        NA
      19  4.641866e-03 2.154692e-05     NA        NA
      20  6.639065e-03 4.407718e-05     NA        NA

---

    Code
      extract_results(res, select_strategy = "list", select_preferences = "B")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1     500    110 0.2200000  superiority            B            B
      2    2    1200    273 0.2275000  superiority            B            B
      3    3    1200    266 0.2216667  superiority            B            B
      4    4     700    156 0.2228571  superiority            B            B
      5    5    1300    295 0.2269231  superiority            B            B
      6    6     600    131 0.2183333  superiority            B            B
      7    7    1900    420 0.2210526  superiority            B            B
      8    8    2000    433 0.2165000          max         <NA>            B
      9    9    1600    353 0.2206250  superiority            B            B
      10  10    1000    220 0.2200000  equivalence         <NA>            B
      11  11    1200    264 0.2200000  superiority            B            B
      12  12     400     94 0.2350000  superiority            B            B
      13  13    2000    469 0.2345000          max         <NA>            B
      14  14     900    197 0.2188889  equivalence         <NA>            B
      15  15    1400    303 0.2164286  superiority            B            B
      16  16    2000    462 0.2310000          max         <NA>            B
      17  17    1000    215 0.2150000  equivalence         <NA>            B
      18  18    2000    472 0.2360000          max         <NA>            B
      19  19    1600    372 0.2325000  superiority            B            B
      20  20     500    135 0.2700000  superiority            B            B
                   err       sq_err err_te sq_err_te
      1  -3.746258e-02 1.403445e-03     NA        NA
      2  -8.091122e-03 6.546625e-05     NA        NA
      3  -9.209925e-03 8.482272e-05     NA        NA
      4  -2.523497e-02 6.368035e-04     NA        NA
      5  -3.681956e-03 1.355680e-05     NA        NA
      6  -3.273552e-02 1.071614e-03     NA        NA
      7  -1.214794e-03 1.475723e-06     NA        NA
      8   4.290576e-05 1.840904e-09     NA        NA
      9  -3.254965e-03 1.059480e-05     NA        NA
      10  2.185308e-05 4.775573e-10     NA        NA
      11 -1.156190e-02 1.336775e-04     NA        NA
      12 -3.542490e-02 1.254923e-03     NA        NA
      13  1.557587e-02 2.426079e-04     NA        NA
      14  1.185545e-04 1.405516e-08     NA        NA
      15 -1.768397e-02 3.127227e-04     NA        NA
      16  1.393885e-02 1.942916e-04     NA        NA
      17  1.076086e-02 1.157961e-04     NA        NA
      18  1.884488e-02 3.551297e-04     NA        NA
      19  4.641866e-03 2.154692e-05     NA        NA
      20  6.639065e-03 4.407718e-05     NA        NA

---

    Code
      extract_results(res, te_comp = "C")
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
                  err       sq_err        err_te    sq_err_te
      1  -0.037462579 1.403445e-03 -0.0309834173 9.599721e-04
      2  -0.008091122 6.546625e-05 -0.0694765496 4.826991e-03
      3  -0.009209925 8.482272e-05  0.0279946570 7.837008e-04
      4  -0.025234966 6.368035e-04  0.0001180144 1.392739e-08
      5  -0.003681956 1.355680e-05 -0.0286462280 8.206064e-04
      6  -0.032735518 1.071614e-03  0.0075002766 5.625415e-05
      7  -0.001214794 1.475723e-06 -0.0425043761 1.806622e-03
      8            NA           NA            NA           NA
      9  -0.003254965 1.059480e-05  0.0246872011 6.094579e-04
      10           NA           NA            NA           NA
      11 -0.011561899 1.336775e-04  0.0324811838 1.055027e-03
      12 -0.035424899 1.254923e-03 -0.0240593040 5.788501e-04
      13           NA           NA            NA           NA
      14           NA           NA            NA           NA
      15 -0.017683969 3.127227e-04  0.0211553332 4.475481e-04
      16           NA           NA            NA           NA
      17           NA           NA            NA           NA
      18           NA           NA            NA           NA
      19  0.004641866 2.154692e-05  0.0242464916 5.878924e-04
      20  0.006639065 4.407718e-05 -0.0697711964 4.868020e-03

---

    Code
      extract_results(res, raw_ests = TRUE)
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
      1  -0.039215686 1.537870e-03     NA        NA
      2  -0.009090909 8.264463e-05     NA        NA
      3  -0.009457580 8.944582e-05     NA        NA
      4  -0.026347305 6.941805e-04     NA        NA
      5  -0.004137931 1.712247e-05     NA        NA
      6  -0.034437086 1.185913e-03     NA        NA
      7  -0.001218583 1.484945e-06     NA        NA
      8            NA           NA     NA        NA
      9  -0.003703704 1.371742e-05     NA        NA
      10           NA           NA     NA        NA
      11 -0.011819596 1.397028e-04     NA        NA
      12 -0.038150289 1.455445e-03     NA        NA
      13           NA           NA     NA        NA
      14           NA           NA     NA        NA
      15 -0.018313953 3.354009e-04     NA        NA
      16           NA           NA     NA        NA
      17           NA           NA     NA        NA
      18           NA           NA     NA        NA
      19  0.004395604 1.932134e-05     NA        NA
      20  0.004633205 2.146659e-05     NA        NA

# Selection works with practical equivalence and outcome-data lag works

    Code
      extract_results(res, select_strategy = "best")
    Output
         sim final_n sum_ys  ratio_ys final_status superior_arm selected_arm
      1    1    1500    351 0.2340000  equivalence         <NA>            A
      2    2    1500    339 0.2260000  equivalence         <NA>            B
      3    3    2100    481 0.2290476          max         <NA>            B
      4    4    1500    349 0.2326667  superiority            B            B
      5    5    1900    462 0.2431579  equivalence         <NA>            B
      6    6    2100    487 0.2319048          max         <NA>            B
      7    7    1500    344 0.2293333  equivalence         <NA>            B
      8    8    1700    430 0.2529412  equivalence         <NA>            B
      9    9    2100    526 0.2504762          max         <NA>            B
      10  10     200     40 0.2000000  superiority            B            B
      11  11    1600    377 0.2356250  equivalence         <NA>            A
      12  12    1600    369 0.2306250  equivalence         <NA>            B
      13  13    1800    476 0.2644444  equivalence         <NA>            B
      14  14    2100    508 0.2419048  equivalence         <NA>            B
      15  15     200     51 0.2550000  superiority            B            B
      16  16    2100    480 0.2285714          max         <NA>            B
      17  17    2100    482 0.2295238          max         <NA>            B
      18  18    1500    339 0.2260000  equivalence         <NA>            B
      19  19    1500    352 0.2346667  equivalence         <NA>            A
      20  20    1900    440 0.2315789  equivalence         <NA>            A
                  err       sq_err err_te sq_err_te
      1  -0.020294048 4.118484e-04     NA        NA
      2  -0.007014838 4.920796e-05     NA        NA
      3  -0.014463951 2.092059e-04     NA        NA
      4  -0.024881085 6.190684e-04     NA        NA
      5   0.007033408 4.946882e-05     NA        NA
      6  -0.017663275 3.119913e-04     NA        NA
      7  -0.003116444 9.712220e-06     NA        NA
      8   0.017648868 3.114825e-04     NA        NA
      9   0.015377199 2.364583e-04     NA        NA
      10 -0.099895742 9.979159e-03     NA        NA
      11 -0.016594114 2.753646e-04     NA        NA
      12 -0.001521558 2.315138e-06     NA        NA
      13  0.031967991 1.021952e-03     NA        NA
      14  0.007552201 5.703574e-05     NA        NA
      15 -0.047414042 2.248091e-03     NA        NA
      16 -0.014629099 2.140105e-04     NA        NA
      17 -0.006069625 3.684034e-05     NA        NA
      18 -0.006869535 4.719051e-05     NA        NA
      19 -0.014451375 2.088422e-04     NA        NA
      20 -0.020764240 4.311537e-04     NA        NA

# Metric history of specific trial works

    Code
      extract_history(res)
    Output
         look look_ns look_ns_all arm old_alloc  ns ns_all sum_ys sum_ys_all
      A     1     300         300   A 0.3333333 122    122     30         30
      B     1     300         300   B 0.3333333  91     91     21         21
      C     1     300         300   C 0.3333333  87     87     20         20
      A1    2     400         400   A 0.3762498 158    158     34         34
      B1    2     400         400   B 0.3113363 124    124     28         28
      C1    2     400         400   C 0.3124139 118    118     30         30
      A2    3     500         500   A 0.2283302 184    184     38         38
      B2    3     500         500   B 0.3000846 158    158     33         33
      C2    3     500         500   C 0.4715852 158    158     40         40
      A3    4     600         600   A 0.2171704 210    210     40         40
      B3    4     600         600   B 0.2395724 180    180     34         34
      C3    4     600         600   C 0.5432572 210    210     56         56
      A4    5     700         700   A 0.1500000 225    225     43         43
      B4    5     700         700   B 0.1500000 194    194     37         37
      C4    5     700         700   C 0.7000000 281    281     75         75
      A5    6     800         800   A 0.1500000 234    234     43         43
      B5    6     800         800   B 0.1500000 210    210     39         39
      C5    6     800         800   C 0.7000000 356    356     97         97
      A6    7     900         900   A 0.1500000 244    244     48         48
      B6    7     900         900   B 0.1500000 223    223     41         41
      C6    7     900         900   C 0.7000000 433    433    126        126
             value
      A  0.3333333
      B  0.3333333
      C  0.3333333
      A1 0.3762498
      B1 0.3113363
      C1 0.3124139
      A2 0.2283302
      B2 0.3000846
      C2 0.4715852
      A3 0.2171704
      B3 0.2395724
      C3 0.5432572
      A4 0.1500000
      B4 0.1500000
      C4 0.7000000
      A5 0.1500000
      B5 0.1500000
      C5 0.7000000
      A6 0.1500000
      B6 0.1500000
      C6 0.7000000

