cap program drop tobalance
program define tobalance
version 13.0

syntax , Range(numlist int ) ///
[Idvar(varlist min=1) Timevar(varlist min = 1 max = 1  numeric  ) Miss(varlist)]


quietly{

	if "`idvar'" != "" & "`timevar'" != ""{
		tempname panelVariable timeVariable
		local panelVariable `idvar'
		local timeVariable `timevar'
		sort `panelVariable' `timeVariable' 
	}
	else if "`idvar'" == "" & "`timevar'" == ""{
				qui capture tsset
				capture confirm e `r(panelvar)'
				if ( _rc != 0 ) {
					dis as error "You must {help tsset} your data before using {cmd:balance},see help {help balance}."
					exit
				}
				 qui tsset
				 tempname panelVariable timeVariable
				 local panelVariable   "`r(panelvar)'"
				 local timeVariable    "`r(timevar)'"
		}
	else {
		di as erro  "You must {help tsset} your data before using {cmd:balance},see help {help balance}."
		di as erro  "use {cmd:balance} or specify id varlist and time variable in idvar() and timevar()  "
		exit
		}

	qui:count 
	tempname originSampleCount
	local originSampleCount = r(N)
	

	if "`miss'" != ""{
		tempvar  missv                     
		egen `missv' = rmiss(`miss')
		qui count if `missv' !=0
		qui drop if `missv' != 0
	}


	tempname newrange size beginTime endTime 
	numlist "`range'" ,sort
	local newrange =  r(numlist)
	local size      :word count `newrange'
	local beginTime :word 1 of `newrange'
	local endTime   :word `size' of `newrange'
	
	sum `timeVariable' ,meanonly
	tempname minTimevar maxTimevar
	local minTimevar r(min)
	local maxTimevar r(max)

	if  `beginTime' < `minTimevar' {
		dis as erro "min time must greater than or equal smallest your timevarle in sample"
		exit
	}
	else if `endTime' > `maxTimevar'  {
		dis as erro "max time must smaller than or equal largest  your timevarle in sample"
		exit
	}

	tempvar  resSample 
	gen `resSample' = 0
	
	tempname status
	local status = 0
	
	foreach v of numlist `newrange'{

		qui:count if `timeVariable' == `v'
		
		if r(N) == 0 {
			di as erro "need to check time at `v'"
			local status = 1
			continue,break
		}
	
		replace `resSample' = 1 if `timeVariable' == `v'
	}
	
	if `status'  {
		exit
	}
	
	keep if `resSample' == 1
	drop `resSample'

	qui:count 
	tempname outRangeCount
	local outRangeCount = `originSampleCount' - r(N)


	quietly :tab `timeVariable'
	tempname allSampleTimeGap
	local allSampleTimeGap = r(r)

	tempvar num totalgaps
	bysort `panelVariable' (`timeVariable'):gen `num' = sum(`timeVariable' != `timeVariable'[_n-1])
	bysort `panelVariable' :egen `totalgaps' = max(`num')
	keep if `totalgaps' == `allSampleTimeGap'


	qui:count 
	tempname afterSampleCount dropCount
	local afterSampleCount = r(N)
	local dropCount = `originSampleCount' - `afterSampleCount'
	
	noi dis as text "OutRange: `outRangeCount' observations deleted"
	noi dis as text "Total   : `dropCount' observations deleted"

}
end
