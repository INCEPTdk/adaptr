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
      2          size_mean 1180.000 122.135 118.608  932.125 1433.375
      3            size_sd  545.411  52.072  54.468  419.645  616.803
      4        size_median 1200.000 175.640 148.260  773.750 1300.000
      5           size_p25  675.000 183.102 148.260  500.000 1075.000
      6           size_p75 1425.000 294.608 259.455 1300.000 2000.000
      7            size_p0  500.000      NA      NA       NA       NA
      8          size_p100 2000.000      NA      NA       NA       NA
      9        sum_ys_mean  264.700  27.965  28.874  210.791  324.089
      10         sum_ys_sd  126.817  11.896  12.228   99.744  143.121
      11     sum_ys_median  260.000  42.943  33.729  162.700  317.500
      12        sum_ys_p25  143.500  37.735  27.428  120.844  249.500
      13        sum_ys_p75  350.250  58.970  94.516  264.000  448.000
      14         sum_ys_p0  105.000      NA      NA       NA       NA
      15       sum_ys_p100  470.000      NA      NA       NA       NA
      16     ratio_ys_mean    0.223   0.003   0.003    0.218    0.230
      17       ratio_ys_sd    0.015   0.002   0.002    0.010    0.018
      18   ratio_ys_median    0.224   0.006   0.004    0.211    0.232
      19      ratio_ys_p25    0.211   0.004   0.001    0.206    0.223
      20      ratio_ys_p75    0.234   0.003   0.002    0.224    0.238
      21       ratio_ys_p0    0.201      NA      NA       NA       NA
      22     ratio_ys_p100    0.253      NA      NA       NA       NA
      23   prob_conclusive    0.800   0.083   0.074    0.600    0.926
      24     prob_superior    0.650   0.100   0.148    0.450    0.800
      25  prob_equivalence    0.150   0.084   0.074    0.000    0.300
      26     prob_futility    0.000   0.000   0.000    0.000    0.000
      27          prob_max    0.200   0.083   0.074    0.074    0.400
      28 prob_select_arm_A    0.000   0.000   0.000    0.000    0.000
      29 prob_select_arm_B    0.650   0.100   0.148    0.450    0.800
      30 prob_select_arm_C    0.000   0.000   0.000    0.000    0.000
      31  prob_select_none    0.350   0.100   0.148    0.200    0.550
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
      2          size_mean 1180.000 122.135 118.608 1060.000 1318.125
      3            size_sd  545.411  52.072  54.468  470.515  590.517
      4        size_median 1200.000 175.640 148.260  918.750 1300.000
      5           size_p25  675.000 183.102 148.260  575.000 1000.000
      6           size_p75 1425.000 294.608 259.455 1300.000 2000.000
      7            size_p0  500.000      NA      NA       NA       NA
      8          size_p100 2000.000      NA      NA       NA       NA
      9        sum_ys_mean  264.700  27.965  28.874  238.094  297.869
      10         sum_ys_sd  126.817  11.896  12.228  110.255  138.306
      11     sum_ys_median  260.000  42.943  33.729  201.000  289.500
      12        sum_ys_p25  143.500  37.735  27.428  126.000  205.750
      13        sum_ys_p75  350.250  58.970  94.516  298.000  426.000
      14         sum_ys_p0  105.000      NA      NA       NA       NA
      15       sum_ys_p100  470.000      NA      NA       NA       NA
      16     ratio_ys_mean    0.223   0.003   0.003    0.219    0.226
      17       ratio_ys_sd    0.015   0.002   0.002    0.012    0.016
      18   ratio_ys_median    0.224   0.006   0.004    0.213    0.230
      19      ratio_ys_p25    0.211   0.004   0.001    0.210    0.213
      20      ratio_ys_p75    0.234   0.003   0.002    0.230    0.235
      21       ratio_ys_p0    0.201      NA      NA       NA       NA
      22     ratio_ys_p100    0.253      NA      NA       NA       NA
      23   prob_conclusive    0.800   0.083   0.074    0.700    0.881
      24     prob_superior    0.650   0.100   0.148    0.500    0.750
      25  prob_equivalence    0.150   0.084   0.074    0.050    0.250
      26     prob_futility    0.000   0.000   0.000    0.000    0.000
      27          prob_max    0.200   0.083   0.074    0.119    0.300
      28 prob_select_arm_A    0.000   0.000   0.000    0.000    0.000
      29 prob_select_arm_B    0.650   0.100   0.148    0.500    0.750
      30 prob_select_arm_C    0.000   0.000   0.000    0.000    0.000
      31  prob_select_none    0.350   0.100   0.148    0.250    0.500
      32              rmse    0.027   0.003   0.003    0.024    0.030
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
      1       n_summarised   13.000   2.071   1.483   9.475   17.000
      2          size_mean  876.923  97.625  86.247 691.270 1064.708
      3            size_sd  337.031  35.926  32.992 249.311  377.440
      4        size_median  800.000 218.754 296.520 500.000 1300.000
      5           size_p25  600.000 103.503 111.195 500.000  800.000
      6           size_p75 1300.000 170.487   0.000 800.000 1300.000
      7            size_p0  500.000      NA      NA      NA       NA
      8          size_p100 1300.000      NA      NA      NA       NA
      9        sum_ys_mean  190.769  21.392  20.418 150.394  232.692
      10         sum_ys_sd   73.574   9.190   8.025  51.914   84.845
      11     sum_ys_median  169.000  41.570  44.478 123.000  273.000
      12        sum_ys_p25  127.000  17.857  15.567 106.663  169.525
      13        sum_ys_p75  261.000  39.131  45.034 169.000  299.050
      14         sum_ys_p0  105.000      NA      NA      NA       NA
      15       sum_ys_p100  306.000      NA      NA      NA       NA
      16     ratio_ys_mean    0.218   0.004   0.004   0.210    0.227
      17       ratio_ys_sd    0.014   0.002   0.002   0.009    0.017
      18   ratio_ys_median    0.212   0.007   0.002   0.209    0.229
      19      ratio_ys_p25    0.210   0.004   0.002   0.201    0.218
      20      ratio_ys_p75    0.229   0.007   0.007   0.212    0.239
      21       ratio_ys_p0    0.201      NA      NA      NA       NA
      22     ratio_ys_p100    0.246      NA      NA      NA       NA
      23   prob_conclusive    0.800   0.081   0.074   0.650    0.950
      24     prob_superior    1.000   0.000   0.000   1.000    1.000
      25  prob_equivalence    0.000   0.000   0.000   0.000    0.000
      26     prob_futility    0.000   0.000   0.000   0.000    0.000
      27          prob_max    0.000   0.000   0.000   0.000    0.000
      28 prob_select_arm_A    0.000   0.000   0.000   0.000    0.000
      29 prob_select_arm_B    1.000   0.000   0.000   1.000    1.000
      30 prob_select_arm_C    0.000   0.000   0.000   0.000    0.000
      31  prob_select_none    0.000   0.000   0.000   0.000    0.000
      32              rmse    0.027   0.004   0.004   0.022    0.036
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
      1       n_summarised   13.000   2.071   1.483   9.475   17.000
      2          size_mean  876.923  97.625  86.247 691.270 1064.708
      3            size_sd  337.031  35.926  32.992 249.311  377.440
      4        size_median  800.000 218.754 296.520 500.000 1300.000
      5           size_p25  600.000 103.503 111.195 500.000  800.000
      6           size_p75 1300.000 170.487   0.000 800.000 1300.000
      7            size_p0  500.000      NA      NA      NA       NA
      8          size_p100 1300.000      NA      NA      NA       NA
      9        sum_ys_mean  190.769  21.392  20.418 150.394  232.692
      10         sum_ys_sd   73.574   9.190   8.025  51.914   84.845
      11     sum_ys_median  169.000  41.570  44.478 123.000  273.000
      12        sum_ys_p25  127.000  17.857  15.567 106.663  169.525
      13        sum_ys_p75  261.000  39.131  45.034 169.000  299.050
      14         sum_ys_p0  105.000      NA      NA      NA       NA
      15       sum_ys_p100  306.000      NA      NA      NA       NA
      16     ratio_ys_mean    0.218   0.004   0.004   0.210    0.227
      17       ratio_ys_sd    0.014   0.002   0.002   0.009    0.017
      18   ratio_ys_median    0.212   0.007   0.002   0.209    0.229
      19      ratio_ys_p25    0.210   0.004   0.002   0.201    0.218
      20      ratio_ys_p75    0.229   0.007   0.007   0.212    0.239
      21       ratio_ys_p0    0.201      NA      NA      NA       NA
      22     ratio_ys_p100    0.246      NA      NA      NA       NA
      23   prob_conclusive    0.800   0.081   0.074   0.650    0.950
      24     prob_superior    1.000   0.000   0.000   1.000    1.000
      25  prob_equivalence    0.000   0.000   0.000   0.000    0.000
      26     prob_futility    0.000   0.000   0.000   0.000    0.000
      27          prob_max    0.000   0.000   0.000   0.000    0.000
      28 prob_select_arm_A    0.000   0.000   0.000   0.000    0.000
      29 prob_select_arm_B    1.000   0.000   0.000   1.000    1.000
      30 prob_select_arm_C    0.000   0.000   0.000   0.000    0.000
      31  prob_select_none    0.000   0.000   0.000   0.000    0.000
      32              rmse    0.027   0.004   0.004   0.022    0.036
      33           rmse_te       NA      NA      NA      NA       NA
      34               idp  100.000   0.000   0.000 100.000  100.000

