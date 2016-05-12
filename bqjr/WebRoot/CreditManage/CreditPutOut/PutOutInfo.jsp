<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 
<%@page import="com.amarsoft.app.bizmethod.*"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jytian 2004/12/7
		Tester:
		Content:  出帐详情
		Input Param:
		Output param:
		History Log:  fXie 2005-03-13   增加校验关系、账号查询
		              sjchuan 2009-10-21  票据业务一次出账申请可以出多笔票据，出账信息Tab页为上下分页显示
		              qfang 2011-6-8 调整上下页面宽度，以及页面传递的参数
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "出帐详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
 	
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	
	//获得组件参数：对象类型和对象编号
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	//定义变量：SQL语句、出帐业务品种、出帐显示模版、对象主表、暂存标志
	String sSql = "",sBusinessType = "",sDisplayTemplet = "",sMainTable = "",sTempSaveFlag="";
	//定义变量：发生类型、合同起始日、合同到期日、合同业务品种
	String sBCOccurType = "",sBCPutOutDate = "",sBCMaturity = "",sBCBusinessType = "",sBCPaymentMode = "",sProductVersion = "";
	String sContractSerialNo = "";
	//定义变量：合同金额
	double dBCBusinessSum = 0.0;	
	//定义变量：查询结果集
	ASResultSet rs = null;
	//根据对象类型从对象类型定义表中查询到相应对象的主表名
	sSql = 	" select ObjectTable from OBJECTTYPE_CATALOG "+
			" where ObjectType =:ObjectType ";
	sMainTable = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectType",sObjectType));	
	
	//获取出帐业务品种
	sSql = 	" select BusinessType,ContractSerialNo from "+sMainTable+" "+
			" where SerialNo =:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sBusinessType = rs.getString("BusinessType");
		sContractSerialNo = rs.getString("ContractSerialNo");
	}
	rs.getStatement().close();
	//获取该业务品种是否可分类
	/*
	BizSort bizSort = new BizSort(Sqlca,sObjectType,sObjectNo,sApproveNeed,sBusinessType);
	boolean isBizsort = bizSort.isBizSort();
	
	if(isBizsort){
		CurPage.setAttribute("ShowDetailArea","true");
		CurPage.setAttribute("DetailAreaHeight","400");
	}
	*/

	//如果业务品种为空,则显示短期流动资金贷款
	if (sBusinessType.equals("")) sBusinessType = "1010010";
	if(sContractSerialNo.equals("")) sContractSerialNo="";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%	
	//获取该出帐信息的发生类型
	sSql = 	" select BC.OccurType,BC.PutOutDate,BC.Maturity,BC.BusinessType,BC.BusinessSum,BC.PaymentMode,BC.ProductVersion "+
	" from BUSINESS_CONTRACT BC "+
	" where exists (select BP.ContractSerialNo from BUSINESS_PUTOUT BP "+
	" where BP.SerialNo =:SerialNo "+
	" and BP.ContractSerialNo = BC.SerialNo) ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sBCOccurType = rs.getString("OccurType");
		sBCPutOutDate = rs.getString("PutOutDate");
		sBCMaturity = rs.getString("Maturity");
		sBCBusinessType = rs.getString("BusinessType");
		sBCPaymentMode = rs.getString("PaymentMode");
		dBCBusinessSum = rs.getDouble("BusinessSum");
		sProductVersion = rs.getString("ProductVersion");
		//将空值转化为空字符串
		if(sBCOccurType == null) sBCOccurType = "";
		if(sBCPutOutDate == null) sBCPutOutDate = "";
		if(sBCMaturity == null) sBCMaturity = "";
		if(sBCBusinessType == null) sBCBusinessType = "";
		if(sProductVersion == null) sProductVersion = "";
	}
	rs.getStatement().close();
	
	if(sBCOccurType.equals("015")) //展期
		sDisplayTemplet = "PutOutInfo0";
	else{
		//根据产品类型从产品信息表BUSINESS_TYPE中获得显示模版名称
		sSql = " select DisplayTemplet from BUSINESS_TYPE where TypeNo =:TypeNo ";
		sDisplayTemplet = Sqlca.getString(new SqlObject(sSql).setParameter("TypeNo",sBusinessType));
		if(sDisplayTemplet==null)sDisplayTemplet="";
	}
	
	//从出账表获得暂存标志
	sSql = "select TempSaveFlag from " + sMainTable + " where SerialNo=:SerialNo";
	sTempSaveFlag = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(sTempSaveFlag == null) sTempSaveFlag = "";
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sDisplayTemplet,Sqlca);
	//设置更新表名和主键
	doTemp.UpdateTable = sMainTable;
	doTemp.setKey("SerialNo",true);
	
	//设置字段的可见属性
	//doTemp.setVisible("PaymentMode",isBizsort);

	
	//设置格式,后面小数点4位
	doTemp.setCheckFormat("RateFloat,BackRate,RiskRate","14");
	//设置利率格式,后面小数点6位
	doTemp.setCheckFormat("BaseRate,BusinessRate","16");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);

	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	/*--------------------------以下核算功能增加代码-----------------*/
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("ProductID", sBusinessType);
	valuePool.setAttribute("ProductVersion", sProductVersion);
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	/*--------------------------以上核算功能增加代码-----------------*/
	
	
	dwTemp.setHarborTemplate(DWExtendedFunctions.getDWDockHTMLTemplate(sDisplayTemplet,"",Sqlca));
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
			{"true","All","Button","保存","保存所有修改","saveRecord()",sResourcesPath},		
			{"true","All","Button","暂存","暂时保存所有修改内容","saveRecordTemp()",sResourcesPath},
			{"true","All","Button","还款计划咨询","还款计划咨询","Simulation('"+sObjectType+"','"+sObjectNo+"')",sResourcesPath}
		};
	//当暂存标志为否，即已保存，暂存按钮应隐藏
	if(sTempSaveFlag.equals("2"))
		sButtons[1][0] = "false";
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(!saveSubItem()) return;
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		setItemValue(0,getRow(),"TempSaveFlag","2"); //暂存标志（1：是；2：否）			
		as_save("myiframe0","afterLoad('<%=sObjectType%>','<%=sObjectNo%>')");
	}
	
	/*~[Describe=暂存;InputParam=无;OutPutParam=无;]~*/
	function saveRecordTemp(){
		//0：表示第一个dw
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		setItemValue(0,getRow(),'TempSaveFlag',"1");//暂存标志（1：是；2：否）
		if(!saveSubItem()) return;
		as_save("myiframe0","afterLoad('<%=sObjectType%>','<%=sObjectNo%>')");   //再暂存
		setNeedCheckRequired(0);//最后再将必输项设置回来	  	
	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck(){
		//发生类型
		sOccurType = "<%=sBCOccurType%>";
		//出帐起始日
		sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
		//出帐到期日
		sMaturity = getItemValue(0,getRow(),"Maturity");	
		//业务品种
		sBusinessType = getItemValue(0,getRow(),"BusinessType");		
		if(typeof(sPutOutDate) != "undefined" && sPutOutDate != "" && typeof(sMaturity) != "undefined" && sMaturity != ""){			
			//合同业务品种
			sBCBusinessType = "<%=sBCBusinessType%>";
			//合同起始日
			sBCPutOutDate = "<%=sBCPutOutDate%>";
			//合同到期日
			sBCMaturity = "<%=sBCMaturity%>";	
			//校验出帐起始日是否早于合同起始日			
			if(typeof(sPutOutDate) != "undefined" && sPutOutDate != ""
			&& typeof(sBCPutOutDate) != "undefined" && sBCPutOutDate != "")
			{
				if(sPutOutDate < sBCPutOutDate)
				{
					if(sOccurType == "015") //展期业务
					{
						alert(getBusinessMessage('592'));//出帐的展期起始日必须晚于或等于合同的展期起始日！
						return false;
					}else
					{
						if(sBusinessType == '1010010'
						|| sBusinessType == '1030020' || sBusinessType == '1030030'
						|| sBusinessType == '1010020'
						|| sBusinessType == '1030010' || sBusinessType == '1080010'
						|| sBusinessType == '1080060'
						|| sBusinessType == '1080040' || sBusinessType == '1010030'
						|| sBusinessType == '1050' || sBusinessType == '1080020'
						|| sBusinessType == '1080030' || sBusinessType == '1010040'
						|| sBusinessType == '2070' || sBusinessType == '1060'
						|| sBusinessType == '1040010' || sBusinessType == '1040020'
						|| sBusinessType == '1040030' || sBusinessType == '1040040') 
						//短期流动资金贷款、技术改造项目贷款、其他类项目贷款、中期流动资金贷款、
						//基本建设项目贷款、信用证项下进口押汇、福费庭、托收项下出口押汇
						//法人帐户透支、房地产开发贷款、信用证项下出口打包贷款、信用证项下出口押汇、出口退税帐户托管贷款、
						//委托贷款、银团贷款、法人购房贷款、汽车法人按揭、设备法人按揭、其他法人按揭
						{	
							alert(getBusinessMessage('593'));//出帐的起贷日必须晚于或等于合同的起始日！
							return false;								
						}else if(sBusinessType == '2030010' || sBusinessType == '2030020'
						|| sBusinessType == '2030030' || sBusinessType == '2030040'
						|| sBusinessType == '2030050' || sBusinessType == '2030060'
						|| sBusinessType == '2030070' || sBusinessType == '2040010'
						|| sBusinessType == '2040020' || sBusinessType == '2040030'
						|| sBusinessType == '2040040' || sBusinessType == '2040050'
						|| sBusinessType == '2040060' || sBusinessType == '2040070'
						|| sBusinessType == '2040080' || sBusinessType == '2040090'
						|| sBusinessType == '2040100' || sBusinessType == '2040110'				
						|| sBusinessType == '1110140' || sBusinessType == '1110170'
						|| sBusinessType == '3030020' || sBusinessType == '1110160'
						|| sBusinessType == '1110150' || sBusinessType == '1110130'
						|| sBusinessType == '1110180' || sBusinessType == '1110120'
						|| sBusinessType == '2100' || sBusinessType == '2090020'
						|| sBusinessType == '1110110' || sBusinessType == '2090010'
						|| sBusinessType == '1110100' || sBusinessType == '1110090'
						|| sBusinessType == '2080010' || sBusinessType == '1110080'
						|| sBusinessType == '1110200' || sBusinessType == '2060040'				
						|| sBusinessType == '1110190' || sBusinessType == '1110050'
						|| sBusinessType == '2060010' || sBusinessType == '1110040'
						|| sBusinessType == '1080005'
						|| sBusinessType == '1110030' || sBusinessType == '1080007'
						|| sBusinessType == '1080410' || sBusinessType == '1110020'
						|| sBusinessType == '1110010' || sBusinessType == '2060020'
						|| sBusinessType == '2060030'
						|| sBusinessType == '2060050' || sBusinessType == '2060060'
						|| sBusinessType == '1110070' || sBusinessType == '1080320'				
						|| sBusinessType == '2080020' || sBusinessType == '2080030'
						|| sBusinessType == '1080310') 
						//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、
						//付款保函、其他融资性保函、投标保函、履约保函、预付款保函、承包工程保函
						//质量维修保函、海事保函、补偿贸易保函、诉讼保函、留置金保函、
						//加工装配业务进口保函、其他非融资性保函、商业助学贷款、个人经营贷款、
						//个人住房装修贷款、国家助学贷款、个人消费汽车贷款、个人住房公积金贷款、
						//个人营运汽车贷款、买入返售业务、有价证券发行担保、个人抵押贷款、贷款担保、
						//个人保证贷款、个人质押贷款、贷款承诺函、个人经营循环贷款、 个人付款保函、
						//转贷买方信贷、个人小额信用贷款、个人委托贷款、个人自助质押贷款、
						//转贷外国政府贷款、个人再交易商业用房贷款、进口信用证、
						//个人商业用房按贷款、备用信用证、提货担保、转贷国际金融组织贷款、
						//国家外汇储备转贷款、个人再交易住房贷款、发行债券转贷款、其他转贷款、
						//个人抵押循环贷款、个人住房贷款、贷款意向书、银行信贷证明、
						//出口保理、进口保理
						{
							if(sBCBusinessType == '1080005') //进口信用证
							{
								alert(getBusinessMessage('594'));//出帐的生效日期必须晚于或等于合同的开证日！
								return false;
							}else if(sBCBusinessType == '1080410' || sBCBusinessType == '1080007' 
							|| sBCBusinessType == '2090010' || sBCBusinessType == '2080030'
							|| sBCBusinessType == '2080020') 
							//提货担保、备用信用证、贷款担保、银行信贷证明、贷款意向书
							{
								alert(getBusinessMessage('595'));//出帐的生效日期必须晚于或等于合同的发放日！
								return false;
							}else if(sBCBusinessType == '2030010' || sBCBusinessType == '2030020'
							|| sBCBusinessType == '2030030' || sBCBusinessType == '2030040'
							|| sBCBusinessType == '2030050' || sBCBusinessType == '2030060'
							|| sBCBusinessType == '2030070' || sBCBusinessType == '2040010'
							|| sBCBusinessType == '2040020' || sBCBusinessType == '2040030'
							|| sBCBusinessType == '2040040' || sBCBusinessType == '2040050'
							|| sBCBusinessType == '2040060' || sBCBusinessType == '2040070'
							|| sBCBusinessType == '2040080' || sBCBusinessType == '2040090'
							|| sBCBusinessType == '2040100' || sBCBusinessType == '2040110') 
							//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、
							//付款保函、其他融资性保函、投标保函、履约保函、预付款保函、承包工程保函
							//质量维修保函、海事保函、补偿贸易保函、诉讼保函、留置金保函、
							//加工装配业务进口保函、其他非融资性保函
							{
								alert(getBusinessMessage('597'));//出帐的生效日期必须晚于或等于合同的生效日期！
								return false;
							}else
							{
								alert(getBusinessMessage('598'));//出帐的生效日期必须晚于或等于合同的起始日！
								return false;
							}
						}else if(sBusinessType == '1090010')//国内信用证
						{
							alert(getBusinessMessage('600'));//出帐的业务日期必须晚于或等于合同的开证日！
							return false;
						}else if(sBusinessType == '2010')//银行承兑汇票
						{
							alert(getBusinessMessage('601'));//出帐的签发日必须晚于或等于合同的出票日！
							return false;
						}
					}
				}
			}
			
			//校验出帐到期日是否晚于合同到期日
			if(typeof(sMaturity) != "undefined" && sMaturity != ""
			&& typeof(sBCMaturity) != "undefined" && sBCMaturity != "")
			{
				if(sMaturity > sBCMaturity)
				{
					if(sOccurType == "015") //展期业务
					{
						alert(getBusinessMessage('602'));//出帐的展期到期日必须早于或等于合同的展期到期日！
						return false;
					}else
					{
						if(sBusinessType == '1010010'
						|| sBusinessType == '1030020' || sBusinessType == '1030030'
						|| sBusinessType == '1010020'
						|| sBusinessType == '1030010' || sBusinessType == '1080010'
						|| sBusinessType == '1080060'
						|| sBusinessType == '1080040' || sBusinessType == '1010030'
						|| sBusinessType == '1050' || sBusinessType == '1080020'
						|| sBusinessType == '1080030' || sBusinessType == '1010040'
						|| sBusinessType == '2070' || sBusinessType == '1060'
						|| sBusinessType == '1040010' || sBusinessType == '1040020'
						|| sBusinessType == '1040030' || sBusinessType == '1040040') 
						//短期流动资金贷款、技术改造项目贷款、其他类项目贷款、中期流动资金贷款、
						//基本建设项目贷款、信用证项下进口押汇、福费庭、托收项下出口押汇
						//法人帐户透支、房地产开发贷款、信用证项下出口打包贷款、信用证项下出口押汇、出口退税帐户托管贷款、
						//委托贷款、银团贷款、法人购房贷款、汽车法人按揭、设备法人按揭、其他法人按揭
						{	
							alert(getBusinessMessage('603'));//出帐的到期日必须早于或等于合同的到期日！
							return false;								
						}else if(sBusinessType == '2030010' || sBusinessType == '2030020'
						|| sBusinessType == '2030030' || sBusinessType == '2030040'
						|| sBusinessType == '2030050' || sBusinessType == '2030060'
						|| sBusinessType == '2030070' || sBusinessType == '2040010'
						|| sBusinessType == '2040020' || sBusinessType == '2040030'
						|| sBusinessType == '2040040' || sBusinessType == '2040050'
						|| sBusinessType == '2040060' || sBusinessType == '2040070'
						|| sBusinessType == '2040080' || sBusinessType == '2040090'
						|| sBusinessType == '2040100' || sBusinessType == '2040110'				
						|| sBusinessType == '1110140' || sBusinessType == '1110170'
						|| sBusinessType == '3030020' || sBusinessType == '1110160'
						|| sBusinessType == '1110150' || sBusinessType == '1110130'
						|| sBusinessType == '1110180' || sBusinessType == '1110120'
						|| sBusinessType == '2100' || sBusinessType == '2090020'
						|| sBusinessType == '1110110' || sBusinessType == '2090010'
						|| sBusinessType == '1110100' || sBusinessType == '1110090'
						|| sBusinessType == '2080010' || sBusinessType == '1110080'
						|| sBusinessType == '1110200' || sBusinessType == '2060040'				
						|| sBusinessType == '1110190' || sBusinessType == '1110050'
						|| sBusinessType == '2060010' || sBusinessType == '1110040'
						|| sBusinessType == '1080005'
						|| sBusinessType == '1110030' || sBusinessType == '1080007'
						|| sBusinessType == '1080410' || sBusinessType == '1110020'
						|| sBusinessType == '1110010' || sBusinessType == '2060020'
						|| sBusinessType == '2060030'
						|| sBusinessType == '2060050' || sBusinessType == '2060060'
						|| sBusinessType == '1110070' || sBusinessType == '1080320'				
						|| sBusinessType == '2080020' || sBusinessType == '2080030'
						|| sBusinessType == '1080310') 
						//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、
						//付款保函、其他融资性保函、投标保函、履约保函、预付款保函、承包工程保函
						//质量维修保函、海事保函、补偿贸易保函、诉讼保函、留置金保函、
						//加工装配业务进口保函、其他非融资性保函、商业助学贷款、个人经营贷款、
						//个人住房装修贷款、国家助学贷款、个人消费汽车贷款、个人住房公积金贷款、
						//个人营运汽车贷款、买入返售业务、有价证券发行担保、个人抵押贷款、贷款担保、
						//个人保证贷款、个人质押贷款、贷款承诺函、个人经营循环贷款、 个人付款保函、
						//转贷买方信贷、个人小额信用贷款、个人委托贷款、个人自助质押贷款、
						//转贷外国政府贷款、个人再交易商业用房贷款、进口信用证、
						//个人商业用房按贷款、备用信用证、提货担保、转贷国际金融组织贷款、
						//国家外汇储备转贷款、个人再交易住房贷款、发行债券转贷款、其他转贷款、
						//个人抵押循环贷款、个人住房贷款、贷款意向书、银行信贷证明、
						//出口保理、进口保理
						{
							if(sBCBusinessType == '1080410' || sBCBusinessType == '1080007' 
							|| sBCBusinessType == '2090010' || sBCBusinessType == '2080030'
							|| sBCBusinessType == '2080020' || sBCBusinessType == '1080005') 
							//提货担保、备用信用证、贷款担保、银行信贷证明、贷款意向书、进口信用证
							{
								alert(getBusinessMessage('604'));//出帐的失效日期必须早于或等于合同的到期日！
								return false;
							}else if(sBCBusinessType == '2030010' || sBCBusinessType == '2030020'
							|| sBCBusinessType == '2030030' || sBCBusinessType == '2030040'
							|| sBCBusinessType == '2030050' || sBCBusinessType == '2030060'
							|| sBCBusinessType == '2030070' || sBCBusinessType == '2040010'
							|| sBCBusinessType == '2040020' || sBCBusinessType == '2040030'
							|| sBCBusinessType == '2040040' || sBCBusinessType == '2040050'
							|| sBCBusinessType == '2040060' || sBCBusinessType == '2040070'
							|| sBCBusinessType == '2040080' || sBCBusinessType == '2040090'
							|| sBCBusinessType == '2040100' || sBCBusinessType == '2040110') 
							//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、
							//付款保函、其他融资性保函、投标保函、履约保函、预付款保函、承包工程保函
							//质量维修保函、海事保函、补偿贸易保函、诉讼保函、留置金保函、
							//加工装配业务进口保函、其他非融资性保函
							{
								alert(getBusinessMessage('606'));//出帐的失效日期必须早于或等于合同的失效日期！
								return false;
							}else
							{
								alert(getBusinessMessage('604'));//出帐的失效日期必须早于或等于合同的到期日！
								return false;
							}
						}else if(sBusinessType == '1020010' || sBusinessType == '1020020'
						|| sBusinessType == '1020030' || sBusinessType == '1020040')
						//银行承兑汇票贴现、商业承兑汇票贴现、协议付息票据贴现、商业承兑汇票保贴
						{
							alert(getBusinessMessage('603'));//出帐的到期日必须早于或等于合同的到期日！
							return false;
						}else if(sBusinessType == '1090010')//国内信用证
						{
							alert(getBusinessMessage('607'));//出帐的信用证有效期必须早于或等于合同的信用证有效期！
							return false;
						}else if(sBusinessType == '2010')//银行承兑汇票
						{
							alert(getBusinessMessage('608'));//出帐的到期付款日必须早于或等于合同的到期日！
							return false;
						}
					}
				}
			}							
		}
		
		//出帐金额
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");	
		//合同金额
		dBCBusinessSum = "<%=dBCBusinessSum%>";
		//汇率（默认为人民币）
		var curErate = 1;
		//判断累计出帐金额是否已超过了合同金额
		if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBCBusinessSum) >= 0)
		{
			//查询当前币种兑换人民币汇率
			var curCurrencyType = getItemValue(0,0,"BusinessCurrency");
			if(curCurrencyType != "undefined" && curCurrencyType != "" && curCurrencyType != "01"){
				var sCurrencyReturn = RunMethod("PublicMethod","GetERateToRMB",curCurrencyType+","); //查询最新汇率
				if(sCurrencyReturn > 0){
					curErate = sCurrencyReturn;
				}
			}
			///获取合同项下可出帐的金额
			//出帐流水号
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
			//合同流水号
			var sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");	
			sSurplusPutOutSum = RunMethod("BusinessManage","GetPutOutSum",sContractSerialNo+","+sSerialNo);
			if(parseFloat(sSurplusPutOutSum) > 0)
			{
				if(curErate*parseFloat(dBusinessSum) > parseFloat(sSurplusPutOutSum))
				{
					alert(getBusinessMessage('572'));//出帐中录入的金额必须小于或等于合同的可用金额！
					return false;
				}
			}else
			{
				alert(getBusinessMessage('573'));//此业务合同已没有可用金额，不能进行放贷申请！
				return false;
			}			 
		}
		
		
		return true;
	}
	
	/*~[Describe=弹出损益入帐机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getPutOutOrg()
	{		
		sParaString = "OrgID"+","+"<%=CurOrg.getOrgID()%>";
		setObjectValue("SelectBelongOrg",sParaString,"@AboutBankID3@0@AboutBankID3Name@1",0,0,"");		
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{							
		setItemValue(0,0,"PaymentMode","<%=sBCPaymentMode%>");//初始化支付方式
	}
	
	/*~[Describe=根据手续费率计算手续费;InputParam=无;OutPutParam=无;]~*/
	function getpdgsum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgRatio = getItemValue(0,getRow(),"PdgRatio");
	        dPdgRatio = roundOff(dPdgRatio,2);
	        if(parseFloat(dPdgRatio) >= 0)
	        {
	            dPdgSum = parseFloat(dBusinessSum)*parseFloat(dPdgRatio)/1000;
	            dPdgSum = roundOff(dPdgSum,2);
	            setItemValue(0,getRow(),"PdgSum",dPdgSum);
	        }
	    }
	}
	
	/*~[Describe=根据保证金比例计算保证金金额;InputParam=无;OutPutParam=无;]~*/
	function getBailSum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailRatio = getItemValue(0,getRow(),"BailRatio");
	        dBailRatio = roundOff(dBailRatio,2);
	        if(parseFloat(dBailRatio) >= 0)
	        {	        
	            dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
	            dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	        }
	    }
	}
	
	</SCRIPT>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	/*------------------核算加入JS代码---------------*/
	afterLoad("<%=sObjectType%>","<%=sObjectNo%>"); 
	/*------------------核算加入JS代码---------------*/
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>