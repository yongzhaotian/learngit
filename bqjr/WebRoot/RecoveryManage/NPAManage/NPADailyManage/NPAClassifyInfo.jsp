<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 资产风险分类信息
		Input Param:
			SerialNo：分类流水号
			ObjectNo：对象编号（合同流水号/借据流水号）
			ObjectType：对象类型（BusinessContract：按合同分类；BusinessDueBill：按借据分类）
			ClassifyType：分类类型（010：待完成分类；020：已完成分类）			
		Output Param:			

		HistoryLog: zywei 2005/09/09 重检代码
				
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "资产风险分类信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义参数:显示模板编号、首次发放日、Sql语句、查询结果集
	String sTempletNo = "";
	String sOriginalPutOutDate = "";
	String sSql = "";
		
	//获得页面参数
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sClassifyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassifyType"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sClassifyType == null) sClassifyType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//待完成分类的显示模板编号
	if(sClassifyType.equals("010")){
		if(sObjectType.equals("BusinessDueBill"))
			sTempletNo = "ManagerClassifyInfo2";
	}
	
	//已完成分类的显示模板编号
	if(sClassifyType.equals("020")){
		if(sObjectType.equals("BusinessContract"))
			sTempletNo = "ViewClassifyInfo1";
		if(sObjectType.equals("BusinessDueBill"))
			sTempletNo = "ViewClassifyInfo2";
	}
	//如果是按合同进行风险分类，那么获得首次发放日
	if(sObjectType.equals("BusinessContract")){
		sSql = " select min(PUTOUTDATE) from BUSINESS_DUEBILL where RelativeSerialNo2 =:RelativeSerialNo2 ";
		sOriginalPutOutDate = Sqlca.getString(new SqlObject(sSql).setParameter("RelativeSerialNo2",sObjectNo));
		if(sOriginalPutOutDate == null) sOriginalPutOutDate = "";
	}
	
	//通过显示模板产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
				
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sObjectNo+","+sObjectType);
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
			{(sFinishType.equals("")?"true":"false"),"","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
			
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		var sObjectType = "<%=sObjectType%>";
		if(sObjectType == "BusinessContract")
		{
			sSum1 = getItemValue(0,getRow(),"SUM1");			
			sSum2 = getItemValue(0,getRow(),"SUM2");			
			sSum3 = getItemValue(0,getRow(),"SUM3");			
			sSum4 = getItemValue(0,getRow(),"SUM4");			
			sSum5 = getItemValue(0,getRow(),"SUM5");
			
			sBusinessBalance = getItemValue(0,getRow(),"Balance");			
			sSum1 = sSum1 + sSum2 + sSum3 + sSum4 + sSum5;
			
			if(sSum1 != sBusinessBalance)
			{
				alert("当前认定金额之和与合同当前余额不相等，请调整认定金额！");
				return;
			}			
		}else
		{			
			setSum();
		}   
    
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~根据不同的五级分类结果置入不同的值~*/
	function setSum()
	{
		
		var sBusinessSum = getItemValue(0,getRow(),"Balance");
		var sClassifyResult = getItemValue(0,getRow(),"RESULT1");
    
        setItemValue(0,getRow(),"SUM1",0);
        setItemValue(0,getRow(),"SUM2",0);
        setItemValue(0,getRow(),"SUM3",0);
        setItemValue(0,getRow(),"SUM4",0);
        setItemValue(0,getRow(),"SUM5",0);
    
		if(sClassifyResult == "01")
		    setItemValue(0,getRow(),"SUM1",sBusinessSum);

		if(sClassifyResult == "02")
		    setItemValue(0,getRow(),"SUM2",sBusinessSum);

		if(sClassifyResult == "03")
		    setItemValue(0,getRow(),"SUM3",sBusinessSum);

		if(sClassifyResult == "04")
		    setItemValue(0,getRow(),"SUM4",sBusinessSum);

		if(sClassifyResult == "05")
		    setItemValue(0,getRow(),"SUM5",sBusinessSum);
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{		
		OpenPage("/RecoveryManage/NPAManage/NPADailyManage/NPAClassifyList.jsp","_self","");		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UPDATEDATE","<%=StringFunction.getToday()%>");	
		//将客户经理认定的分类结果存放在最终分类结果中	
		sResult1 = getItemValue(0,getRow(),"Result1");		
		setItemValue(0,0,"FinallyResult",sResult1);		
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
  		var sClassifyType = "<%=sClassifyType%>";
  		var sObjectType = "<%=sObjectType%>";
  		
  		if(sClassifyType == "010")
  		{
  			if(sObjectType == "BusinessContract")
  				setItemValue(0,0,"OriginalPutOutDate","<%=sOriginalPutOutDate%>");
  			setItemValue(0,0,"ClassifyUserID","<%=CurUser.getUserID()%>");
  			setItemValue(0,0,"ClassifyUserName","<%=CurUser.getUserName()%>");
  			setItemValue(0,0,"ClassifyOrgID","<%=CurOrg.getOrgID()%>");
  			setItemValue(0,0,"ClassifyOrgName","<%=CurOrg.getOrgName()%>");  			
  		}  		
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

