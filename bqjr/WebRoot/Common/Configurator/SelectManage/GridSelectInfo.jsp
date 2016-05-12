<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 查询列表信息详情
		Input Param:
               SelName：查询列表名称
		History Log: 
			zywei 2007/10/11 新增Attribute4为是否根据检索条件查询，即解决大数据量查询引起的响应延迟
	 */
	String PG_TITLE = "查询列表信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得页面参数	
	String sSelName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	if(sSelName == null) sSelName = "";
	
	String sTempletNo = "GridSelectInfo"; //模版编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSelName);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecordAndReturn(){
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn();");        
	}
    
	function saveRecordAndAdd(){
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","newRecord()");
	}

	function doReturn(sIsRefresh){
		OpenPage("/Common/Configurator/SelectManage/GridSelectList.jsp","_self","");
	}
    
	function newRecord(){
		OpenPage("/Common/Configurator/SelectManage/GridSelectInfo.jsp","_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");		
			setItemValue(0,0,"SelType","Sql");
			setItemValue(0,0,"SelBrowseMode","Grid");
			setItemValue(0,0,"MutilOrSingle","Single");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();  
</script>	
<%@ include file="/IncludeEnd.jsp"%>