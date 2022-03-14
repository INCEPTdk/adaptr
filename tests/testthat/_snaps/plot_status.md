# Status extraction works

    Code
      extract_statuses(results, x_value = "look")
    Output
          x      status    p
      1   1  Recruiting 0.85
      2   2  Recruiting 0.60
      3   3  Recruiting 0.45
      4   4  Recruiting 0.40
      5   5  Recruiting 0.30
      6   6  Recruiting 0.20
      7   7  Recruiting 0.20
      8   8  Recruiting 0.15
      9   9  Recruiting 0.15
      10 10  Recruiting 0.15
      11 11  Recruiting 0.05
      12 12  Recruiting 0.05
      13 13  Recruiting 0.05
      14 14  Recruiting 0.05
      15 15  Recruiting 0.05
      16 16  Recruiting 0.05
      17 17  Recruiting 0.05
      18 18  Recruiting 0.05
      37  1    Futility 0.15
      38  2    Futility 0.40
      39  3    Futility 0.55
      40  4    Futility 0.60
      41  5    Futility 0.70
      42  6    Futility 0.75
      43  7    Futility 0.75
      44  8    Futility 0.75
      45  9    Futility 0.75
      46 10    Futility 0.75
      47 11    Futility 0.80
      48 12    Futility 0.80
      49 13    Futility 0.80
      50 14    Futility 0.80
      51 15    Futility 0.80
      52 16    Futility 0.80
      53 17    Futility 0.80
      54 18    Futility 0.80
      55  1 Equivalence 0.00
      56  2 Equivalence 0.00
      57  3 Equivalence 0.00
      58  4 Equivalence 0.00
      59  5 Equivalence 0.00
      60  6 Equivalence 0.00
      61  7 Equivalence 0.00
      62  8 Equivalence 0.05
      63  9 Equivalence 0.05
      64 10 Equivalence 0.05
      65 11 Equivalence 0.10
      66 12 Equivalence 0.10
      67 13 Equivalence 0.10
      68 14 Equivalence 0.10
      69 15 Equivalence 0.10
      70 16 Equivalence 0.10
      71 17 Equivalence 0.10
      72 18 Equivalence 0.10
      73  1 Superiority 0.00
      74  2 Superiority 0.00
      75  3 Superiority 0.00
      76  4 Superiority 0.00
      77  5 Superiority 0.00
      78  6 Superiority 0.05
      79  7 Superiority 0.05
      80  8 Superiority 0.05
      81  9 Superiority 0.05
      82 10 Superiority 0.05
      83 11 Superiority 0.05
      84 12 Superiority 0.05
      85 13 Superiority 0.05
      86 14 Superiority 0.05
      87 15 Superiority 0.05
      88 16 Superiority 0.05
      89 17 Superiority 0.05
      90 18 Superiority 0.05

---

    Code
      extract_statuses(results, x_value = "n")
    Output
          i    n    p      status    x
      1   1  300 0.85  Recruiting  300
      2   2  400 0.60  Recruiting  400
      3   3  500 0.45  Recruiting  500
      4   4  600 0.40  Recruiting  600
      5   5  700 0.30  Recruiting  700
      6   6  800 0.20  Recruiting  800
      7   7  900 0.20  Recruiting  900
      8   8 1000 0.15  Recruiting 1000
      9   9 1100 0.15  Recruiting 1100
      10 10 1200 0.15  Recruiting 1200
      11 11 1300 0.05  Recruiting 1300
      12 12 1400 0.05  Recruiting 1400
      13 13 1500 0.05  Recruiting 1500
      14 14 1600 0.05  Recruiting 1600
      15 15 1700 0.05  Recruiting 1700
      16 16 1800 0.05  Recruiting 1800
      17 17 1900 0.05  Recruiting 1900
      18 18 2000 0.05  Recruiting 2000
      37  1  300 0.15    Futility  300
      38  2  400 0.40    Futility  400
      39  3  500 0.55    Futility  500
      40  4  600 0.60    Futility  600
      41  5  700 0.70    Futility  700
      42  6  800 0.75    Futility  800
      43  7  900 0.75    Futility  900
      44  8 1000 0.75    Futility 1000
      45  9 1100 0.75    Futility 1100
      46 10 1200 0.75    Futility 1200
      47 11 1300 0.80    Futility 1300
      48 12 1400 0.80    Futility 1400
      49 13 1500 0.80    Futility 1500
      50 14 1600 0.80    Futility 1600
      51 15 1700 0.80    Futility 1700
      52 16 1800 0.80    Futility 1800
      53 17 1900 0.80    Futility 1900
      54 18 2000 0.80    Futility 2000
      55  1  300 0.00 Equivalence  300
      56  2  400 0.00 Equivalence  400
      57  3  500 0.00 Equivalence  500
      58  4  600 0.00 Equivalence  600
      59  5  700 0.00 Equivalence  700
      60  6  800 0.00 Equivalence  800
      61  7  900 0.00 Equivalence  900
      62  8 1000 0.05 Equivalence 1000
      63  9 1100 0.05 Equivalence 1100
      64 10 1200 0.05 Equivalence 1200
      65 11 1300 0.10 Equivalence 1300
      66 12 1400 0.10 Equivalence 1400
      67 13 1500 0.10 Equivalence 1500
      68 14 1600 0.10 Equivalence 1600
      69 15 1700 0.10 Equivalence 1700
      70 16 1800 0.10 Equivalence 1800
      71 17 1900 0.10 Equivalence 1900
      72 18 2000 0.10 Equivalence 2000
      73  1  300 0.00 Superiority  300
      74  2  400 0.00 Superiority  400
      75  3  500 0.00 Superiority  500
      76  4  600 0.00 Superiority  600
      77  5  700 0.00 Superiority  700
      78  6  800 0.05 Superiority  800
      79  7  900 0.05 Superiority  900
      80  8 1000 0.05 Superiority 1000
      81  9 1100 0.05 Superiority 1100
      82 10 1200 0.05 Superiority 1200
      83 11 1300 0.05 Superiority 1300
      84 12 1400 0.05 Superiority 1400
      85 13 1500 0.05 Superiority 1500
      86 14 1600 0.05 Superiority 1600
      87 15 1700 0.05 Superiority 1700
      88 16 1800 0.05 Superiority 1800
      89 17 1900 0.05 Superiority 1900
      90 18 2000 0.05 Superiority 2000

