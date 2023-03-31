# Status extraction works

    Code
      extract_statuses(results, x_value = "look")
    Output
          x      status          p
      1   1  Recruiting 0.84999999
      2   2  Recruiting 0.74999999
      3   3  Recruiting 0.59999999
      4   4  Recruiting 0.59999999
      5   5  Recruiting 0.44999999
      6   6  Recruiting 0.44999999
      7   7  Recruiting 0.29999999
      8   8  Recruiting 0.29999999
      9   9  Recruiting 0.19999999
      10 10  Recruiting 0.14999999
      11 11  Recruiting 0.09999999
      12 12  Recruiting 0.04999999
      13 13  Recruiting 0.04999999
      14 14  Recruiting 0.04999999
      15 15  Recruiting 0.04999999
      16 16  Recruiting 0.04999999
      17 17  Recruiting 0.00000000
      35  1    Futility 0.15000000
      36  2    Futility 0.25000000
      37  3    Futility 0.35000000
      38  4    Futility 0.35000000
      39  5    Futility 0.45000000
      40  6    Futility 0.45000000
      41  7    Futility 0.55000000
      42  8    Futility 0.55000000
      43  9    Futility 0.65000000
      44 10    Futility 0.65000000
      45 11    Futility 0.70000000
      46 12    Futility 0.75000000
      47 13    Futility 0.75000000
      48 14    Futility 0.75000000
      49 15    Futility 0.75000000
      50 16    Futility 0.75000000
      51 17    Futility 0.75000000
      52  1 Equivalence 0.00000000
      53  2 Equivalence 0.00000000
      54  3 Equivalence 0.00000000
      55  4 Equivalence 0.00000000
      56  5 Equivalence 0.00000000
      57  6 Equivalence 0.00000000
      58  7 Equivalence 0.00000000
      59  8 Equivalence 0.00000000
      60  9 Equivalence 0.00000000
      61 10 Equivalence 0.00000000
      62 11 Equivalence 0.00000000
      63 12 Equivalence 0.00000000
      64 13 Equivalence 0.00000000
      65 14 Equivalence 0.00000000
      66 15 Equivalence 0.00000000
      67 16 Equivalence 0.00000000
      68 17 Equivalence 0.00000000
      69  1 Superiority 0.00000000
      70  2 Superiority 0.00000000
      71  3 Superiority 0.05000000
      72  4 Superiority 0.05000000
      73  5 Superiority 0.10000000
      74  6 Superiority 0.10000000
      75  7 Superiority 0.15000000
      76  8 Superiority 0.15000000
      77  9 Superiority 0.15000000
      78 10 Superiority 0.20000000
      79 11 Superiority 0.20000000
      80 12 Superiority 0.20000000
      81 13 Superiority 0.20000000
      82 14 Superiority 0.20000000
      83 15 Superiority 0.20000000
      84 16 Superiority 0.20000000
      85 17 Superiority 0.25000000

---

    Code
      extract_statuses(results, x_value = "n")
    Output
          i   nf   nr          p      status
      1   1  300  300 0.84999999  Recruiting
      2   2  400  400 0.74999999  Recruiting
      3   3  500  500 0.59999999  Recruiting
      4   4  600  600 0.59999999  Recruiting
      5   5  700  700 0.44999999  Recruiting
      6   6  800  800 0.44999999  Recruiting
      7   7  900  900 0.29999999  Recruiting
      8   8 1000 1000 0.29999999  Recruiting
      9   9 1100 1100 0.19999999  Recruiting
      10 10 1200 1200 0.14999999  Recruiting
      11 11 1300 1300 0.09999999  Recruiting
      12 12 1400 1400 0.04999999  Recruiting
      13 13 1500 1500 0.04999999  Recruiting
      14 14 1600 1600 0.04999999  Recruiting
      15 15 1700 1700 0.04999999  Recruiting
      16 16 1800 1800 0.04999999  Recruiting
      17 17 1900 1900 0.00000000  Recruiting
      35  1  300  300 0.15000000    Futility
      36  2  400  400 0.25000000    Futility
      37  3  500  500 0.35000000    Futility
      38  4  600  600 0.35000000    Futility
      39  5  700  700 0.45000000    Futility
      40  6  800  800 0.45000000    Futility
      41  7  900  900 0.55000000    Futility
      42  8 1000 1000 0.55000000    Futility
      43  9 1100 1100 0.65000000    Futility
      44 10 1200 1200 0.65000000    Futility
      45 11 1300 1300 0.70000000    Futility
      46 12 1400 1400 0.75000000    Futility
      47 13 1500 1500 0.75000000    Futility
      48 14 1600 1600 0.75000000    Futility
      49 15 1700 1700 0.75000000    Futility
      50 16 1800 1800 0.75000000    Futility
      51 17 1900 1900 0.75000000    Futility
      52  1  300  300 0.00000000 Equivalence
      53  2  400  400 0.00000000 Equivalence
      54  3  500  500 0.00000000 Equivalence
      55  4  600  600 0.00000000 Equivalence
      56  5  700  700 0.00000000 Equivalence
      57  6  800  800 0.00000000 Equivalence
      58  7  900  900 0.00000000 Equivalence
      59  8 1000 1000 0.00000000 Equivalence
      60  9 1100 1100 0.00000000 Equivalence
      61 10 1200 1200 0.00000000 Equivalence
      62 11 1300 1300 0.00000000 Equivalence
      63 12 1400 1400 0.00000000 Equivalence
      64 13 1500 1500 0.00000000 Equivalence
      65 14 1600 1600 0.00000000 Equivalence
      66 15 1700 1700 0.00000000 Equivalence
      67 16 1800 1800 0.00000000 Equivalence
      68 17 1900 1900 0.00000000 Equivalence
      69  1  300  300 0.00000000 Superiority
      70  2  400  400 0.00000000 Superiority
      71  3  500  500 0.05000000 Superiority
      72  4  600  600 0.05000000 Superiority
      73  5  700  700 0.10000000 Superiority
      74  6  800  800 0.10000000 Superiority
      75  7  900  900 0.15000000 Superiority
      76  8 1000 1000 0.15000000 Superiority
      77  9 1100 1100 0.15000000 Superiority
      78 10 1200 1200 0.20000000 Superiority
      79 11 1300 1300 0.20000000 Superiority
      80 12 1400 1400 0.20000000 Superiority
      81 13 1500 1500 0.20000000 Superiority
      82 14 1600 1600 0.20000000 Superiority
      83 15 1700 1700 0.20000000 Superiority
      84 16 1800 1800 0.20000000 Superiority
      85 17 1900 1900 0.25000000 Superiority

---

    Code
      extract_statuses(res, x_value = "look")
    Output
         x      status    p
      1  1  Recruiting 1.00
      2  2  Recruiting 0.95
      3  3  Recruiting 0.95
      4  4  Recruiting 0.95
      5  5  Recruiting 0.95
      21 1 Superiority 0.00
      22 2 Superiority 0.05
      23 3 Superiority 0.05
      24 4 Superiority 0.05
      25 5 Superiority 0.05

