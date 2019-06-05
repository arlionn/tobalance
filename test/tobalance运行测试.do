/*
** 项目：tobalance运行测试
** 时间：20190517
** 测试人：展金泳
*/


**************************************************
* tobalance运行准确性测试
**************************************************
//运用xtbalance与最初的匹配算法作为对比，比较tobalance与两种算法的结果 
//xtbalance与tobalance的ado内置，此处列出匹配算法（merbalance）

cap program drop merbalance
program define merbalance
version 13.0
syntax ,idvar(varlist) timevar(varlist min = 1 max = 1) Range(numlist) 
quietly{

sort `idvar' `timevar' 
tempvar minTime maxTime resSample

gen `resSample' = 0
foreach v of numlist `range'{
replace `resSample' = 1 if `timevar' == `v'
}
keep if `resSample' == 1
drop `resSample'

quietly :tab `timevar'
local allSampleTimeGap = r(r)
/* Method 1 */ 
tempvar idTimeGap
preserve
tempfile onlyfile
duplicates drop `idvar' `timevar' ,force
bysort `idvar' : gen `idTimeGap' = _N
keep if `idTimeGap' == `allSampleTimeGap'
duplicates drop `idvar',force
save "`onlyfile'"
restore
merge m:1 `idvar' using "`onlyfile'"
keep if _merge == 3
drop _merge

}
end	

//伪造数据
clear
set  obs 100000
gen firm =int(_n/1000.001)+1
//100家企业的编码为从1-100，分别表示第1家企业到第100家企业。
bysort firm: gen  product = int(_n/100.001)+100001
//海关数据库中产品代码由2、4、6、8等位次，在学术研究中大多用6位产品海关代码，因此伪造数据中产品的取值为100001-100010共10种产品。
bysort firm product: gen country = int(_n/10.001)+1
//10个进口国的编码为从1-10，分别表示第1个进口国到第10个进口国。
bysort firm product country: gen year = _n+2000
//时间的取值为2001-2010，取值2001表示2001年的出口。
egen id=group(firm product country)
xtset id year

dis _N
set seed 123456
//设定种子以使得操作可重复
drop if runiform() <0.05
dis _N
xtset id year

gen n=_n


//比较三种算法(连续情况下)
preserve
merbalance, idvar(id) timevar(year) range(2001(1)2008)
count
sum n
restore


preserve
tobalance, idvar(id) timevar(year) range(2001(1)2008)
count
sum n
restore


preserve
xtbalance, range(2001 2008) 
count
sum n
restore



//比较三种算法(非连续情况下)
preserve
merbalance, idvar(id) timevar(year) range(2001(2)2008)
count
sum n
restore


preserve
tobalance, idvar(id) timevar(year) range(2001(2)2008)
tab year
count
sum n
restore


preserve
cap drop new_year
gen new_year=.
replace new_year=1 if year==2001
replace new_year=2 if year==2003
replace new_year=3 if year==2005
replace new_year=4 if year==2007
drop if new_year==.
xtset id new_year
xtbalance, range(1 4) 
count
sum n
restore

**结论：tobalance的处理结果与merbalance以及xtbalance的结果一致

**************************************************
* tobalance运行效率测试测试
**************************************************

preserve
timer clear 1
timer on 1
merbalance, idvar(id) timevar(year) range(2001(1)2008)
timer off 1
timer list 1
count
sum n
restore


preserve
timer clear 1
timer on 1
tobalance, idvar(id) timevar(year) range(2001(1)2008)
timer off 1
timer list 1
count
sum n
restore


preserve
timer clear 1
timer on 1
xtset id year
xtbalance, range(2001 2008) 
timer off 1
timer list 1
count
sum n
restore

preserve
timer clear 1
timer on 1
xtbalance, range(2001 2008) 
timer off 1
timer list 1
count
sum n
restore

**结论：merbalance用时0.11；tobalance用时0.07；xtbalance用时0.83（含面板设定） 0.78（不含面板设定）
**tobalance的算法大概是xtbalance的十倍。


**************************************************
* tobalance在大数据中的运用（100万）
**************************************************
//将数据级别由之前的10万观测值拓展到100万，1000万与1亿。

//10万；100家企业在10年内出口10种产品到10个国家
//100万；1000家企业在10年内出口10种产品到10个国家
//1000万；10000家企业在10年内出口10种产品到10个国家
//1亿；100000家企业在10年内出口10种产品到10个国家

//伪造数据
clear
set  obs 1000000
gen firm =int(_n/1000.001)+1
//1000家企业的编码为从1-100，分别表示第1家企业到第100家企业。
bysort firm: gen  product = int(_n/100.001)+100001
//海关数据库中产品代码由2、4、6、8等位次，在学术研究中大多用6位产品海关代码，因此伪造数据中产品的取值为100001-100010共10种产品。
bysort firm product: gen country = int(_n/10.001)+1
//10个进口国的编码为从1-10，分别表示第1个进口国到第10个进口国。
bysort firm product country: gen year = _n+2000
//时间的取值为2001-2010，取值2001表示2001年的出口。
egen id=group(firm product country)
xtset id year

count
set seed 123456
//设定种子以使得操作可重复
drop if runiform() <0.05
count
xtset id year

gen n=_n

preserve
timer clear 1
timer on 1
merbalance, idvar(id) timevar(year) range(2001(1)2008)
timer off 1
timer list 1
count
sum n
restore


preserve
timer clear 1
timer on 1
tobalance, idvar(id) timevar(year) range(2001(1)2008)
timer off 1
timer list 1
count
sum n
restore


preserve
timer clear 1
timer on 1
xtbalance, range(2001 2008) 
timer off 1
timer list 1
count
sum n
restore



**************************************************
* tobalance在大数据中的运用（1000万）
**************************************************
//将数据级别由之前的10万观测值拓展到100万，1000万与1亿。

//10万；100家企业在10年内出口10种产品到10个国家
//100万；1000家企业在10年内出口10种产品到10个国家
//1000万；10000家企业在10年内出口10种产品到10个国家
//1亿；100000家企业在10年内出口10种产品到10个国家

//伪造数据
clear
set  obs 10000000
gen firm =int(_n/1000.000001)+1
//10000家企业的编码为从1-100，分别表示第1家企业到第100家企业。
bysort firm: gen  product = int(_n/100.000001)+100001
//海关数据库中产品代码由2、4、6、8等位次，在学术研究中大多用6位产品海关代码，因此伪造数据中产品的取值为100001-100010共10种产品。
bysort firm product: gen country = int(_n/10.001)+1
//10个进口国的编码为从1-10，分别表示第1个进口国到第10个进口国。
bysort firm product country: gen year = _n+2000
//时间的取值为2001-2010，取值2001表示2001年的出口。
egen id=group(firm product country)
xtset id year

count
set seed 123456
//设定种子以使得操作可重复
drop if runiform() <0.05
count
xtset id year

gen n=_n

preserve
timer clear 1
timer on 1
merbalance, idvar(id) timevar(year) range(2001(1)2008)
timer off 1
timer list 1
count
sum n
restore


preserve
timer clear 1
timer on 1
tobalance, idvar(id) timevar(year) range(2001(1)2008)
timer off 1
timer list 1
count
sum n
restore


preserve
timer clear 1
timer on 1
xtbalance, range(2001 2008) 
timer off 1
timer list 1
count
sum n
restore


**************************************************
* tobalance在大数据中的运用（1亿）
**************************************************
//将数据级别由之前的10万观测值拓展到100万，1000万与1亿。

//10万；100家企业在10年内出口10种产品到10个国家
//100万；1000家企业在10年内出口10种产品到10个国家
//1000万；10000家企业在10年内出口10种产品到10个国家
//1亿；100000家企业在10年内出口10种产品到10个国家

//伪造数据
clear
set  obs 100000000
gen firm =int(_n/1000.000001)+1
//100000家企业的编码为从1-100，分别表示第1家企业到第100家企业。
bysort firm: gen  product = int(_n/100.000001)+100001
//海关数据库中产品代码由2、4、6、8等位次，在学术研究中大多用6位产品海关代码，因此伪造数据中产品的取值为100001-100010共10种产品。
bysort firm product: gen country = int(_n/10.001)+1
//10个进口国的编码为从1-10，分别表示第1个进口国到第10个进口国。
bysort firm product country: gen year = _n+2000
//时间的取值为2001-2010，取值2001表示2001年的出口。
egen id=group(firm product country)
xtset id year

count
set seed 123456
//设定种子以使得操作可重复
drop if runiform() <0.05
count
xtset id year

gen n=_n

preserve
timer clear 1
timer on 1
merbalance, idvar(id) timevar(year) range(2001(1)2008)
timer off 1
timer list 1
count
sum n
restore


preserve
timer clear 1
timer on 1
tobalance, idvar(id) timevar(year) range(2001(1)2008)
timer off 1
timer list 1
count
sum n
restore


preserve
timer clear 1
timer on 1
xtbalance, range(2001 2008) 
timer off 1
timer list 1
count
sum n
restore


**************************************************
* range间断时间测试
**************************************************
//伪造数据
clear
set  obs 100000
gen firm =int(_n/1000.001)+1
//100家企业的编码为从1-100，分别表示第1家企业到第100家企业。
bysort firm: gen  product = int(_n/100.001)+100001
//海关数据库中产品代码由2、4、6、8等位次，在学术研究中大多用6位产品海关代码，因此伪造数据中产品的取值为100001-100010共10种产品。
bysort firm product: gen country = int(_n/10.001)+1
//10个进口国的编码为从1-10，分别表示第1个进口国到第10个进口国。
bysort firm product country: gen year = _n+2000
//时间的取值为2001-2010，取值2001表示2001年的出口。
egen id=group(firm product country)
xtset id year

dis _N
set seed 123456
//设定种子以使得操作可重复
drop if runiform() <0.05
dis _N
xtset id year

gen n=_n

//固定间隔
preserve
tobalance, idvar(id) timevar(year) range(2001(3)2010)
tab year
count
sum n
tab year
restore


preserve
cap drop new_year
gen new_year=.
replace new_year=1 if year==2001
replace new_year=2 if year==2004
replace new_year=3 if year==2007
replace new_year=4 if year==2010
drop if new_year==.
xtset id new_year
xtbalance, range(1 4) 
count
sum n
tab year
restore

//不固定间隔
preserve
tobalance, idvar(id) timevar(year) range(2001 2003 2006(2)2010)
tab year
count
sum n
tab year
restore


preserve
cap drop new_year
gen new_year=.
replace new_year=1 if year==2001
replace new_year=2 if year==2003
replace new_year=3 if year==2006
replace new_year=4 if year==2008
replace new_year=5 if year==2010
drop if new_year==.
xtset id new_year
xtbalance, range(1 5) 
count
sum n
tab year
restore

**************************************************
* range设置乱序测试，时间可以任意设置，不受顺序影响
**************************************************

preserve
tobalance, idvar(id) timevar(year) range(2001(3)2010)
sum n
restore

preserve
tobalance, idvar(id) timevar(year) range(2010 2001(3)2007)
sum n
restore

preserve
tobalance, idvar(id) timevar(year) range(2010 2004 2007 2001)
sum n
restore




