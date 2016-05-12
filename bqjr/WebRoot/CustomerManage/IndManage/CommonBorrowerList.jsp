<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 共同借款人信息;
		Input Param:

		Output Param:

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "共同借款人信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量

	//获得页面参数
	
	//获得组件参数,客户代码
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	System.out.println("-------1111------------"+sObjectType);
	System.out.println("--------2222-----------"+sObjectNo);
	
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = ""; 
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	

	String sTempletNo = "CommonBorrowerList"; //模版编号

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);//25条一分页
	
    //定义后续事件，同时删除表信息
	//dwTemp.setEvent("BeforeDelete","!BusinessManage.DelContractRecord(#sObjectType,#)");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);//传入显示模板参数
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
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
		{"true","","Button","新增","新增","newRecord()",sResourcesPath},
		{"true","","Button","详情","详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		//OpenPage("/CustomerManage/IndManage/CommonBorrowerInfo.jsp","_self","");
		sObjectType="<%=sObjectType%>";
		sObjectNo="<%=sObjectNo%>";
		
		sCompID = "CarCommApplyInfo";
		sCompURL = "/CreditManage/CreditApply/CarCommApplyInfo.jsp";
		sParamString ="ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		sReturn = sReturn.split("@");
		sCustomerID=sReturn[0];
		sCustomerType=sReturn[1];
		
		//alert("-------"+sCustomerID+"----"+sCustomerType);
		
		if(sObjectNo !=""){
			OpenPage("/CustomerManage/IndManage/CommonBorrowerInfo.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"_self","");
		}
		
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"ObjectNo");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");

		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('70'))){ //您真的想取消该信息吗？
			//删除关联关系
			RunMethod("BusinessManage","DelContractRecord",sSerialNo+","+sCustomerID);
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();  //刷新以实现连续取消
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sCustomerID  = getItemValue(0,getRow(),"ObjectNo");
		sCustomerType  = getItemValue(0,getRow(),"RelationStatus");

		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/CustomerManage/IndManage/CommonBorrowerInfo.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType, "_self","");
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
