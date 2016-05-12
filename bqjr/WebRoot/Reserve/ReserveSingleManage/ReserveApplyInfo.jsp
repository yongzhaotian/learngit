<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-9
		Tester:
		Content: 单项计提减值准备申请详情页面
		Input Param:
				 ObjectType：对象类型
				 ObjectNo：对象编号
		History:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "单项计提减值准备信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量：SQL语句
	String sSql = "";
	//定义变量：显示模版名称、暂存标志
	String sDisplayTemplet = "",sTempSaveFlag = "";
	//定义变量：查询结果集
	ASResultSet rs = null;
	//会计月份，借据号
	String sAccountMonth = "";
	String sDuebillNo = "";
	String sCustomerType = "";
	//过滤器
	String sTempletFilter = "1=1";
	
	//获得页面参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sPhaseType == null) sPhaseType = ""; 	
	
	sSql = " select AccountMonth,DuebillNo,CustomerType from Reserve_Apply "+
    	   " where SerialNo = :SerialNo";
	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if (rs.next()) 
	{  	 
		sAccountMonth = rs.getString("AccountMonth");  
		sDuebillNo = rs.getString("DuebillNo");
		sCustomerType = rs.getString("CustomerType");
	}  
	rs.getStatement().close();
	if(sAccountMonth == null) sAccountMonth = "";
	if(sDuebillNo == null) sDuebillNo = "";
	if(sCustomerType == null) sCustomerType = "";
	
%>
<%/*~END~*/%>

	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%	
	//显示模板
	sDisplayTemplet = "ReserveApplyInfo";//归档时显示模板	
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sDisplayTemplet,sTempletFilter,Sqlca);		
	if(sCustomerType.equals("03"))
		doTemp.setVisible("IsMsIndustry,IndustryGrade,IsMarket,IndustryType,BelongArea",false);	
	
	//生成DataWindow对象	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//设置是否只读 1:只读 0:可写
	//如果为已登记台帐状态的逐笔减值准备则处置详情只读
	dwTemp.ReadOnly = "0"; 	
				
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
				//{(sPhaseType.equals("1040"))?"false":"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		//录入数据有效性检查					
		if(vI_all("myiframe0"))
		{    
			beforeUpdate();
			setItemValue(0,getRow(),"TempSaveFlag","2"); //暂存标志（1：是；2：否）			
			as_save("myiframe0");
		}
	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{	
		
	}

	/*~[Describe=初始化数据;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		
	}

	
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();	
	var bCheckBeforeUnload=false;
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>