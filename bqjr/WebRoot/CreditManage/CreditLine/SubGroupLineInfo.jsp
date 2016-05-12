<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:jgao1 2009-10-26
		Tester:
		Content: 集团额度分配基本信息页面
		Input Param:
			ParentLineID：额度编号
			LineID：额度分配编号
		Output param:
		History Log: gftang 2013-05-09 改成模板生成

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "集团额度分配基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="";
	ASResultSet rs = null;
	String sCustomerID = "";//客户ID
	double dLineSum = 0;//额度协议金额
	String sCustomerName = "";//客户名称
	String sTable = "";//相关表

	//获得页面参数	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sParentLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentLineID"));
	String sSubLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubLineID"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sParentLineID == null) sParentLineID = "";
	if(sSubLineID == null) sSubLineID = "";	
	
	//根据对象类型与对象编号获取公司客户状态,用于区分中小企业客户与公司客户
	if("CreditApply".equals(sObjectType)){
		sTable="BUSINESS_APPLY";
	}else if("ApproveApply".equals(sObjectType)){
		sTable="BUSINESS_APPROVE";
	}else{
		sTable="BUSINESS_CONTRACT";
	}
	
	//根据额度编号获取额度协议金额、申请流水号、最终审批意见流水号、合同流水号、额度类型、额度名称、客户编号、客户名称、人民币币种
	String sApplySerialNo = "",sApproveSerialNo = "",sContractSerialNo = "",sCLTypeID = "",sCLTypeName = "",sCurrencyName="";
	sSql = 	" select LineSum1,getItemName('Currency',Currency) as CurrencyName,ApplySerialNo,ApproveSerialNo,BCSerialNo,CLTypeID,CLTypeName,CustomerID,CustomerName "+
			" from CL_INFO where "+
			" LineID = :LineID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("LineID",sParentLineID));
	if(rs.next()){
		dLineSum = rs.getDouble("LineSum1");
		sCurrencyName = rs.getString("CurrencyName");
		sApplySerialNo = rs.getString("ApplySerialNo");
		sApproveSerialNo = rs.getString("ApproveSerialNo");
		sContractSerialNo = rs.getString("BCSerialNo");
		sCLTypeID = rs.getString("CLTypeID");
		sCLTypeName = rs.getString("CLTypeName");
		sCustomerID = rs.getString("CustomerID");
		sCustomerName = rs.getString("CustomerName");
	}
	rs.getStatement().close();
	//将空值转化为空字符串
	if(sApplySerialNo == null) sApplySerialNo = "";
	if(sApproveSerialNo == null) sApproveSerialNo = "";
	if(sContractSerialNo == null) sContractSerialNo = "";
	if(sCLTypeID == null) sCLTypeID = "";
	if(sCLTypeName == null) sCLTypeName = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerName == null) sCustomerName = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//设置显示标题				
    String sTempletNo = "SubGroupLineInfo";
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
  	
  	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置setEvent
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSubLineID+","+sParentLineID);
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回到额度分配列表","goBack()",sResourcesPath}
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
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}
	
	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditLine/SubGroupLineList.jsp?ParentLineID=<%=sParentLineID%>","_self","");
	}	
		
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{	
		if(CheckSubCreditLine()) return true;
		else return false;
	}
	
	/*~[Describe=授信限额和敞口限额检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function CheckSubCreditLine()
	{
		sParentLineID = "<%=sParentLineID%>";
		sSubLineCurrency=getItemValue(0,getRow(),"Currency");//当前子额度币种
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//取当前集团成员客户号
		sLineID = getItemValue(0,getRow(),"LineID");//取当前子额度额度编号
		sLineSum1 = getItemValue(0,0,"LineSum1");//取当前值
		sBailRatio = getItemValue(0,0,"BailRatio");//取当前值
		//如果取到比率值为空时，则自动置位成0.00
		if (typeof(sBailRatio)=="undefined" || sBailRatio.length==0)
		{
			sBailRatio = 0.00;
			setItemValue(0,0,"BailRatio","0.00");
		}
		//如果取到授信限额为空时，则自动置位成0.00
		if (typeof(sLineSum1)=="undefined" || sLineSum1.length==0)
		{
			sLineSum1 = 0.00;
			setItemValue(0,0,"LineSum1","0.00");
		}
	
		sReturn = RunMethod("CreditLine","CheckGroupLine",sParentLineID+","+sLineID+","+sCustomerID+","+sLineSum1+","+sSubLineCurrency);
		if(sReturn == "10")	
		{
			alert("当前集团成员授信限额超过集团授信额度总额，请更正！");
			return false;					
		}
		if(sReturn == "99")	
		{
			alert("已分配该集团成员的授信配额，请更正!");
			return false;					
		}
		if(sReturn == "00")	
		{
			return true;					
		}
		return false;
	}

	/*~[Describe=弹出集团成员选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getGroupCustomer()
	{
		sCustomerID = "<%=sCustomerID%>";
		setObjectValue("SelectGroupCustomer","CustomerID,"+sCustomerID,"@CustomerID@0@CustomerName@1",0,0,"");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ParentLineID","<%=sParentLineID%>");	
			setItemValue(0,0,"ApplySerialNo","<%=sApplySerialNo%>");
			setItemValue(0,0,"ApproveSerialNo","<%=sApproveSerialNo%>");
			setItemValue(0,0,"BCSerialNo","<%=sContractSerialNo%>");			
			setItemValue(0,0,"CLTypeID","<%=sCLTypeID%>");	
			setItemValue(0,0,"CLTypeName","<%=sCLTypeName%>");									
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Rotative","2");
			bIsInsert = true;			
		}		
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "GLINE_INFO";//表名
		var sColumnName = "LineID";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
