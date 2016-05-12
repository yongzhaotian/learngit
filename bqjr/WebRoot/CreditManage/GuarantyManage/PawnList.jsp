<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: 抵押物信息列表;
		Input Param:
			GuarantyStatus: 抵押物状态
		Output Param:
			
		HistoryLog:
			fwang 2009/08/10  增加对权利人的搜索
			sxjiang 2010/07/14  增加出库凭证和临时出库凭证
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵押物信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletNo = "";

	//获得页面参数：抵押物状态
	String sGuarantyStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyStatus"));
	if(sGuarantyStatus == null) sGuarantyStatus = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	sTempletNo = "PawnList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause += " and GuarantyType like '010%' and GuarantyStatus = '"+sGuarantyStatus+"' " + 
	          			  " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')";
	//+" and exists (select 1 from Guaranty_Relative where ObjectType='BusinessContract' and GuarantyID=Guaranty_Info.GuarantyID)";
	
	//增加过滤器	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);
	
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{(sGuarantyStatus.equals("01")?"true":"false"),"","Button","新增","新增抵押物信息","newRecord()",sResourcesPath},
		{(sGuarantyStatus.equals("01")?"true":"false"),"","Button","删除","删除抵押物信息","deleteRecord()",sResourcesPath},
		{"true","","Button","详情","查看抵押物信息详情","viewAndEdit()",sResourcesPath},
		{(sGuarantyStatus.equals("01")?"true":"false"),"","Button","打印入库凭证","打印抵押物入库凭证","printLoadGuaranty()",sResourcesPath},
		{(sGuarantyStatus.equals("01")&&(CurUser.hasRole("057")||CurUser.hasRole("257")||CurUser.hasRole("457"))?"true":"false"),"","Button","入库","抵押物入库","loadGuaranty()",sResourcesPath}, //提交放贷审核岗 
		//{(sGuarantyStatus.equals("01")&&(CurUser.hasRole("057")||CurUser.hasRole("257")||CurUser.hasRole("457"))?"true":"false"),"","Button","转不应入库","转不应入库","toNonTransfer()",sResourcesPath},  //提交放贷审核岗,相应节点已经停用，屏蔽此按钮，modified by yzheng 
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","价值变更","抵押物价值变更","valueChange()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","信息变更","抵押物其他信息变更","otherChange()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","临时出库","抵押物临时出库","unloadGuaranty1()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","出库","抵押物出库","unloadGuaranty2()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","打印出库凭证","打印抵押物出库凭证","printLoadGuaranty1()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","打印临时出库凭证","打印抵押物临时出库凭证","printLoadGuaranty2()",sResourcesPath},
		{(sGuarantyStatus.equals("03")?"true":"false"),"","Button","再回库","抵押物再回库","reloadGuaranty()",sResourcesPath},
		{(!sGuarantyStatus.equals("01")&&(!sGuarantyStatus.equals("05"))?"true":"false"),"","Button","出入库历史记录","查看出入库历史记录","viewGuarantyAudit()",sResourcesPath},
		{(!sGuarantyStatus.equals("01")?"true":"false"),"","Button","担保合同信息","查看担保合同信息","viewGuarantyContract()",sResourcesPath},
		{(!sGuarantyStatus.equals("01")?"true":"false"),"","Button","业务合同信息","查看业务合同信息","viewBusinessContract()",sResourcesPath}
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
		//获取抵押物类型
		sReturn = setObjectValue("SelectPawnType","","",0,0,"");
		//判断是否返回有效信息
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined") return;
		sReturn = sReturn.split('@');
		sPawnType = sReturn[0];	
		OpenPage("/CreditManage/GuarantyManage/PawnInfo.jsp?GuarantyStatus=<%=sGuarantyStatus%>&PawnType="+sPawnType,"_self");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{			
			sReturn=RunMethod("BusinessManage","CheckGuarantyRelative",sGuarantyID);
			if(sReturn > 0) 
			{
				alert(getBusinessMessage('850'));//该抵押物已签担保合同，不能删除！
				return;
			}else
			{
				as_del('myiframe0');
				as_save("myiframe0");  //如果单个删除，则要调用此语句	
			}		
		}		
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		sPawnType = getItemValue(0,getRow(),"GuarantyType");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			OpenPage("/CreditManage/GuarantyManage/PawnInfo.jsp?GuarantyStatus=<%=sGuarantyStatus%>&GuarantyID="+sGuarantyID+"&PawnType="+sPawnType,"_self");
		}
	}
	
	/*~[Describe=抵押物入库;InputParam=无;OutPutParam=无;]~*/
	function loadGuaranty()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getBusinessMessage('851'))) //您真的想将该抵押物入库吗？
		{
			sReturn=RunMethod("BusinessManage","InsertGuarantyAudit",sGuarantyID+",02,"+"<%=CurUser.getUserID()%>");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert(getBusinessMessage('852'));//抵押物入库成功！
				reloadSelf();
			}else
			{
				alert(getBusinessMessage('853'));//抵押物入库失败，请重新操作！
				return;
			}
		}
	}
	
	/*~[Describe=打印抵押物入库凭证;InputParam=无;OutPutParam=无;]~*/
	function printLoadGuaranty()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			PopComp("LoadPawnSheet","/CreditManage/GuarantyManage/LoadPawnSheet.jsp","GuarantyID="+sGuarantyID,"dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no");
		}
	}	

	/*~[Describe=打印抵押物出库凭证;InputParam=无;OutPutParam=无;]~*/
	function printLoadGuaranty1()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			PopComp("EmergePawnSheet","/CreditManage/GuarantyManage/EmergePawnSheet.jsp","GuarantyID="+sGuarantyID,"dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no");
		}
	}	

	/*~[Describe=打印抵押物临时出库凭证;InputParam=无;OutPutParam=无;]~*/
	function printLoadGuaranty2()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			PopComp("EmergePawnSheetTemp","/CreditManage/GuarantyManage/EmergePawnSheetTemp.jsp","GuarantyID="+sGuarantyID,"dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no");
		}
	}	
	
	/*~[Describe=抵押物价值变更;InputParam=无;OutPutParam=无;]~*/
	function valueChange()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			popComp("ChangePawnList","/CreditManage/GuarantyManage/ChangePawnList.jsp","ChangeType=010&GuarantyID="+sGuarantyID);
			reloadSelf();
		}
	}

	/*~[Describe=抵押物其他信息变更;InputParam=无;OutPutParam=无;]~*/
	function otherChange()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			popComp("ChangePawnList","/CreditManage/GuarantyManage/ChangePawnList.jsp","ChangeType=020&GuarantyID="+sGuarantyID);
			reloadSelf();
		}
	}
	
	/*~[Describe=抵押物临时出库;InputParam=无;OutPutParam=无;]~*/
	function unloadGuaranty1()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			sReturn = popComp("AddGuarantyAudit","/CreditManage/GuarantyManage/GuarantyAuditInfo.jsp","GuarantyID="+sGuarantyID+"&GuarantyStatus=03");
			if(sReturn){
				alert("抵押物出库成功！");//抵押物出库成功！
			}
			reloadSelf();
		}
	}
		
	/*~[Describe=抵押物出库;InputParam=无;OutPutParam=无;]~*/
	function unloadGuaranty2()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm("是否确定出库？"))
		{			
			sReturn=RunMethod("BusinessManage","InsertGuarantyAudit",sGuarantyID+",04,"+"<%=CurUser.getUserID()%>");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert(getBusinessMessage('854'));//抵押物出库成功！
				reloadSelf();
			}else
			{
				alert(getBusinessMessage('855'));//抵押物出库失败，请重新操作！
				return;
			}			
		}
	}
	
	/*~[Describe=抵押物再回库;InputParam=无;OutPutParam=无;]~*/
	function reloadGuaranty()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm("确定将该抵押物再回库吗？请选择实际回库日期")) 
		{
			sReturn = PopPage("/FixStat/SelectDate.jsp","_blank","resizable=yes;dialogWidth=20;dialogHeight=16;center:yes;status:no;statusbar:no");
			if(typeof(sReturn) != "undefined" && sReturn != "_CANCEL_" && sReturn != "_NONE_" )
			{
				sSerialNo = RunMethod("BusinessManage","GetGuarantyAuditSerialNo",sGuarantyID);
				sLostDate = RunMethod("PublicMethod","GetColValue","LostDate,GUARANTY_AUDIT,String@SerialNo@"+sSerialNo);
				arr = sLostDate.split("@");
				if(sReturn < arr[1]){
					alert("实际回库时间不能小于临时出库时间");
					return false;
				}
				RunMethod("BusinessManage","UpdateGuarantyStatusWithDate",sSerialNo+","+sReturn);
				sReturn = RunMethod("BusinessManage","UpdateGuarantyStatus",sGuarantyID+",02");
				if(typeof(sReturn) != "undefined" && sReturn != "")
				{
					alert("该抵押物已成功回库!");
				}
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=查看入库/出库日志信息;InputParam=无;OutPutParam=无;]~*/
	function viewGuarantyAudit()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			popComp("logGuarantyAudit","/CreditManage/GuarantyManage/GuarantyAuditList.jsp","GuarantyID="+sGuarantyID+"&GuarantyStatus=00");
		}
	}
	
	/*~[Describe=查看担保合同信息;InputParam=无;OutPutParam=无;]~*/
	function viewGuarantyContract()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			popComp("GuarantyContractList","/CreditManage/GuarantyManage/GuarantyContractList.jsp","GuarantyID="+sGuarantyID);
		}
	}
	
	/*~[Describe=查看业务合同信息;InputParam=无;OutPutParam=无;]~*/
	function viewBusinessContract()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			popComp("BusinessContractList","/CreditManage/GuarantyManage/BusinessContractList.jsp","GuarantyID="+sGuarantyID);
		}
	}

	function toNonTransfer(){
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{			
			sReturn=RunMethod("BusinessManage","UpdateTransfer",sGuarantyID);
			reloadSelf();
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>