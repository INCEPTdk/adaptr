# valid parameters work

    Code
      check_performance(res)
    Output
                    metric      est
      1       n_summarised   20.000
      2          size_mean 1180.000
      3            size_sd  545.411
      4        size_median 1200.000
      5           size_p25  675.000
      6           size_p75 1425.000
      7            size_p0  500.000
      8          size_p100 2000.000
      9        sum_ys_mean  264.700
      10         sum_ys_sd  126.817
      11     sum_ys_median  260.000
      12        sum_ys_p25  143.500
      13        sum_ys_p75  350.250
      14         sum_ys_p0  105.000
      15       sum_ys_p100  470.000
      16     ratio_ys_mean    0.223
      17       ratio_ys_sd    0.015
      18   ratio_ys_median    0.224
      19      ratio_ys_p25    0.211
      20      ratio_ys_p75    0.234
      21       ratio_ys_p0    0.201
      22     ratio_ys_p100    0.253
      23   prob_conclusive    0.800
      24     prob_superior    0.650
      25  prob_equivalence    0.150
      26     prob_futility    0.000
      27          prob_max    0.200
      28 prob_select_arm_A    0.000
      29 prob_select_arm_B    0.650
      30 prob_select_arm_C    0.000
      31  prob_select_none    0.350
      32              rmse    0.027
      33           rmse_te       NA
      34               idp  100.000

---

    Code
      check_performance(res, uncertainty = FALSE)
    Output
                    metric      est
      1       n_summarised   20.000
      2          size_mean 1180.000
      3            size_sd  545.411
      4        size_median 1200.000
      5           size_p25  675.000
      6           size_p75 1425.000
      7            size_p0  500.000
      8          size_p100 2000.000
      9        sum_ys_mean  264.700
      10         sum_ys_sd  126.817
      11     sum_ys_median  260.000
      12        sum_ys_p25  143.500
      13        sum_ys_p75  350.250
      14         sum_ys_p0  105.000
      15       sum_ys_p100  470.000
      16     ratio_ys_mean    0.223
      17       ratio_ys_sd    0.015
      18   ratio_ys_median    0.224
      19      ratio_ys_p25    0.211
      20      ratio_ys_p75    0.234
      21       ratio_ys_p0    0.201
      22     ratio_ys_p100    0.253
      23   prob_conclusive    0.800
      24     prob_superior    0.650
      25  prob_equivalence    0.150
      26     prob_futility    0.000
      27          prob_max    0.200
      28 prob_select_arm_A    0.000
      29 prob_select_arm_B    0.650
      30 prob_select_arm_C    0.000
      31  prob_select_none    0.350
      32              rmse    0.027
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
      2          size_mean 1180.000 117.710 122.314  972.375 1398.125
      3            size_sd  545.411  53.422  60.401  434.800  627.121
      4        size_median 1200.000 162.259 148.260  900.000 1300.000
      5           size_p25  675.000 170.202 148.260  500.000 1100.000
      6           size_p75 1425.000 304.644 185.325 1300.000 2000.000
      7            size_p0  500.000      NA      NA       NA       NA
      8          size_p100 2000.000      NA      NA       NA       NA
      9        sum_ys_mean  264.700  27.838  26.539  216.696  318.431
      10         sum_ys_sd  126.817  12.272  12.976  100.645  146.723
      11     sum_ys_median  260.000  40.243  37.806  185.000  321.637
      12        sum_ys_p25  143.500  34.475  26.687  123.000  259.000
      13        sum_ys_p75  350.250  60.381  94.516  267.919  450.625
      14         sum_ys_p0  105.000      NA      NA       NA       NA
      15       sum_ys_p100  470.000      NA      NA       NA       NA
      16     ratio_ys_mean    0.223   0.003   0.003    0.217    0.229
      17       ratio_ys_sd    0.015   0.002   0.002    0.011    0.017
      18   ratio_ys_median    0.224   0.006   0.004    0.211    0.233
      19      ratio_ys_p25    0.211   0.004   0.001    0.206    0.221
      20      ratio_ys_p75    0.234   0.004   0.002    0.224    0.238
      21       ratio_ys_p0    0.201      NA      NA       NA       NA
      22     ratio_ys_p100    0.253      NA      NA       NA       NA
      23   prob_conclusive    0.800   0.091   0.074    0.600    0.950
      24     prob_superior    0.650   0.113   0.074    0.448    0.876
      25  prob_equivalence    0.150   0.080   0.074    0.000    0.300
      26     prob_futility    0.000   0.000   0.000    0.000    0.000
      27          prob_max    0.200   0.091   0.074    0.050    0.400
      28 prob_select_arm_A    0.000   0.000   0.000    0.000    0.000
      29 prob_select_arm_B    0.650   0.113   0.074    0.448    0.876
      30 prob_select_arm_C    0.000   0.000   0.000    0.000    0.000
      31  prob_select_none    0.350   0.113   0.074    0.124    0.552
      32              rmse    0.027   0.003   0.003    0.020    0.033
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
      2          size_mean 1180.000 117.710 122.314 1051.875 1308.125
      3            size_sd  545.411  53.422  60.401  468.505  593.264
      4        size_median 1200.000 162.259 148.260 1000.000 1300.000
      5           size_p25  675.000 170.202 148.260  575.000  950.000
      6           size_p75 1425.000 304.644 185.325 1300.000 2000.000
      7            size_p0  500.000      NA      NA       NA       NA
      8          size_p100 2000.000      NA      NA       NA       NA
      9        sum_ys_mean  264.700  27.838  26.539  233.819  296.587
      10         sum_ys_sd  126.817  12.272  12.976  108.337  136.528
      11     sum_ys_median  260.000  40.243  37.806  201.000  294.812
      12        sum_ys_p25  143.500  34.475  26.687  126.000  198.000
      13        sum_ys_p75  350.250  60.381  94.516  298.000  430.000
      14         sum_ys_p0  105.000      NA      NA       NA       NA
      15       sum_ys_p100  470.000      NA      NA       NA       NA
      16     ratio_ys_mean    0.223   0.003   0.003    0.219    0.227
      17       ratio_ys_sd    0.015   0.002   0.002    0.012    0.016
      18   ratio_ys_median    0.224   0.006   0.004    0.213    0.230
      19      ratio_ys_p25    0.211   0.004   0.001    0.209    0.213
      20      ratio_ys_p75    0.234   0.004   0.002    0.230    0.235
      21       ratio_ys_p0    0.201      NA      NA       NA       NA
      22     ratio_ys_p100    0.253      NA      NA       NA       NA
      23   prob_conclusive    0.800   0.091   0.074    0.700    0.900
      24     prob_superior    0.650   0.113   0.074    0.550    0.800
      25  prob_equivalence    0.150   0.080   0.074    0.050    0.250
      26     prob_futility    0.000   0.000   0.000    0.000    0.000
      27          prob_max    0.200   0.091   0.074    0.100    0.300
      28 prob_select_arm_A    0.000   0.000   0.000    0.000    0.000
      29 prob_select_arm_B    0.650   0.113   0.074    0.550    0.800
      30 prob_select_arm_C    0.000   0.000   0.000    0.000    0.000
      31  prob_select_none    0.350   0.113   0.074    0.200    0.450
      32              rmse    0.027   0.003   0.003    0.024    0.031
      33           rmse_te       NA      NA      NA       NA       NA
      34               idp  100.000   0.000   0.000  100.000  100.000

---

    Code
      check_performance(res, restrict = "superior")
    Output
                    metric      est
      1       n_summarised   13.000
      2          size_mean  876.923
      3            size_sd  337.031
      4        size_median  800.000
      5           size_p25  600.000
      6           size_p75 1300.000
      7            size_p0  500.000
      8          size_p100 1300.000
      9        sum_ys_mean  190.769
      10         sum_ys_sd   73.574
      11     sum_ys_median  169.000
      12        sum_ys_p25  127.000
      13        sum_ys_p75  261.000
      14         sum_ys_p0  105.000
      15       sum_ys_p100  306.000
      16     ratio_ys_mean    0.218
      17       ratio_ys_sd    0.014
      18   ratio_ys_median    0.212
      19      ratio_ys_p25    0.210
      20      ratio_ys_p75    0.229
      21       ratio_ys_p0    0.201
      22     ratio_ys_p100    0.246
      23   prob_conclusive    0.800
      24     prob_superior    1.000
      25  prob_equivalence    0.000
      26     prob_futility    0.000
      27          prob_max    0.000
      28 prob_select_arm_A    0.000
      29 prob_select_arm_B    1.000
      30 prob_select_arm_C    0.000
      31  prob_select_none    0.000
      32              rmse    0.027
      33           rmse_te       NA
      34               idp  100.000

---

    Code
      check_performance(res, restrict = "selected")
    Output
                    metric      est
      1       n_summarised   13.000
      2          size_mean  876.923
      3            size_sd  337.031
      4        size_median  800.000
      5           size_p25  600.000
      6           size_p75 1300.000
      7            size_p0  500.000
      8          size_p100 1300.000
      9        sum_ys_mean  190.769
      10         sum_ys_sd   73.574
      11     sum_ys_median  169.000
      12        sum_ys_p25  127.000
      13        sum_ys_p75  261.000
      14         sum_ys_p0  105.000
      15       sum_ys_p100  306.000
      16     ratio_ys_mean    0.218
      17       ratio_ys_sd    0.014
      18   ratio_ys_median    0.212
      19      ratio_ys_p25    0.210
      20      ratio_ys_p75    0.229
      21       ratio_ys_p0    0.201
      22     ratio_ys_p100    0.246
      23   prob_conclusive    0.800
      24     prob_superior    1.000
      25  prob_equivalence    0.000
      26     prob_futility    0.000
      27          prob_max    0.000
      28 prob_select_arm_A    0.000
      29 prob_select_arm_B    1.000
      30 prob_select_arm_C    0.000
      31  prob_select_none    0.000
      32              rmse    0.027
      33           rmse_te       NA
      34               idp  100.000

---

    Code
      check_performance(res, restrict = "superior", uncertainty = TRUE, boot_seed = "base",
        n_boot = 100)
    Warning <simpleWarning>
      values for n_boot < 1000 are not recommended, as they may cause instable results.
    Output
                    metric      est  err_sd err_mad   lo_ci    hi_ci
      1       n_summarised   13.000   2.263   1.483   8.950   17.525
      2          size_mean  876.923  83.733  75.674 697.955 1022.404
      3            size_sd  337.031  35.398  28.245 245.478  387.061
      4        size_median  800.000 165.132 148.260 600.000 1150.000
      5           size_p25  600.000  82.601  74.130 500.000  800.000
      6           size_p75 1300.000 177.244   0.000 747.500 1300.000
      7            size_p0  500.000      NA      NA      NA       NA
      8          size_p100 1300.000      NA      NA      NA       NA
      9        sum_ys_mean  190.769  18.573  15.555 152.990  224.084
      10         sum_ys_sd   73.574   8.575   7.382  50.419   85.580
      11     sum_ys_median  169.000  32.921  38.548 127.000  241.000
      12        sum_ys_p25  127.000  14.101  14.085 111.081  169.000
      13        sum_ys_p75  261.000  38.251  30.393 157.188  300.100
      14         sum_ys_p0  105.000      NA      NA      NA       NA
      15       sum_ys_p100  306.000      NA      NA      NA       NA
      16     ratio_ys_mean    0.218   0.003   0.003   0.212    0.224
      17       ratio_ys_sd    0.014   0.002   0.002   0.009    0.017
      18   ratio_ys_median    0.212   0.006   0.007   0.209    0.229
      19      ratio_ys_p25    0.210   0.003   0.002   0.201    0.212
      20      ratio_ys_p75    0.229   0.006   0.005   0.212    0.235
      21       ratio_ys_p0    0.201      NA      NA      NA       NA
      22     ratio_ys_p100    0.246      NA      NA      NA       NA
      23   prob_conclusive    0.800   0.091   0.074   0.600    0.950
      24     prob_superior    1.000   0.000   0.000   1.000    1.000
      25  prob_equivalence    0.000   0.000   0.000   0.000    0.000
      26     prob_futility    0.000   0.000   0.000   0.000    0.000
      27          prob_max    0.000   0.000   0.000   0.000    0.000
      28 prob_select_arm_A    0.000   0.000   0.000   0.000    0.000
      29 prob_select_arm_B    1.000   0.000   0.000   1.000    1.000
      30 prob_select_arm_C    0.000   0.000   0.000   0.000    0.000
      31  prob_select_none    0.000   0.000   0.000   0.000    0.000
      32              rmse    0.027   0.003   0.003   0.020    0.033
      33           rmse_te       NA      NA      NA      NA       NA
      34               idp  100.000   0.000   0.000 100.000  100.000

---

    Code
      check_performance(res, restrict = "selected", uncertainty = TRUE, boot_seed = "base",
        n_boot = 100)
    Warning <simpleWarning>
      values for n_boot < 1000 are not recommended, as they may cause instable results.
    Output
                    metric      est  err_sd err_mad   lo_ci    hi_ci
      1       n_summarised   13.000   2.263   1.483   8.950   17.525
      2          size_mean  876.923  83.733  75.674 697.955 1022.404
      3            size_sd  337.031  35.398  28.245 245.478  387.061
      4        size_median  800.000 165.132 148.260 600.000 1150.000
      5           size_p25  600.000  82.601  74.130 500.000  800.000
      6           size_p75 1300.000 177.244   0.000 747.500 1300.000
      7            size_p0  500.000      NA      NA      NA       NA
      8          size_p100 1300.000      NA      NA      NA       NA
      9        sum_ys_mean  190.769  18.573  15.555 152.990  224.084
      10         sum_ys_sd   73.574   8.575   7.382  50.419   85.580
      11     sum_ys_median  169.000  32.921  38.548 127.000  241.000
      12        sum_ys_p25  127.000  14.101  14.085 111.081  169.000
      13        sum_ys_p75  261.000  38.251  30.393 157.188  300.100
      14         sum_ys_p0  105.000      NA      NA      NA       NA
      15       sum_ys_p100  306.000      NA      NA      NA       NA
      16     ratio_ys_mean    0.218   0.003   0.003   0.212    0.224
      17       ratio_ys_sd    0.014   0.002   0.002   0.009    0.017
      18   ratio_ys_median    0.212   0.006   0.007   0.209    0.229
      19      ratio_ys_p25    0.210   0.003   0.002   0.201    0.212
      20      ratio_ys_p75    0.229   0.006   0.005   0.212    0.235
      21       ratio_ys_p0    0.201      NA      NA      NA       NA
      22     ratio_ys_p100    0.246      NA      NA      NA       NA
      23   prob_conclusive    0.800   0.091   0.074   0.600    0.950
      24     prob_superior    1.000   0.000   0.000   1.000    1.000
      25  prob_equivalence    0.000   0.000   0.000   0.000    0.000
      26     prob_futility    0.000   0.000   0.000   0.000    0.000
      27          prob_max    0.000   0.000   0.000   0.000    0.000
      28 prob_select_arm_A    0.000   0.000   0.000   0.000    0.000
      29 prob_select_arm_B    1.000   0.000   0.000   1.000    1.000
      30 prob_select_arm_C    0.000   0.000   0.000   0.000    0.000
      31  prob_select_none    0.000   0.000   0.000   0.000    0.000
      32              rmse    0.027   0.003   0.003   0.020    0.033
      33           rmse_te       NA      NA      NA      NA       NA
      34               idp  100.000   0.000   0.000 100.000  100.000

