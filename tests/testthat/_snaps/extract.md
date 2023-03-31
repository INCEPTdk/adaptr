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
               sq_err    sq_err_te
      1            NA           NA
      2  1.624546e-03 3.500275e-04
      3            NA           NA
      4            NA           NA
      5  1.273993e-04 8.827508e-04
      6            NA           NA
      7            NA           NA
      8            NA           NA
      9            NA           NA
      10 3.479209e-04 4.446702e-05
      11           NA           NA
      12 1.399986e-07 5.469797e-04
      13           NA           NA
      14           NA           NA
      15 1.334537e-03 8.410892e-04
      16           NA           NA
      17           NA           NA
      18           NA           NA
      19           NA           NA
      20           NA           NA

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
               sq_err    sq_err_te
      1            NA           NA
      2  1.624546e-03 3.500275e-04
      3            NA           NA
      4            NA           NA
      5  1.273993e-04 8.827508e-04
      6            NA           NA
      7            NA           NA
      8            NA           NA
      9            NA           NA
      10 3.479209e-04 4.446702e-05
      11           NA           NA
      12 1.399986e-07 5.469797e-04
      13           NA           NA
      14           NA           NA
      15 1.334537e-03 8.410892e-04
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
               sq_err    sq_err_te
      1            NA           NA
      2  1.624546e-03 3.500275e-04
      3            NA           NA
      4            NA           NA
      5  1.273993e-04 8.827508e-04
      6            NA           NA
      7            NA           NA
      8            NA           NA
      9            NA           NA
      10 3.479209e-04 4.446702e-05
      11           NA           NA
      12 1.399986e-07 5.469797e-04
      13           NA           NA
      14           NA           NA
      15 1.334537e-03 8.410892e-04
      16           NA           NA
      17           NA           NA
      18           NA           NA
      19           NA           NA
      20           NA           NA

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
               sq_err    sq_err_te
      1  1.027946e-03 3.315766e-04
      2  1.624546e-03 3.500275e-04
      3  4.505182e-04 4.430545e-06
      4  4.911235e-05 6.079230e-05
      5  1.273993e-04 8.827508e-04
      6  2.658014e-04 2.083754e-05
      7  1.747864e-03 3.881508e-03
      8  4.469369e-04 8.045543e-04
      9  5.834430e-04 1.595652e-03
      10 3.479209e-04 4.446702e-05
      11 5.576087e-04 9.820124e-04
      12 1.399986e-07 5.469797e-04
      13 4.667364e-03 1.574570e-03
      14 4.289623e-03 1.718314e-02
      15 1.334537e-03 8.410892e-04
      16 3.056154e-03 1.747921e-03
      17 1.085232e-04 1.639552e-03
      18 1.006312e-03 2.451906e-05
      19 2.303900e-05 3.488792e-04
      20 5.731230e-03 5.154508e-03

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
               sq_err    sq_err_te
      1  1.027946e-03 3.315766e-04
      2  1.624546e-03 3.500275e-04
      3  4.505182e-04 4.430545e-06
      4  4.911235e-05 6.079230e-05
      5  1.273993e-04 8.827508e-04
      6  2.658014e-04 2.083754e-05
      7  1.747864e-03 3.881508e-03
      8  4.469369e-04 8.045543e-04
      9  5.834430e-04 1.595652e-03
      10 3.479209e-04 4.446702e-05
      11 5.576087e-04 9.820124e-04
      12 1.399986e-07 5.469797e-04
      13 4.667364e-03 1.574570e-03
      14 4.289623e-03 1.718314e-02
      15 1.334537e-03 8.410892e-04
      16 3.056154e-03 1.747921e-03
      17 1.085232e-04 1.639552e-03
      18 1.006312e-03 2.451906e-05
      19 2.303900e-05 3.488792e-04
      20 5.731230e-03 5.154508e-03

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
               sq_err    sq_err_te
      1  1.027946e-03 3.315766e-04
      2  1.624546e-03 3.500275e-04
      3  4.505182e-04 4.430545e-06
      4  4.911235e-05 6.079230e-05
      5  1.273993e-04 8.827508e-04
      6  2.658014e-04 2.083754e-05
      7  1.747864e-03 3.881508e-03
      8  4.469369e-04 8.045543e-04
      9  5.834430e-04 1.595652e-03
      10 3.479209e-04 4.446702e-05
      11 5.576087e-04 9.820124e-04
      12 1.399986e-07 5.469797e-04
      13 4.667364e-03 1.574570e-03
      14 4.289623e-03 1.718314e-02
      15 1.334537e-03 8.410892e-04
      16 3.056154e-03 1.747921e-03
      17 1.085232e-04 1.639552e-03
      18 1.006312e-03 2.451906e-05
      19 2.303900e-05 3.488792e-04
      20 5.731230e-03 5.154508e-03

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
               sq_err    sq_err_te
      1  1.027946e-03 3.315766e-04
      2  1.624546e-03 3.500275e-04
      3  4.505182e-04 4.430545e-06
      4  4.911235e-05 6.079230e-05
      5  1.273993e-04 8.827508e-04
      6  2.658014e-04 2.083754e-05
      7  1.747864e-03 3.881508e-03
      8  4.469369e-04 8.045543e-04
      9  5.834430e-04 1.595652e-03
      10 3.479209e-04 4.446702e-05
      11 5.576087e-04 9.820124e-04
      12 1.399986e-07 5.469797e-04
      13 4.667364e-03 1.574570e-03
      14 4.289623e-03 1.718314e-02
      15 1.334537e-03 8.410892e-04
      16 3.056154e-03 1.747921e-03
      17 1.085232e-04 1.639552e-03
      18 1.006312e-03 2.451906e-05
      19 2.303900e-05 3.488792e-04
      20 5.731230e-03 5.154508e-03

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
               sq_err    sq_err_te
      1            NA           NA
      2  1.624546e-03 3.500275e-04
      3            NA           NA
      4            NA           NA
      5  1.273993e-04 8.827508e-04
      6            NA           NA
      7            NA           NA
      8            NA           NA
      9            NA           NA
      10 3.479209e-04 4.446702e-05
      11           NA           NA
      12 1.399986e-07 5.469797e-04
      13           NA           NA
      14           NA           NA
      15 1.334537e-03 8.410892e-04
      16           NA           NA
      17           NA           NA
      18           NA           NA
      19           NA           NA
      20           NA           NA

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
               sq_err sq_err_te
      1            NA        NA
      2  1.624546e-03        NA
      3            NA        NA
      4            NA        NA
      5  1.273993e-04        NA
      6            NA        NA
      7            NA        NA
      8            NA        NA
      9            NA        NA
      10 3.479209e-04        NA
      11           NA        NA
      12 1.399986e-07        NA
      13           NA        NA
      14           NA        NA
      15 1.334537e-03        NA
      16           NA        NA
      17           NA        NA
      18           NA        NA
      19           NA        NA
      20           NA        NA

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
               sq_err    sq_err_te
      1            NA           NA
      2  0.0015699537 4.466986e-04
      3            NA           NA
      4            NA           NA
      5  0.0001204640 8.265865e-04
      6            NA           NA
      7            NA           NA
      8            NA           NA
      9            NA           NA
      10 0.0003818206 1.809316e-05
      11           NA           NA
      12 0.0000000000 6.634527e-04
      13           NA           NA
      14           NA           NA
      15 0.0013741082 8.004110e-04
      16           NA           NA
      17           NA           NA
      18           NA           NA
      19           NA           NA
      20           NA           NA

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
               sq_err sq_err_te
      1  1.403445e-03        NA
      2  6.546625e-05        NA
      3  8.482272e-05        NA
      4  6.368035e-04        NA
      5  1.355680e-05        NA
      6  1.071614e-03        NA
      7  1.475723e-06        NA
      8  1.840904e-09        NA
      9  1.059480e-05        NA
      10 4.775573e-10        NA
      11 1.336775e-04        NA
      12 1.254923e-03        NA
      13 2.426079e-04        NA
      14 1.405516e-08        NA
      15 3.127227e-04        NA
      16 1.942916e-04        NA
      17 2.169804e-03        NA
      18 3.551297e-04        NA
      19 2.154692e-05        NA
      20 4.407718e-05        NA

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
               sq_err sq_err_te
      1  1.403445e-03        NA
      2  6.546625e-05        NA
      3  8.482272e-05        NA
      4  6.368035e-04        NA
      5  1.355680e-05        NA
      6  1.071614e-03        NA
      7  1.475723e-06        NA
      8  1.840904e-09        NA
      9  1.059480e-05        NA
      10 4.775573e-10        NA
      11 1.336775e-04        NA
      12 1.254923e-03        NA
      13 2.426079e-04        NA
      14 1.405516e-08        NA
      15 3.127227e-04        NA
      16 1.942916e-04        NA
      17 1.157961e-04        NA
      18 3.551297e-04        NA
      19 2.154692e-05        NA
      20 4.407718e-05        NA

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
               sq_err sq_err_te
      1  1.403445e-03        NA
      2  6.546625e-05        NA
      3  8.482272e-05        NA
      4  6.368035e-04        NA
      5  1.355680e-05        NA
      6  1.071614e-03        NA
      7  1.475723e-06        NA
      8  1.840904e-09        NA
      9  1.059480e-05        NA
      10 4.775573e-10        NA
      11 1.336775e-04        NA
      12 1.254923e-03        NA
      13 2.426079e-04        NA
      14 1.405516e-08        NA
      15 3.127227e-04        NA
      16 1.942916e-04        NA
      17 1.157961e-04        NA
      18 3.551297e-04        NA
      19 2.154692e-05        NA
      20 4.407718e-05        NA

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
               sq_err    sq_err_te
      1  1.403445e-03 9.599721e-04
      2  6.546625e-05 4.826991e-03
      3  8.482272e-05 7.837008e-04
      4  6.368035e-04 1.392739e-08
      5  1.355680e-05 8.206064e-04
      6  1.071614e-03 5.625415e-05
      7  1.475723e-06 1.806622e-03
      8            NA           NA
      9  1.059480e-05 6.094579e-04
      10           NA           NA
      11 1.336775e-04 1.055027e-03
      12 1.254923e-03 5.788501e-04
      13           NA           NA
      14           NA           NA
      15 3.127227e-04 4.475481e-04
      16           NA           NA
      17           NA           NA
      18           NA           NA
      19 2.154692e-05 5.878924e-04
      20 4.407718e-05 4.868020e-03

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
               sq_err sq_err_te
      1  1.537870e-03        NA
      2  8.264463e-05        NA
      3  8.944582e-05        NA
      4  6.941805e-04        NA
      5  1.712247e-05        NA
      6  1.185913e-03        NA
      7  1.484945e-06        NA
      8            NA        NA
      9  1.371742e-05        NA
      10           NA        NA
      11 1.397028e-04        NA
      12 1.455445e-03        NA
      13           NA        NA
      14           NA        NA
      15 3.354009e-04        NA
      16           NA        NA
      17           NA        NA
      18           NA        NA
      19 1.932134e-05        NA
      20 2.146659e-05        NA

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

