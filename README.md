&emsp;

> 作者：展金泳 (对外经济贸易大学)      吴雄（湘潭大学） 胡杰（中山大学）
>     
> Stata 连享会： [知乎](https://zhuanlan.zhihu.com/arlion) | [简书](http://www.jianshu.com/u/69a30474ef33) | [码云](https://gitee.com/arlionn)

&emsp;

- Stata连享会 [精彩推文1](https://gitee.com/arlionn/stata_training/blob/master/README.md)  || [精彩推文2](https://github.com/arlionn/stata/blob/master/README.md)

![](https://upload-images.jianshu.io/upload_images/7692714-8b1fb0b5068487af.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

  

与一般的数据不同，企业层面的贸易数据往往是高维的，例如我国海关数据库中的进出口数据一般为4维的：企业A在时间B出口（或进口）产品C到（从）国家D。在处理贸易数据的过程中笔者发现很多处理面板数据（相当于二维）的命令纷纷失效，有鉴于此，笔者希望能够对以往面板数据中的常用命令进行改造，以扩大其适用的范围。在本文中，笔者就通过对连玉君老师所编写的xtbalance进行完善（可能并不精确，暂时明名为tobalance），以使其能够完成高维数据中数据的处理。

### 目录
* 平衡数据转换的背景
* 1.`tobalance`简介
* 2.`tobalance`在连续时间中的应用
	* 2.1 生成数据
	* 2.2 面板数据的处理
	* 2.3 高维不使用`tobalance`的处理流程
	* 2.4 高维使用`tobalance`的处理流程
* 3.`tobalance`在非连续时间中的应用
	* 3.1 生成数据
	* 3.2 不使用`tobalance`的处理流程
	* 3.3 使用`tobalance`的处理流程
* 4.`tobalance`与`xtbalance`的区别与联系

### 平衡数据转换的背景
- 为何转换平衡面板：事实上，在实证分析中，并不要求数据结构为平衡数据，当将非平衡数据强制转换成平衡数据的过程中会删除一定的样本观测值，造成样本选择性偏误，使得实证结论有偏。那么，在什么情况下需要将非平衡数据转换为平衡数据呢？首先，在政策评估中，为了研究政策发生前后企业（或其他研究主体）经营状况的变化，需要保留哪些在政策前后的样本期间均存在企业，这样就需要将哪些中间退出或者新进入的企业剔除；其次，在异质性分析中，研究对特定时间段持续存在个体与非连续存在个体作用间的差异；最后，在一些特定模型中需要平衡数据才能进行操作。
- 注意事项：将非平衡数据转换为平衡数据的过程中会删除部分样本观测值，因此在数据处理前请务必做好数据备份，以防执行操作后原始数据无法找回。
- 现有做法：当前将非平衡数据转换为平衡数据的命令主要是`xtbalance`，该命令有以下局限：只能对面板数据进行处理，不能处理高维数据；数据的处理依赖于对面板数据的声明，运行速率较慢；仅适用于连续时间的设定。基于此，在同连老师反复沟通后，通过优化算法，弥补`xtbalance`的缺陷开发了`tobalance`命令。

### 1.`tobalance`简介

- 功能简介：`tobalance`在`xtbalance`的基础上完善得到，主要用于将非平衡数据转换成平衡数据，二维数据中保留个体变量在选定时间范围内均存在观测值的样本，高维数据保留选定维度（低于最高维）在选定时间范围内均有观测的样本。
- 语法结构：
`tobalance`并不是stata内置的命令，需要安装才能进行使用。目前主要有以下安装途径：（1）通过码云（后期完成后设成超链接）下载tobalance.ado文件；（2）`ssc install tobalance`（后期完成后设定）。

`tobalance` 的语法格式: ` tobalance [, options]`

其中option选项有` idvar(varlist)、timevar(varlist)、range(numlist) 、miss(varlist)`四个选项，分别可以简写为`i`、`t`、`r`、`m` ，下面分别进行介绍。

* ` idvar(varlist)、timevar(varlist)`表示保留个体变量（` idvar`）在时间变量（` timevar`）特定范围（` range`）内都存在的观测值。` idvar(varlist)、timevar(varlist)`成对出现，如果写要一起都写，如果不写则用前文设定面板数据中的个体变量与时间变量，如果没有填写并且前文也没有设定面板（`xtset panelvar timevar` 或 `tsset  panelvar timevar` ）则会报错。` idvar(varlist)`括号内可以书写一个或多个变量，当写一个变量时则是二维面板数据的处理，如果写多个变量时则是高维数据的处理；` timevar(varlist)`里只能写一个变量，并且要与`range(numlist)`的设定要对应。

*  `range(numlist)`括号里为时间变量（` timevar`）的取值范围。如果为连续时间，可以设置为`tobalance, range(2001 2008)`，表示将前面设定的面板数据转换为2001-2008年八年间的平衡面板。如果为非连续时间，可以设置为`balance, range(2001/2003, 2005, 2007/2010)`表示将前面设定的面板数据转换为2001-2003（三年），2005（一年）， 2007-2010（四年）共8年的平衡面板。时间的设定不要求按从小到大或者从大到小的顺序书写，任意顺序均可。

* `miss(varlist)`括号里为变量列表，可以写一个或多个变量，表示再删除选定变量的缺省值后再进行平衡面板的转换。

* 设定案例：`balance, var(firm year) range(2001 2008)`表示保留2001-2008年8年间企业均存在出口行为的样本，前面不需要用 `xtset` 或 `tsset`设定面板，其等同于`xtset firm year` 加 `balance, range(2001 2008)`。`balance, var(firm product year) range(2001 2008)`表示保留2001-2008年8年间企业-产品组均存在出口行为的样本。`balance, var(firm product year) range(2001 2003, 2007)`表示保留2001-2003与2007年四年间企业-产品对均存在出口行为的样本观测值。

* 注意：`range(numlist)`的设定与`xtbalance`有所差异，在`xtbalance`中range(2001 2008)表示2001至2008年（8年），`tobalance`中`range(2001 2008)`表示2001与2008年（两年），`tobalance`中`range(2001/2008)`或者`range(2001(1)2008)`可以表示2001至2008年。`tobalance`中`range(numlist)`的设定与`forvalues`循环中的设定方式保持一致。

### 2.`tobalance`在连续时间中的应用

在本部分笔者将伪造一份贸易数据来解析`tobalance`命令对数据处理的过程。

#### 2.1 生成数据

我们首先生成一份贸易数据，100家国内公司（`firm`）在2001-2010年10年间（`year`）出口10种产品（`product`）到10个国家（`country`）共10万观测值的连续时间、高维、平衡数据。

```Stata 
. clear

. set obs 100000
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

. count
  100,000
```
鉴于firm product coutry year的4维数据无法直接设定面板，在数据生成中对firm product coutry进行分组配对（`egen id=group(firm product country)`），生成的id变量取值范围为1-10000，每个id对应10年，这样便可以对id和year进行面板设定。

接下来，利用随机函数将平衡数据转换成非平衡数据，为了保证操作的可重复性在数据删除的过程中设定了种子，每条观测值被删除的概率为50%。

```Stata 

. set seed 123456

. //设定种子以使得操作可重复
. drop if runiform() <0.5
(49,921 observations deleted)

. dis _N
50079

. xtset id year
       panel variable:  id (unbalanced)
        time variable:  year, 2001 to 2010, but with gaps
                delta:  1 unit

. count
  50,079

```
利用随机函数进行删除后，样本观测值由100000减少至50079个。


#### 2.2 面板数据的处理
设定案例：`tobalance, idvar(id) timevar(year) range(2001/2008)`表示保留2001-2008年8年间企业-产品-国家对均存在出口行为的样本。在使用`tobalance`命令时，`idvar`和`timevar`为所接受的个体标识变量和时间标识变量，若当前数据集已经声明个体标识和时间标记`（cmd:xtset）`，可不必继续设置`idvar`和`timevar`。因此，命令也可以设定为`tobalance, range(2001/2008)`或者`tobalance, range(2001（1）2008)`
```Stata 
. preserve
. tobalance, idvar(id) timevar(year) range(2001/2008)
OutRange: 10007 observations deleted
Total   : 49775 observations deleted
. count
  304
. restore

. preserve
. tobalance,  range(2001/2008)
OutRange: 10007 observations deleted
Total   : 49775 observations deleted
. count
  304
. restore

. preserve
. tobalance,  range(2001(1)2008)
OutRange: 10007 observations deleted
Total   : 49775 observations deleted
. count
  304
. restore
```
上面演示的是常规面板的数据处理，而在贸易等领域，高维数据的应用逐渐流行，常规的方法逐渐脱节。以上述数据为例，在研究企业出口行为时，一般以企业、产品研究对象，例我们需要生成样本期间企业产品为平衡的数据集，即样本期间企业和其产品在所有年度都有观测值（而不去管产品是否在每一年度都出口了同一国家，只要该公司产品有出口）。下面是`tobalance`在高维数据中的使用演示。

#### 2.3 高维不使用`tobalance`的处理流程

设定案例：`tobalance, idvar(firm product) timevar(year) range(2001/2008)`表示保留2001-2008年8年间企业-产品对均存在出口行为的样本。

第一步，删除不在样本范围内的样本。
```Stata 
. sort firm product year

. drop if year<2001 | year>2008
(10,007 observations deleted)
```
第二步，保留2001-2008年8年间企业-产品对均存在出口行为的样本。
```Stata 
. quietly :tab year

. gen lin1 = r(r)

. bysort firm product (year): gen lin2=sum(year!=year[_n-1])

. bysort firm product: egen lin3=max(lin2)

. keep if lin3==lin1
(299 observations deleted)

. drop lin*

. count
  39,773
```

#### 2.4 高维使用`tobalance`的处理流程
```Stata 
. tobalance, idvar(firm product) timevar(year) range(2001/2008)
OutRange: 10007 observations deleted
Total   : 10306 observations deleted

. count
  39,773
```
### 3.`tobalance`在非连续时间中的应用
* 演示案例：`tobalance, idvar(firm product) timevar(year) range(2001/2003 2007)`
* 保留2001-2003与2007年四年间企业-产品对均存在出口行为的样本观测值。

#### 3.1 生成数据
本部分继续用前文所构造的贸易数据来进行模拟，数据生成的方式见`2.1`小节。
#### 3.2 不使用`tobalance`的处理流程
第一步，删除时间范围外的样本。
```Stata 
. sort firm product year

. //删除选定范围外的样本观测值
. drop if year>2003 & year<2007
(15,033 observations deleted)

. drop if year>2007
(15,006 observations deleted)
```
第二步，筛选出企业-产品组在设定范围（`2001 2003, 2007`）内均存在出口行为的样本。
```Stata 
. quietly :tab year

. gen lin1 = r(r)

. bysort firm product (year): gen lin2=sum(year!=year[_n-1])

. bysort firm product: egen lin3=max(lin2)

. keep if lin3==lin1
(63 observations deleted)

. drop lin*

. count
  19,977
```

#### 3.3 使用`tobalance`的处理流程
```Stata 
. tobalance, idvar(firm product) timevar(year) range(2001/2003 2007)
OutRange: 30039 observations deleted
Total   : 30102 observations deleted

. count
  19,977
```
### 4.`tobalance`与`xtbalance`的联系与区别
* 联系：`tobalance`与`xtbalance`都可以将非平衡面板数据转换为平衡面板。
* 区别：`tobalance`使得`xtbalance`摆脱了面板数据的限制，扩大其使用的范围。
* 改进：（1）不需要专门设定面板；（2）兼容了对非连续时间的处理；（3）可以处理高维数据的转换；（4）兼容了以往`xtbalance`的设定；（5）增加了对选定变量缺省值的处理；（6）处理速度提高了10-20倍。

- `tobalance`与`xtbalance`处理面板数据速率对比。
```Stata 
. preserve
. timer clear 1
. timer on 1
. tobalance,idvar(id) timevar(year) range(2001/2008)
OutRange: 10007 observations deleted
Total   : 49775 observations deleted
. timer off 1
. timer list 1
   1:      0.03 /        1 =       0.0310
. count
  304
. restore

. preserve
. timer clear 1
. timer on 1
. xtset id year
       panel variable:  id (unbalanced)
        time variable:  year, 2001 to 2010, but with gaps
                delta:  1 unit
. xtbalance , range(2001 2008)
(10007 observations deleted due to out of range) 
(39768 observations deleted due to discontinues) 
. timer off 1
. timer list 1
   1:      0.57 /        1 =       0.5730
. count
  304
. restore
```

### 5. 后记 (连玉君)

在写作这篇推文过程中，我与吴雄多次沟通，受到了不少启发。

后续我们会将文中提及的 `xtbalance` 的局限一一解决掉，以便大家能够更为便捷地进行非平衡面板 &rarr; 平衡面板的转换。

计划添加的功能如下(欢迎各位补充，反馈至：arlionn@163.com )：
- 添加 `delta()` 选项：以便处理**有固定间隔的平衡面板数据**；
- 添加 `gen(newvarname)` 选项：以便对平衡面板构成的观察值进行标记；
- 添加 `force` 选项：由程序自动对用户的数据进行处理；
- ……

&emsp;

---


>#### 关于我们

- 【**Stata 连享会(公众号：StataChina)**】由中山大学连玉君老师团队创办，旨在定期与大家分享 Stata 应用的各种经验和技巧。
- 公众号推文同步发布于 [CSDN-Stata连享会](https://blog.csdn.net/arlionn) 、[简书-Stata连享会](http://www.jianshu.com/u/69a30474ef33) 和 [知乎-连玉君Stata专栏](https://www.zhihu.com/people/arlionn)。可以在上述网站中搜索关键词`Stata`或`Stata连享会`后关注我们。
- 点击推文底部【阅读原文】可以查看推文中的链接并下载相关资料。
- Stata连享会 [精彩推文1](https://gitee.com/arlionn/stata_training/blob/master/README.md)  || [精彩推文2](https://github.com/arlionn/stata/blob/master/README.md)

>#### 联系我们

- **欢迎赐稿：** 欢迎将您的文章或笔记投稿至`Stata连享会(公众号: StataChina)`，我们会保留您的署名；录用稿件达`五篇`以上，即可**免费**获得 Stata 现场培训 (初级或高级选其一) 资格。
- **意见和资料：** 欢迎您的宝贵意见，您也可以来信索取推文中提及的程序和数据。
- **招募英才：** 欢迎加入我们的团队，一起学习 Stata。合作编辑或撰写稿件五篇以上，即可**免费**获得 Stata 现场培训 (初级或高级选其一) 资格。
- **联系邮件：** StataChina@163.com

>#### 往期精彩推文
- [Stata连享会推文列表1](https://www.jianshu.com/p/de82fdc2c18a) 
- [Stata连享会推文列表2](https://gitee.com/arlionn/jianshu/blob/master/README.md)
- Stata连享会 [精彩推文1](https://gitee.com/arlionn/stata_training/blob/master/README.md)  || [精彩推文2](https://github.com/arlionn/stata/blob/master/README.md)

![](https://upload-images.jianshu.io/upload_images/7692714-8b1fb0b5068487af.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



---
![欢迎加入Stata连享会(公众号: StataChina)](http://upload-images.jianshu.io/upload_images/7692714-c317947be074a605.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "扫码关注 Stata 连享会")