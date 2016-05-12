<%
//检查输入信息的有效性
if(sObjectType.equals("CreditApply")) //申请对象
{
	//展期
	if(sDisplayTemplet.equals("ApplyInfo0000")) 
	{
		//设置展期金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"展期金额必须大于等于0！\" ");
		//设置展期期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"展期期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置展期执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"展期执行年利率(%)必须大于等于0！\" ");
	}
	
	//协议付息票据贴现
	if(sDisplayTemplet.equals("ApplyInfo0020"))
	{
		//设置票据数量(张)范围
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"票据数量(张)必须大于等于0！\" ");
		//设置票据总金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"票据总金额必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置买方应付贴现利息范围
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"买方应付贴现利息必须大于等于0！\" ");
	}
	
	//商业承兑汇票保贴
	if(sDisplayTemplet.equals("ApplyInfo0030"))
	{
		//设置汇票数量(张)范围
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"汇票数量(张)必须大于等于0！\" ");
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置承诺费范围
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承诺费必须大于等于0！\" ");
	}
	
	//基本建设项目贷款、技术改造项目贷款、其他类项目贷款
	if(sDisplayTemplet.equals("ApplyInfo0040"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置提款期限(月)范围
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"提款期限(月)必须大于等于0！\" ");
		//设置贷款宽限期(月)范围
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贷款宽限期(月)必须大于等于0！\" ");
	}
	
	//法人购房贷款
	if(sDisplayTemplet.equals("ApplyInfo0050"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置房产建筑面积范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房产建筑面积必须大于等于0！\" ");
		//设置房产套内面积范围
		doTemp.appendHTMLStyle("UseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房产套内面积必须大于等于0！\" ");
		//设置购房合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"购房合同金额必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
	}
	
	//汽车法人按揭
	if(sDisplayTemplet.equals("ApplyInfo0060"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置购车合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"购车合同金额必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
	}
	
	//设备法人按揭
	if(sDisplayTemplet.equals("ApplyInfo0070"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置购买机器设备合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"购买机器设备合同金额必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
	}
	
	//其他法人按揭
	if(sDisplayTemplet.equals("ApplyInfo0080"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置按揭资产使用年限范围
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"按揭资产使用年限必须大于等于0！\" ");
		//设置按揭资产合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"按揭资产合同金额必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
	}
	
	//银团贷款
	if(sDisplayTemplet.equals("ApplyInfo0090"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置宽限期(月)范围
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"宽限期(月)必须大于等于0！\" ");
		//设置银团贷款总金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"银团贷款总金额必须大于等于0！\" ");
		//设置提款期限(月)范围
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"提款期限(月)必须大于等于0！\" ");
		//设置承诺费率(‰)范围
    	doTemp.appendHTMLStyle("PromisesFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"承诺费率(‰)的范围为[0,1000]\" ");
    	//设置承诺费计收期(月)范围
		doTemp.appendHTMLStyle("PromisesFeePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承诺费计收期(月)必须大于等于0！\" ");
		//设置承诺费金额范围
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承诺费金额必须大于等于0！\" ");
		//设置管理费率(‰)范围
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"管理费率(‰)的范围为[0,1000]\" ");
    	//设置管理费金额范围
		doTemp.appendHTMLStyle("MFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"管理费金额必须大于等于0！\" ");
		//设置代理费范围
		doTemp.appendHTMLStyle("AgentFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"代理费必须大于等于0！\" ");
		//设置安排费范围
		doTemp.appendHTMLStyle("DealFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"安排费必须大于等于0！\" ");
		//设置总成本范围
		doTemp.appendHTMLStyle("TotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"总成本必须大于等于0！\" ");
	}
	
	//委托贷款
	if(sDisplayTemplet.equals("ApplyInfo0100"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置委托基金范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"委托基金必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
		//设置违约年利率(%)范围
		doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"违约年利率(%)必须大于等于0！\" ");
	}
	
	//有价证券发行担保
	if(sDisplayTemplet.equals("ApplyInfo0110"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
    	//设置保证金比例(%)范围
    	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
	}
	
	//国家外汇储备转贷款
	if(sDisplayTemplet.equals("ApplyInfo0140"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
		//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
	}
	
	//出口合同打包贷款
	if(sDisplayTemplet.equals("ApplyInfo0190"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置贸易合同总金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贸易合同总金额必须大于等于0！\" ");
		//设置打包成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"打包成数(%)的范围为[0,100]\" ");
	}
	
	//信用证项下进口押汇
	if(sDisplayTemplet.equals("ApplyInfo0240"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置信用证金额范围
		doTemp.appendHTMLStyle("OldLCSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"信用证金额必须大于等于0！\" ");
		//设置对外付汇金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"对外付汇金额必须大于等于0！\" ");
		//设置开证保证金比例(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"开证保证金比例(%)的范围为[0,100]\" ");
	}
	
	//短期流动资金贷款
	if(sDisplayTemplet.equals("ApplyInfo0360"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
	}
	
	//法人帐户透支
	if(sDisplayTemplet.equals("ApplyInfo0380"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置连续透支期(月)范围
		doTemp.appendHTMLStyle("OverDraftPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"连续透支期(月)必须大于等于0！\" ");
		//设置承诺费范围
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承诺费必须大于等于0！\" ");
	}
	
	//出口退税帐户托管贷款
	if(sDisplayTemplet.equals("ApplyInfo0390"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置截止申请日上月应收退税金额范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"截止申请日上月应收退税金额必须大于等于0！\" ");
	}
	
	//银行承兑汇票贴现
	if(sDisplayTemplet.equals("ApplyInfo0410"))
	{
		//设置汇票数量(张)范围
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"汇票数量(张)必须大于等于0！\" ");
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");		
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置承兑汇票项下贸易合同合同标的范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承兑汇票项下贸易合同合同标的必须大于等于0！\" ");
	}
	
	//商业承兑汇票贴现
	if(sDisplayTemplet.equals("ApplyInfo0420"))
	{
		//设置汇票数量(张)范围
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"汇票数量(张)必须大于等于0！\" ");
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");		
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置扣减此次申请贴现金额后保贴额度余额范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"扣减此次申请贴现金额后保贴额度余额必须大于等于0！\" ");
		//设置承兑汇票项下贸易合同合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承兑汇票项下贸易合同合同金额必须大于等于0！\" ");
	}
	
	//房地产开发贷款
	if(sDisplayTemplet.equals("ApplyInfo0430"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置预计开发项目中我行可做个人按揭贷款的金额范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"预计开发项目中我行可做个人按揭贷款的金额必须大于等于0！\" ");
	}
	
	//银行承兑汇票
	if(sDisplayTemplet.equals("ApplyInfo0530"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置贸易背景合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贸易背景合同金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
	}
	
	//贷款担保
	if(sDisplayTemplet.equals("ApplyInfo0533"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置贷款金额范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贷款金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
	}
	
	//银行信贷证明
	if(sDisplayTemplet.equals("ApplyInfo0534"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
	}
	
	//贷款意向书
	if(sDisplayTemplet.equals("ApplyInfo0535"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
	}
	
	//贷款承诺函
	if(sDisplayTemplet.equals("ApplyInfo0536"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
	}
	
	//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、付款保函、其他融资性保函、
	//投标保函、履约保函、预付款保函、承包工程保函、质量维修保函、海事保函、补偿贸易保函、诉讼保函、
	//留置金保函、加工装配业务进口保函、其他非融资性保函
	if(sDisplayTemplet.equals("ApplyInfo0541"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置项目合同标的范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"项目合同标的必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
	}
	
	//综合授信额度
	if(sDisplayTemplet.equals("ApplyInfo0570"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
	}
	
	//个人住房贷款
	if(sDisplayTemplet.equals("ApplyInfo1010"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑面积（平米）必须大于等于0\" ");
	}
	
	//个人再交易住房贷款
	if(sDisplayTemplet.equals("ApplyInfo1050"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑面积（平米）必须大于等于0\" ");
	}
	
	//个人商业用房按贷款
	if(sDisplayTemplet.equals("ApplyInfo1060"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑面积（平米）必须大于等于0\" ");
	}
	
	//个人再交易商业用房贷款
	if(sDisplayTemplet.equals("ApplyInfo1080"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑面积（平米）必须大于等于0\" ");
	}
	
	//个人保证贷款
	if(sDisplayTemplet.equals("ApplyInfo1130"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
	}
	
	//个人质押贷款、个人抵押贷款
	if(sDisplayTemplet.equals("ApplyInfo1140"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
	}
	
	//个人住房装修贷款
	if(sDisplayTemplet.equals("ApplyInfo1160"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置房产套内面积/建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房产套内面积/建筑面积（平米）必须大于等于0\" ");
	}
	
	//个人经营贷款
	if(sDisplayTemplet.equals("ApplyInfo1170"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
	}
	
	//个人委托贷款
	if(sDisplayTemplet.equals("ApplyInfo1180"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
	}
	
	//个人付款保函
	if(sDisplayTemplet.equals("ApplyInfo1190"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
    	//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
	}
	
	//个人房屋贷款合作项目
	if(sDisplayTemplet.equals("ApplyInfo1200"))
	{
		//设置申请敞口总额度范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请敞口总额度必须大于等于0！\" ");
		//设置额度有效期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"额度有效期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
    	//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
    	//设置项目总面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"项目总面积（平米）必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
	}
	
	//个贷其它合作商
	if(sDisplayTemplet.equals("ApplyInfo1210"))
	{
		//设置申请敞口总额度范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请敞口总额度必须大于等于0！\" ");
		//设置额度有效期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"额度有效期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
    	//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
	}
	
	//个人住房公积金贷款
	if(sDisplayTemplet.equals("ApplyInfo1220"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置房产套内面积/建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房产套内面积/建筑面积（平米）必须大于等于0\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
	}
	
	//个人营运汽车贷款
	if(sDisplayTemplet.equals("ApplyInfo1240"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
	}
	
	//个人消费汽车贷款
	if(sDisplayTemplet.equals("ApplyInfo1250"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
	}
	
	//汽车消费贷款合作经销商
	if(sDisplayTemplet.equals("ApplyInfo1260"))
	{
		//设置申请敞口总额度范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请敞口总额度必须大于等于0！\" ");
		//设置额度有效期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"额度有效期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
    	//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
	}
	
	//个人经营循环贷款
	if(sDisplayTemplet.equals("ApplyInfo1330"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
	}
	
	//个人抵押循环贷款
	if(sDisplayTemplet.equals("ApplyInfo1340"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
	}
	
	//个人小额信用贷款
	if(sDisplayTemplet.equals("ApplyInfo1350"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
	}
	
	//商业助学贷款
	if(sDisplayTemplet.equals("ApplyInfo1360"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
	}
	
	//国家助学贷款
	if(sDisplayTemplet.equals("ApplyInfo1370"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
	}
	
	//个人自助质押贷款
	if(sDisplayTemplet.equals("ApplyInfo1390"))
	{
		//设置申请金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
	}
}
if(sObjectType.equals("ApproveApply")) //最终审批意见对象
{
	//展期
	if(sDisplayTemplet.equals("ApproveInfo0000")) 
	{
		//设置批准展期金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准展期金额必须大于等于0！\" ");
		//设置展期期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"展期期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置展期执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"展期执行年利率(%)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//协议付息票据贴现
	if(sDisplayTemplet.equals("ApproveInfo0020"))
	{
		//设置票据数量(张)范围
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"票据数量(张)必须大于等于0！\" ");
		//设置批准票据总金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准票据总金额必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置买方应付贴现利息范围
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"买方应付贴现利息必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//商业承兑汇票保贴
	if(sDisplayTemplet.equals("ApproveInfo0030"))
	{
		//设置汇票数量(张)范围
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"汇票数量(张)必须大于等于0！\" ");
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置承诺费范围
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承诺费必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//基本建设项目贷款、技术改造项目贷款、其他类项目贷款
	if(sDisplayTemplet.equals("ApproveInfo0040"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置提款期限(月)范围
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"提款期限(月)必须大于等于0！\" ");
		//设置贷款宽限期(月)范围
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贷款宽限期(月)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//法人购房贷款
	if(sDisplayTemplet.equals("ApproveInfo0050"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置房产建筑面积范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房产建筑面积必须大于等于0！\" ");
		//设置房产套内面积范围
		doTemp.appendHTMLStyle("UseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房产套内面积必须大于等于0！\" ");
		//设置购房合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"购房合同金额必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//汽车法人按揭
	if(sDisplayTemplet.equals("ApproveInfo0060"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置购车合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"购车合同金额必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//设备法人按揭
	if(sDisplayTemplet.equals("ApproveInfo0070"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置购买机器设备合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"购买机器设备合同金额必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//其他法人按揭
	if(sDisplayTemplet.equals("ApproveInfo0080"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置按揭资产使用年限范围
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"按揭资产使用年限必须大于等于0！\" ");
		//设置按揭资产合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"按揭资产合同金额必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//银团贷款
	if(sDisplayTemplet.equals("ApproveInfo0090"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置宽限期(月)范围
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"宽限期(月)必须大于等于0！\" ");
		//设置银团贷款总金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"银团贷款总金额必须大于等于0！\" ");
		//设置提款期限(月)范围
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"提款期限(月)必须大于等于0！\" ");
		//设置承诺费率(‰)范围
    	doTemp.appendHTMLStyle("PromisesFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"承诺费率(‰)的范围为[0,1000]\" ");
    	//设置承诺费计收期(月)范围
		doTemp.appendHTMLStyle("PromisesFeePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承诺费计收期(月)必须大于等于0！\" ");
		//设置承诺费金额范围
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承诺费金额必须大于等于0！\" ");
		//设置管理费率(‰)范围
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"管理费率(‰)的范围为[0,1000]\" ");
    	//设置管理费金额范围
		doTemp.appendHTMLStyle("MFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"管理费金额必须大于等于0！\" ");
		//设置代理费范围
		doTemp.appendHTMLStyle("AgentFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"代理费必须大于等于0！\" ");
		//设置安排费范围
		doTemp.appendHTMLStyle("DealFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"安排费必须大于等于0！\" ");
		//设置总成本范围
		doTemp.appendHTMLStyle("TotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"总成本必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//委托贷款
	if(sDisplayTemplet.equals("ApproveInfo0100"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置委托基金范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"委托基金必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
		//设置违约年利率(%)范围
		doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"违约年利率(%)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//有价证券发行担保
	if(sDisplayTemplet.equals("ApproveInfo0110"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
    	//设置保证金比例(%)范围
    	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
    	//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//国家外汇储备转贷款
	if(sDisplayTemplet.equals("ApproveInfo0140"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
		//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//出口合同打包贷款
	if(sDisplayTemplet.equals("ApproveInfo0190"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置贸易合同总金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贸易合同总金额必须大于等于0！\" ");
		//设置打包成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"打包成数(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//信用证项下进口押汇
	if(sDisplayTemplet.equals("ApproveInfo0240"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置信用证金额范围
		doTemp.appendHTMLStyle("OldLCSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"信用证金额必须大于等于0！\" ");
		//设置对外付汇金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"对外付汇金额必须大于等于0！\" ");
		//设置开证保证金比例(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"开证保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//短期流动资金贷款
	if(sDisplayTemplet.equals("ApproveInfo0360"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//法人帐户透支
	if(sDisplayTemplet.equals("ApproveInfo0380"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置连续透支期(月)范围
		doTemp.appendHTMLStyle("OverDraftPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"连续透支期(月)必须大于等于0！\" ");
		//设置承诺费范围
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承诺费必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//出口退税帐户托管贷款
	if(sDisplayTemplet.equals("ApproveInfo0390"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置截止申请日上月应收退税金额范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"截止申请日上月应收退税金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//银行承兑汇票贴现
	if(sDisplayTemplet.equals("ApproveInfo0410"))
	{
		//设置汇票数量(张)范围
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"汇票数量(张)必须大于等于0！\" ");
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");		
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置承兑汇票项下贸易合同合同标的范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承兑汇票项下贸易合同合同标的必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//商业承兑汇票贴现
	if(sDisplayTemplet.equals("ApproveInfo0420"))
	{
		//设置汇票数量(张)范围
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"汇票数量(张)必须大于等于0！\" ");
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");		
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置扣减此次申请贴现金额后保贴额度余额范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"扣减此次申请贴现金额后保贴额度余额必须大于等于0！\" ");
		//设置承兑汇票项下贸易合同合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承兑汇票项下贸易合同合同金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//房地产开发贷款
	if(sDisplayTemplet.equals("ApproveInfo0430"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0！\" ");
		//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置预计开发项目中我行可做个人按揭贷款的金额范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"预计开发项目中我行可做个人按揭贷款的金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//银行承兑汇票
	if(sDisplayTemplet.equals("ApproveInfo0530"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置贸易背景合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贸易背景合同金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//贷款担保
	if(sDisplayTemplet.equals("ApproveInfo0533"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置贷款金额范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贷款金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//银行信贷证明
	if(sDisplayTemplet.equals("ApproveInfo0534"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//贷款意向书
	if(sDisplayTemplet.equals("ApproveInfo0535"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//贷款承诺函
	if(sDisplayTemplet.equals("ApproveInfo0536"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、付款保函、其他融资性保函、
	//投标保函、履约保函、预付款保函、承包工程保函、质量维修保函、海事保函、补偿贸易保函、诉讼保函、
	//留置金保函、加工装配业务进口保函、其他非融资性保函
	if(sDisplayTemplet.equals("ApproveInfo0541"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置项目合同标的范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"项目合同标的必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//综合授信额度
	if(sDisplayTemplet.equals("ApproveInfo0570"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人住房贷款
	if(sDisplayTemplet.equals("ApproveInfo1010"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑面积（平米）必须大于等于0\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人再交易住房贷款
	if(sDisplayTemplet.equals("ApproveInfo1050"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑面积（平米）必须大于等于0\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人商业用房按贷款
	if(sDisplayTemplet.equals("ApproveInfo1060"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑面积（平米）必须大于等于0\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人再交易商业用房贷款
	if(sDisplayTemplet.equals("ApproveInfo1080"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑面积（平米）必须大于等于0\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人保证贷款
	if(sDisplayTemplet.equals("ApproveInfo1130"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值(%)范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值(%)必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人质押贷款、个人抵押贷款
	if(sDisplayTemplet.equals("ApproveInfo1140"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值(%)范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值(%)必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人住房装修贷款
	if(sDisplayTemplet.equals("ApproveInfo1160"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置房产套内面积/建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房产套内面积/建筑面积（平米）必须大于等于0\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人经营贷款
	if(sDisplayTemplet.equals("ApproveInfo1170"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人委托贷款
	if(sDisplayTemplet.equals("ApproveInfo1180"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人付款保函
	if(sDisplayTemplet.equals("ApproveInfo1190"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
    	//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人房屋贷款合作项目
	if(sDisplayTemplet.equals("ApproveInfo1200"))
	{
		//设置批准敞口总额度范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准敞口总额度必须大于等于0！\" ");
		//设置额度有效期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"额度有效期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
    	//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
    	//设置项目总面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"项目总面积（平米）必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个贷其它合作商
	if(sDisplayTemplet.equals("ApproveInfo1210"))
	{
		//设置批准敞口总额度范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准敞口总额度必须大于等于0！\" ");
		//设置额度有效期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"额度有效期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
    	//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人住房公积金贷款
	if(sDisplayTemplet.equals("ApproveInfo1220"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置房产套内面积/建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房产套内面积/建筑面积（平米）必须大于等于0\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人营运汽车贷款
	if(sDisplayTemplet.equals("ApproveInfo1240"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人消费汽车贷款
	if(sDisplayTemplet.equals("ApproveInfo1250"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//汽车消费贷款合作经销商
	if(sDisplayTemplet.equals("ApproveInfo1260"))
	{
		//设置申请敞口总额度范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请敞口总额度必须大于等于0！\" ");
		//设置额度有效期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"额度有效期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
    	//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人经营循环贷款
	if(sDisplayTemplet.equals("ApproveInfo1330"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人抵押循环贷款
	if(sDisplayTemplet.equals("ApproveInfo1340"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人小额信用贷款
	if(sDisplayTemplet.equals("ApproveInfo1350"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//商业助学贷款
	if(sDisplayTemplet.equals("ApproveInfo1360"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//国家助学贷款
	if(sDisplayTemplet.equals("ApproveInfo1370"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人自助质押贷款
	if(sDisplayTemplet.equals("ApproveInfo1390"))
	{
		//设置批准金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"批准金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
}

if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //合同对象
{
	//展期
	if(sDisplayTemplet.equals("ContractInfo0000")) 
	{
		//设置展期金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"展期金额必须大于等于0！\" ");
		//设置展期期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"展期期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置展期执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"展期执行年利率(%)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//协议付息票据贴现
	if(sDisplayTemplet.equals("ContractInfo0020"))
	{
		//设置票据数量(张)范围
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"票据数量(张)必须大于等于0！\" ");
		//设置票据总金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"票据总金额必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置买方应付贴现利息范围
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"买方应付贴现利息必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//商业承兑汇票保贴
	if(sDisplayTemplet.equals("ContractInfo0030"))
	{
		//设置汇票数量(张)范围
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"汇票数量(张)必须大于等于0！\" ");
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置承诺费范围
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承诺费必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//基本建设项目贷款、技术改造项目贷款、其他类项目贷款
	if(sDisplayTemplet.equals("ContractInfo0040"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置提款期限(月)范围
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"提款期限(月)必须大于等于0！\" ");
		//设置贷款宽限期(月)范围
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贷款宽限期(月)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//法人购房贷款
	if(sDisplayTemplet.equals("ContractInfo0050"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置房产建筑面积范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房产建筑面积必须大于等于0！\" ");
		//设置房产套内面积范围
		doTemp.appendHTMLStyle("UseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房产套内面积必须大于等于0！\" ");
		//设置购房合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"购房合同金额必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//汽车法人按揭
	if(sDisplayTemplet.equals("ContractInfo0060"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置购车合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"购车合同金额必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//设备法人按揭
	if(sDisplayTemplet.equals("ContractInfo0070"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置购买机器设备合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"购买机器设备合同金额必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//其他法人按揭
	if(sDisplayTemplet.equals("ContractInfo0080"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置按揭资产使用年限范围
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"按揭资产使用年限必须大于等于0！\" ");
		//设置按揭资产合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"按揭资产合同金额必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//银团贷款
	if(sDisplayTemplet.equals("ContractInfo0090"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置宽限期(月)范围
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"宽限期(月)必须大于等于0！\" ");
		//设置银团贷款总金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"银团贷款总金额必须大于等于0！\" ");
		//设置提款期限(月)范围
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"提款期限(月)必须大于等于0！\" ");
		//设置承诺费率(‰)范围
    	doTemp.appendHTMLStyle("PromisesFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"承诺费率(‰)的范围为[0,1000]\" ");
    	//设置承诺费计收期(月)范围
		doTemp.appendHTMLStyle("PromisesFeePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承诺费计收期(月)必须大于等于0！\" ");
		//设置承诺费金额范围
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承诺费金额必须大于等于0！\" ");
		//设置管理费率(‰)范围
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"管理费率(‰)的范围为[0,1000]\" ");
    	//设置管理费金额范围
		doTemp.appendHTMLStyle("MFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"管理费金额必须大于等于0！\" ");
		//设置代理费范围
		doTemp.appendHTMLStyle("AgentFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"代理费必须大于等于0！\" ");
		//设置安排费范围
		doTemp.appendHTMLStyle("DealFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"安排费必须大于等于0！\" ");
		//设置总成本范围
		doTemp.appendHTMLStyle("TotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"总成本必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//委托贷款
	if(sDisplayTemplet.equals("ContractInfo0100"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置委托基金范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"委托基金必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
		//设置违约年利率(%)范围
		doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"违约年利率(%)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//有价证券发行担保
	if(sDisplayTemplet.equals("ContractInfo0110"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
    	//设置保证金比例(%)范围
    	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
    	//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//国家外汇储备转贷款
	if(sDisplayTemplet.equals("ContractInfo0140"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
		//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//出口合同打包贷款
	if(sDisplayTemplet.equals("ContractInfo0190"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置贸易合同总金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贸易合同总金额必须大于等于0！\" ");
		//设置打包成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"打包成数(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//信用证项下进口押汇
	if(sDisplayTemplet.equals("ContractInfo0240"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置信用证金额范围
		doTemp.appendHTMLStyle("OldLCSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"信用证金额必须大于等于0！\" ");
		//设置对外付汇金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"对外付汇金额必须大于等于0！\" ");
		//设置开证保证金比例(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"开证保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//短期流动资金贷款
	if(sDisplayTemplet.equals("ContractInfo0360"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//法人帐户透支
	if(sDisplayTemplet.equals("ContractInfo0380"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置连续透支期(月)范围
		doTemp.appendHTMLStyle("OverDraftPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"连续透支期(月)必须大于等于0！\" ");
		//设置承诺费范围
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承诺费必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//出口退税帐户托管贷款
	if(sDisplayTemplet.equals("ContractInfo0390"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置截止申请日上月应收退税金额范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"截止申请日上月应收退税金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//银行承兑汇票贴现
	if(sDisplayTemplet.equals("ContractInfo0410"))
	{
		//设置汇票数量(张)范围
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"汇票数量(张)必须大于等于0！\" ");
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");		
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置承兑汇票项下贸易合同合同标的范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承兑汇票项下贸易合同合同标的必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//商业承兑汇票贴现
	if(sDisplayTemplet.equals("ContractInfo0420"))
	{
		//设置汇票数量(张)范围
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"汇票数量(张)必须大于等于0！\" ");
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");		
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置扣减此次申请贴现金额后保贴额度余额范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"扣减此次申请贴现金额后保贴额度余额必须大于等于0！\" ");
		//设置承兑汇票项下贸易合同合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"承兑汇票项下贸易合同合同金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//房地产开发贷款
	if(sDisplayTemplet.equals("ContractInfo0430"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置预计开发项目中我行可做个人按揭贷款的金额范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"预计开发项目中我行可做个人按揭贷款的金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//银行承兑汇票
	if(sDisplayTemplet.equals("ContractInfo0530"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置贸易背景合同金额范围
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贸易背景合同金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//贷款担保
	if(sDisplayTemplet.equals("ContractInfo0533"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置贷款金额范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贷款金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//银行信贷证明
	if(sDisplayTemplet.equals("ContractInfo0534"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//贷款意向书
	if(sDisplayTemplet.equals("ContractInfo0535"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//贷款承诺函
	if(sDisplayTemplet.equals("ContractInfo0536"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、付款保函、其他融资性保函、
	//投标保函、履约保函、预付款保函、承包工程保函、质量维修保函、海事保函、补偿贸易保函、诉讼保函、
	//留置金保函、加工装配业务进口保函、其他非融资性保函
	if(sDisplayTemplet.equals("ContractInfo0541"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置项目合同标的范围
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"项目合同标的必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//综合授信额度
	if(sDisplayTemplet.equals("ContractInfo0570"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人住房贷款
	if(sDisplayTemplet.equals("ContractInfo1010"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值(%)范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值(%)必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑面积（平米）必须大于等于0\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人再交易住房贷款
	if(sDisplayTemplet.equals("ContractInfo1050"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值(%)范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值(%)必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑面积（平米）必须大于等于0\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人商业用房按贷款
	if(sDisplayTemplet.equals("ContractInfo1060"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值(%)范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值(%)必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑面积（平米）必须大于等于0\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人再交易商业用房贷款
	if(sDisplayTemplet.equals("ContractInfo1080"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值(%)范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值(%)必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"建筑面积（平米）必须大于等于0\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人保证贷款
	if(sDisplayTemplet.equals("ContractInfo1130"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值(%)范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值(%)必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人质押贷款、个人抵押贷款
	if(sDisplayTemplet.equals("ContractInfo1140"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值(%)范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值(%)必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人住房装修贷款
	if(sDisplayTemplet.equals("ContractInfo1160"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值(%)范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值(%)必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置房产套内面积/建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房产套内面积/建筑面积（平米）必须大于等于0\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人经营贷款
	if(sDisplayTemplet.equals("ContractInfo1170"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值(%)范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值(%)必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人委托贷款
	if(sDisplayTemplet.equals("ContractInfo1180"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值(%)范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值(%)必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人付款保函
	if(sDisplayTemplet.equals("ContractInfo1190"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置手续费率(‰)范围
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
    	//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人房屋贷款合作项目
	if(sDisplayTemplet.equals("ContractInfo1200"))
	{
		//设置申请敞口总额度范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请敞口总额度必须大于等于0！\" ");
		//设置额度有效期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"额度有效期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
    	//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
    	//设置项目总面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"项目总面积（平米）必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个贷其它合作商
	if(sDisplayTemplet.equals("ContractInfo1210"))
	{
		//设置申请敞口总额度范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请敞口总额度必须大于等于0！\" ");
		//设置额度有效期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"额度有效期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
    	//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人住房公积金贷款
	if(sDisplayTemplet.equals("ContractInfo1220"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置房产套内面积/建筑面积（平米）范围
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"房产套内面积/建筑面积（平米）必须大于等于0\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人营运汽车贷款
	if(sDisplayTemplet.equals("ContractInfo1240"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人消费汽车贷款
	if(sDisplayTemplet.equals("ContractInfo1250"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置贷款成数(%)范围
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"贷款成数(%)的范围为[0,100]\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//汽车消费贷款合作经销商
	if(sDisplayTemplet.equals("ContractInfo1260"))
	{
		//设置申请敞口总额度范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"申请敞口总额度必须大于等于0！\" ");
		//设置额度有效期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"额度有效期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
    	//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人经营循环贷款
	if(sDisplayTemplet.equals("ContractInfo1330"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人抵押循环贷款
	if(sDisplayTemplet.equals("ContractInfo1340"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人小额信用贷款
	if(sDisplayTemplet.equals("ContractInfo1350"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//商业助学贷款
	if(sDisplayTemplet.equals("ContractInfo1360"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值(%)范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值(%)必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置保证金金额范围
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"保证金金额必须大于等于0！\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//国家助学贷款
	if(sDisplayTemplet.equals("ContractInfo1370"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
	
	//个人自助质押贷款
	if(sDisplayTemplet.equals("ContractInfo1390"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置期限(月)范围
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"期限(月)必须大于等于0！\" ");
		//设置零(天)范围
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"零(天)必须大于等于0！\" ");
		//设置基准年利率(%)范围
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"基准年利率(%)必须大于等于0\" ");
    	//设置利率浮动值范围
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"利率浮动值必须大于等于0！\" ");
		//设置执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行月利率(‰)必须大于等于0！\" ");
		//设置检查频率(月)范围
		//doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"检查频率(月)必须大于等于0！\" ");
	}
}

if(sObjectType.equals("PutOutApply")) //出帐对象
{
	if(sDisplayTemplet.equals("PutOutInfo0"))
	{
		//设置展期金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"展期金额必须大于等于0！\" ");
		//设置展期年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"展期年利率(%)必须大于等于0！\" ");
	}
	
	if(sDisplayTemplet.equals("PutOutInfo1"))
	{
		//设置合同金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置合同金额范围
		doTemp.appendHTMLStyle("ContractSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置固定周期范围
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"固定周期必须大于等于0！\" ");
		//设置贷款风险系数范围
    	doTemp.appendHTMLStyle("RiskRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贷款风险系数必须大于等于0\" ");
	}	
	
	if(sDisplayTemplet.equals("PutOutInfo2"))
	{
		//设置发放金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"发放金额必须大于等于0！\" ");
		//设置手续费金额范围
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"手续费金额必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置违约年利率(%)范围
		doTemp.appendHTMLStyle("BackRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"违约年利率(%)必须大于等于0！\" ");
		//设置固定周期范围
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"固定周期必须大于等于0！\" ");
		//设置贷款风险系数范围
    	doTemp.appendHTMLStyle("RiskRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贷款风险系数必须大于等于0\" ");
	}	
	
	if(sDisplayTemplet.equals("PutOutInfo3"))
	{
		//设置发放金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"发放金额必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置固定周期范围
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"固定周期必须大于等于0！\" ");
	}	
	
	if(sDisplayTemplet.equals("PutOutInfo6"))
	{
		//设置票面金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"票面金额必须大于等于0！\" ");
		//设置买方付息比例(%)范围
		doTemp.appendHTMLStyle("BillRisk"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"买方付息比例(%)的范围为[0,100]\" ");
		//设置贴现执行月利率(‰)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贴现执行月利率(‰)必须大于等于0！\" ");
		//设置调整天数范围
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"调整天数必须大于等于0！\" ");
	}
	
	if(sDisplayTemplet.equals("PutOutInfo8"))
	{
		//设置交易金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"交易金额必须大于等于0！\" ");
	}
		
	if(sDisplayTemplet.equals("PutOutInfo9"))
	{
		//设置发放金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"发放金额必须大于等于0！\" ");
		//设置合同金额范围
		doTemp.appendHTMLStyle("ContractSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"合同金额必须大于等于0！\" ");
		//设置发展商保证金额范围
		doTemp.appendHTMLStyle("FZGuaBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"发展商保证金额必须大于等于0！\" ");
		//设置执行年利率(%)范围
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"执行年利率(%)必须大于等于0！\" ");
		//设置发展商入帐净额范围
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"发展商入帐净额必须大于等于0！\" ");
		//设置固定月数范围
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"固定月数必须大于等于0！\" ");
		//设置贷款风险系数范围
    	doTemp.appendHTMLStyle("RiskRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"贷款风险系数必须大于等于0\" ");
	}
		
	if(sDisplayTemplet.equals("PutOutInfo11"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置手续费率(‰)范围
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
	}
		
	if(sDisplayTemplet.equals("PutOutInfo12"))
	{
		//设置金额范围
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"金额必须大于等于0！\" ");
		//设置手续费率(‰)范围
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率(‰)的范围为[0,1000]\" ");
		//设置保证金比例(%)范围
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例(%)的范围为[0,100]\" ");
	}
}
%>