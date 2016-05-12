<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:FSGong  2004.12.09
		Tester:
		Content:抵债资产处置总结汇总
		Input Param:
			SerialNo：抵债资产流水号
			Type：类型
		Output param:	
			
		History Log: zywei 2005/09/07 重检代码
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产价值处置总结汇总"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数
	String  sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));	
	//type=1 意味着从AppDisposingList中执行处置终结并且汇总。
	//type=2 意味着从PDADisposalEndList中察看汇总:屏蔽所有button,并且只读
	//type=3 意味着从PDADisposalBookList中察看汇总:屏蔽所有button,并且只读  2/3的处理是一样的,但是为了日后的扩展,还是分开考虑.
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));	
	//将空值转化为空字符串
	if (sType == null) sType = "";	
	if(sSerialNo == null ) sSerialNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo ="PDADisposalEndInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//得到该资产的表外/内/未抵入标志,已决定显示风格
	String mySql = " select flag from ASSET_INFO where SerialNo = :SerialNo ";
	String myFlag = Sqlca.getString(new SqlObject(mySql).setParameter("SerialNo",sSerialNo));
	if(myFlag == null) myFlag = ""; 
	if(myFlag.equals("")) myFlag = "010";  //缺省表内		
	
	if (myFlag.equals("010")) //表内
		doTemp.setVisible("EnterValue",true);		
	if (myFlag.equals("020"))  //表外
		doTemp.setVisible("OutInitBalance",true);		

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform

	if (sType.equals("1"))  //执行处置终结,可写
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	else					//查看汇总信息只读
		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);	
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
				{"false","","Button","处置完成","保存所有修改","saveRecord()",sResourcesPath},
				{"true","","Button","关闭","关闭本页面","goBack()",sResourcesPath}
			};
		//根据sType的不同,决定是否显示button
		if (sType.equals("1"))  sButtons[0][0]="true";
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		var sType = "<%=sType%>";
		//如果是从AppDisposingList中调用，则是执行处置总结，并且汇总。其他地方调用都是察看汇总，也可以修改帐务处理描述。
		if (sType == "1")  
		{
			if (confirm("你确认执行处置终结吗？"))
			{
				beforeUpdate();
				as_save("myiframe0");		
			}
		}else   //对已经终结的资产作汇总，可能会修改帐务处理描述。
		{
			beforeUpdate();
			as_save("myiframe0");		
		}
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{				
		var sType = "<%=sType%>";
		if (sType == "1")  		
			setItemValue(0,0,"AssetStatus","04");//处置终结
	}	

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		var sType = "<%=sType%>";
		if (sType == "1")  //处置终结
			setItemValue(0,0,"PigeonholeDate","<%=StringFunction.getToday()%>");
		//统计相关信息
		var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndStatisticsAjax.jsp?ObjectNo=<%=sSerialNo%>&ObjectType=ASSET_INFO","","");
		sReturn = sReturn.split("@");
		//统计累计出租回收金额
		setItemValue(0,0,"TotalRentValue",amarMoney(sReturn[0],2));
		//统计累计出售回收金额
		setItemValue(0,0,"TotalSaleValue",amarMoney(sReturn[1],2));
		//统计累计费用支付总额
		setItemValue(0,0,"TotalFeeValue",amarMoney(sReturn[2],2));
		//统计处理净收入
		setItemValue(0,0,"TotalNetValue",amarMoney(sReturn[3],2));
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>

