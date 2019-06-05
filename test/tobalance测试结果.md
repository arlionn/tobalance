
> `2019/6/5 10:59`

```stata

. doedit "C:\Users\Administrator\Desktop\tobalance运行测试.do" 

. do "C:\Users\Administrator\Desktop\tobalance运行测试.do"

. /*
> ** 项目：tobalance运行测试
> ** 时间：20190517
> ** 测试人：展金泳
> */
. 
. 
. **************************************************
. * tobalance运行准确性测试
. **************************************************
. //运用xtbalance与最初的匹配算法作为对比，比较tobalance与两种算法的结果 
. //xtbalance与tobalance的ado内置，此处列出匹配算法（merbalance）
. 
. cap program drop merbalance

. program define merbalance
  1. version 13.0
  2. syntax ,idvar(varlist) timevar(varlist min = 1 max = 1) Range(numlist) 
  3. quietly{
  4. 
. sort `idvar' `timevar' 
  5. tempvar minTime maxTime resSample
  6. 
. gen `resSample' = 0
  7. foreach v of numlist `range'{
  8. replace `resSample' = 1 if `timevar' == `v'
  9. }
 10. keep if `resSample' == 1
 11. drop `resSample'
 12. 
. quietly :tab `timevar'
 13. local allSampleTimeGap = r(r)
 14. /* Method 1 */ 
. tempvar idTimeGap
 15. preserve
 16. tempfile onlyfile
 17. duplicates drop `idvar' `timevar' ,force
 18. bysort `idvar' : gen `idTimeGap' = _N
 19. keep if `idTimeGap' == `allSampleTimeGap'
 20. duplicates drop `idvar',force
 21. save "`onlyfile'"
 22. restore
 23. merge m:1 `idvar' using "`onlyfile'"
 24. keep if _merge == 3
 25. drop _merge
 26. 
. }
 27. end     

. 
. //伪造数据
. clear

. set  obs 100000
number of observations (_N) was 0, now 100,000

. gen firm =int(_n/1000.001)+1

. //100家企业的编码为从1-100，分别表示第1家企业到第100家企业。
. bysort firm: gen  product = int(_n/100.001)+100001

. //海关数据库中产品代码由2、4、6、8等位次，在学术研究中大多用6位产品海关代码，因此伪造数据中产品的取值为100001-100010共10种产品。
. bysort firm product: gen country = int(_n/10.001)+1

. //10个进口国的编码为从1-10，分别表示第1个进口国到第10个进口国。
. bysort firm product country: gen year = _n+2000

. //时间的取值为2001-2010，取值2001表示2001年的出口。
. egen id=group(firm product country)

. xtset id year
       panel variable:  id (strongly balanced)
        time variable:  year, 2001 to 2010
                delta:  1 unit

. 
. dis _N
100000

. set seed 123456

. //设定种子以使得操作可重复
. drop if runiform() <0.05
(4,896 observations deleted)

. dis _N
95104

. xtset id year
       panel variable:  id (unbalanced)
        time variable:  year, 2001 to 2010, but with gaps
                delta:  1 unit

. 
. gen n=_n

. 
. 
. //比较三种算法(连续情况下)
. preserve

. merbalance, idvar(id) timevar(year) range(2001(1)2008)

. count
  53,576

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     53,576    47522.51     27521.3          1      95103

. restore

. 
. 
. preserve

. tobalance, idvar(id) timevar(year) range(2001(1)2008)
OutRange: 18986 observations deleted
Total   : 41528 observations deleted

. count
  53,576

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     53,576    47522.51     27521.3          1      95103

. restore

. 
. 
. preserve

. xtbalance, range(2001 2008) 

(18986 observations deleted due to out of range) 

(22542 observations deleted due to discontinues) 

. count
  53,576

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     53,576    47522.51     27521.3          1      95103

. restore

. 
. 
. 
. //比较三种算法(非连续情况下)
. preserve

. merbalance, idvar(id) timevar(year) range(2001(2)2008)

. count
  32,728

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     32,728    47550.88    27503.37          1      95102

. restore

. 
. 
. preserve

. tobalance, idvar(id) timevar(year) range(2001(2)2008)
OutRange: 57039 observations deleted
Total   : 62376 observations deleted

. tab year

       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2001 |      8,182       25.00       25.00
       2003 |      8,182       25.00       50.00
       2005 |      8,182       25.00       75.00
       2007 |      8,182       25.00      100.00
------------+-----------------------------------
      Total |     32,728      100.00

. count
  32,728

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     32,728    47550.88    27503.37          1      95102

. restore

. 
. 
. preserve

. cap drop new_year

. gen new_year=.
(95,104 missing values generated)

. replace new_year=1 if year==2001
(9,524 real changes made)

. replace new_year=2 if year==2003
(9,508 real changes made)

. replace new_year=3 if year==2005
(9,506 real changes made)

. replace new_year=4 if year==2007
(9,527 real changes made)

. drop if new_year==.
(57,039 observations deleted)

. xtset id new_year
       panel variable:  id (unbalanced)
        time variable:  new_year, 1 to 4, but with gaps
                delta:  1 unit

. xtbalance, range(1 4) 

(5337 observations deleted due to discontinues) 

. count
  32,728

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     32,728    47550.88    27503.37          1      95102

. restore

. 
. **结论：tobalance的处理结果与merbalance以及xtbalance的结果一致
. 
. **************************************************
. * tobalance运行效率测试测试
. **************************************************
. 
. preserve

. timer clear 1

. timer on 1

. merbalance, idvar(id) timevar(year) range(2001(1)2008)

. timer off 1

. timer list 1
   1:      0.09 /        1 =       0.0900

. count
  53,576

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     53,576    47522.51     27521.3          1      95103

. restore

. 
. 
. preserve

. timer clear 1

. timer on 1

. tobalance, idvar(id) timevar(year) range(2001(1)2008)
OutRange: 18986 observations deleted
Total   : 41528 observations deleted

. timer off 1

. timer list 1
   1:      0.06 /        1 =       0.0550

. count
  53,576

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     53,576    47522.51     27521.3          1      95103

. restore

. 
. 
. preserve

. timer clear 1

. timer on 1

. xtset id year
       panel variable:  id (unbalanced)
        time variable:  year, 2001 to 2010, but with gaps
                delta:  1 unit

. xtbalance, range(2001 2008) 

(18986 observations deleted due to out of range) 

(22542 observations deleted due to discontinues) 

. timer off 1

. timer list 1
   1:      0.84 /        1 =       0.8410

. count
  53,576

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     53,576    47522.51     27521.3          1      95103

. restore

. 
. preserve

. timer clear 1

. timer on 1

. xtbalance, range(2001 2008) 

(18986 observations deleted due to out of range) 

(22542 observations deleted due to discontinues) 

. timer off 1

. timer list 1
   1:      0.82 /        1 =       0.8230

. count
  53,576

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     53,576    47522.51     27521.3          1      95103

. restore

. 
. **结论：merbalance用时0.11；tobalance用时0.07；xtbalance用时0.83（含面板设定） 0.78（不含面板设定）
. **tobalance的算法大概是xtbalance的十倍。
. 
. 
. **************************************************
. * tobalance在大数据中的运用（100万）
. **************************************************
. //将数据级别由之前的10万观测值拓展到100万，1000万与1亿。
. 
. //10万；100家企业在10年内出口10种产品到10个国家
. //100万；1000家企业在10年内出口10种产品到10个国家
. //1000万；10000家企业在10年内出口10种产品到10个国家
. //1亿；100000家企业在10年内出口10种产品到10个国家
. 
. //伪造数据
. clear

. set  obs 1000000
number of observations (_N) was 0, now 1,000,000

. gen firm =int(_n/1000.001)+1

. //1000家企业的编码为从1-100，分别表示第1家企业到第100家企业。
. bysort firm: gen  product = int(_n/100.001)+100001

. //海关数据库中产品代码由2、4、6、8等位次，在学术研究中大多用6位产品海关代码，因此伪造数据中产品的取值为100001-100010共10种产品。
. bysort firm product: gen country = int(_n/10.001)+1

. //10个进口国的编码为从1-10，分别表示第1个进口国到第10个进口国。
. bysort firm product country: gen year = _n+2000

. //时间的取值为2001-2010，取值2001表示2001年的出口。
. egen id=group(firm product country)

. xtset id year
       panel variable:  id (strongly balanced)
        time variable:  year, 2001 to 2010
                delta:  1 unit

. 
. count
  1,000,000

. set seed 123456

. //设定种子以使得操作可重复
. drop if runiform() <0.05
(49,842 observations deleted)

. count
  950,158

. xtset id year
       panel variable:  id (unbalanced)
        time variable:  year, 2001 to 2010, but with gaps
                delta:  1 unit

. 
. gen n=_n

. 
. preserve

. timer clear 1

. timer on 1

. merbalance, idvar(id) timevar(year) range(2001(1)2008)

. timer off 1

. timer list 1
   1:      0.63 /        1 =       0.6260

. count
  530,536

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |    530,536    475392.7    274614.1          1     950147

. restore

. 
. 
. preserve

. timer clear 1

. timer on 1

. tobalance, idvar(id) timevar(year) range(2001(1)2008)
OutRange: 190065 observations deleted
Total   : 419622 observations deleted

. timer off 1

. timer list 1
   1:      0.39 /        1 =       0.3930

. count
  530,536

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |    530,536    475392.7    274614.1          1     950147

. restore

. 
. 
. preserve

. timer clear 1

. timer on 1

. xtbalance, range(2001 2008) 

(190065 observations deleted due to out of range) 

(229557 observations deleted due to discontinues) 

. timer off 1

. timer list 1
   1:      7.32 /        1 =       7.3220

. count
  530,536

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |    530,536    475392.7    274614.1          1     950147

. restore

. 
. 
. 
. **************************************************
. * tobalance在大数据中的运用（1000万）
. **************************************************
. //将数据级别由之前的10万观测值拓展到100万，1000万与1亿。
. 
. //10万；100家企业在10年内出口10种产品到10个国家
. //100万；1000家企业在10年内出口10种产品到10个国家
. //1000万；10000家企业在10年内出口10种产品到10个国家
. //1亿；100000家企业在10年内出口10种产品到10个国家
. 
. //伪造数据
. clear

. set  obs 10000000
number of observations (_N) was 0, now 10,000,000

. gen firm =int(_n/1000.000001)+1

. //10000家企业的编码为从1-100，分别表示第1家企业到第100家企业。
. bysort firm: gen  product = int(_n/100.000001)+100001

. //海关数据库中产品代码由2、4、6、8等位次，在学术研究中大多用6位产品海关代码，因此伪造数据中产品的取值为100001-100010共10种产品。
. bysort firm product: gen country = int(_n/10.001)+1

. //10个进口国的编码为从1-10，分别表示第1个进口国到第10个进口国。
. bysort firm product country: gen year = _n+2000

. //时间的取值为2001-2010，取值2001表示2001年的出口。
. egen id=group(firm product country)

. xtset id year
       panel variable:  id (strongly balanced)
        time variable:  year, 2001 to 2010
                delta:  1 unit

. 
. count
  10,000,000

. set seed 123456

. //设定种子以使得操作可重复
. drop if runiform() <0.05
(500,114 observations deleted)

. count
  9,499,886

. xtset id year
       panel variable:  id (unbalanced)
        time variable:  year, 2001 to 2010, but with gaps
                delta:  1 unit

. 
. gen n=_n

. 
. preserve

. timer clear 1

. timer on 1

. merbalance, idvar(id) timevar(year) range(2001(1)2008)

. timer off 1

. timer list 1
   1:      6.41 /        1 =       6.4060

. count
  5,307,272

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |  5,307,272     4750101     2743036          1    9499884

. restore

. 
. 
. preserve

. timer clear 1

. timer on 1

. tobalance, idvar(id) timevar(year) range(2001(1)2008)
OutRange: 1899900 observations deleted
Total   : 4192614 observations deleted

. timer off 1

. timer list 1
   1:      3.58 /        1 =       3.5770

. count
  5,307,272

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |  5,307,272     4750101     2743036          1    9499884

. restore

. 
. 
. preserve

. timer clear 1

. timer on 1

. xtbalance, range(2001 2008) 

(1899900 observations deleted due to out of range) 

(2292714 observations deleted due to discontinues) 

. timer off 1

. timer list 1
   1:     78.89 /        1 =      78.8850

. count
  5,307,272

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |  5,307,272     4750101     2743036          1    9499884

. restore

. 
. 
. **************************************************
. * tobalance在大数据中的运用（1亿）
. **************************************************
. //将数据级别由之前的10万观测值拓展到100万，1000万与1亿。
. 
. //10万；100家企业在10年内出口10种产品到10个国家
. //100万；1000家企业在10年内出口10种产品到10个国家
. //1000万；10000家企业在10年内出口10种产品到10个国家
. //1亿；100000家企业在10年内出口10种产品到10个国家
. 
. //伪造数据
. clear

. set  obs 100000000
number of observations (_N) was 0, now 100,000,000

. gen firm =int(_n/1000.000001)+1

. //100000家企业的编码为从1-100，分别表示第1家企业到第100家企业。
. bysort firm: gen  product = int(_n/100.000001)+100001

. //海关数据库中产品代码由2、4、6、8等位次，在学术研究中大多用6位产品海关代码，因此伪造数据中产品的取值为100001-100010共10种产品。
. bysort firm product: gen country = int(_n/10.001)+1

. //10个进口国的编码为从1-10，分别表示第1个进口国到第10个进口国。
. bysort firm product country: gen year = _n+2000

. //时间的取值为2001-2010，取值2001表示2001年的出口。
. egen id=group(firm product country)

. xtset id year
       panel variable:  id (strongly balanced)
        time variable:  year, 2001 to 2010
                delta:  1 unit

. 
. count
  100,000,000

. set seed 123456

. //设定种子以使得操作可重复
. drop if runiform() <0.05
(4,999,531 observations deleted)

. count
  95,000,469

. xtset id year
       panel variable:  id (unbalanced)
        time variable:  year, 2001 to 2010, but with gaps
                delta:  1 unit

. 
. gen n=_n

. 
. preserve

. timer clear 1

. timer on 1

. merbalance, idvar(id) timevar(year) range(2001(1)2008)

. timer off 1

. timer list 1
   1:     75.70 /        1 =      75.7010

. count
  53,071,896

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n | 53,071,896    4.75e+07    2.74e+07          1   9.50e+07

. restore

. 
. 
. preserve

. timer clear 1

. timer on 1

. tobalance, idvar(id) timevar(year) range(2001(1)2008)
OutRange: 19000010 observations deleted
Total   : 41928573 observations deleted

. timer off 1

. timer list 1
   1:     34.74 /        1 =      34.7430

. count
  53,071,896

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n | 53,071,896    4.75e+07    2.74e+07          1   9.50e+07

. restore

. 
. 
. preserve

. timer clear 1

. timer on 1

. xtbalance, range(2001 2008) 

(19000010 observations deleted due to out of range) 

(22928563 observations deleted due to discontinues) 

. timer off 1

. timer list 1
   1:    805.05 /        1 =     805.0480

. count
  53,071,896

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n | 53,071,896    4.75e+07    2.74e+07          1   9.50e+07

. restore

. 
. 
. **************************************************
. * range间断时间测试
. **************************************************
. //伪造数据
. clear

. set  obs 100000
number of observations (_N) was 0, now 100,000

. gen firm =int(_n/1000.001)+1

. //100家企业的编码为从1-100，分别表示第1家企业到第100家企业。
. bysort firm: gen  product = int(_n/100.001)+100001

. //海关数据库中产品代码由2、4、6、8等位次，在学术研究中大多用6位产品海关代码，因此伪造数据中产品的取值为100001-100010共10种产品。
. bysort firm product: gen country = int(_n/10.001)+1

. //10个进口国的编码为从1-10，分别表示第1个进口国到第10个进口国。
. bysort firm product country: gen year = _n+2000

. //时间的取值为2001-2010，取值2001表示2001年的出口。
. egen id=group(firm product country)

. xtset id year
       panel variable:  id (strongly balanced)
        time variable:  year, 2001 to 2010
                delta:  1 unit

. 
. dis _N
100000

. set seed 123456

. //设定种子以使得操作可重复
. drop if runiform() <0.05
(4,896 observations deleted)

. dis _N
95104

. xtset id year
       panel variable:  id (unbalanced)
        time variable:  year, 2001 to 2010, but with gaps
                delta:  1 unit

. 
. gen n=_n

. 
. //固定间隔
. preserve

. tobalance, idvar(id) timevar(year) range(2001(3)2010)
OutRange: 56986 observations deleted
Total   : 62104 observations deleted

. tab year

       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2001 |      8,250       25.00       25.00
       2004 |      8,250       25.00       50.00
       2007 |      8,250       25.00       75.00
       2010 |      8,250       25.00      100.00
------------+-----------------------------------
      Total |     33,000      100.00

. count
  33,000

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     33,000    47541.48    27459.03          1      95095

. tab year

       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2001 |      8,250       25.00       25.00
       2004 |      8,250       25.00       50.00
       2007 |      8,250       25.00       75.00
       2010 |      8,250       25.00      100.00
------------+-----------------------------------
      Total |     33,000      100.00

. restore

. 
. 
. preserve

. cap drop new_year

. gen new_year=.
(95,104 missing values generated)

. replace new_year=1 if year==2001
(9,524 real changes made)

. replace new_year=2 if year==2004
(9,563 real changes made)

. replace new_year=3 if year==2007
(9,527 real changes made)

. replace new_year=4 if year==2010
(9,504 real changes made)

. drop if new_year==.
(56,986 observations deleted)

. xtset id new_year
       panel variable:  id (unbalanced)
        time variable:  new_year, 1 to 4, but with gaps
                delta:  1 unit

. xtbalance, range(1 4) 

(5118 observations deleted due to discontinues) 

. count
  33,000

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     33,000    47541.48    27459.03          1      95095

. tab year

       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2001 |      8,250       25.00       25.00
       2004 |      8,250       25.00       50.00
       2007 |      8,250       25.00       75.00
       2010 |      8,250       25.00      100.00
------------+-----------------------------------
      Total |     33,000      100.00

. restore

. 
. //不固定间隔
. preserve

. tobalance, idvar(id) timevar(year) range(2001 2003 2006(2)2010)
OutRange: 47597 observations deleted
Total   : 56349 observations deleted

. tab year

       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2001 |      7,751       20.00       20.00
       2003 |      7,751       20.00       40.00
       2006 |      7,751       20.00       60.00
       2008 |      7,751       20.00       80.00
       2010 |      7,751       20.00      100.00
------------+-----------------------------------
      Total |     38,755      100.00

. count
  38,755

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     38,755    47687.32       27505          1      95095

. tab year

       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2001 |      7,751       20.00       20.00
       2003 |      7,751       20.00       40.00
       2006 |      7,751       20.00       60.00
       2008 |      7,751       20.00       80.00
       2010 |      7,751       20.00      100.00
------------+-----------------------------------
      Total |     38,755      100.00

. restore

. 
. 
. preserve

. cap drop new_year

. gen new_year=.
(95,104 missing values generated)

. replace new_year=1 if year==2001
(9,524 real changes made)

. replace new_year=2 if year==2003
(9,508 real changes made)

. replace new_year=3 if year==2006
(9,493 real changes made)

. replace new_year=4 if year==2008
(9,478 real changes made)

. replace new_year=5 if year==2010
(9,504 real changes made)

. drop if new_year==.
(47,597 observations deleted)

. xtset id new_year
       panel variable:  id (unbalanced)
        time variable:  new_year, 1 to 5, but with gaps
                delta:  1 unit

. xtbalance, range(1 5) 

(8752 observations deleted due to discontinues) 

. count
  38,755

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     38,755    47687.32       27505          1      95095

. tab year

       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2001 |      7,751       20.00       20.00
       2003 |      7,751       20.00       40.00
       2006 |      7,751       20.00       60.00
       2008 |      7,751       20.00       80.00
       2010 |      7,751       20.00      100.00
------------+-----------------------------------
      Total |     38,755      100.00

. restore

. 
. **************************************************
. * range设置乱序测试，时间可以任意设置，不受顺序影响
. **************************************************
. 
. preserve

. tobalance, idvar(id) timevar(year) range(2001(3)2010)
OutRange: 56986 observations deleted
Total   : 62104 observations deleted

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     33,000    47541.48    27459.03          1      95095

. restore

. 
. preserve

. tobalance, idvar(id) timevar(year) range(2010 2001(3)2007)
OutRange: 56986 observations deleted
Total   : 62104 observations deleted

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     33,000    47541.48    27459.03          1      95095

. restore

. 
. preserve

. tobalance, idvar(id) timevar(year) range(2010 2004 2007 2001)
OutRange: 56986 observations deleted
Total   : 62104 observations deleted

. sum n

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
           n |     33,000    47541.48    27459.03          1      95095

. restore

. 
. 
. 
. 
. 
end of do-file

. exit, clear

```