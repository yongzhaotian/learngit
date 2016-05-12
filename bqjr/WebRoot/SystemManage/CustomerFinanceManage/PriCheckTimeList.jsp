<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		Author:  xswang 2015/07/16
		Tester:
		Content: 优先审核时间配置
		Input Param:
		Output param:
		History Log: 
	*/
	String PG_TITLE = "优先审核时间配置";

	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PriCheckTimeInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条优先级时间配置信息","my_add()",sResourcesPath},
		{"true","","Button","详情","查看并修改","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除","DeleteRecord()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	//新增
	function my_add() {
		sCompID = "";
		sCompURL = "/SystemManage/CustomerFinanceManage/PriCheckTimeAdd.jsp";
		sParamString = "";
		popComp(sCompID,sCompURL,sParamString,"dialogWidth=550px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	//详情
	function viewAndEdit() {
		var sPriority =getItemValue(0,getRow(),"Priority");
		var sTime =getItemValue(0,getRow(),"Time");
		if (typeof(sPriority)=="undefined" || sPriority.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "PriCheckTimeAdd";
		sCompURL = "/SystemManage/CustomerFinanceManage/PriCheckTimeAdd.jsp";
		sParamString = "Priority="+sPriority+"&Time="+sTime;
		popComp(sCompID,sCompURL,sParamString,"dialogWidth=550px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	//删除
	function DeleteRecord() {
		var sPriority =getItemValue(0,getRow(),"Priority");
		if (typeof(sPriority)=="undefined" || sPriority.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm("确实删除该记录吗？")){
			RunMethod("公用方法","DelByWhereClause","PriCheckTimeInfo,Priority='"+sPriority+"'");
			as_del("myiframe0");
			reloadSelf();
		}
	}
</script>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>