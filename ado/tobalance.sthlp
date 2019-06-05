{smcl}
{* 18May2019}{...}
{hline}
help for {hi:tobalance}{right:version 2.01, {cmd:by Lian Yu-Jun}}
{hline}

{title:Trans the dataset into balance Data}

{p 8 15 2}
{cmd:tobalance}, 
[ {cmdab:i:dvar:(}{it:varlist}{cmd:)} ]
[ {cmdab:t:imevar:(}{it:varlist}{cmd:)} ]
[ {cmdab:r:ange:(}{it:numlist}{cmd:)} ]
[ {cmdab:m:iss:(}{it:varlist}{cmd:)} ]

{p 4 4 2}
You must {cmd:tsset} your data before using {cmd:tobalance} 
if {cmd:idvar(}{it:varlist}{cmd:)} and {cmd:timevar(}{it:varlist}{cmd:)} 
are omitted; see help {help tsset}.


{title:Description}

{p 4 4 2}
{cmd:tobalance} Trans the unbalanced Data into balanced Data 
with sample range specified by option {cmd:range}.

{p 4 4 2}
{cmd:Note:}The {cmd:xtbalance} command can handle some 
special panels. For example, the stock market will be closed for weekends and 
holidays, so the daily data collected by listed companies is not continuous, 
but in essence, it is still a balanced panel. The {cmd:tobalance} command 
is well compatible with this type of data set. In addition, cmd:tobalance} 
command can handle high-dimensional data sets and no longer rely 
on {cmd:tsset} settings.

{title:Options}

{p 4 8 2}
{cmd:idvar(}{it:varlist}{cmd:)} specifies dimension variable to be transfored.
{it:varlist} have at least one dimension variable. 

{p 4 8 2}
{cmd:timevar(}{it:varlist}{cmd:)} specifies time variable to be transfored.
{it:varlist} must be one time variable. 

{p 4 8 2}
{cmd:range(}{it:numlist}{cmd:)} specifies sample range to be transfored.
{it:numlist} can be a continuous or discontinuous period of time. 

{p 4 8 2}
{cmd:miss(}{it:varlist}{cmd:)} forces to drop the observations if any one 
of the variable in {it:varlist} has missing value.


{title:Examples}

{p 4 8 2}{cmd:. help tobalance}{p_end}

{p 4 8 2}{cmd:. tobalance , idvar(firm) timevar(year) range(2005(1)2010)}{p_end}

{p 4 8 2}{cmd:. tobalance , idvar(firm) timevar(year) range(2001 2005(1)2010) miss(invest market)}{p_end}

{p 4 8 2}{cmd:. tobalance , idvar(firm) timevar(year) range(2001 2005(1)2010) miss(_all)}{p_end}


{hline}
{pstd}Setup 1{break}
create balanced dataset {p_end}
{phang2}{cmd:. clear }{p_end}
{phang2}{cmd:. set obs 100000}{p_end}
{phang2}{cmd:. gen gen firm =int(_n/1000.001)+1}{p_end}
{phang2}{cmd:. bysort firm: gen  product = int(_n/100.001)+100001}{p_end}
{phang2}{cmd:. bysort firm product: gen country = int(_n/10.001)+1}{p_end}		
{phang2}{cmd:. bysort firm product country: gen year = _n+2000}{p_end}
{phang2}{cmd:. egen id=group(firm product country) }{p_end}

{pstd}Setup 2{break}
create unbalanced dataset {p_end}
{phang2}{cmd:. set seed 123456}{p_end}
{phang2}{cmd:. drop if runiform() <0.05}{p_end}
{phang2}{cmd:. gen value = 1}{p_end}
{phang2}{cmd:. replace value = . if _n < 100}{p_end}
{phang2}{cmd:. save somedata.dta}{p_end}
{hline}
{pstd}Perform 1{break}
Trans the dataset into balance Data{break}
In the final balance Data time variable is regular time. {p_end}
{phang2}{cmd:. use somedata.dta}{p_end}
{phang2}{cmd:. xtset id year}{p_end}
{phang2}{cmd:. tobalance,idvar(id) timevar(year) range(2002(1)2007)}{p_end}
{phang2}{cmd:. xtset id year}{p_end}
{hline}
{pstd}Perform 2{break}
Trans the dataset into balance Data{break}
In the final balance Data time variable is is discontinuous. {p_end}
{phang2}{cmd:. use somedata.dta}{p_end}
{phang2}{cmd:. xtset id year}{p_end}
{phang2}{cmd:. tobalance,idvar(id) timevar(year) range(2002(2)2007 2009)}{p_end}
{phang2}{cmd:. xtset id year}{p_end}
{hline}
{pstd}Perform 3{break}
Trans the dataset into balance Panel Data{break}
The final balance Panel Data is high-dimensional. {p_end}
{phang2}{cmd:. use somedata.dta}{p_end}
{phang2}{cmd:. tobalance,idvar(firm product) timevar(year) range(2002(2)2007 2009)}{p_end}
{hline}

{title:For problems and suggestions}


{phang}
{cmd:Author: Yujun,Lian (Arlion)} Department of Finance, Lingnan College, Sun Yat-Sen University.{break}
E-mail: {browse "mailto:arlionn@163.com":arlionn@163.com}. {break}
Blog: {browse "http://blog.cnfol.com/arlion":http://blog.cnfol.com/arlion}. {break}


