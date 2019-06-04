cap program drop tobalance
program define tobalance
version 13.0

syntax , Range(numlist int ) ///
[idvar(varlist min=1) timevar(varlist min = 1 max = 1  numeric  ) Miss(varlist)]


quietly{
	/*
		数据处理
		* [2019-05-12-16:30-wx]range必填，否则程序直接报错 
		* [2019-05-12-16:30-wx]idvar与timevar选填，但需同时指定id与time
		* 通过设定idvar 与 timevar后，可不必再获取内存中的id与time标识，避免出错并提高效率
	*/
	

	if "`idvar'" != "" & "`timevar'" != ""{
		tempname panelVariable timeVariable
		local panelVariable `idvar'
		local timeVariable `timevar'
		sort `panelVariable' `timeVariable' 
	}
	else if "`idvar'" == "" & "`timevar'" == ""{
				//* [2019-05-12-16:30] 兼容xtbalace的做法  
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
		
	//保存原始数据集的总观测值数
	qui:count 
	tempname originSampleCount
	local originSampleCount = r(N)
	
	//先清理缺失，如果用户选择了miss() 先清理缺失再处理数据
	if "`miss'" != ""{
	//原始命令中的[MISS]
		tempvar  missv                     
		egen `missv' = rmiss(`miss')
		qui count if `missv' !=0
		qui drop if `missv' != 0
	}

	
	/*
	*检查range
	* [2019-05-12-16:30-wx] range为numlist，允许用户随意顺序输入range里面数值列表顺序
	*旧版本是先删除range外再检查range范围，此法容易导致用户输入错误的范围，之后
	使用xtbalance导致全部数据删除后才提示数据范围；
	*首先就检查时间列表，如果超过时间列表就报错并退出，并未对数据进行处理。
	*/
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



	//由于用户可按照顺序来自己输入range列表，因此保留用户指定值的时间
	tempvar  resSample //通过使用tempvar 避免原始数据集中含有该名称变量
	gen `resSample' = 0
	
	tempname status
	local status = 0
	
	foreach v of numlist `newrange'{
	
		//* [2019-05-12-18:20-wx] 如果range内有不在样本内的时间，报错，退出
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

	//不在范围内的
	qui:count 
	tempname outRangeCount
	local outRangeCount = `originSampleCount' - r(N)


	//生成此使整个样本内时间段数，如果每个个体的时间段与样本的不一样，则肯定为缺失
	quietly :tab `timeVariable'
	tempname allSampleTimeGap
	local allSampleTimeGap = r(r)
	/*Method 3*/
	tempvar num totalgaps
	bysort `panelVariable' (`timeVariable'):gen `num' = sum(`timeVariable' != `timeVariable'[_n-1])
	bysort `panelVariable' :egen `totalgaps' = max(`num')
	keep if `totalgaps' == `allSampleTimeGap'

	//保存处理数据集的总观测值数
	qui:count 
	tempname afterSampleCount dropCount
	local afterSampleCount = r(N)
	local dropCount = `originSampleCount' - `afterSampleCount'
	
	noi dis as text "OutRange: `outRangeCount' observations deleted"
	noi dis as text "Total   : `dropCount' observations deleted"

}
end
