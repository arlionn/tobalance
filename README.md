&emsp;

> ���ߣ�չ��Ӿ (���⾭��ó�״�ѧ)      ���ۣ���̶��ѧ�� ���ܣ���ɽ��ѧ��
>     
> Stata ����᣺ [֪��](https://zhuanlan.zhihu.com/arlion) | [����](http://www.jianshu.com/u/69a30474ef33) | [����](https://gitee.com/arlionn)

&emsp;

- Stata����� [��������1](https://gitee.com/arlionn/stata_training/blob/master/README.md)  || [��������2](https://github.com/arlionn/stata/blob/master/README.md)

![](https://upload-images.jianshu.io/upload_images/7692714-8b1fb0b5068487af.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

  

��һ������ݲ�ͬ����ҵ�����ó�����������Ǹ�ά�ģ������ҹ��������ݿ��еĽ���������һ��Ϊ4ά�ģ���ҵA��ʱ��B���ڣ�����ڣ���ƷC�����ӣ�����D���ڴ���ó�����ݵĹ����б��߷��ֺܶദ��������ݣ��൱�ڶ�ά��������׷�ʧЧ���м��ڴˣ�����ϣ���ܹ���������������еĳ���������и��죬�����������õķ�Χ���ڱ����У����߾�ͨ�����������ʦ����д��xtbalance�������ƣ����ܲ�����ȷ����ʱ����Ϊtobalance������ʹ���ܹ���ɸ�ά���������ݵĴ���

### Ŀ¼
* ƽ������ת���ı���
* 1.`tobalance`���
* 2.`tobalance`������ʱ���е�Ӧ��
	* 2.1 ��������
	* 2.2 ������ݵĴ���
	* 2.3 ��ά��ʹ��`tobalance`�Ĵ�������
	* 2.4 ��άʹ��`tobalance`�Ĵ�������
* 3.`tobalance`�ڷ�����ʱ���е�Ӧ��
	* 3.1 ��������
	* 3.2 ��ʹ��`tobalance`�Ĵ�������
	* 3.3 ʹ��`tobalance`�Ĵ�������
* 4.`tobalance`��`xtbalance`����������ϵ

### ƽ������ת���ı���
- Ϊ��ת��ƽ����壺��ʵ�ϣ���ʵ֤�����У�����Ҫ�����ݽṹΪƽ�����ݣ�������ƽ������ǿ��ת����ƽ�����ݵĹ����л�ɾ��һ���������۲�ֵ���������ѡ����ƫ��ʹ��ʵ֤������ƫ����ô����ʲô�������Ҫ����ƽ������ת��Ϊƽ�������أ����ȣ������������У�Ϊ���о����߷���ǰ����ҵ���������о����壩��Ӫ״���ı仯����Ҫ������Щ������ǰ��������ڼ��������ҵ����������Ҫ����Щ�м��˳������½������ҵ�޳�����Σ��������Է����У��о����ض�ʱ��γ������ڸ�������������ڸ������ü�Ĳ��죻�����һЩ�ض�ģ������Ҫƽ�����ݲ��ܽ��в�����
- ע���������ƽ������ת��Ϊƽ�����ݵĹ����л�ɾ�����������۲�ֵ����������ݴ���ǰ������������ݱ��ݣ��Է�ִ�в�����ԭʼ�����޷��һء�
- ������������ǰ����ƽ������ת��Ϊƽ�����ݵ�������Ҫ��`xtbalance`�������������¾��ޣ�ֻ�ܶ�������ݽ��д������ܴ����ά���ݣ����ݵĴ��������ڶ�������ݵ��������������ʽ�����������������ʱ����趨�����ڴˣ���ͬ����ʦ������ͨ��ͨ���Ż��㷨���ֲ�`xtbalance`��ȱ�ݿ�����`tobalance`���

### 1.`tobalance`���

- ���ܼ�飺`tobalance`��`xtbalance`�Ļ��������Ƶõ�����Ҫ���ڽ���ƽ������ת����ƽ�����ݣ���ά�����б������������ѡ��ʱ�䷶Χ�ھ����ڹ۲�ֵ����������ά���ݱ���ѡ��ά�ȣ��������ά����ѡ��ʱ�䷶Χ�ھ��й۲��������
- �﷨�ṹ��
`tobalance`������stata���õ������Ҫ��װ���ܽ���ʹ�á�Ŀǰ��Ҫ�����°�װ;������1��ͨ�����ƣ�������ɺ���ɳ����ӣ�����tobalance.ado�ļ�����2��`ssc install tobalance`��������ɺ��趨����

`tobalance` ���﷨��ʽ: ` tobalance [, options]`

����optionѡ����` idvar(varlist)��timevar(varlist)��range(numlist) ��miss(varlist)`�ĸ�ѡ��ֱ���Լ�дΪ`i`��`t`��`r`��`m` ������ֱ���н��ܡ�

* ` idvar(varlist)��timevar(varlist)`��ʾ�������������` idvar`����ʱ�������` timevar`���ض���Χ��` range`���ڶ����ڵĹ۲�ֵ��` idvar(varlist)��timevar(varlist)`�ɶԳ��֣����дҪһ��д�������д����ǰ���趨��������еĸ��������ʱ����������û����д����ǰ��Ҳû���趨��壨`xtset panelvar timevar` �� `tsset  panelvar timevar` ����ᱨ��` idvar(varlist)`�����ڿ�����дһ��������������дһ������ʱ���Ƕ�ά������ݵĴ������д�������ʱ���Ǹ�ά���ݵĴ���` timevar(varlist)`��ֻ��дһ������������Ҫ��`range(numlist)`���趨Ҫ��Ӧ��

*  `range(numlist)`������Ϊʱ�������` timevar`����ȡֵ��Χ�����Ϊ����ʱ�䣬��������Ϊ`tobalance, range(2001 2008)`����ʾ��ǰ���趨���������ת��Ϊ2001-2008�������ƽ����塣���Ϊ������ʱ�䣬��������Ϊ`balance, range(2001/2003, 2005, 2007/2010)`��ʾ��ǰ���趨���������ת��Ϊ2001-2003�����꣩��2005��һ�꣩�� 2007-2010�����꣩��8���ƽ����塣ʱ����趨��Ҫ�󰴴�С������ߴӴ�С��˳����д������˳����ɡ�

* `miss(varlist)`������Ϊ�����б�����дһ��������������ʾ��ɾ��ѡ��������ȱʡֵ���ٽ���ƽ������ת����

* �趨������`balance, var(firm year) range(2001 2008)`��ʾ����2001-2008��8�����ҵ�����ڳ�����Ϊ��������ǰ�治��Ҫ�� `xtset` �� `tsset`�趨��壬���ͬ��`xtset firm year` �� `balance, range(2001 2008)`��`balance, var(firm product year) range(2001 2008)`��ʾ����2001-2008��8�����ҵ-��Ʒ������ڳ�����Ϊ��������`balance, var(firm product year) range(2001 2003, 2007)`��ʾ����2001-2003��2007���������ҵ-��Ʒ�Ծ����ڳ�����Ϊ�������۲�ֵ��

* ע�⣺`range(numlist)`���趨��`xtbalance`�������죬��`xtbalance`��range(2001 2008)��ʾ2001��2008�꣨8�꣩��`tobalance`��`range(2001 2008)`��ʾ2001��2008�꣨���꣩��`tobalance`��`range(2001/2008)`����`range(2001(1)2008)`���Ա�ʾ2001��2008�ꡣ`tobalance`��`range(numlist)`���趨��`forvalues`ѭ���е��趨��ʽ����һ�¡�

### 2.`tobalance`������ʱ���е�Ӧ��

�ڱ����ֱ��߽�α��һ��ó������������`tobalance`��������ݴ���Ĺ��̡�

#### 2.1 ��������

������������һ��ó�����ݣ�100�ҹ��ڹ�˾��`firm`����2001-2010��10��䣨`year`������10�ֲ�Ʒ��`product`����10�����ң�`country`����10��۲�ֵ������ʱ�䡢��ά��ƽ�����ݡ�

```Stata 
. clear

. set obs 100000
number of observations (_N) was 0, now 100,000

. gen firm =int(_n/1000.001)+1

. //100����ҵ�ı���Ϊ��1-100���ֱ��ʾ��1����ҵ����100����ҵ��
. bysort firm: gen  product = int(_n/100.001)+100001

. //�������ݿ��в�Ʒ������2��4��6��8��λ�Σ���ѧ���о��д����6λ��Ʒ���ش��룬���α�������в�Ʒ��ȡֵΪ100001-100010��10�ֲ�Ʒ��
. bysort firm product: gen country = int(_n/10.001)+1

. //10�����ڹ��ı���Ϊ��1-10���ֱ��ʾ��1�����ڹ�����10�����ڹ���
. bysort firm product country: gen year = _n+2000

. //ʱ���ȡֵΪ2001-2010��ȡֵ2001��ʾ2001��ĳ��ڡ�
. egen id=group(firm product country)

. xtset id year
       panel variable:  id (strongly balanced)
        time variable:  year, 2001 to 2010
                delta:  1 unit

. count
  100,000
```
����firm product coutry year��4ά�����޷�ֱ���趨��壬�����������ж�firm product coutry���з�����ԣ�`egen id=group(firm product country)`�������ɵ�id����ȡֵ��ΧΪ1-10000��ÿ��id��Ӧ10�꣬��������Զ�id��year��������趨��

���������������������ƽ������ת���ɷ�ƽ�����ݣ�Ϊ�˱�֤�����Ŀ��ظ���������ɾ���Ĺ������趨�����ӣ�ÿ���۲�ֵ��ɾ���ĸ���Ϊ50%��

```Stata 

. set seed 123456

. //�趨������ʹ�ò������ظ�
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
���������������ɾ���������۲�ֵ��100000������50079����


#### 2.2 ������ݵĴ���
�趨������`tobalance, idvar(id) timevar(year) range(2001/2008)`��ʾ����2001-2008��8�����ҵ-��Ʒ-���ҶԾ����ڳ�����Ϊ����������ʹ��`tobalance`����ʱ��`idvar`��`timevar`Ϊ�����ܵĸ����ʶ������ʱ���ʶ����������ǰ���ݼ��Ѿ����������ʶ��ʱ����`��cmd:xtset��`���ɲ��ؼ�������`idvar`��`timevar`����ˣ�����Ҳ�����趨Ϊ`tobalance, range(2001/2008)`����`tobalance, range(2001��1��2008)`
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
������ʾ���ǳ����������ݴ�������ó�׵����򣬸�ά���ݵ�Ӧ�������У�����ķ������ѽڡ�����������Ϊ�������о���ҵ������Ϊʱ��һ������ҵ����Ʒ�о�������������Ҫ���������ڼ���ҵ��ƷΪƽ������ݼ����������ڼ���ҵ�����Ʒ��������ȶ��й۲�ֵ������ȥ�ܲ�Ʒ�Ƿ���ÿһ��ȶ�������ͬһ���ң�ֻҪ�ù�˾��Ʒ�г��ڣ���������`tobalance`�ڸ�ά�����е�ʹ����ʾ��

#### 2.3 ��ά��ʹ��`tobalance`�Ĵ�������

�趨������`tobalance, idvar(firm product) timevar(year) range(2001/2008)`��ʾ����2001-2008��8�����ҵ-��Ʒ�Ծ����ڳ�����Ϊ��������

��һ����ɾ������������Χ�ڵ�������
```Stata 
. sort firm product year

. drop if year<2001 | year>2008
(10,007 observations deleted)
```
�ڶ���������2001-2008��8�����ҵ-��Ʒ�Ծ����ڳ�����Ϊ��������
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

#### 2.4 ��άʹ��`tobalance`�Ĵ�������
```Stata 
. tobalance, idvar(firm product) timevar(year) range(2001/2008)
OutRange: 10007 observations deleted
Total   : 10306 observations deleted

. count
  39,773
```
### 3.`tobalance`�ڷ�����ʱ���е�Ӧ��
* ��ʾ������`tobalance, idvar(firm product) timevar(year) range(2001/2003 2007)`
* ����2001-2003��2007���������ҵ-��Ʒ�Ծ����ڳ�����Ϊ�������۲�ֵ��

#### 3.1 ��������
�����ּ�����ǰ���������ó������������ģ�⣬�������ɵķ�ʽ��`2.1`С�ڡ�
#### 3.2 ��ʹ��`tobalance`�Ĵ�������
��һ����ɾ��ʱ�䷶Χ���������
```Stata 
. sort firm product year

. //ɾ��ѡ����Χ��������۲�ֵ
. drop if year>2003 & year<2007
(15,033 observations deleted)

. drop if year>2007
(15,006 observations deleted)
```
�ڶ�����ɸѡ����ҵ-��Ʒ�����趨��Χ��`2001 2003, 2007`���ھ����ڳ�����Ϊ��������
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

#### 3.3 ʹ��`tobalance`�Ĵ�������
```Stata 
. tobalance, idvar(firm product) timevar(year) range(2001/2003 2007)
OutRange: 30039 observations deleted
Total   : 30102 observations deleted

. count
  19,977
```
### 4.`tobalance`��`xtbalance`����ϵ������
* ��ϵ��`tobalance`��`xtbalance`�����Խ���ƽ���������ת��Ϊƽ����塣
* ����`tobalance`ʹ��`xtbalance`������������ݵ����ƣ�������ʹ�õķ�Χ��
* �Ľ�����1������Ҫר���趨��壻��2�������˶Է�����ʱ��Ĵ�����3�����Դ����ά���ݵ�ת������4������������`xtbalance`���趨����5�������˶�ѡ������ȱʡֵ�Ĵ�����6�������ٶ������10-20����

- `tobalance`��`xtbalance`��������������ʶԱȡ�
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

### 5. ��� (�����)

��д����ƪ���Ĺ����У��������۶�ι�ͨ���ܵ��˲���������

�������ǻὫ�����ἰ�� `xtbalance` �ľ���һһ��������Ա����ܹ���Ϊ��ݵؽ��з�ƽ����� &rarr; ƽ������ת����

�ƻ���ӵĹ�������(��ӭ��λ���䣬��������arlionn@163.com )��
- ��� `delta()` ѡ��Ա㴦��**�й̶������ƽ���������**��
- ��� `gen(newvarname)` ѡ��Ա��ƽ����幹�ɵĹ۲�ֵ���б�ǣ�
- ��� `force` ѡ��ɳ����Զ����û������ݽ��д���
- ����

&emsp;

---


>#### ��������

- ��**Stata �����(���ںţ�StataChina)**������ɽ��ѧ�������ʦ�ŶӴ��죬ּ�ڶ������ҷ��� Stata Ӧ�õĸ��־���ͼ��ɡ�
- ���ں�����ͬ�������� [CSDN-Stata�����](https://blog.csdn.net/arlionn) ��[����-Stata�����](http://www.jianshu.com/u/69a30474ef33) �� [֪��-�����Stataר��](https://www.zhihu.com/people/arlionn)��������������վ�������ؼ���`Stata`��`Stata�����`���ע���ǡ�
- ������ĵײ����Ķ�ԭ�ġ����Բ鿴�����е����Ӳ�����������ϡ�
- Stata����� [��������1](https://gitee.com/arlionn/stata_training/blob/master/README.md)  || [��������2](https://github.com/arlionn/stata/blob/master/README.md)

>#### ��ϵ����

- **��ӭ�͸壺** ��ӭ���������»�ʼ�Ͷ����`Stata�����(���ں�: StataChina)`�����ǻᱣ������������¼�ø����`��ƪ`���ϣ�����**���**��� Stata �ֳ���ѵ (������߼�ѡ��һ) �ʸ�
- **��������ϣ�** ��ӭ���ı����������Ҳ����������ȡ�������ἰ�ĳ�������ݡ�
- **��ļӢ�ţ�** ��ӭ�������ǵ��Ŷӣ�һ��ѧϰ Stata�������༭��׫д�����ƪ���ϣ�����**���**��� Stata �ֳ���ѵ (������߼�ѡ��һ) �ʸ�
- **��ϵ�ʼ���** StataChina@163.com

>#### ���ھ�������
- [Stata����������б�1](https://www.jianshu.com/p/de82fdc2c18a) 
- [Stata����������б�2](https://gitee.com/arlionn/jianshu/blob/master/README.md)
- Stata����� [��������1](https://gitee.com/arlionn/stata_training/blob/master/README.md)  || [��������2](https://github.com/arlionn/stata/blob/master/README.md)

![](https://upload-images.jianshu.io/upload_images/7692714-8b1fb0b5068487af.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



---
![��ӭ����Stata�����(���ں�: StataChina)](http://upload-images.jianshu.io/upload_images/7692714-c317947be074a605.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "ɨ���ע Stata �����")