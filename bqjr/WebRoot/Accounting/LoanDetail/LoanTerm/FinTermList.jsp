<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "罚息组件"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//定义变量
	String businessType = "";
	String projectVersion = "";
	
	//获得组件参数	
	
	//获得页面参数
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String status = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("Status")));//状态
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	
	BusinessObject businessObject = AbstractBusinessObjectManager.getBusinessObject(sObjectType, sObjectNo,Sqlca);
	if(businessObject != null)
	{
		businessType = businessObject.getString("BusinessType");
		projectVersion = businessObject.getString("ProductVersion");
	}else
	{
		throw new Exception("对象【"+sObjectType+".+"+sObjectNo+"】不存在！");
	}
	

	//显示模版编号
	String sTempletNo = "FinRateSegmentList";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+businessObject.getObjectType());
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));

	//依次为：
	//0.是否显示
	//1.注册目标组件号(为空则自动取当前组件)
	//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.按钮文字
	//4.说明文字
	//5.事件
	//6.资源图片路径
	String sButtons[][] = {
			{"true", "All", "Button", "新增", "新增","newRecord()",sResourcesPath},
			{"true", "", "Button", "详情", "详情","viewAndEdit()",sResourcesPath},
			{"true", "All", "Button", "删除", "删除","deleteRecord()",sResourcesPath},
	};
	if(sObjectType.equals("PutOutApply")){ 
		CurComp.setAttribute("RightType", "ReadOnly");
	}
	
%>
<%@ include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>	
	function newRecord()
	{
		var returnValue = setObjectValue("SelectTermLibrary","TermType,FIN,ObjectType,Product,ObjectNo,<%=businessType+"-"+projectVersion%>","",0,0,"");
		if(typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_") 
		{
			return;
		}
		var sTermID = returnValue.split("@")[0];
		for(var i=0;i<getRowCount(0);i++)
		{
			var termID = getItemValue(0,i,"RateTermID");
			if(sTermID == termID)
			{
				alert("已经存在【"+getItemValue(0,i,"RateTermName")+"】！");
				return;
			}
		}
		//新增罚息
		RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+sTermID+",<%=businessObject.getObjectType()%>,<%=sObjectNo%>");
		//更新基准年利率
		RunMethod("BusinessManage","UpdateFineBusinessRate","<%=businessObject.getObjectType()%>,<%=sObjectNo%>");
		reloadSelf();
	}
	
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	    popComp("FinTermInfo","/Accounting/LoanDetail/LoanTerm/FinTermInfo.jsp","ToInheritObj=y&SerialNo="+sSerialNo+"&ObjectType=<%=businessObject.getObjectType()%>&ObjectNo=<%=sObjectNo%>&ToInheritObj=y","dialogWidth=50;dialogHeight=50;");
	    reloadSelf();
	}
	
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@include file="/IncludeEnd.jsp"%>