# valid parameters work

    Code
      check_performance(res)
    Output
                    metric      est
      1       n_summarised   20.000
      2          size_mean 1250.000
      3            size_sd  551.076
      4        size_median 1200.000
      5           size_p25  850.000
      6           size_p75 1675.000
      7            size_p0  400.000
      8          size_p100 2000.000
      9        sum_ys_mean  282.000
      10         sum_ys_sd  125.760
      11     sum_ys_median  269.500
      12        sum_ys_p25  186.750
      13        sum_ys_p75  384.000
      14         sum_ys_p0   94.000
      15       sum_ys_p100  472.000
      16     ratio_ys_mean    0.226
      17       ratio_ys_sd    0.012
      18   ratio_ys_median    0.221
      19      ratio_ys_p25    0.220
      20      ratio_ys_p75    0.231
      21       ratio_ys_p0    0.215
      22     ratio_ys_p100    0.270
      23   prob_conclusive    0.800
      24     prob_superior    0.650
      25  prob_equivalence    0.150
      26     prob_futility    0.000
      27          prob_max    0.200
      28 prob_select_arm_A    0.000
      29 prob_select_arm_B    0.650
      30 prob_select_arm_C    0.000
      31  prob_select_none    0.350
      32              rmse    0.020
      33           rmse_te       NA
      34               idp  100.000

---

    Code
      check_performance(res, uncertainty = FALSE)
    Output
                    metric      est
      1       n_summarised   20.000
      2          size_mean 1250.000
      3            size_sd  551.076
      4        size_median 1200.000
      5           size_p25  850.000
      6           size_p75 1675.000
      7            size_p0  400.000
      8          size_p100 2000.000
      9        sum_ys_mean  282.000
      10         sum_ys_sd  125.760
      11     sum_ys_median  269.500
      12        sum_ys_p25  186.750
      13        sum_ys_p75  384.000
      14         sum_ys_p0   94.000
      15       sum_ys_p100  472.000
      16     ratio_ys_mean    0.226
      17       ratio_ys_sd    0.012
      18   ratio_ys_median    0.221
      19      ratio_ys_p25    0.220
      20      ratio_ys_p75    0.231
      21       ratio_ys_p0    0.215
      22     ratio_ys_p100    0.270
      23   prob_conclusive    0.800
      24     prob_superior    0.650
      25  prob_equivalence    0.150
      26     prob_futility    0.000
      27          prob_max    0.200
      28 prob_select_arm_A    0.000
      29 prob_select_arm_B    0.650
      30 prob_select_arm_C    0.000
      31  prob_select_none    0.350
      32              rmse    0.020
      33           rmse_te       NA
      34               idp  100.000

---

    Code
      check_performance(res, uncertainty = TRUE, boot_seed = 4131, n_boot = 100)
    Warning <simpleWarning>
      values for n_boot < 1000 are not recommended, as they may cause instable results.
    Output
                    metric      est  err_sd err_mad    lo_ci    hi_ci
      1       n_summarised   20.000   0.000   0.000   20.000   20.000
      2          size_mean 1250.000 115.920 129.727 1031.875 1462.625
      3            size_sd  551.076  58.032  59.628  415.681  653.692
      4        size_median 1200.000 166.978 148.260  973.750 1600.000
      5           size_p25  850.000 189.979 222.390  500.000 1176.250
      6           size_p75 1675.000 231.369 352.118 1236.875 2000.000
      7            size_p0  400.000      NA      NA       NA       NA
      8          size_p100 2000.000      NA      NA       NA       NA
      9        sum_ys_mean  282.000  26.300  27.132  232.823  330.822
      10         sum_ys_sd  125.760  13.762  14.130   95.505  146.682
      11     sum_ys_median  269.500  38.722  39.289  210.275  357.987
      12        sum_ys_p25  186.750  38.798  45.590  129.819  260.275
      13        sum_ys_p75  384.000  50.837  58.192  276.794  462.000
      14         sum_ys_p0   94.000      NA      NA       NA       NA
      15       sum_ys_p100  472.000      NA      NA       NA       NA
      16     ratio_ys_mean    0.226   0.003   0.003    0.222    0.232
      17       ratio_ys_sd    0.012   0.004   0.005    0.005    0.019
      18   ratio_ys_median    0.221   0.003   0.002    0.220    0.229
      19      ratio_ys_p25    0.220   0.001   0.001    0.216    0.221
      20      ratio_ys_p75    0.231   0.004   0.004    0.222    0.235
      21       ratio_ys_p0    0.215      NA      NA       NA       NA
      22     ratio_ys_p100    0.270      NA      NA       NA       NA
      23   prob_conclusive    0.800   0.087   0.074    0.624    0.950
      24     prob_superior    0.650   0.103   0.111    0.450    0.800
      25  prob_equivalence    0.150   0.079   0.074    0.000    0.300
      26     prob_futility    0.000   0.000   0.000    0.000    0.000
      27          prob_max    0.200   0.087   0.074    0.050    0.376
      28 prob_select_arm_A    0.000   0.000   0.000    0.000    0.000
      29 prob_select_arm_B    0.650   0.103   0.111    0.450    0.800
      30 prob_select_arm_C    0.000   0.000   0.000    0.000    0.000
      31  prob_select_none    0.350   0.103   0.111    0.200    0.550
      32              rmse    0.020   0.004   0.003    0.011    0.026
      33           rmse_te       NA      NA      NA       NA       NA
      34               idp  100.000   0.000   0.000  100.000  100.000

---

    Code
      check_performance(res, uncertainty = TRUE, ci_width = 0.75, boot_seed = 4131,
        n_boot = 100)
    Warning <simpleWarning>
      values for n_boot < 1000 are not recommended, as they may cause instable results.
    Output
                    metric      est  err_sd err_mad    lo_ci    hi_ci
      1       n_summarised   20.000   0.000   0.000   20.000   20.000
      2          size_mean 1250.000 115.920 129.727 1116.875 1383.125
      3            size_sd  551.076  58.032  59.628  471.321  600.569
      4        size_median 1200.000 166.978 148.260 1000.000 1400.000
      5           size_p25  850.000 189.979 222.390  600.000 1000.000
      6           size_p75 1675.000 231.369 352.118 1418.750 2000.000
      7            size_p0  400.000      NA      NA       NA       NA
      8          size_p100 2000.000      NA      NA       NA       NA
      9        sum_ys_mean  282.000  26.300  27.132  252.144  313.913
      10         sum_ys_sd  125.760  13.762  14.130  106.971  138.581
      11     sum_ys_median  269.500  38.722  39.289  220.000  303.000
      12        sum_ys_p25  186.750  38.798  45.590  135.000  220.000
      13        sum_ys_p75  384.000  50.837  58.192  314.719  433.000
      14         sum_ys_p0   94.000      NA      NA       NA       NA
      15       sum_ys_p100  472.000      NA      NA       NA       NA
      16     ratio_ys_mean    0.226   0.003   0.003    0.223    0.229
      17       ratio_ys_sd    0.012   0.004   0.005    0.006    0.016
      18   ratio_ys_median    0.221   0.003   0.002    0.220    0.225
      19      ratio_ys_p25    0.220   0.001   0.001    0.218    0.220
      20      ratio_ys_p75    0.231   0.004   0.004    0.225    0.235
      21       ratio_ys_p0    0.215      NA      NA       NA       NA
      22     ratio_ys_p100    0.270      NA      NA       NA       NA
      23   prob_conclusive    0.800   0.087   0.074    0.700    0.900
      24     prob_superior    0.650   0.103   0.111    0.500    0.750
      25  prob_equivalence    0.150   0.079   0.074    0.050    0.250
      26     prob_futility    0.000   0.000   0.000    0.000    0.000
      27          prob_max    0.200   0.087   0.074    0.100    0.300
      28 prob_select_arm_A    0.000   0.000   0.000    0.000    0.000
      29 prob_select_arm_B    0.650   0.103   0.111    0.500    0.750
      30 prob_select_arm_C    0.000   0.000   0.000    0.000    0.000
      31  prob_select_none    0.350   0.103   0.111    0.250    0.500
      32              rmse    0.020   0.004   0.003    0.014    0.023
      33           rmse_te       NA      NA      NA       NA       NA
      34               idp  100.000   0.000   0.000  100.000  100.000

---

    Code
      check_performance(res, restrict = "superior")
    Output
                    metric      est
      1       n_summarised   13.000
      2          size_mean 1084.615
      3            size_sd  493.028
      4        size_median 1200.000
      5           size_p25  600.000
      6           size_p75 1400.000
      7            size_p0  400.000
      8          size_p100 1900.000
      9        sum_ys_mean  244.000
      10         sum_ys_sd  107.973
      11     sum_ys_median  266.000
      12        sum_ys_p25  135.000
      13        sum_ys_p75  303.000
      14         sum_ys_p0   94.000
      15       sum_ys_p100  420.000
      16     ratio_ys_mean    0.227
      17       ratio_ys_sd    0.014
      18   ratio_ys_median    0.222
      19      ratio_ys_p25    0.220
      20      ratio_ys_p75    0.228
      21       ratio_ys_p0    0.216
      22     ratio_ys_p100    0.270
      23   prob_conclusive    1.000
      24     prob_superior    1.000
      25  prob_equivalence    0.000
      26     prob_futility    0.000
      27          prob_max    0.000
      28 prob_select_arm_A    0.000
      29 prob_select_arm_B    1.000
      30 prob_select_arm_C    0.000
      31  prob_select_none    0.000
      32              rmse    0.020
      33           rmse_te       NA
      34               idp  100.000

---

    Code
      check_performance(res, restrict = "selected")
    Output
                    metric      est
      1       n_summarised   13.000
      2          size_mean 1084.615
      3            size_sd  493.028
      4        size_median 1200.000
      5           size_p25  600.000
      6           size_p75 1400.000
      7            size_p0  400.000
      8          size_p100 1900.000
      9        sum_ys_mean  244.000
      10         sum_ys_sd  107.973
      11     sum_ys_median  266.000
      12        sum_ys_p25  135.000
      13        sum_ys_p75  303.000
      14         sum_ys_p0   94.000
      15       sum_ys_p100  420.000
      16     ratio_ys_mean    0.227
      17       ratio_ys_sd    0.014
      18   ratio_ys_median    0.222
      19      ratio_ys_p25    0.220
      20      ratio_ys_p75    0.228
      21       ratio_ys_p0    0.216
      22     ratio_ys_p100    0.270
      23   prob_conclusive    1.000
      24     prob_superior    1.000
      25  prob_equivalence    0.000
      26     prob_futility    0.000
      27          prob_max    0.000
      28 prob_select_arm_A    0.000
      29 prob_select_arm_B    1.000
      30 prob_select_arm_C    0.000
      31  prob_select_none    0.000
      32              rmse    0.020
      33           rmse_te       NA
      34               idp  100.000

---

    Code
      check_performance(res, restrict = "superior", uncertainty = TRUE, boot_seed = "base",
        n_boot = 100)
    Warning <simpleWarning>
      values for n_boot < 1000 are not recommended, as they may cause instable results.
    Output
                    metric      est  err_sd err_mad    lo_ci    hi_ci
      1       n_summarised   13.000   1.859   1.483    9.000   17.000
      2          size_mean 1084.615 123.986 130.963  849.643 1305.357
      3            size_sd  493.028  64.548  69.102  347.577  597.946
      4        size_median 1200.000 231.802   0.000  600.000 1376.250
      5           size_p25  600.000 244.294 148.260  500.000 1200.000
      6           size_p75 1400.000 172.379 148.260 1200.000 1639.375
      7            size_p0  400.000      NA      NA       NA       NA
      8          size_p100 1900.000      NA      NA       NA       NA
      9        sum_ys_mean  244.000  27.085  28.637  193.007  292.815
      10         sum_ys_sd  107.973  13.743  13.825   75.508  129.319
      11     sum_ys_median  266.000  50.890  10.378  135.000  301.100
      12        sum_ys_p25  135.000  50.145  23.351  110.000  265.762
      13        sum_ys_p75  303.000  38.952  26.872  266.000  372.000
      14         sum_ys_p0   94.000      NA      NA       NA       NA
      15       sum_ys_p100  420.000      NA      NA       NA       NA
      16     ratio_ys_mean    0.227   0.004   0.004    0.221    0.236
      17       ratio_ys_sd    0.014   0.006   0.006    0.003    0.022
      18   ratio_ys_median    0.222   0.003   0.001    0.220    0.229
      19      ratio_ys_p25    0.220   0.001   0.001    0.218    0.222
      20      ratio_ys_p75    0.228   0.008   0.004    0.222    0.253
      21       ratio_ys_p0    0.216      NA      NA       NA       NA
      22     ratio_ys_p100    0.270      NA      NA       NA       NA
      23   prob_conclusive    1.000   0.000   0.000    1.000    1.000
      24     prob_superior    1.000   0.000   0.000    1.000    1.000
      25  prob_equivalence    0.000   0.000   0.000    0.000    0.000
      26     prob_futility    0.000   0.000   0.000    0.000    0.000
      27          prob_max    0.000   0.000   0.000    0.000    0.000
      28 prob_select_arm_A    0.000   0.000   0.000    0.000    0.000
      29 prob_select_arm_B    1.000   0.000   0.000    1.000    1.000
      30 prob_select_arm_C    0.000   0.000   0.000    0.000    0.000
      31  prob_select_none    0.000   0.000   0.000    0.000    0.000
      32              rmse    0.020   0.003   0.004    0.013    0.025
      33           rmse_te       NA      NA      NA       NA       NA
      34               idp  100.000   0.000   0.000  100.000  100.000

---

    Code
      check_performance(res, restrict = "selected", uncertainty = TRUE, boot_seed = "base",
        n_boot = 100)
    Warning <simpleWarning>
      values for n_boot < 1000 are not recommended, as they may cause instable results.
    Output
                    metric      est  err_sd err_mad    lo_ci    hi_ci
      1       n_summarised   13.000   1.859   1.483    9.000   17.000
      2          size_mean 1084.615 123.986 130.963  849.643 1305.357
      3            size_sd  493.028  64.548  69.102  347.577  597.946
      4        size_median 1200.000 231.802   0.000  600.000 1376.250
      5           size_p25  600.000 244.294 148.260  500.000 1200.000
      6           size_p75 1400.000 172.379 148.260 1200.000 1639.375
      7            size_p0  400.000      NA      NA       NA       NA
      8          size_p100 1900.000      NA      NA       NA       NA
      9        sum_ys_mean  244.000  27.085  28.637  193.007  292.815
      10         sum_ys_sd  107.973  13.743  13.825   75.508  129.319
      11     sum_ys_median  266.000  50.890  10.378  135.000  301.100
      12        sum_ys_p25  135.000  50.145  23.351  110.000  265.762
      13        sum_ys_p75  303.000  38.952  26.872  266.000  372.000
      14         sum_ys_p0   94.000      NA      NA       NA       NA
      15       sum_ys_p100  420.000      NA      NA       NA       NA
      16     ratio_ys_mean    0.227   0.004   0.004    0.221    0.236
      17       ratio_ys_sd    0.014   0.006   0.006    0.003    0.022
      18   ratio_ys_median    0.222   0.003   0.001    0.220    0.229
      19      ratio_ys_p25    0.220   0.001   0.001    0.218    0.222
      20      ratio_ys_p75    0.228   0.008   0.004    0.222    0.253
      21       ratio_ys_p0    0.216      NA      NA       NA       NA
      22     ratio_ys_p100    0.270      NA      NA       NA       NA
      23   prob_conclusive    1.000   0.000   0.000    1.000    1.000
      24     prob_superior    1.000   0.000   0.000    1.000    1.000
      25  prob_equivalence    0.000   0.000   0.000    0.000    0.000
      26     prob_futility    0.000   0.000   0.000    0.000    0.000
      27          prob_max    0.000   0.000   0.000    0.000    0.000
      28 prob_select_arm_A    0.000   0.000   0.000    0.000    0.000
      29 prob_select_arm_B    1.000   0.000   0.000    1.000    1.000
      30 prob_select_arm_C    0.000   0.000   0.000    0.000    0.000
      31  prob_select_none    0.000   0.000   0.000    0.000    0.000
      32              rmse    0.020   0.003   0.004    0.013    0.025
      33           rmse_te       NA      NA      NA       NA       NA
      34               idp  100.000   0.000   0.000  100.000  100.000

