# Status extraction works

    Code
      extract_statuses(results, x_value = "look")
    Output
          x      status          p
      1   1  Recruiting 0.84999999
      2   2  Recruiting 0.59999999
      3   3  Recruiting 0.44999999
      4   4  Recruiting 0.39999999
      5   5  Recruiting 0.29999999
      6   6  Recruiting 0.19999999
      7   7  Recruiting 0.19999999
      8   8  Recruiting 0.14999999
      9   9  Recruiting 0.14999999
      10 10  Recruiting 0.14999999
      11 11  Recruiting 0.04999999
      12 12  Recruiting 0.04999999
      13 13  Recruiting 0.04999999
      14 14  Recruiting 0.04999999
      15 15  Recruiting 0.04999999
      16 16  Recruiting 0.04999999
      17 17  Recruiting 0.04999999
      18 18  Recruiting 0.04999999
      37  1    Futility 0.15000000
      38  2    Futility 0.40000000
      39  3    Futility 0.55000000
      40  4    Futility 0.60000000
      41  5    Futility 0.70000000
      42  6    Futility 0.75000000
      43  7    Futility 0.75000000
      44  8    Futility 0.75000000
      45  9    Futility 0.75000000
      46 10    Futility 0.75000000
      47 11    Futility 0.80000000
      48 12    Futility 0.80000000
      49 13    Futility 0.80000000
      50 14    Futility 0.80000000
      51 15    Futility 0.80000000
      52 16    Futility 0.80000000
      53 17    Futility 0.80000000
      54 18    Futility 0.80000000
      55  1 Equivalence 0.00000000
      56  2 Equivalence 0.00000000
      57  3 Equivalence 0.00000000
      58  4 Equivalence 0.00000000
      59  5 Equivalence 0.00000000
      60  6 Equivalence 0.00000000
      61  7 Equivalence 0.00000000
      62  8 Equivalence 0.05000000
      63  9 Equivalence 0.05000000
      64 10 Equivalence 0.05000000
      65 11 Equivalence 0.10000000
      66 12 Equivalence 0.10000000
      67 13 Equivalence 0.10000000
      68 14 Equivalence 0.10000000
      69 15 Equivalence 0.10000000
      70 16 Equivalence 0.10000000
      71 17 Equivalence 0.10000000
      72 18 Equivalence 0.10000000
      73  1 Superiority 0.00000000
      74  2 Superiority 0.00000000
      75  3 Superiority 0.00000000
      76  4 Superiority 0.00000000
      77  5 Superiority 0.00000000
      78  6 Superiority 0.05000000
      79  7 Superiority 0.05000000
      80  8 Superiority 0.05000000
      81  9 Superiority 0.05000000
      82 10 Superiority 0.05000000
      83 11 Superiority 0.05000000
      84 12 Superiority 0.05000000
      85 13 Superiority 0.05000000
      86 14 Superiority 0.05000000
      87 15 Superiority 0.05000000
      88 16 Superiority 0.05000000
      89 17 Superiority 0.05000000
      90 18 Superiority 0.05000000

---

    Code
      extract_statuses(results, x_value = "n")
    Output
          i   nf   nr          p      status
      1   1  300  300 0.84999999  Recruiting
      2   2  400  400 0.59999999  Recruiting
      3   3  500  500 0.44999999  Recruiting
      4   4  600  600 0.39999999  Recruiting
      5   5  700  700 0.29999999  Recruiting
      6   6  800  800 0.19999999  Recruiting
      7   7  900  900 0.19999999  Recruiting
      8   8 1000 1000 0.14999999  Recruiting
      9   9 1100 1100 0.14999999  Recruiting
      10 10 1200 1200 0.14999999  Recruiting
      11 11 1300 1300 0.04999999  Recruiting
      12 12 1400 1400 0.04999999  Recruiting
      13 13 1500 1500 0.04999999  Recruiting
      14 14 1600 1600 0.04999999  Recruiting
      15 15 1700 1700 0.04999999  Recruiting
      16 16 1800 1800 0.04999999  Recruiting
      17 17 1900 1900 0.04999999  Recruiting
      18 18 2000 2000 0.04999999  Recruiting
      37  1  300  300 0.15000000    Futility
      38  2  400  400 0.40000000    Futility
      39  3  500  500 0.55000000    Futility
      40  4  600  600 0.60000000    Futility
      41  5  700  700 0.70000000    Futility
      42  6  800  800 0.75000000    Futility
      43  7  900  900 0.75000000    Futility
      44  8 1000 1000 0.75000000    Futility
      45  9 1100 1100 0.75000000    Futility
      46 10 1200 1200 0.75000000    Futility
      47 11 1300 1300 0.80000000    Futility
      48 12 1400 1400 0.80000000    Futility
      49 13 1500 1500 0.80000000    Futility
      50 14 1600 1600 0.80000000    Futility
      51 15 1700 1700 0.80000000    Futility
      52 16 1800 1800 0.80000000    Futility
      53 17 1900 1900 0.80000000    Futility
      54 18 2000 2000 0.80000000    Futility
      55  1  300  300 0.00000000 Equivalence
      56  2  400  400 0.00000000 Equivalence
      57  3  500  500 0.00000000 Equivalence
      58  4  600  600 0.00000000 Equivalence
      59  5  700  700 0.00000000 Equivalence
      60  6  800  800 0.00000000 Equivalence
      61  7  900  900 0.00000000 Equivalence
      62  8 1000 1000 0.05000000 Equivalence
      63  9 1100 1100 0.05000000 Equivalence
      64 10 1200 1200 0.05000000 Equivalence
      65 11 1300 1300 0.10000000 Equivalence
      66 12 1400 1400 0.10000000 Equivalence
      67 13 1500 1500 0.10000000 Equivalence
      68 14 1600 1600 0.10000000 Equivalence
      69 15 1700 1700 0.10000000 Equivalence
      70 16 1800 1800 0.10000000 Equivalence
      71 17 1900 1900 0.10000000 Equivalence
      72 18 2000 2000 0.10000000 Equivalence
      73  1  300  300 0.00000000 Superiority
      74  2  400  400 0.00000000 Superiority
      75  3  500  500 0.00000000 Superiority
      76  4  600  600 0.00000000 Superiority
      77  5  700  700 0.00000000 Superiority
      78  6  800  800 0.05000000 Superiority
      79  7  900  900 0.05000000 Superiority
      80  8 1000 1000 0.05000000 Superiority
      81  9 1100 1100 0.05000000 Superiority
      82 10 1200 1200 0.05000000 Superiority
      83 11 1300 1300 0.05000000 Superiority
      84 12 1400 1400 0.05000000 Superiority
      85 13 1500 1500 0.05000000 Superiority
      86 14 1600 1600 0.05000000 Superiority
      87 15 1700 1700 0.05000000 Superiority
      88 16 1800 1800 0.05000000 Superiority
      89 17 1900 1900 0.05000000 Superiority
      90 18 2000 2000 0.05000000 Superiority

