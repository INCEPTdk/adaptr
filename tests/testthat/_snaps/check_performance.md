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
      7        sum_ys_mean  264.700
      8          sum_ys_sd  126.817
      9      sum_ys_median  260.000
      10        sum_ys_p25  143.500
      11        sum_ys_p75  350.250
      12     ratio_ys_mean    0.223
      13       ratio_ys_sd    0.015
      14   ratio_ys_median    0.224
      15      ratio_ys_p25    0.211
      16      ratio_ys_p75    0.234
      17   prob_conclusive    0.800
      18     prob_superior    0.650
      19  prob_equivalence    0.150
      20     prob_futility    0.000
      21          prob_max    0.200
      22 prob_select_arm_A    0.000
      23 prob_select_arm_B    0.650
      24 prob_select_arm_C    0.000
      25  prob_select_none    0.350
      26              rmse    0.027
      27           rmse_te       NA
      28               idp  100.000

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
      7        sum_ys_mean  264.700
      8          sum_ys_sd  126.817
      9      sum_ys_median  260.000
      10        sum_ys_p25  143.500
      11        sum_ys_p75  350.250
      12     ratio_ys_mean    0.223
      13       ratio_ys_sd    0.015
      14   ratio_ys_median    0.224
      15      ratio_ys_p25    0.211
      16      ratio_ys_p75    0.234
      17   prob_conclusive    0.800
      18     prob_superior    0.650
      19  prob_equivalence    0.150
      20     prob_futility    0.000
      21          prob_max    0.200
      22 prob_select_arm_A    0.000
      23 prob_select_arm_B    0.650
      24 prob_select_arm_C    0.000
      25  prob_select_none    0.350
      26              rmse    0.027
      27           rmse_te       NA
      28               idp  100.000

---

    Code
      check_performance(res, uncertainty = TRUE, boot_seed = 4131, n_boot = 100)
    Warning <simpleWarning>
      values for n_boot < 1000 are not recommended, as they may cause instable results.
    Output
                    metric      est  err_sd err_mad    lo_ci    hi_ci
      1       n_summarised   20.000   0.000   0.000   20.000   20.000
      2          size_mean 1180.000 109.905 118.608  984.750 1380.250
      3            size_sd  545.411  60.743  61.818  417.849  618.539
      4        size_median 1200.000 158.723 222.390  800.000 1300.000
      5           size_p25  675.000 162.311 129.727  500.000 1075.000
      6           size_p75 1425.000 287.933 185.325 1300.000 2000.000
      7        sum_ys_mean  264.700  25.816  28.206  216.875  311.785
      8          sum_ys_sd  126.817  13.512  13.040   97.905  142.000
      9      sum_ys_median  260.000  37.578  31.505  169.000  309.937
      10        sum_ys_p25  143.500  34.362  25.575  123.000  249.500
      11        sum_ys_p75  350.250  56.771  54.856  271.244  453.000
      12     ratio_ys_mean    0.223   0.003   0.003    0.217    0.228
      13       ratio_ys_sd    0.015   0.002   0.002    0.011    0.018
      14   ratio_ys_median    0.224   0.006   0.008    0.211    0.230
      15      ratio_ys_p25    0.211   0.004   0.001    0.207    0.222
      16      ratio_ys_p75    0.234   0.003   0.002    0.227    0.235
      17   prob_conclusive    0.800   0.084   0.074    0.650    0.950
      18     prob_superior    0.650   0.105   0.074    0.450    0.850
      19  prob_equivalence    0.150   0.085   0.074    0.000    0.300
      20     prob_futility    0.000   0.000   0.000    0.000    0.000
      21          prob_max    0.200   0.084   0.074    0.050    0.350
      22 prob_select_arm_A    0.000   0.000   0.000    0.000    0.000
      23 prob_select_arm_B    0.650   0.105   0.074    0.450    0.850
      24 prob_select_arm_C    0.000   0.000   0.000    0.000    0.000
      25  prob_select_none    0.350   0.105   0.074    0.150    0.550
      26              rmse    0.027   0.004   0.004    0.020    0.036
      27           rmse_te       NA      NA      NA       NA       NA
      28               idp  100.000   0.000   0.000  100.000  100.000

---

    Code
      check_performance(res, uncertainty = TRUE, ci_width = 0.75, boot_seed = 4131,
        n_boot = 100)
    Warning <simpleWarning>
      values for n_boot < 1000 are not recommended, as they may cause instable results.
    Output
                    metric      est  err_sd err_mad    lo_ci    hi_ci
      1       n_summarised   20.000   0.000   0.000   20.000   20.000
      2          size_mean 1180.000 109.905 118.608 1056.875 1303.125
      3            size_sd  545.411  60.743  61.818  462.758  585.819
      4        size_median 1200.000 158.723 222.390 1000.000 1300.000
      5           size_p25  675.000 162.311 129.727  575.000  965.625
      6           size_p75 1425.000 287.933 185.325 1300.000 2000.000
      7        sum_ys_mean  264.700  25.816  28.206  236.806  295.619
      8          sum_ys_sd  126.817  13.512  13.040  106.410  135.780
      9      sum_ys_median  260.000  37.578  31.505  205.375  285.500
      10        sum_ys_p25  143.500  34.362  25.575  127.000  201.000
      11        sum_ys_p75  350.250  56.771  54.856  300.000  426.000
      12     ratio_ys_mean    0.223   0.003   0.003    0.220    0.226
      13       ratio_ys_sd    0.015   0.002   0.002    0.012    0.017
      14   ratio_ys_median    0.224   0.006   0.008    0.212    0.230
      15      ratio_ys_p25    0.211   0.004   0.001    0.209    0.213
      16      ratio_ys_p75    0.234   0.003   0.002    0.230    0.235
      17   prob_conclusive    0.800   0.084   0.074    0.700    0.900
      18     prob_superior    0.650   0.105   0.074    0.519    0.750
      19  prob_equivalence    0.150   0.085   0.074    0.050    0.250
      20     prob_futility    0.000   0.000   0.000    0.000    0.000
      21          prob_max    0.200   0.084   0.074    0.100    0.300
      22 prob_select_arm_A    0.000   0.000   0.000    0.000    0.000
      23 prob_select_arm_B    0.650   0.105   0.074    0.519    0.750
      24 prob_select_arm_C    0.000   0.000   0.000    0.000    0.000
      25  prob_select_none    0.350   0.105   0.074    0.250    0.481
      26              rmse    0.027   0.004   0.004    0.024    0.032
      27           rmse_te       NA      NA      NA       NA       NA
      28               idp  100.000   0.000   0.000  100.000  100.000

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
      7        sum_ys_mean  190.769
      8          sum_ys_sd   73.574
      9      sum_ys_median  169.000
      10        sum_ys_p25  127.000
      11        sum_ys_p75  261.000
      12     ratio_ys_mean    0.218
      13       ratio_ys_sd    0.014
      14   ratio_ys_median    0.212
      15      ratio_ys_p25    0.210
      16      ratio_ys_p75    0.229
      17   prob_conclusive    0.800
      18     prob_superior    1.000
      19  prob_equivalence    0.000
      20     prob_futility    0.000
      21          prob_max    0.000
      22 prob_select_arm_A    0.000
      23 prob_select_arm_B    1.000
      24 prob_select_arm_C    0.000
      25  prob_select_none    0.000
      26              rmse    0.027
      27           rmse_te       NA
      28               idp  100.000

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
      7        sum_ys_mean  190.769
      8          sum_ys_sd   73.574
      9      sum_ys_median  169.000
      10        sum_ys_p25  127.000
      11        sum_ys_p75  261.000
      12     ratio_ys_mean    0.218
      13       ratio_ys_sd    0.014
      14   ratio_ys_median    0.212
      15      ratio_ys_p25    0.210
      16      ratio_ys_p75    0.229
      17   prob_conclusive    0.800
      18     prob_superior    1.000
      19  prob_equivalence    0.000
      20     prob_futility    0.000
      21          prob_max    0.000
      22 prob_select_arm_A    0.000
      23 prob_select_arm_B    1.000
      24 prob_select_arm_C    0.000
      25  prob_select_none    0.000
      26              rmse    0.027
      27           rmse_te       NA
      28               idp  100.000

