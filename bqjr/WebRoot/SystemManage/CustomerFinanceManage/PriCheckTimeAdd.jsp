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
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	String PG_TITLE = "新增优先审核时间配置";
	//获得页面参数
	String sPriority =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Priority"));
	String sTime =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Time"));
	if(sPriority==null) sPriority="";
	if(sTime==null) sTime="";
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PriCheckTimeInfo1";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPriority);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回页面", "backRecord()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(){
		var sPriority =  getItemValue(0,0,"Priority");
		var sTime =  getItemValue(0,0,"Time");
		if(!(/^[1-9]\d*$/).test(sPriority)){
			alert("优先级应为正整数!");
			return;
		}
		if(bIsInsert && checkPrimaryKey("PriCheckTimeInfo","Priority")){
			alert("该优先级已存在!");
			return;
		}
		if(!(/^[1-9]\d*$/).test(sTime)){
			alert("时间应为正整数!");
			return;
		}
		setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		as_save("myiframe0","");
		alert("保存成功!");
		window.close();
	}

	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
			setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");

			setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "UpdateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			bIsInsert = true;
		}else{
			setItemReadOnly(0, 0, "Priority", true);
			setItemValue(0, 0, "Priority", "<%=sPriority%>");
			setItemValue(0, 0, "Time", "<%=sTime%>");
		}
    }
	
	function backRecord(){
		window.close();
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>