<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ccxie 2010/03/22
		Tester:
		Describe: 业务合同新增的担保合同所对应的质物信息列表;
		Input Param:
			ObjectType：对象类型
			ObjectNo: 对象编号
			ContractNo：担保信息编号
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "质物信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletNo = "";

	//获得页面参数：对象类型、对象编号、担保信息编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractNo"));
	String sRelationStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RelationStatus"));
	//将空值转化为空字符串
	if(sRelationStatus == null) sRelationStatus = "";
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sContractNo == null) sContractNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	sTempletNo = "ImpawnGuarantyList1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//担保信息项下的质物	
	PG_TITLE = "担保信息["+sContractNo+"]项下的质物信息列表@PageTitle";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sContractNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);//调试datawindow的Sql语句

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
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
		{(sRelationStatus.equals("020")?"true":"false"),"","Button","新增","新增质物信息","newRecord()",sResourcesPath},
		{(sRelationStatus.equals("020")?"true":"false"),"","Button","引入","引入已经登记的质物信息","importGuaranty()",sResourcesPath},
		{"true","","Button","详情","查看质物信息详情","viewAndEdit()",sResourcesPath},
		{(sRelationStatus.equals("020")?"true":"false"),"","Button","删除","删除质物信息","deleteRecord()",sResourcesPath}
	};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		//获取质物类型
		sReturn = setObjectValue("SelectImpawnType","","",0,0,"");
		//判断是否返回有效信息
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined") return;
		sReturn = sReturn.split('@');
		sImpawnType = sReturn[0];	
		OpenPage("/CreditManage/CreditTransform/TransformContractImpawnInfo1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo=<%=sContractNo%>&ImpawnType="+sImpawnType,"_self");
	}
	
	/*~[Describe=引入记录;InputParam=无;OutPutParam=无;]~*/
	function importGuaranty()
	{
		//获取质物类型
		sReturn = setObjectValue("SelectImpawnType","","",0,0,"");
		//判断是否返回有效信息
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined") return;
		sReturn = sReturn.split('@');
		sImpawnType = sReturn[0];
		sParaString = "GuarantyType"+","+sImpawnType;
		sReturn = setObjectValue("SelectImportImpawn",sParaString,"",0,0,"");	
		if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || sReturn=="_CLEAR_" || typeof(sReturn)=="undefined") return;
		sReturn = sReturn.split('@');
		sGuarantyID = sReturn[0];
		if(typeof(sGuarantyID) != "undefined" && sGuarantyID.length > 0) 
		{
			//进行质物引入关联关系建立操作
			sReturn=RunMethod("BusinessManage","InsertGuarantyRelative","<%=sObjectType%>"+","+"<%=sObjectNo%>"+","+"<%=sContractNo%>"+","+sGuarantyID+","+"Copy"+","+"Import");
			if(typeof(sReturn) != "undefined" && sReturn != "" && parseInt(sReturn) == '0')
			{
				alert(getBusinessMessage('866'));//质物已经引入过，请选择其他质物！
				return;
			}else if(typeof(sReturn) != "undefined" && sReturn != "" && parseInt(sReturn) == '1')
			{
				alert(getBusinessMessage('864'));//引入质物成功！
				reloadSelf();
			}else
			{
				alert(getBusinessMessage('865'));//引入质物失败！
				return;
			}
		}
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");		
		if(typeof(sGuarantyID) == "undefined" || sGuarantyID.length == 0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			//进行质物删除操作
			sReturn=RunMethod("BusinessManage","DeleteGuarantyInfo","<%=sObjectType%>"+","+"<%=sObjectNo%>"+","+"<%=sContractNo%>"+","+sGuarantyID);
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				alert(getHtmlMessage('7'));//信息删除成功！
				reloadSelf();
			}else
			{
				alert(getHtmlMessage('8'));//对不起，删除信息失败！
				return;
			}
		}		
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		sImpawnType = getItemValue(0,getRow(),"GuarantyType");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			OpenPage("/CreditManage/CreditTransform/TransformContractImpawnInfo1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&RelationStatus=<%=sRelationStatus%>&ContractNo=<%=sContractNo%>&GuarantyID="+sGuarantyID+"&ImpawnType="+sImpawnType,"_self");
		}
	}
		
	</script>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	</script>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>